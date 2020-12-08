

CREATE   PROCEDURE [dbo].[sp_client_create_separate_grid]
(																		
  @folder_name Nvarchar(255)																		
, @table_name Nvarchar(255)	
, @grid_name Nvarchar(255)																		
)																		
AS																		
																		
BEGIN																		
																		
DECLARE @Table_ID Int,																		
	@Field_ID Int,																	
	@Field_Name Nvarchar(255),																	
	@Type_Field Nvarchar(255),																	
	@NbRow Int,																	
	@Grid_ID Int,																	
	--@Grid_Name Nvarchar(255),																	
	@order_column Int,																	
	@Module_ID Int,																	
	@folder_id Int,																	
	@folder_row Int,																	
	@errors Int,																	
	@SQL_String Nvarchar(Max),
	@K_Modules_TypeGrid INT																	

																		
--BEGIN TRANSACTION create_grids_tran																		

SET @errors = 0																		
SET @K_Modules_TypeGrid = (SELECT id_module_type FROM k_modules_types WHERE name_module_type='grid') 					
SET @folder_id = (SELECT TOP 1 [id_folder] FROM k_referential_grid_folders WHERE [name_folder] = @folder_name)																																				
SET @folder_row = (SELECT Count([id_folder]) FROM k_referential_grid_folders WHERE [name_folder] = @folder_name)	
																	

/*********************************************************/
--Creation of the folder if it does not exist																		
IF @folder_row < 1																		
BEGIN																		
	INSERT INTO k_referential_grid_folders (																		
		[id_parent_folder] ,																	
		[name_folder] ,																	
		[is_public] ,																	
		[visibility] ,																	
		[id_owner] ,																	
		[date_create_folder] ,																	
		[id_user_update] ,																	
		[date_update_folder] ,																	
		[sort_folder] ,																	
		[id_source_tenant] ,																	
		[id_source] ,																	
		[id_change_set]																	
	)																		
	SELECT 																		
		-1, --[id_parent_folder] ,																	
		@folder_name ,																	
		NULL, --[is_public] ,																	
		NULL, --[visibility] ,																	
		-1, --[id_owner] ,																	
		NULL, --[date_create_folder] ,																	
		NULL, --[id_user_update] ,																	
		NULL, --[date_update_folder] ,																	
		Max(sort_folder)+1, --[sort_folder] ,																	
		NULL, --[id_source_tenant] ,																	
		NULL, --[id_source] ,																	
		NULL --[id_change_set]																	
	FROM k_referential_grid_folders																		
END																		
																		
SET @folder_id=(Select TOP 1 id_folder From k_referential_grid_folders Where name_folder=@folder_name)
PRINT '@folder_id=' + Convert(Varchar,@folder_id)																		



/*********************************************************/
--Creation of the grid if it does not exist																																				
SET @Table_ID = (SELECT id_table_view FROM k_referential_tables_views WHERE name_table_view = @table_name)																
SET @errors = @errors + @@error																		
																		
IF NOT EXISTS(SELECT id_grid FROM k_referential_grids WHERE id_table_view = @Table_ID AND name_grid = @grid_name)																	
BEGIN																	
	INSERT INTO k_referential_grids (																	
	[id_table_view] ,																	
	[id_grid_parent] ,																	
	[name_grid] ,																	
	[type_grid] ,																	
	[comments] ,																	
	[page_size] ,																	
	[is_addable] ,																	
	[form_id] ,																	
	[url] ,																	
	[is_deletable] ,																	
	[is_searchable] ,																	
	[is_exportable] ,																	
	[date_grid] ,																	
	[grouping_field] ,																	
	[frozen_column] ,																	
	[active_trace] ,																	
	[filtering_field] ,																	
	[is_simulated] ,																	
	[is_importable] ,																	
	[idOwner] ,																	
	[is_auto_resize] ,																	
	[is_track_change] ,																	
	[sort_grid] ,																	
	[width] ,																	
	[fit_to_screen] ,																	
	[id_source_tenant] ,																	
	[id_source] ,																	
	[id_change_set]																	
	)																	
	VALUES (																	
	@Table_ID, --[id_table_view] ,																	
	@folder_id, --[id_grid_parent] ,																	
	@grid_name, --[name_grid] ,																	
	-1, --[type_grid] ,																	
	NULL, --[comments] ,																	
	20, --[page_size] ,																	
	1, --[is_addable] ,																	
	NULL, --[form_id] ,																	
	NULL, --[url] ,																	
	1, --[is_deletable] ,																	
	0, --[is_searchable] ,																	
	1, --[is_exportable] ,																	
	NULL, --[date_grid] ,																	
	NULL, --[grouping_field] ,																	
	NULL, --[frozen_column] ,																	
	0, --[active_trace] ,																	
	NULL, --[filtering_field] ,																	
	0, --[is_simulated] ,																	
	1, --[is_importable] ,																	
	-1, --[idOwner] ,																	
	0, --[is_auto_resize] ,																	
	0, --[is_track_change] ,																	
	0, --[sort_grid] ,																	
	NULL, --[width] ,																	
	1, --[fit_to_screen] ,																	
	NULL, --[id_source_tenant] ,																	
	NULL, --[id_source] ,																	
	NULL --[id_change_set]																	
	)																	
