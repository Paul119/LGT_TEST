CREATE PROCEDURE [dbo].[sp_client_create_parent_child_grids_relation]                    
(                    
@Parent_Gri_dName NVARCHAR(255)
,@Child_Grid_Name NVARCHAR(255)
,@Parent_Table_Name NVARCHAR(255)
,@child_Table_Name NVARCHAR(255)
,@Parent_Field_Link NVARCHAR(255)
,@Child_Field_Link NVARCHAR(255)
,@Tab_Name NVARCHAR(255)
)                    
AS                    
                    
BEGIN                    
DECLARE @errors INT                     
SET @errors = 0                    
                    
BEGIN TRANSACTION update_grids_tran                    

DECLARE @ParentGridId INT = (SELECT krg.id_grid FROM k_referential_grids krg WHERE krg.name_grid = @Parent_Gri_dName)

DECLARE @ChildGrifId INT = (SELECT krg.id_grid FROM k_referential_grids krg WHERE krg.name_grid = @Child_Grid_Name)

UPDATE k_referential_grids
Set use_attached_objects = 1 
WHERE id_grid = @ParentGridId

DECLARE @ParentViewId INT = (SELECT krtv.id_table_view FROM k_referential_tables_views krtv WHERE krtv.name_table_view = @Parent_Table_Name)
DECLARE @ChildViewId INT = (SELECT krtv.id_table_view FROM k_referential_tables_views krtv WHERE krtv.name_table_view = @child_Table_Name)

DECLARE @ParentFieldId INT = (SELECT id_field FROM k_referential_tables_views_fields krtvf WHERE krtvf.id_table_view = @ParentViewId AND krtvf.name_field = @Parent_Field_Link)
DECLARE @ChildFieldId INT = (SELECT id_field FROM k_referential_tables_views_fields krtvf WHERE krtvf.id_table_view = @ChildViewId AND krtvf.name_field = @Child_Field_Link)

--DELETE FROM k_referential_grid_tab
--WHERE id_parent_grid = @ParentGridId

DELETE FROM k_referential_grid_tab_field_mapping
WHERE id_parent_table_view_field = @ParentFieldId

INSERT INTO k_referential_grid_tab (id_parent_grid,id_grid,grid_tab_name,refresh_type,display_order)
VALUES (@ParentGridId,@ChildGrifId,@Tab_Name,-2,1)
DECLARE @ChildGridtabId INT = (SELECT krgt.id_grid_tab FROM k_referential_grid_tab krgt WHERE krgt.id_parent_grid = @ParentGridId AND krgt.grid_tab_name = @Tab_Name)

INSERT INTO k_referential_grid_tab_field_mapping (id_grid_tab,id_parent_table_view_field,id_table_view_field)
VALUES (@ChildGridtabId,@ParentFieldId,@ChildFieldId)                 
              
SET @errors = @errors + @@error                    
IF @errors = 0                     
 COMMIT TRANSACTION update_grids_tran                   
ELSE                     
 ROLLBACK TRANSACTION update_grids_tran                   
                    
END