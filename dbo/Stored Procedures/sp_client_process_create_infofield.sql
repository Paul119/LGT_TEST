CREATE PROCEDURE [dbo].[sp_client_process_create_infofield] 
	 @ProcessName Nvarchar(255)
	,@FieldName Nvarchar(255)
	,@ColumnName Nvarchar(255)
	,@IsVisible Bit
	,@Width Int
	,@SortOrder Int
	,@IsLocked Bit
	,@IsDefault Bit = 0
	,@IsFlexible Bit = 1
AS
/*   
==========================================================================

Called by:		manually

Parameters:     @ProcessName, searched in k_m_plans
				@FieldName, searched in vw_client_std_tables_grids_fields together with Grid from Process Template
				@ColumnName is set separatly in k_referential_grids_fields regardless the other parameters
				@IsVisible = 0 -> delete info column
				@Width of the columns in the process grid
				@SortOrder of the columns in the process grid
				@IsLocked column shown separated, not movable on the left side (only meaningful with low sort order)
				@IsDefault column is part of the default view
				@IsFlexible column is part of the flexible view

Returns:        -

Description:    creates, alignes or deleted one InfoColumn in a grid

==========================================================================
  Date       Author      Change
---------------------------------------------
11.10.2017   U. Balkau   Creation
==========================================================================
*/
BEGIN
DECLARE @errors INT = 0

DECLARE @id_plan int = (SELECT id_plan FROM k_m_plans WHERE name_plan = @ProcessName)
DECLARE @profile_set int = (-1)
DECLARE @id_column int = (
	SELECT gf.id_column
	FROM k_m_plans p
	INNER JOIN k_m_type_plan tp
		ON p.id_type_plan = tp.id_type_plan
	INNER JOIN k_referential_grids g
		ON g.name_grid = tp.name_type_plan
		AND g.type_grid = -4 
	INNER JOIN vw_client_std_tables_grids_fields gf
		ON gf.id_grid = g.id_grid
	WHERE p.name_plan = @ProcessName
	AND gf.name_field = @FieldName)

IF @id_plan IS NULL OR @id_column IS NULL
BEGIN	
	print 'ERROR: @id_plan or @id_column not found for ' + @FieldName
	RETURN
END

BEGIN TRANSACTION upd_process_infofield_tran

-- Create Plan display if not exists
IF NOT EXISTS (SELECT TOP 1 kmpd.id_plan_display FROM k_m_plan_display kmpd WHERE kmpd.id_plan = @id_plan)
BEGIN
	INSERT INTO k_m_plan_display (id_plan, id_profile, available_start_date, available_end_date, available_workflow_status, available_workflow_step_name, show_start_date, show_end_date, show_workflow_status, show_workflow_step_name, optional_show_start_date, optional_show_end_date, optional_show_workflow_status, optional_show_workflow_step_name, id_source_tenant, id_source, id_change_set, available_default_form_header, workflow_level)
	SELECT @id_plan, kp.id_profile, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL FROM k_profiles kp
END

IF @IsVisible = 0
BEGIN
	DECLARE @id_planInfo int 
	SELECT @id_planInfo = id_planInfo 
	FROM k_m_plans_informations 
	WHERE id_plan = @id_plan
	AND id_field_grid = @id_column
	
	-- Delete visibility rights of column to be deleted before
	DELETE FROM k_m_plan_display_information 
	WHERE id_plan_information = @id_planInfo

	-- Delete user settings filters
	DELETE FROM k_user_plan_field_filter 
	WHERE id_plan_information = @id_planInfo

	-- Delete user settings
	DELETE FROM k_user_plan_field 
	WHERE id_plan_information = @id_planInfo

	-- Now delete infoculumn itself
	DELETE FROM dbo.k_m_plans_informations
	WHERE id_plan = @id_plan
	AND id_field_grid = @id_column

	SET @errors = @errors + @@error
END
ELSE
IF (SELECT COUNT(*) FROM dbo.k_m_plans_informations WHERE id_plan = @id_plan AND id_field_grid = @id_column) = 0
BEGIN
	INSERT INTO dbo.k_m_plans_informations (
		 id_plan
		,id_field_grid
		,width
		,sort
		,is_locked)
	VALUES (
		 @id_plan
		,@id_column
		,@Width
		,@SortOrder
		,@IsLocked)
	
	SET @errors = @errors + @@error
END
ELSE
BEGIN
	UPDATE dbo.k_m_plans_informations
	SET width = @Width,
		sort = @SortOrder,
		Is_Locked = @IsLocked
	WHERE id_plan = @id_plan 
	AND id_field_grid = @id_column
	
	SET @errors = @errors + @@error
END

-- Atttention: Visibility of new or changed infocolumn is done identically for all profiles!
;WITH cte_source AS (
	SELECT 
		id_plan_display,
		id_planInfo AS id_plan_information,
		d.id_profile,
		inf.sort
	FROM k_m_plans_informations inf
	INNER JOIN k_m_plan_display d
		ON inf.id_plan = d.id_plan
	WHERE inf.id_plan = @id_plan
	AND inf.id_field_grid = @id_column
	AND (d.id_profile in (select id_profile from k_profiles where id_owner = @profile_set) OR d.id_profile = -1)
)
MERGE k_m_plan_display_information AS TARGETT
USING cte_source AS SOURCET  ON (TARGETT.id_plan_display	 = SOURCET.id_plan_display)
							AND	(TARGETT.id_plan_information = SOURCET.id_plan_information)
--When records not in target we insert 
WHEN NOT MATCHED BY TARGET
THEN INSERT (id_plan_display, id_plan_information, 
	available_plan_display_information, 
	show_plan_display_information, 
	optional_show_plan_display_information)
VALUES (SOURCET.id_plan_display, SOURCET.id_plan_information, 
	1, -- All available (for calculation), but maybe not visible
	@IsDefault,
	@IsFlexible)	
--When records in target we update
WHEN MATCHED
THEN UPDATE SET 
	TARGETT.available_plan_display_information	= 1, 
	TARGETT.show_plan_display_information		= @IsDefault, 
	TARGETT.optional_show_plan_display_information	= @IsFlexible
;
-- Independant from infocolumn in given process: Change infocolumn name
UPDATE k_referential_grids_fields
SET name_column = @ColumnName
WHERE id_column = @id_column

SET @errors = @errors + @@error

IF @errors = 0
	COMMIT TRANSACTION upd_process_infofield_tran
ELSE
	ROLLBACK TRANSACTION upd_process_infofield_tran

END