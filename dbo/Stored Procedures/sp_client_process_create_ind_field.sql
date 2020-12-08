CREATE PROCEDURE [dbo].[sp_client_process_create_ind_field] 
	@ProcessName Nvarchar(255)
	,@IndicatorName Nvarchar(255)
	,@FieldName Nvarchar(255)
	,@FieldLabel Nvarchar(255)
	,@FieldCode Nvarchar(255)
	,@FieldWidth Int
	,@FieldUnit Int
	,@FieldType Int
	,@FieldControl Int
	,@FieldFormat Int
	,@FieldDecPrec Int
	,@FieldIsPercent Int
	,@SortOrder Int
	,@DefaultSource Nvarchar(255)
	,@IndicatorSortOrder Int
AS
/*   
==========================================================================

Called by:		manually

Parameters:     @ProcessName: searched in k_m_plans
				@IndicatorName: Name of Indicator, created if non existing
				@FieldName: Name of Field
				@FieldLabel: Label of Field
				@FieldCode: Code of Field, created if non existing
				@FieldWidth
				@FieldUnit
				@FieldType
				@FieldControl
				@FieldFormat
				@FieldDecPrec
				@FieldIsPercent
				@SortOrder: of field in Indicator
				@DefaultSource: Name of Table and Field to be used as default in the form <table/view name>.<column name>
				@IndicatorSortOrder

Returns:        -

Description:    creates or alignes Indicators and fields

==========================================================================
  Date       Author      Change
---------------------------------------------
13.10.2017   U. Balkau   Creation
19.10.2017   U. Balkau	 Added @DefaultSource
13.06.2019   M. Wasselin Process name and indicator sort order added - Indicator Assignment to Process 
17.07.2019	 U. Balkau	 Added update case for @IndicatorSortOrder
14.08.2019	 U. Balkau	 Moved id_üplan check before TRAN
==========================================================================
*/
BEGIN
DECLARE @errors INT = 0

DECLARE @id_plan int = (SELECT id_plan FROM k_m_plans WHERE name_plan = @ProcessName)

IF @id_plan IS NULL
BEGIN	
	print 'ERROR: @id_plan not found for ' + @ProcessName
	RETURN
END

BEGIN TRANSACTION upd_process_ind_field_tran

-- Get field id for default (if provided)
DECLARE @DefaultSourceId int
IF CHARINDEX('.', @DefaultSource) > 0
	SELECT @DefaultSourceId = tvf.id_field
	FROM k_referential_tables_views_fields tvf
	INNER JOIN  k_referential_tables_views tv
		ON tvf.id_table_view = tv.id_table_view
	WHERE tv.name_table_view = SUBSTRING(@DefaultSource, 1, CHARINDEX('.', @DefaultSource) - 1)
	AND tvf.name_field = SUBSTRING(@DefaultSource, CHARINDEX('.', @DefaultSource) + 1, 100)

IF CHARINDEX('.', @DefaultSource) > 0 AND @DefaultSourceId IS NULL
	PRINT 'ERROR: ' + @DefaultSource + ' not found.'

-- Create Plan display if not exists
IF NOT EXISTS (SELECT TOP 1 kmpd.id_plan_display FROM k_m_plan_display kmpd WHERE kmpd.id_plan = @id_plan)
BEGIN
	INSERT INTO k_m_plan_display (id_plan, id_profile, available_start_date, available_end_date, available_workflow_status, available_workflow_step_name, show_start_date, show_end_date, show_workflow_status, show_workflow_step_name, optional_show_start_date, optional_show_end_date, optional_show_workflow_status, optional_show_workflow_step_name, id_source_tenant, id_source, id_change_set, available_default_form_header, workflow_level)
	SELECT @id_plan, kp.id_profile, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL FROM k_profiles kp
END

-- Get / Create Indicator (no updateble fields)
DECLARE @id_ind int = (SELECT kmi.id_ind FROM k_m_indicators kmi INNER JOIN k_m_plans_indicators kmpi ON kmi.id_ind = kmpi.id_ind WHERE kmi.name_ind = @IndicatorName AND kmpi.id_plan = @id_plan)
IF @id_ind IS NULL AND @IndicatorName IS NOT NULL
BEGIN
	INSERT INTO k_m_indicators (name_ind, id_type_ind, is_olap, date_create_ind)
	VALUES (@IndicatorName, -6, 0, getdate())

	SELECT @id_ind = SCOPE_IDENTITY()

	-- Assign Indicator to process
	INSERT INTO k_m_plans_indicators (id_plan, id_ind, weight_plan_ind, comment_plan_ind, sort_plan_ind, start_date_plan_ind, end_date_plan_ind)
	VALUES (@id_plan, @id_ind, 100, @ProcessName + '/' + @IndicatorName, @IndicatorSortOrder, DATEFROMPARTS(YEAR(GETDATE()),1,1), DATEFROMPARTS(YEAR(GETDATE()),12,31));

	SET @errors = @errors + @@error							  
