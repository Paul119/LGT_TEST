CREATE PROCEDURE [dbo].[sp_client_process_create_std_field] 
	 @ProcessName Nvarchar(255)
	,@FieldName Nvarchar(255)
	,@IsFilterVisible Bit
	,@IsVisible Bit
	,@Width Int
	,@SortOrder Int
	,@IsLocked Bit
AS
/*   
==========================================================================

Called by:		manually											 

Parameters:     @ProcessName: Name of Process
				@FieldName: Name of Field
				@IsFilterVisible: 1 if filter should be displayed, 0 if it should not be displayed
				@IsVisible: 1 if field should be displayed, 0 if it should not be displayed
				@Width: of the field
				@SortOrder: of field in the process grid
				@IsLocked: If the field should be locked (no scroll)

Returns:        -

Description:    creates or alignes standard fields

==========================================================================
  Date       Author      Change
---------------------------------------------
12.06.2019   M. Wasselin   Creation
==========================================================================
*/
BEGIN
DECLARE @errors INT = 0

BEGIN TRANSACTION upd_process_std_field_tran

-- Get Plan
DECLARE @id_plan int = (SELECT id_plan FROM k_m_plans WHERE name_plan = @ProcessName)

IF @id_plan IS NULL
BEGIN
	PRINT 'ERROR: Plan not found'
	RETURN
END

DECLARE @profile_set int = (-1)

-- Get / Create / Adjust Std Fields
IF @FieldName = 'Workflow Status'
BEGIN
	UPDATE k_m_plans SET available_workflow_status = @IsVisible, width_workflow_status = @Width, sort_order_workflow_status = @SortOrder, workflow_status_is_locked = @IsLocked 
	WHERE id_plan = @id_plan

	UPDATE k_m_plan_display SET available_workflow_status = @IsVisible, show_workflow_status = @IsVisible, optional_show_workflow_status = @IsVisible
	WHERE id_plan = @id_plan AND (id_profile in (select id_profile from k_profiles where id_owner = @profile_set) OR id_profile = -1)

	SET @errors = @errors + @@error
END
ELSE IF @FieldName = 'Workflow Step'
BEGIN
	UPDATE k_m_plans SET filter_workflow_step_visibility = @IsFilterVisible, available_workflow_step_name = @IsVisible, width_workflow_step_name = @Width, sort_order_workflow_step = @SortOrder, workflow_step_is_locked = @IsLocked 
	WHERE id_plan = @id_plan

	UPDATE k_m_plan_display SET available_workflow_step_name = @IsVisible, show_workflow_step_name = @IsVisible, optional_show_workflow_step_name = @IsVisible
	WHERE id_plan = @id_plan AND (id_profile in (select id_profile from k_profiles where id_owner = @profile_set) OR id_profile = -1)

	SET @errors = @errors + @@error
END
ELSE IF @FieldName = 'Start date'
BEGIN
	UPDATE k_m_plans SET filter_start_date_visibility = @IsFilterVisible, available_start_date = @IsVisible, width_start_date = @Width, sort_order_start_date = @SortOrder, start_date_is_locked = @IsLocked 
	WHERE id_plan = @id_plan

	UPDATE k_m_plan_display SET available_start_date = @IsVisible, show_start_date = @IsVisible, optional_show_start_date = @IsVisible
	WHERE id_plan = @id_plan AND (id_profile in (select id_profile from k_profiles where id_owner = @profile_set) OR id_profile = -1)

	SET @errors = @errors + @@error
END
ELSE IF @FieldName = 'End date'
BEGIN
	UPDATE k_m_plans SET filter_end_date_visibility = @IsFilterVisible, available_end_date = @IsVisible, width_end_date = @Width, sort_order_end_date = @SortOrder, end_date_is_locked = @IsLocked 
	WHERE id_plan = @id_plan

	UPDATE k_m_plan_display SET available_end_date = @IsVisible, show_end_date = @IsVisible, optional_show_end_date = @IsVisible
	WHERE id_plan = @id_plan AND (id_profile in (select id_profile from k_profiles where id_owner = @profile_set) OR id_profile = -1)

	SET @errors = @errors + @@error
END

IF @errors = 0
	COMMIT TRANSACTION upd_process_std_field_tran
ELSE
	ROLLBACK TRANSACTION upd_process_std_field_tran

END