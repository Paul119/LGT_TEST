CREATE VIEW dbo.vw_client_std_tables_grids_fields 
/**
# ===============================================================
Description: |
    Return information about existing grid's settings
Called by:
 - Developer
# ===============================================================
Changes:
 - Date: 2017-01-01
   Author: Unknown
   Change: Creation
 - Date: 2019-03-18
   Author: Sebastian Dziula
   Change: Add several fields
# ===============================================================
**/
AS
		SELECT 																		
				G.[id_grid_parent] As id_folder,																	
				O.[name_folder],																	
				F.[id_column],																	
				F.[id_grid],																	
				G.[name_grid],																	
				G.[id_table_view],																	
				S.[name_table_view],																	
				F.[id_field],																	
				V.[name_field],																	
				F.[name_column],																	
				F.[order_column],																	
				F.[is_editable],
				F.[is_mandatory],																
				F.[regular_expression],																	
				F.[is_sortable],																	
				F.[error_message],																	
				F.[url],																	
				F.[width],																	
				F.[combo_datasource_name],																	
				F.[combo_datavaluefield_name],																	
				F.[combo_datatextfield_name],																	
				F.[combo_defaultfield_value],																	
				F.[combo_page_size],																	
				F.[combo_filtered_column_name],																	
				F.[combo_filtered_pattern],																	
				F.[combo_allow_custom_text],																	
				F.[group_index],																	
				F.[is_frozen],																	
				F.[thousand_separator],																	
				F.[decimal_precision],																	
				F.[filter_field],																	
				F.[sort_order],																	
				F.[column_align],																	
				F.[is_flex_used],																	
				F.[flex],																	
				F.[id_source_tenant] As f_id_source_tenant,																	
				F.[id_source],																	
				F.[id_change_set],																	
				G.[id_grid] As g_id_grid,																	
				G.[type_grid],																	
				T.[name] As [type_name],																	
				G.[comments],																	
				G.[page_size],																	
				G.[is_addable],																	
				G.[form_id],																	
				G.[url] As g_url,																	
				G.[is_deletable],																	
				G.[is_searchable],																	
				G.[is_exportable],
				G.[is_export_template_enabled],																
				G.[date_grid],																	
				G.[grouping_field],																	
				G.[frozen_column],																	
				G.[active_trace],																	
				G.[filtering_field],																	
				G.[is_simulated],																	
				G.[is_importable],																	
				G.[idOwner],																	
				G.[is_auto_resize],																	
				G.[is_track_change],																	
				G.[sort_grid],																	
				G.[width] As g_width,																	
				G.[fit_to_screen],
				G.[wrap_header],
				G.[sp_grid_add_pre],
				G.[sp_grid_add_post],
				G.[sp_grid_save_pre],
				G.[sp_grid_save_post],
				G.[sp_grid_delete_pre],
				G.[sp_grid_delete_post],
				G.[sp_grid_import_pre],
				G.[sp_grid_import_post],
				G.[is_bulk_insert],
				G.[is_password_protection_enabled],													
				G.[id_source_tenant],																	
				G.[id_source] As g_id_source,																	
				G.[id_change_set] As g_id_change_set																	
			FROM k_referential_grids_fields F																		
			LEFT JOIN k_referential_grids G																		
				ON F.[id_grid]=G.[id_grid] 																		
			LEFT JOIN k_referential_grids_types T																		
				ON G.[type_grid]=T.[id]																		
			LEFT JOIN k_referential_grid_folders O																		
				ON G.[id_grid_parent]=O.[id_folder]																		
			LEFT JOIN k_referential_tables_views_fields V																		
				ON F.[id_field]=V.[id_field]																		
			LEFT JOIN k_referential_tables_views S																		
				ON G.[id_table_view]=S.[id_table_view]