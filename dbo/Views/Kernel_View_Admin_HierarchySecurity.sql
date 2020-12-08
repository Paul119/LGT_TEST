CREATE VIEW [dbo].[Kernel_View_Admin_HierarchySecurity]
AS
SELECT
	ts.id_tree_security 
	,u.firstname_user +' ' + u.lastname_user as [user_name]
	,p.name_profile as [profile_name]
	,up.id_profile
	,nt.name as [tree_name]
	,ts.begin_date
	,ts.end_date
	,tst.name_tree_security_type
	,
	CASE ts.is_apply_filter
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
	AS filters
	,
	(
		CASE nlp.idType
			WHEN 14 THEN (SELECT TOP 1 firstname + ' ' + lastname FROM py_Payee WHERE idPayee = nlp.idChild)
			WHEN 47 THEN (SELECT TOP 1 long_name_territory FROM Dim_Territory WHERE Dim_Territory.id_territory = nlp.idChild)
			WHEN 48 THEN (SELECT TOP 1 long_name_structure FROM Dim_Structure WHERE Dim_Structure.id_structure = nlp.idChild)
			WHEN 49 THEN (SELECT TOP 1 long_name_department FROM Dim_Department WHERE Dim_Department.id_department = nlp.idChild)
		END
	) AS node
	,
	STUFF
	(
	(
		SELECT ', ' + 
				CASE nlp2.idType
					WHEN 14 THEN (SELECT TOP 1 firstname + ' ' + lastname FROM py_Payee WHERE idPayee = nlp2.idChild)
					WHEN 47 THEN (SELECT TOP 1 long_name_territory FROM Dim_Territory WHERE Dim_Territory.id_territory = nlp2.idChild)
					WHEN 48 THEN (SELECT TOP 1 long_name_structure FROM Dim_Structure WHERE Dim_Structure.id_structure = nlp2.idChild)
					WHEN 49 THEN (SELECT TOP 1 long_name_department FROM Dim_Department WHERE Dim_Department.id_department = nlp2.idChild)
				END AS [text()]
		FROM	k_tree_security_exception tse
		JOIN hm_NodelinkPublished nlp2
			ON tse.id_tree_node_published = nlp2.id 
		WHERE tse.id_tree_security = ts.id_tree_security
		FOR XML PATH('')
	)
	,1,1,''
	) AS exclusions
	,ts.description_security
	,u.id_user
	,ts.id_owner
	,u2.login_user as [owner_name]
	,CASE ts.is_apply_filter 
		WHEN 0 THEN '' 
		ELSE
			CASE WHEN ts.is_included = 1 THEN 'GV_Include' ELSE 'GV_Exclude' END
	 END as pop_filter_used
FROM k_tree_security ts
JOIN k_users_profiles up
	ON ts.id_user_profile = up.idUserProfile
JOIN k_users u
	ON up.id_user = u.id_user
JOIN k_profiles p
	ON up.id_profile = p.id_profile
JOIN hm_NodelinkPublished nlp
	ON ts.id_tree_node_published = nlp.id
JOIN hm_NodeTreePublished nt
	ON nlp.idTree = nt.id
JOIN k_users u2
	ON ts.id_owner = u2.id_user
LEFT JOIN k_tree_security_type tst
	ON ts.id_tree_security_type = tst.id_tree_security_type