END																	
ELSE																	
BEGIN																	
		--UPDATE k_referential_grids																	
		--SET [id_table_view] = @Table_ID, [name_grid] = @table_name																	
		--WHERE id_table_view = @Table_ID AND name_grid = @grid_name		
		PRINT 'The grid already exists'														
END																	





/*********************************************************/
--Creation of the module if it does not exist																																				
SELECT @Grid_ID = id_grid FROM k_referential_grids WHERE [id_table_view] = @Table_ID AND name_grid = @grid_name																	
																		
IF NOT EXISTS(SELECT id_item FROM k_modules WHERE id_item = @Grid_ID)																		
BEGIN																	
	INSERT INTO k_modules (																	
	[id_parent_module] ,																	
	[name_module] ,																	
	[id_module_type] ,																	
	[id_tab] ,																	
	[id_item] ,																	
	[order_module] ,																	
	[id_source_tenant] ,																	
	[id_source] ,																	
	[id_change_set] 																	
	)																	
	VALUES (																	
	-111 , --[id_parent_module] ,																	
	@Grid_Name , --[name_module] ,																	
	@K_Modules_TypeGrid , --[id_module_type] ,																	
	-6 , --[id_tab] ,																	
	@Grid_ID , --[id_item] ,																	
	0 , --[order_module] ,																	
	NULL , --[id_source_tenant] ,																	
	NULL , --[id_source] ,																	
	NULL --[id_change_set] 																	
	)																	
END																	
ELSE																	
BEGIN																	
	UPDATE k_modules																	
	SET [name_module] = @Grid_Name																
	WHERE id_item = @Grid_ID																	
END																	
																		
SET @Module_ID = (SELECT id_module FROM k_modules WHERE id_item = @Grid_ID AND id_module_type = @K_Modules_TypeGrid)																		
IF NOT EXISTS(SELECT id_module FROM k_modules_rights WHERE id_module = @Module_ID)																		
	BEGIN																		
		Insert Into k_modules_rights(id_module, id_right) Values(@Module_ID,-1)
		Insert Into k_modules_rights(id_module, id_right) Values(@Module_ID,-3)
		Insert Into k_modules_rights(id_module, id_right) Values(@Module_ID,-9)
		Insert Into k_modules_rights(id_module, id_right) Values(@Module_ID,-4)
		Insert Into k_modules_rights(id_module, id_right) Values(@Module_ID,-6)
		Insert Into k_modules_rights(id_module, id_right) Values(@Module_ID,-16)
		Insert Into k_modules_rights(id_module, id_right) Values(@Module_ID,-27)
		Insert Into k_modules_rights(id_module, id_right) Values(@Module_ID,-28)
		Insert Into k_modules_rights(id_module, id_right) Values(@Module_ID,-29)
		Insert Into k_modules_rights(id_module, id_right) Values(@Module_ID,-30)
		Insert Into k_modules_rights(id_module, id_right) Values(@Module_ID,-31)
		Insert Into k_modules_rights(id_module, id_right) Values(@Module_ID,-32)																	
	END																	




