CREATE PROCEDURE [dbo].[sp_client_process_create_calcfield] 
	 @ProcessName Nvarchar(255)
	,@IndicatorName Nvarchar(255)
	,@FieldCode Nvarchar(255)
	,@Formula Nvarchar(max)
AS
/*   
==========================================================================

Called by:		manually

Parameters:     @ProcessName: Name of the process where a calculated field is created
				@IndicatorName: Name of Indicator where a calculated field is created
				@FieldCode: Name of Field which should be calculated
				@Formula: Formula with FieldCodes, which will be translated in beqom references

Returns:        -

Description:    creates or alignes calculated fields
				IMPORTANT prerequisites: All field codes must be unique, each used field is assigned to only one indicator

==========================================================================
  Date       Author      Change
---------------------------------------------
13.10.2017   U. Balkau   Creation
13.08.2019	 U. Balkau	 Issue handling for not found ids
==========================================================================
*/
BEGIN
DECLARE @errors INT = 0

DECLARE @FieldCodeRef Nvarchar(255) 
DECLARE @beqomRef Nvarchar(255) 

-- Get and check @id_plan
DECLARE @id_plan int = (SELECT id_plan FROM k_m_plans WHERE name_plan = @ProcessName)
IF @id_plan IS NULL
BEGIN
	PRINT 'ERROR: Plan ' + @ProcessName + ' not found'
	RETURN
END

-- Get and check @id_ind
DECLARE @id_ind int = (SELECT kmi.id_ind FROM k_m_indicators kmi INNER JOIN k_m_plans_indicators kmpi ON kmi.id_ind = kmpi.id_ind WHERE kmi.name_ind = @IndicatorName AND kmpi.id_plan = @id_plan)
IF @id_ind IS NULL
BEGIN
	PRINT 'ERROR: Indicator ' + @IndicatorName + ' not found'
	RETURN
END

-- Get and check @id_field
DECLARE @id_field int = (SELECT id_field FROM k_m_fields WHERE code_field = @FieldCode)
IF @id_field IS NULL
BEGIN
	PRINT 'ERROR: Field ' + @FieldCode + ' not found'
	RETURN
END

SELECT @Formula = dbo.fn_client_process_name2ref(@ProcessName, @Formula, 1, 0)
PRINT @Formula

BEGIN TRANSACTION upd_process_calc_field_tran

-- Create / Adjust Calculated Field
IF (SELECT COUNT(*) FROM k_m_plans_calculated_fields WHERE id_plan = @id_plan AND id_ind = @id_ind AND id_field = @id_field) = 0
BEGIN
	INSERT INTO k_m_plans_calculated_fields (id_plan, id_ind, id_field, formula, date_creation, date_update, InUse)
	VALUES (@id_plan, @id_ind, @id_field, @Formula, getdate(), getdate(), 0)

	SET @errors = @errors + @@error
END
ELSE 
BEGIN
	UPDATE k_m_plans_calculated_fields
	SET formula = @Formula,
		date_update = getdate()
	WHERE id_plan = @id_plan
	AND id_ind = @id_ind
	AND id_field = @id_field

	SET @errors = @errors + @@error
END

IF @errors = 0
	COMMIT TRANSACTION upd_process_calc_field_tran
ELSE
	ROLLBACK TRANSACTION upd_process_calc_field_tran

END