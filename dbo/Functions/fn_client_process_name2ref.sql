CREATE FUNCTION [dbo].[fn_client_process_name2ref](
	 @ProcessName Nvarchar(255)
	,@Formula Nvarchar(max)
	,@Brackets int
	,@PlanPrefix int)
RETURNS Nvarchar(max)
AS 
/*   
==========================================================================
Called by:		sp_client_process_create_calcfield and others

Parameter:      @ProcessName: Name of the process. Needed for calculations with info columns and for plan prefix
				@Formula:  Formula with FieldCodes, which will be translated in beqom references
				@Brackets: If 0, square Brackets are removed from the resulting formula
				@PlanPrefix:  If 1, a prefix <process_id>_ will be added to references

Returns:        converted @Formula

Description:    used to script capclualted fields and data operations
==========================================================================				  
Date        Author      Change
---------------------------------------------

==========================================================================
*/
BEGIN
DECLARE @FieldCodeRef Nvarchar(255) 
DECLARE @beqomRef Nvarchar(255) 
DECLARE @id_plan int = (SELECT id_plan FROM k_m_plans WHERE name_plan = @ProcessName)
DECLARE @prefix_plan Nvarchar(255) = CASE WHEN @PlanPrefix = 1 THEN ISNULL(CAST(@id_plan AS Nvarchar(10)), '') + '_' ELSE '' END

-- Replace all occurences of FieldCodes by beqom field references
WHILE CHARINDEX('{', @Formula) > 0
BEGIN
	SET @FieldCodeRef = SUBSTRING(@Formula, CHARINDEX('{', @Formula) + 1, CHARINDEX('}', @Formula) - CHARINDEX('{', @Formula) - 1)

	IF LEFT(@FieldCodeRef, 3) = 'IC_'
		SELECT @beqomRef = '[IC_' + CAST(gf.id_column AS Nvarchar(10))  + ']'
		FROM k_m_plans p
		INNER JOIN k_m_type_plan tp
			ON p.id_type_plan = tp.id_type_plan
		INNER JOIN k_referential_grids g
			ON g.name_grid = tp.name_type_plan
			AND g.type_grid = -4 
		INNER JOIN vw_client_std_tables_grids_fields gf
			ON gf.id_grid = g.id_grid
		WHERE p.name_plan = @ProcessName
		AND gf.name_field = SUBSTRING(@FieldCodeRef, 4, 100)
	ELSE IF LEFT(@FieldCodeRef, 2) = 'S_'
		SELECT @beqomRef = '[' + @FieldCodeRef + ']'
	ELSE
		SELECT @beqomRef = '[' + @prefix_plan + CAST(kmif.id_ind AS Nvarchar(10)) + '_' + CAST(kmif.id_field AS Nvarchar(10)) + ']'
		FROM k_m_indicators_fields kmif
		INNER JOIN k_m_fields kmf
			ON kmif.id_field = kmf.id_field
		WHERE kmf.code_field = @FieldCodeRef

	SET @Formula = REPLACE(@Formula, '{' + @FieldCodeRef + '}', @beqomRef)
END

IF @Brackets = 0
	SET @Formula = REPLACE(REPLACE(@Formula, '[', ''), ']', '')

RETURN @Formula
END