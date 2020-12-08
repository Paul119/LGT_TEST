
CREATE PROCEDURE [dbo].[sp_client_grid_create_validation] 
	 @GridName Nvarchar(255)
	,@FieldName Nvarchar(255)
	,@Formula Nvarchar(max)
	,@FalseAllowSaving Bit
	,@FalseSaveMessage Bit
	,@FalseChangeMessage Bit
	,@FalseMessage Nvarchar(max)
	,@FalseUseColors Bit
	,@FalseColorText Nvarchar(50)
	,@FalseColorBorder Nvarchar(50)
	,@FalseColorBackground Nvarchar(50)
	,@TrueUseColors Bit
	,@TrueColorText Nvarchar(50)
	,@TrueColorBorder Nvarchar(50)
	,@TrueColorBackground Nvarchar(50)
AS
/*   
==========================================================================

Called by:		manually

Parameter:      @GridName: Name of the grid where the validation has to be installed
				@FieldName: Name of field in k_referential_tables_views_fields 
				@Formula: Formula with FieldNames, which will be translated in beqom references
				@FalseAllowSaving: Is saving allowed ?
				@FalseSaveMessage: Show a save message?
				@FalseChangeMessage: Show a change message? Only valid if @FalseSaveMessage = 1
				@FalseMessage: Message to be shown in both cases
				@FalseUseColors: Use special colors?
				@FalseColorText: In 6 letter hex RGB format ('000000' - 'FFFFFF')
				@FalseColorBorder: In 6 letter hex RGB format ('000000' - 'FFFFFF')
				@FalseColorBackground: In 6 letter hex RGB format ('000000' - 'FFFFFF')
				@TrueUseColors: Use special colors?
				@TrueColorText: In 6 letter hex RGB format ('000000' - 'FFFFFF')
				@TrueColorBorder: In 6 letter hex RGB format ('000000' - 'FFFFFF')
				@TrueColorBackground: In 6 letter hex RGB format ('000000' - 'FFFFFF')

Returns:        -

Description:    creates or alignes field validation

==========================================================================
Date        Author      Change
---------------------------------------------
05/02/2017  U. Balkau   Creation
==========================================================================
*/
BEGIN
DECLARE @errors INT = 0
DECLARE @FieldCodeRef Nvarchar(255) 
DECLARE @FieldsReferenced TABLE (id_field INT NOT NULL)
DECLARE @id_field INT

-- Replace all occurences of FieldNames by beqom field references
WHILE CHARINDEX('{', @Formula) > 0
BEGIN
	SET @FieldCodeRef = SUBSTRING(@Formula, CHARINDEX('{', @Formula) + 1, CHARINDEX('}', @Formula) - CHARINDEX('{', @Formula) - 1)

	SELECT @id_field = tbf.id_field
	FROM k_referential_grids g 
	INNER JOIN k_referential_tables_views_fields tbf 
		ON tbf.id_table_view = g.id_table_view
	WHERE g.name_grid = @GridName
	AND tbf.name_field=@FieldCodeRef

	IF @id_field IS NULL
		PRINT 'ERROR: ' + '{' + @FieldCodeRef + '}' + ' not found'
	ELSE
		-- store found reference for later insert into k_referential_grid_field_validation_formula_items
		INSERT INTO @FieldsReferenced VALUES (@id_field)

	-- replace reference (by 0 if not found to ensure loop end)
	-- SET @Formula = REPLACE(@Formula, '{' + @FieldCodeRef + '}', '[' + CAST(ISNULL(@id_field, 0) AS Nvarchar(10))  + ']')
	-- wee need only one replacement at a time to duplicate field id's for later insert into k_referential_grid_field_validation_formula_items
	SET @Formula = STUFF(@Formula, CHARINDEX('{' + @FieldCodeRef + '}', @Formula), LEN('{' + @FieldCodeRef + '}'), '[' + CAST(ISNULL(@id_field, 0) AS Nvarchar(10))  + ']')
	SET @id_field = NULL


END
PRINT @Formula


-- get @id_grid and @id_field
DECLARE @id_grid int = (SELECT id_grid FROM k_referential_grids WHERE name_grid = @GridName)
SELECT @id_field = NULL  -- initialize again, used already above
SELECT @id_field = tbf.id_field
FROM k_referential_grids g 
INNER JOIN k_referential_grids_fields gf ON g.id_grid = gf.id_grid
INNER JOIN k_referential_tables_views_fields tbf ON tbf.id_table_view = g.id_table_view AND tbf.id_field = gf.id_field
WHERE g.id_grid = @id_grid
AND tbf.name_field=@FieldName

IF @id_grid IS NULL OR @id_field IS NULL
BEGIN	
	print 'ERROR: Grid or visible Field not found'
	RETURN
END

BEGIN TRANSACTION upd_grid_validation_tran

-- Align k_m_plans_field_validation
-- Get id if row already exists
DECLARE @id_grid_field_validation INT
SELECT @id_grid_field_validation = id_grid_field_validation
FROM k_referential_grid_field_validation
WHERE id_grid = @id_grid
AND id_field = @id_field

IF @id_grid_field_validation IS NULL
BEGIN
	INSERT INTO k_referential_grid_field_validation (
		id_grid,
		id_field,
		formula,
		action_false_allow_saving,
		action_false_show_error,
		action_false_error_message,
		action_false_use_field_style,
		action_false_text_color,
		action_false_border_color,
		action_false_background_color,
		action_true_use_field_style,
		action_true_text_color,
		action_true_border_color,
		action_true_background_color,
		action_false_show_error_on_change)
	VALUES (
		@id_grid,
		@id_field,
		@Formula,
		@FalseAllowSaving,
		@FalseSaveMessage,
		@FalseMessage,
		@FalseUseColors,
		@FalseColorText,
		@FalseColorBorder,
		@FalseColorBackground,
		@TrueUseColors,
		@TrueColorText,
		@TrueColorBorder,
		@TrueColorBackground,
		@FalseChangeMessage)

	SET @errors = @errors + @@error
	SELECT @id_grid_field_validation = SCOPE_IDENTITY() FROM k_referential_grid_field_validation

END
ELSE
BEGIN
	UPDATE k_referential_grid_field_validation
	SET formula = @Formula,
		action_false_allow_saving		= @FalseAllowSaving,
		action_false_show_error			= @FalseSaveMessage,
		action_false_error_message		= @FalseMessage,
		action_false_use_field_style	= @FalseUseColors,
		action_false_text_color			= @FalseColorText,
		action_false_border_color		= @FalseColorBorder,
		action_false_background_color	= @FalseColorBackground,
		action_true_use_field_style		= @TrueUseColors,
		action_true_text_color			= @TrueColorText,
		action_true_border_color		= @TrueColorBorder,
		action_true_background_color	= @TrueColorBackground,
		action_false_show_error_on_change = @FalseChangeMessage
	WHERE id_grid_field_validation		= @id_grid_field_validation

	SET @errors = @errors + @@error
END

-- Align k_referential_grid_field_validation_formula_items (delete and new)
DELETE FROM k_referential_grid_field_validation_formula_items
WHERE id_grid_field_validation = @id_grid_field_validation

SET @errors = @errors + @@error

INSERT INTO k_referential_grid_field_validation_formula_items (id_grid_field_validation, id_field)
SELECT @id_grid_field_validation, id_field
FROM @FieldsReferenced

SET @errors = @errors + @@error

IF @errors = 0
	COMMIT TRANSACTION upd_grid_validation_tran
ELSE
	ROLLBACK TRANSACTION upd_grid_validation_tran

END