CREATE VIEW [dbo].[Kernel_View_Admin_GridEditor]
AS 

--SELECT     G.name_grid, G.id_grid,  G.id_grid_parent, CAST(G.comments AS VARCHAR) AS comments, (CASE WHEN G.id_grid_parent IS NOT NULL THEN
--                          (SELECT     name_grid
--                            FROM          k_referential_grids
--                            WHERE      id_grid = G.id_grid_parent) ELSE NULL END) AS name_grid_parent, G.id_table_view, T.name_table_view, T.type_table_view,
--                      G.page_size, G.is_addable, G.form_id, G.is_deletable, G.is_searchable, G.is_exportable, G.date_grid, dsu.id_user, dsu.id_profile, G.type_grid
--FROM         dbo.k_referential_grids AS G INNER JOIN
--                      dbo.k_referential_tables_views AS T ON T.id_table_view = G.id_table_view INNER JOIN
--                      dbo.k_dataspaces_tables_views AS dsd ON dsd.id_table_view = G.id_table_view INNER JOIN
--                      dbo.k_dataspaces AS ds ON ds.id = dsd.id_dataspace INNER JOIN
--                  dbo.k_dataspaces_users_profiles AS dsu ON dsu.id_dataspace = ds.id

--WHERE   (SELECT DISTINCT T.id_table_view FROM k_referential_tables_views AS T JOIN   k_referential_tables_views_fields AS F ON F.id_table_view = T.id_table_view WHERE G.id_table_view = T.id_table_view) IS NOT NULL

--UNION
SELECT     G.id_grid,G.name_grid, G.id_grid_parent, CAST(G.comments AS VARCHAR) AS comments, (CASE WHEN G.id_grid_parent IS NOT NULL THEN
                          (SELECT     name_grid
                            FROM          k_referential_grids
                            WHERE      id_grid = G.id_grid_parent) ELSE NULL END) AS name_grid_parent, G.id_table_view, T.name_table_view, T.type_table_view,
                      G.page_size, G.is_addable, G.form_id, G.is_deletable, G.is_searchable, G.is_exportable, G.date_grid, NULL AS id_user, NULL AS id_profile, G.type_grid
FROM         dbo.k_referential_grids AS G INNER JOIN
                      dbo.k_referential_tables_views AS T ON T.id_table_view = G.id_table_view
WHERE   (SELECT DISTINCT T.id_table_view FROM k_referential_tables_views AS T JOIN   k_referential_tables_views_fields AS F ON F.id_table_view = T.id_table_view WHERE G.id_table_view = T.id_table_view) IS NOT NULL;