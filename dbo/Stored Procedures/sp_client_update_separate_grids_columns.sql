CREATE PROCEDURE [dbo].[sp_client_update_separate_grids_columns]
(
  @Table_Name Nvarchar(255)
, @Grid_Name Nvarchar(255)
, @Field_Name Nvarchar(255)
, @Column_Name Nvarchar(255)
, @Is_Visible Bit
, @Is_Editable BIT
, @Is_Mandatory BIT
, @Is_Sortable Bit
, @Is_Flex_Used Bit
, @Order_Column Int
, @Width Int
, @Flex Int
, @Source_Name Nvarchar(255)
, @Source_Value_Field Nvarchar(255)
, @Source_Display_Field  Nvarchar(255)
, @Thousand_Separator Int
, @Decimal_Precision Int
, @Sort_Order Int
, @Column_Align Nvarchar(50)
)
/**
# ===============================================================
Description: |
    Configure column properties in the grid
Called by:
 - Developer
# ===============================================================
Changes:
 - Date: 2017-01-01
   Author: Unknown
   Change: Creation
 - Date: 2019-03-19
   Author: Sebastian Dziula
   Change: Add several fields
# ===============================================================
**/
AS

BEGIN
DECLARE @errors INT, @Grid_Exists BIT, @Grid_Id INT;
SET @errors = 0; 
SET @Grid_Exists = 0;
SET @Grid_Id = 0;


SET @Grid_Id = (SELECT g.id_grid FROM k_referential_grids g INNER JOIN k_referential_tables_views t ON g.id_table_view = t.id_table_view WHERE t.name_table_view = @Table_Name AND g.name_grid = @Grid_Name)
IF @Grid_Id > 0 SET @Grid_Exists = 1

BEGIN TRANSACTION upd_grids_fields_tran

IF @Grid_Exists = 1
BEGIN

IF @Is_Visible = 0
	DELETE FROM dbo.k_referential_grids_fields
	--WHERE [id_column] = (SELECT id_column FROM vw_client_std_tables_grids_fields WHERE name_table_view = @Table_Name AND name_field = @Field_Name)
	WHERE [id_column] = (SELECT g.id_column FROM k_referential_grids_fields g INNER JOIN k_referential_tables_views_fields f ON g.id_field = f.id_field WHERE id_grid = @Grid_Id AND f.name_field = @Field_Name)

ELSE
	UPDATE dbo.k_referential_grids_fields
	SET [name_column] = @Column_Name
	, [is_editable] = @Is_Editable
	, is_mandatory = @Is_Mandatory
	, [is_sortable] = @Is_Sortable
	, [is_flex_used] = @Is_Flex_Used
	, [order_column] = @Order_Column
	, [width] = @Width
	, [flex] = @Flex
	, [combo_datasource_name] = @Source_Name
	, [combo_datavaluefield_name] = @Source_Value_Field
	, [combo_datatextfield_name] = @Source_Display_Field
	, [combo_type] = CASE WHEN @Source_Name != '' THEN -1 ELSE NULL END
	, [thousand_separator] = @Thousand_Separator
	, [decimal_precision] = @Decimal_Precision
	, [sort_order] = @Sort_Order
	, [column_align] = @Column_Align
	--WHERE [id_column] = (SELECT id_column FROM vw_client_std_tables_grids_fields WHERE name_table_view = @Table_Name AND name_field = @Field_Name)
	WHERE [id_column] = (SELECT g.id_column FROM k_referential_grids_fields g INNER JOIN k_referential_tables_views_fields f ON g.id_field = f.id_field WHERE g.id_grid = @Grid_Id AND f.name_field = @Field_Name)

SET @errors = @errors + @@error

END
ELSE 
PRINT 'The grid does not exist'




IF @errors = 0
	COMMIT TRANSACTION upd_grids_fields_tran
ELSE
	ROLLBACK TRANSACTION upd_grids_fields_tran

END