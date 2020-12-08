CREATE VIEW [dbo].[Kernel_View_Admin_Grid_Object_Security_Detail]
	AS 
	SELECT rgsta.id, pr.name_profile, us.firstname_user + ' ' + us.lastname_user AS user_name, gst.id_grid, gst.id_grid_security_tree
	from 
	k_referential_grid_security_tree_assignment as rgsta
	INNER JOIN k_referential_grid_security_tree  gst ON 	gst.id_grid_security_tree = rgsta.id_grid_security_tree
	INNER JOIN dbo.k_users_profiles AS up ON up.idUserProfile = rgsta.id_user_profile 
	INNER JOIN dbo.k_profiles As pr ON up.id_profile = pr.id_profile 
	INNER JOIN dbo.k_users AS us ON us.id_user = up.id_user 
	where rgsta.id_tree_security IS NULL