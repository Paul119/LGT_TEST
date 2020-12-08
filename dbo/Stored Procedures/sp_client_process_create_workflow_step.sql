CREATE PROCEDURE [dbo].[sp_client_process_create_workflow_step] 
	 @ProcessName Nvarchar(255)
	,@WorkflowName Nvarchar(255)
	,@StepName Nvarchar(255)
	,@SortStep Int
AS
/*   
==========================================================================

Called by:		manually

Parameters:		@ProcessName: Name of the process where the calculation is executed and triggered
				@WorkflowName: Name of workflow to be created or updated
				@StepName: Name of workflow step to be created or updated
				@SortStep: Sorting of the workflow steps

Returns:        -

Description:    creates or alignes workflow_step
				Workflow Name musty be unique for one process and Workflow Steps must be unique within a Workflow

==========================================================================
  Date       Author      Change
---------------------------------------------
12.06.2019   M. Wasselin   Creation
==========================================================================
*/
BEGIN
DECLARE @errors INT = 0

BEGIN TRANSACTION upd_process_workflow_step


-- Get Plan
DECLARE @id_plan int = (SELECT id_plan FROM k_m_plans WHERE name_plan = @ProcessName)

IF @id_plan IS NULL
BEGIN
	PRINT 'ERROR: Plan not found'
	RETURN
END


-- Get / Create / Adjust Workflow
DECLARE @id_workflow int
DECLARE @name_workflow Nvarchar(255)
SELECT @name_workflow = w.name_workflow 
FROM k_m_workflow w
INNER JOIN k_m_plans p
	ON w.id_workflow = p.id_workflow
	AND p.id_plan = @id_plan

IF @name_workflow IS NULL
BEGIN
	INSERT INTO k_m_workflow (name_workflow)
	VALUES (@WorkflowName);

	SET @errors = @errors + @@error
	SELECT @id_workflow = SCOPE_IDENTITY()

	UPDATE k_m_plans SET id_workflow = @id_workflow WHERE id_plan = @id_plan
	SET @errors = @errors + @@error
END
ELSE IF @name_workflow <> @WorkflowName
BEGIN
	SELECT @id_workflow = id_workflow FROM k_m_plans WHERE id_plan = @id_plan
	UPDATE k_m_workflow SET name_workflow = @WorkflowName WHERE id_workflow = @id_workflow
	SET @errors = @errors + @@error
END
ELSE
BEGIN
	SELECT @id_workflow = id_workflow FROM k_m_plans WHERE id_plan = @id_plan
	SET @errors = @errors + @@error
END


-- Get / Create / Adjust Workflow Step
DECLARE @id_wflstep INT
DECLARE @sort_step INT
SELECT @id_wflstep = id_wflstep, @sort_step = ws.sort_step
FROM k_m_workflow_step ws
WHERE id_workflow = @id_workflow
AND name_step = @StepName

IF @id_wflstep IS NULL
BEGIN
	INSERT INTO k_m_workflow_step (
		id_workflow
		, name_step
		, sort_step)
	VALUES (
		@id_workflow
		, @StepName
		, @SortStep)

	SET @errors = @errors + @@error
	SELECT @id_wflstep = SCOPE_IDENTITY()
END
ELSE 
BEGIN
	UPDATE k_m_workflow_step
	SET sort_step = @SortStep
	WHERE id_wflstep = @id_wflstep

	SET @errors = @errors + @@error
END


IF @errors = 0
	COMMIT TRANSACTION upd_process_workflow_step
ELSE
	ROLLBACK TRANSACTION upd_process_workflow_step

END