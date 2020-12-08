CREATE VIEW [dbo].[Kernel_View_Data_Grid_Field_Validations]
AS
    SELECT  grid.id_grid ,
            tableViewField.id_field ,
            tableViewField.name_field ,
            CASE WHEN EXISTS ( SELECT   *
                               FROM     dbo.k_referential_grid_field_validation validationField
                               WHERE    validationField.id_grid = grid.id_grid  and validationField.id_field = tableViewField.id_field)
                 THEN 'GV_Validation'
                 ELSE ''
            END AS validation_enabled ,
            ISNULL(( SELECT id_grid_field_validation
                     FROM   k_referential_grid_field_validation validationField
                     WHERE  validationField.id_grid = grid.id_grid  and validationField.id_field = tableViewField.id_field
                   ), 0) AS id_grid_field_validation ,
            CASE WHEN gridField.id_field IS NOT NULL
                 THEN 1
                 ELSE 0
            END AS selected_columns
    FROM    k_referential_grids grid
            JOIN k_referential_tables_views_fields tableViewField on grid.id_table_view = tableViewField.id_table_view
            left join k_referential_grids_fields gridField on tableViewField.id_field = gridField.id_field
                                                              and gridField.id_grid = grid.id_grid;