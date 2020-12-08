CREATE VIEW [dbo].[Kernel_View_Admin_Grid_Hierarchy_Security_Detail]
AS 
	SELECT 
		  rgsta.id
		, pr.name_profile
		, us.firstname_user +  '' + us.lastname_user AS [user_name]
		, ntp.name AS [tree_node_published_name]
		, (
			CASE nlp.idType
				WHEN 14 THEN (SELECT TOP 1 firstname + ' ' + lastname FROM py_Payee WHERE idPayee = nlp.idChild)
				WHEN 47 THEN (SELECT TOP 1 long_name_territory FROM Dim_Territory WHERE Dim_Territory.id_territory = nlp.idChild)
				WHEN 48 THEN (SELECT TOP 1 long_name_structure FROM Dim_Structure WHERE Dim_Structure.id_structure = nlp.idChild)
				WHEN 49 THEN (SELECT TOP 1 long_name_department FROM Dim_Department WHERE Dim_Department.id_department = nlp.idChild)
			END
		) AS node
		, gst.id_grid
		,CASE ts.is_apply_filter
			When 0 THEN ''
			ELSE
			STUFF
			(
				(
					SELECT 
							', ' + p.name AS [text()]
					FROM	k_tree_security_filter tsf
					JOIN pop_Population p
						ON tsf.id_pop = p.idPop
					WHERE tsf.id_tree_security = ts.id_tree_security
					FOR XML PATH('')
				)
			,1,1,''
			)
			END
		AS population_name,
		gst.id_grid_security_tree
    FROM  dbo.k_referential_grid_security_tree_assignment AS rgsta 
		INNER JOIN k_referential_grid_security_tree AS gst ON gst.id_grid_security_tree = rgsta.id_grid_security_tree
		INNER JOIN dbo.k_tree_security AS ts ON ts.id_tree_security = rgsta.id_tree_security 
		INNER JOIN hm_NodelinkPublished nlp ON ts.id_tree_node_published = nlp.id
        INNER JOIN dbo.hm_NodeTreePublished AS ntp ON ntp.id = nlp.idTree 
        INNER JOIN dbo.k_users_profiles AS up ON up.idUserProfile = ts.id_user_profile 
		INNER JOIN dbo.k_profiles As pr ON up.id_profile = pr.id_profile 
        INNER JOIN dbo.k_users AS us ON us.id_user = up.id_user 
    WHERE rgsta.id_tree_security IS NOT NULL