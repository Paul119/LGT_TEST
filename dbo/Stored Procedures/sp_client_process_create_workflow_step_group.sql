CREATE PROCEDURE [dbo].[sp_client_process_create_workflow_step_group] 
	 @ProcessName Nvarchar(255)
	,@StepName Nvarchar(255)
	,@GroupNo Int
	,@ProfilePrefix Nvarchar(255)
	,@Level Int
	,@IsMinLevel Int
	,@EditRights Bit
	,@ValidateRights Bit
	,@MassValidateRights Bit
	,@InvalidateRights Bit
AS
/*   
==========================================================================

Called by:		manually

Parameters:		@ProcessName: Name of the process where the calculation is executed and triggered
				@StepName: Name of workflow step to be changed
				@GroupNo: Number of group in sortorder of id_wflstepgroup, will be changed or created if not existent
				@ProfilePrefix: Assign this group to all profiles starting with @ProfilePrefix. Profiles will be removed from any other group before to avoid inconsistencies
				@Level:
				@IsMinLevel:
				@EditRights: Give edit rights to all editable fields in the process to the group
				@ValidateRights: Give Validation rights to the group
				@MassValidateRights: Give MassValidation rights to the group
				@InvalidateRights: Give InValidation and MassInValidation rights to the group

Returns:        -

Description:    creates or alignes workflow_step_group rights and profiles
				Field Names must be unique, no field assigned to more than one indicator
				Set write rights to all columns which are not calculated or not of type -1 = Result

==========================================================================
  Date       Author      Change
---------------------------------------------
17.10.2017   U. Balkau   Creation
14.06.2019   M. Wasselin Update - Level and IsMinLevel parameters added
==========================================================================
*/
BEGIN
DECLARE @errors INT = 0

BEGIN TRANSACTION upd_process_workflow_step_group


-- Get Plan and Step id
DECLARE @id_plan int = (SELECT id_plan FROM k_m_plans WHERE name_plan = @ProcessName)
DECLARE @id_wflstep int 
SELECT @id_wflstep = id_wflstep 
FROM k_m_workflow_step ws
INNER JOIN k_m_plans p
	ON ws.id_workflow = p.id_workflow
	AND p.id_plan = @id_plan
WHERE name_step = @StepName

IF @id_plan IS NULL OR @id_wflstep IS NULL
BEGIN
	PRINT 'ERROR: Plan or Workflow Step not found'
	RETURN
END


-- Get / Create / Adjust Workflow Step Group
DECLARE @id_wflstepgroup int 
SELECT @id_wflstepgroup = id_wflstepgroup FROM 
	(SELECT id_wflstepgroup, ROW_NUMBER() OVER (ORDER BY id_wflstepgroup) AS RowNumber
	 FROM k_m_workflow_step_group
	 WHERE id_wflstep = @id_wflstep) subquery
WHERE RowNumber = @GroupNo

IF @id_wflstepgroup IS NULL
BEGIN
	INSERT INTO k_m_workflow_step_group (
		id_wflstep, 
		level_step, 
		is_min_level, 
		enable_validation, 
		enable_invalidation, 
		enable_massvalidation, 
		enable_massinvalidation)
	VALUES (
		@id_wflstep,
		@Level, 
		@IsMinLevel,
		@ValidateRights,
		@InvalidateRights,
		@MassValidateRights,
		@InvalidateRights)   -- only 1 choice for both invalidation

	SET @errors = @errors + @@error
	SELECT @id_wflstepgroup = SCOPE_IDENTITY() FROM k_m_workflow_step_group
END
ELSE 
BEGIN
	UPDATE k_m_workflow_step_group
	SET level_step				= @Level,
		is_min_level			= @IsMinLevel,
		enable_validation		= @ValidateRights,
		enable_invalidation		= @InvalidateRights,
		enable_massvalidation	= @MassValidateRights, 
		enable_massinvalidation = @InvalidateRights
	WHERE id_wflstepgroup = @id_wflstepgroup

	SET @errors = @errors + @@error
END


-- Create / Adjust details = field edit rights
;WITH cte_source AS (
	SELECT 
		f.id_field, 
		kmif.id_ind,
		CASE WHEN f.id_control_type = -5 OR f.id_field_type = -1 THEN 0 ELSE @EditRights END AS EditRights
	FROM k_m_plans p
	INNER JOIN k_m_plans_indicators kmpi
		ON kmpi.id_plan = p.id_plan
	INNER JOIN k_m_indicators_fields kmif
		ON kmpi.id_ind = kmif.id_ind
	INNER JOIN k_m_fields f
		ON kmif.id_field = f.id_field
	WHERE p.id_plan = @id_plan
)
MERGE k_m_workflow_step_group_detail AS TARGETT
USING cte_source AS SOURCET  ON (TARGETT.id_wflstepgroup	= @id_wflstepgroup)
							AND	(TARGETT.id_field			= SOURCET.id_field)
							AND	(TARGETT.id_ind				= SOURCET.id_ind)
--When records not in target we insert 
WHEN NOT MATCHED BY TARGET
THEN INSERT (id_wflstepgroup, id_field, is_editable, id_ind, is_readable)
VALUES (@id_wflstepgroup, SOURCET.id_field, SOURCET.EditRights, SOURCET.id_ind, 
	1)
WHEN MATCHED
THEN UPDATE 
SET TARGETT.is_editable	= SOURCET.EditRights,
	TARGETT.is_readable = 1
;
SET @errors = @errors + @@error


-- Delete profile(s) from all other groups of this step first
DELETE k_m_workflow_step_group_profile
FROM k_m_workflow_step_group_profile sgp
INNER JOIN k_m_workflow_step_group sg
	ON sgp.id_wflstepgroup = sg.id_wflstepgroup  
	AND sg.id_wflstep = @id_wflstep   -- all of the same workflow step
	AND sg.id_wflstepgroup != @id_wflstepgroup  -- except the current one
INNER JOIN k_profiles p
	ON sgp.id_profile = p.id_profile
	AND p.name_profile like @ProfilePrefix + '%'


-- assign profile(s) to @id_wflstepgroup is missing
INSERT INTO k_m_workflow_step_group_profile (id_wflstepgroup, id_profile)
SELECT @id_wflstepgroup, id_profile
FROM k_profiles p
WHERE p.name_profile like @ProfilePrefix + '%'
AND NOT EXISTS (SELECT 1 FROM k_m_workflow_step_group_profile
				WHERE id_wflstepgroup = @id_wflstepgroup
				AND id_profile = p.id_profile)

SET @errors = @errors + @@error


IF @errors = 0
	COMMIT TRANSACTION upd_process_workflow_step_group
ELSE
	ROLLBACK TRANSACTION upd_process_workflow_step_group

END