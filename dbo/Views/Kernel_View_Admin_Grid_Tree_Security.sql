CREATE VIEW Kernel_View_Admin_Grid_Tree_Security AS
		SELECT 
		id_grid_security_tree,
		id_grid,
		(CASE view_type 
		 WHEN -1 THEN 'GV_ObjectSecurity' ELSE 'GV_HierarchySecurity' END) as view_type,
		name_grid_security_tree ,
		begin_date,
		end_date,
		include_selected_node ,
		override_permissions
		FROM k_referential_grid_security_tree