END
ELSE
	-- If existent already then update the only updateable field
	UPDATE k_m_plans_indicators
	SET sort_plan_ind = @IndicatorSortOrder
	WHERE id_plan = @id_plan
	AND id_ind = @id_ind


-- Assign 


-- Get / Create / Adjust Field
DECLARE @id_field int = (SELECT id_field FROM k_m_fields WHERE code_field = @FieldCode)
IF @id_field IS NULL
BEGIN
	INSERT INTO k_m_fields (name_field, label_field, code_field, 
		width, id_unit, id_field_type, id_control_type, type_value, decimal_precision, is_percentage_used, 
		default_type, default_value,
		thousand_separator, is_olap, date_create_field, show_min, show_max, id_access_type)
	VALUES (@FieldName, @FieldLabel, @FieldCode, 
		@FieldWidth, @FieldUnit, @FieldType, @FieldControl, @FieldFormat, @FieldDecPrec, @FieldIsPercent,
		CASE WHEN @DefaultSourceId IS NULL THEN NULL ELSE 'sql' END, @DefaultSourceId,
		1, 0, getdate(), 1, 1, -1)

	SET @errors = @errors + @@error
	SELECT @id_field = SCOPE_IDENTITY() FROM k_m_fields
END
ELSE 
BEGIN
	UPDATE k_m_fields
	SET name_field		= @FieldName,
		label_field		= @FieldLabel,
		width			= @FieldWidth,
		id_unit			= @FieldUnit,
		id_field_type	= @FieldType,
		id_control_type	= @FieldControl,
		type_value		= @FieldFormat,
		decimal_precision  = @FieldDecPrec,
		is_percentage_used = @FieldIsPercent,
		default_type	= CASE WHEN @DefaultSourceId IS NULL THEN NULL ELSE 'sql' END,
		default_value	= @DefaultSourceId
	WHERE id_field = @id_field

	SET @errors = @errors + @@error
END

-- Assign field to Indicator, adjust sort order
IF (SELECT COUNT(*) FROM k_m_indicators_fields WHERE id_ind = @id_ind and id_field = @id_field) = 0
BEGIN
	INSERT INTO k_m_indicators_fields (id_ind, id_field, sort)
	VALUES (@id_ind, @id_field, @SortOrder)

	SET @errors = @errors + @@error
END
ELSE 
BEGIN
	UPDATE k_m_indicators_fields
	SET sort = @SortOrder
	WHERE id_ind = @id_ind
	AND id_field = @id_field

	SET @errors = @errors + @@error
END

-- Atttention: Visibility of new or changed indicator field is done identically for all profiles!
DECLARE @profile_set int = (-1)
;WITH cte_source AS (
	SELECT id_plan_display,
		kmif.id_indicator_field AS id_indicator_field,
		d.id_profile
	FROM k_m_plans_indicators kmpi
	INNER JOIN k_m_indicators_fields kmif 
		ON kmpi.id_ind = kmif.id_ind
	INNER JOIN k_m_plan_display d
		ON kmpi.id_plan = d.id_plan
	WHERE kmpi.id_plan = @id_plan
		AND kmpi.id_ind = @id_ind
		AND kmif.id_field = @id_field
		AND (d.id_profile in (select id_profile from k_profiles where id_owner = @profile_set) OR d.id_profile = -1)
)
MERGE k_m_plan_display_field AS TARGETT
USING cte_source AS SOURCET  ON (TARGETT.id_plan_display	 = SOURCET.id_plan_display)
							AND	(TARGETT.id_indicator_field = SOURCET.id_indicator_field)
--When records not in target we insert 
WHEN NOT MATCHED BY TARGET
THEN INSERT (id_plan_display, id_indicator_field, 
	available_plan_display_field, 
	show_plan_display_field, 
	optional_show_plan_display_field)
VALUES (SOURCET.id_plan_display, SOURCET.id_indicator_field, 
	1, -- All available (for calculation), but maybe not visible
	1,--@IsDefault,
	1)--@IsFlexible)
--When records in target we update
WHEN MATCHED
THEN UPDATE SET 
	TARGETT.available_plan_display_field	= 1, 
	TARGETT.show_plan_display_field		= 1,--@IsDefault, 
	TARGETT.optional_show_plan_display_field	= 1--@IsFlexible
;

IF @errors = 0
	COMMIT TRANSACTION upd_process_ind_field_tran
ELSE
	ROLLBACK TRANSACTION upd_process_ind_field_tran														  

END