CREATE VIEW Kernel_View_Grid_Tab_Unassigned AS
SELECT 
	KG.id_grid AS id_parent_grid,
	'G_'+ CONVERT(varchar(50), KGJ.id_grid) AS id,
	KGJ.name_grid AS name_field,
	'GV_Grid' AS [type],
	1 AS id_type
FROM k_referential_grids KG
CROSS JOIN k_referential_grids KGJ 
LEFT JOIN k_referential_grid_tab KGT ON KGT.id_grid = KGJ.id_grid AND KGT.id_parent_grid=KG.id_grid
WHERE 
	KGT.id_grid_tab IS NULL AND 
	KG.id_grid > 0 AND
	KGJ.id_grid > 0 AND 
	KG.id_grid <> KGJ.id_grid

UNION ALL

SELECT 
	KG.id_grid AS id_parent_grid,
	'F_'+ CONVERT(varchar(50), KFJ.form_id) AS id,
	KFJ.form_name AS name_field,
	'GV_Form' AS [type],
	2 AS id_type
FROM k_referential_grids KG
CROSS JOIN k_referential_form KFJ 
LEFT JOIN k_referential_grid_tab KGT ON KGT.id_form = KFJ.form_id AND KGT.id_parent_grid=KG.id_grid
WHERE 
	KGT.id_grid_tab IS NULL AND 
	KG.id_grid > 0 AND
	KFJ.form_id > 0 AND KFJ.table_view_id IS NOT NULL