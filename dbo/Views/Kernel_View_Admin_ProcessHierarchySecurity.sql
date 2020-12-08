--UPDATE:[Ticket ID: 38194] Hierarchy security assignment : GF_Filters in the grid displays a value even if FF_usePopFilter is not checked - Also done for Process Hierarchy
CREATE VIEW [dbo].[Kernel_View_Admin_ProcessHierarchySecurity]
AS

SELECT        ts .id_tree_security, u.login_user AS user_name, p.name_profile AS profile_name, nt.name AS tree_name, ts .begin_date, ts .end_date, tst.name_tree_security_type,c.culture,
						     CASE ts .is_apply_filter WHEN 0 THEN '' ELSE STUFF
                             ((SELECT        ', ' + ISNULL(l.value, p.name) AS [text()]
                                 FROM            k_tree_security_filter tsf JOIN
                                                          pop_Population p ON tsf.id_pop = p.idPop
														  left join rps_localization l
															ON l.name = p.name and l.culture = c.culture
                                 WHERE        tsf.id_tree_security = ts .id_tree_security FOR XML PATH(''))
								 , 1, 1, '') END AS filters, (CASE nlp.idType WHEN 14 THEN
                             (SELECT        TOP 1 firstname + ' ' + lastname
                               FROM            py_Payee
                               WHERE        idPayee = nlp.idChild) WHEN 47 THEN
                             (SELECT        TOP 1 long_name_territory
                               FROM            Dim_Territory
                               WHERE        Dim_Territory.id_territory = nlp.idChild) WHEN 48 THEN
                             (SELECT        TOP 1 long_name_structure
                               FROM            Dim_Structure
                               WHERE        Dim_Structure.id_structure = nlp.idChild) WHEN 49 THEN
                             (SELECT        TOP 1 long_name_department
                               FROM            Dim_Department
                               WHERE        Dim_Department.id_department = nlp.idChild) END) AS node, STUFF
                             ((SELECT        ', ' + CASE nlp2.idType WHEN 14 THEN
                                                              (SELECT        TOP 1 firstname + ' ' + lastname
                                                                FROM            py_Payee
                                                                WHERE        idPayee = nlp2.idChild) WHEN 47 THEN
                                                              (SELECT        TOP 1 long_name_territory
                                                                FROM            Dim_Territory
                                                                WHERE        Dim_Territory.id_territory = nlp2.idChild) WHEN 48 THEN
                                                              (SELECT        TOP 1 long_name_structure
                                                                FROM            Dim_Structure
                                                                WHERE        Dim_Structure.id_structure = nlp2.idChild) WHEN 49 THEN
                                                              (SELECT        TOP 1 long_name_department
                                                                FROM            Dim_Department
                                                                WHERE        Dim_Department.id_department = nlp2.idChild) END AS [text()]
                                 FROM            k_tree_security_exception tse JOIN
                                                          hm_NodelinkPublished nlp2 ON tse.id_tree_node_published = nlp2.id
                                 WHERE        tse.id_tree_security = ts .id_tree_security FOR XML PATH('')), 1, 1, '') AS exclusions, tspl.id_tree_security_plan_level, STUFF
                             ((
										SELECT        ', ' + ISNULL(l.value, p.name_plan) AS [text()]
										 FROM            k_m_plan_data_security pds JOIN
														k_m_plans p ON pds.id_process = p.id_plan
														left join rps_localization l
															ON l.name = p.name_plan and l.culture = c.culture
														
										WHERE        pds.id_tree_security_plan_level = tspl.id_tree_security_plan_level
										FOR XML PATH(''))
										, 1, 1, '') AS processes
								  , STUFF
                             ((SELECT        ', ' + CASE nlp3.idType WHEN 14 THEN
                                                              (SELECT        TOP 1 firstname + ' ' + lastname
                                                                FROM            py_Payee
                                                                WHERE        idPayee = nlp3.idChild) WHEN 47 THEN
                                                              (SELECT        TOP 1 long_name_territory
                                                                FROM            Dim_Territory
                                                                WHERE        Dim_Territory.id_territory = nlp3.idChild) WHEN 48 THEN
                                                              (SELECT        TOP 1 long_name_structure
                                                                FROM            Dim_Structure
                                                                WHERE        Dim_Structure.id_structure = nlp3.idChild) WHEN 49 THEN
                                                              (SELECT        TOP 1 long_name_department
                                                                FROM            Dim_Department
                                                                WHERE        Dim_Department.id_department = nlp3.idChild) END AS [text()]
                                 FROM            k_tree_security_plan_level_exception tsple JOIN
                                                          hm_NodelinkPublished nlp3 ON tsple.id_tree_node_published = nlp3.id
                                 WHERE        tsple.id_tree_security_plan_level = tspl.id_tree_security_plan_level FOR XML PATH('')), 1, 1, '') AS plan_level_exclusions, tspl.begin_date AS plan_level_begin_date, 
                         tspl.end_date AS plan_level_end_date, tspl.is_override_workflow_permission, u.id_user, tspl.id_owner, u2.login_user AS owner_name, ts .description_security, ts .is_included
FROM            k_tree_security ts JOIN
                         k_tree_security_plan_level tspl ON ts .id_tree_security = tspl.id_tree_security JOIN
                         k_users_profiles up ON ts .id_user_profile = up.idUserProfile JOIN
                         k_users u ON up.id_user = u.id_user JOIN
                         k_profiles p ON up.id_profile = p.id_profile JOIN
                         hm_NodelinkPublished nlp ON ts .id_tree_node_published = nlp.id JOIN
                         hm_NodeTreePublished nt ON nlp.idTree = nt.id JOIN
                         k_users u2 ON tspl.id_owner = u2.id_user LEFT JOIN
                         k_tree_security_type tst ON ts .id_tree_security_type = tst.id_tree_security_type
						 , [k_cultures] AS [c]