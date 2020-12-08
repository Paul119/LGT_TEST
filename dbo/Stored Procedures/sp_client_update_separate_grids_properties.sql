CREATE PROCEDURE dbo.sp_client_update_separate_grids_properties																		
(																		
  @Table_Name Nvarchar(255)																		
, @Grid_Name Nvarchar(255)																		
, @Page_Size Int																		
, @Is_Deletable Int																		
, @Is_Addable Int																		
, @Is_Exportable INT
, @is_export_template_enabled INT																		
, @Is_Importable Int																		
, @Is_Auto_Resize Int																		
, @Fit_To_Screen INT
, @wrap_header INT																	
, @Is_Track_Change Int	
, @sp_grid_add_pre NVARCHAR(255)
, @sp_grid_add_post NVARCHAR(255)
, @sp_grid_save_pre NVARCHAR(255)
, @sp_grid_save_post NVARCHAR(255)
, @sp_grid_delete_pre NVARCHAR(255)
, @sp_grid_delete_post NVARCHAR(255)
, @is_bulk_insert INT
, @is_password_protection_enabled INT											
)																		
AS																		
																		
BEGIN																		
DECLARE @errors INT 																		
SET @errors = 0																		
																		
BEGIN TRANSACTION update_grids_tran																		
																		
	UPDATE dbo.k_referential_grids 																		
	SET --[name_grid] = @Grid_Name																		
	  [page_size] = @Page_Size 																		
	, [is_deletable] = @Is_Deletable																		
	, [is_addable] = @Is_Addable																		
	, [is_exportable] = @Is_Exportable
	, is_export_template_enabled = @is_export_template_enabled																	
	, [is_importable] = @Is_Importable																		
	, [is_auto_resize] = @Is_Auto_Resize																		
	, [fit_to_screen] = @Fit_To_Screen
	, wrap_header = @wrap_header																	
	, [is_track_change] = @Is_Track_Change
	, sp_grid_add_pre = @sp_grid_add_pre
	, sp_grid_add_post = @sp_grid_add_post
	, sp_grid_save_pre = @sp_grid_save_pre
	, sp_grid_save_post = @sp_grid_save_post
	, sp_grid_delete_pre = @sp_grid_delete_pre
	, sp_grid_delete_post = sp_grid_delete_post
	, is_bulk_insert = @is_bulk_insert
	, is_password_protection_enabled = @is_password_protection_enabled																		
	--WHERE [id_grid] = (SELECT DISTINCT id_grid FROM vw_client_std_tables_grids_fields WHERE name_table_view = @table_name)
	WHERE [id_grid] = (SELECT DISTINCT g.id_grid FROM k_referential_grids g INNER JOIN k_referential_tables_views t ON g.id_table_view = t.id_table_view WHERE t.name_table_view = @table_name AND g.name_grid = @Grid_Name)
																		
SET @errors = @errors + @@error																		
IF @errors = 0 																		
	COMMIT TRANSACTION update_grids_tran																	
ELSE 																		
	ROLLBACK TRANSACTION update_grids_tran																	
																		
END