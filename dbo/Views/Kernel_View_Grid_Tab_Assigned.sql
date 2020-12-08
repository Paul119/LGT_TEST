CREATE VIEW Kernel_View_Grid_Tab_Assigned AS
SELECT 
	id_parent_grid AS id_parent_grid,
	id_grid_tab AS id,
	CASE WHEN id_grid IS NOT NULL THEN id_grid ELSE id_form END AS id_child,
	grid_tab_name as name_field,
	CASE WHEN id_grid IS NOT NULL THEN 'GV_Grid' ELSE 'GV_Form' END AS [type],
	CASE WHEN id_grid IS NOT NULL THEN 1 ELSE 2 END AS id_type,
	display_order as display_order
FROM
	k_referential_grid_tab