/*********************************************************/
--Creation of the fields if they do not exist																																																					
SET @errors = @errors + @@error																		
SET @order_column = 0																		
DECLARE Field_Cursor CURSOR FOR																		
	SELECT F.id_field, F.name_field																	
	FROM k_referential_tables_views T	
	LEFT JOIN k_referential_tables_views_fields F ON T.id_table_view = F.id_table_view	
	WHERE T.id_table_view = @Table_ID AND ISNULL(F.constraint_field,'') not like '%IDENTITY%'
	AND F.name_field NOT IN ('id_user','CreatedDate','ModificationDate', 'ParentId')
	ORDER BY F.order_field
OPEN Field_Cursor																		
FETCH NEXT FROM Field_Cursor INTO @Field_ID, @Field_Name																		
WHILE @@FETCH_STATUS = 0																		
   BEGIN																		
																		
	  IF NOT EXISTS(SELECT id_field FROM k_referential_grids_fields WHERE id_field = @Field_ID AND id_grid = @Grid_ID)																	
		BEGIN																
			INSERT INTO k_referential_grids_fields (																
			[id_grid] ,																
			[id_field] ,																
			[name_column] ,																
			[order_column] ,																
			[is_editable] ,																
			[regular_expression] ,																
			[is_sortable] ,																
			[error_message] ,																
			[url] ,																
			[width] ,																
			[combo_datasource_name] ,																
			[combo_datavaluefield_name] ,																
			[combo_datatextfield_name] ,																
			[combo_defaultfield_value] ,																
			[combo_page_size] ,																
			[combo_filtered_column_name] ,																
			[combo_filtered_pattern] ,																
			[combo_allow_custom_text] ,																
			[group_index] ,																
			[is_frozen] ,																
			[thousand_separator] ,																
			[decimal_precision] ,																
			[filter_field] ,																
			[sort_order] ,																
			[column_align] ,																
			[is_flex_used] ,																
			[flex] ,																
			[id_source_tenant] ,																
			[id_source] ,																
			[id_change_set] 																
			)																
			VALUES (																
			@Grid_ID , --[id_grid] ,																
			@Field_ID , --[id_field] ,																
			@Field_Name , --[name_column] ,																
			@order_column , --[order_column] ,																
			1 , --[is_editable] ,																
			NULL , --[regular_expression] ,																
			1 , --[is_sortable] ,																
			NULL , --[error_message],
			NULL , --[url] ,																
			100 , --[width] ,																
			'' , --[combo_datasource_name] ,																
			'' , --[combo_datavaluefield_name] ,																
			'' , --[combo_datatextfield_name] ,																
			NULL , --[combo_defaultfield_value] ,																
			NULL , --[combo_page_size] ,																
			NULL , --[combo_filtered_column_name] ,																
			NULL , --[combo_filtered_pattern] ,																
			NULL , --[combo_allow_custom_text] ,																
			NULL , --[group_index] ,																
			NULL , --[is_frozen] ,																
			1 , --[thousand_separator] ,																
			0 , --[decimal_precision] ,																
			'' , --[filter_field] ,																
			0 , --[sort_order] ,																
			'left' , --[column_align] ,																
			1 , --[is_flex_used] ,																
			1 , --[flex] ,																
			NULL , --[id_source_tenant] ,																
			NULL , --[id_source] ,																
			NULL   --[id_change_set] 																
			)																
		END																
		ELSE																
		BEGIN																
			UPDATE k_referential_grids_fields																
			SET [name_column] = @Field_Name , [order_column] = @order_column															
			WHERE [id_field] = @Field_ID AND id_grid = @Grid_ID																
		END																
		SET @order_column = @order_column + 1																
      FETCH NEXT FROM Field_Cursor INTO @Field_ID, @Field_Name																		
   END																		
CLOSE Field_Cursor																		
DEALLOCATE Field_Cursor																		
																		
--SET @errors = @errors + @@error																		
----IF @errors = 0 																		
----	COMMIT TRANSACTION create_grids_tran 																	
----ELSE 																		
----	ROLLBACK TRANSACTION create_grids_tran																	
																		
END