CREATE VIEW [dbo].[Kernel_View_Search]
    AS SELECT 
         Q.[id_item]
       , Q.[id_module]
       , Q.[id_itemtype]
       , Q.[id_hierarchy]
       , Q.[id_accordion_module]
       , ISNULL(L.[value], Q.[Text]) AS [Text]
       , Q.[id_owner]
       , ISNULL(L.[culture], '') AS [culture]
       FROM (
       SELECT -- From k_modules but not report items on accordion -116
               Q.[id_item]
             , Q.[id_module]
             , Q.[id_itemtype]
             , NULL AS [id_hierarchy]
             , Q.[id_accordion_module]
             , Q.[Text]
             , 0 AS [id_owner]                
       FROM (
             SELECT 
                             ISNULL(M.id_item, M.id_module) AS [id_item]
                           , M.id_tab AS [id_module]
                           , CASE WHEN M.id_module_type = 5 THEN CASE WHEN CH.C > 0 THEN 44 ELSE 43 END ELSE 4 END AS [id_itemtype]                   
                           , CASE WHEN M2.id_module_type = 4 THEN M2.id_module ELSE CASE WHEN M3.id_module_type = 4 THEN M3.id_module ELSE NULL END END AS [id_accordion_module]
                           , M.name_module AS [Text]
                    FROM k_modules M WITH (NOLOCK)
                           LEFT JOIN k_modules M2 WITH (NOLOCK) ON M.id_parent_module = M2.id_module
                           LEFT JOIN k_modules M3 WITH (NOLOCK) ON M2.id_parent_module = M3.id_module
						   OUTER APPLY(
								SELECT Count(*) AS C FROM k_modules KM where KM.id_parent_module = M.id_module AND KM.id_module_type in (5,2)
						   ) CH                           
                    WHERE 
                           M.id_module_type in (5,2)
                           AND M.id_tab IN (-10,-9,-8,-7,-6,-5,-4,-3,-2,-1)
						   AND M.id_parent_module <> -237 
						   AND M.id_module <> -237
             ) Q
             WHERE Q.id_accordion_module IS NOT NULL
		UNION ALL
			 SELECT -- From k_modules only report items on accordion -116
               Q.[id_item]
             , Q.[id_module]
             , Q.[id_itemtype]
             , NULL AS [id_hierarchy]
             , Q.[id_accordion_module]
             , Q.[Text]
             , 0 AS [id_owner]
       FROM (
             SELECT 
                             ISNULL(M.id_item, M.id_module) AS [id_item]
                           , M.id_tab AS [id_module]
                           , CASE WHEN M.id_parent_module = -237 THEN 72 ELSE 71 END AS [id_itemtype]                  
                           , CASE WHEN M2.id_module_type = 4 THEN M2.id_module ELSE CASE WHEN M3.id_module_type = 4 THEN M3.id_module ELSE NULL END END AS [id_accordion_module]
                           , M.name_module AS [Text]						   
                    FROM k_modules M WITH (NOLOCK)
                           LEFT JOIN k_modules M2 WITH (NOLOCK) ON M.id_parent_module = M2.id_module
                           LEFT JOIN k_modules M3 WITH (NOLOCK) ON M2.id_parent_module = M3.id_module                           
                    WHERE 
                            M.id_parent_module = -237 OR M.id_module = -237
             ) Q
             WHERE Q.id_accordion_module IS NOT NULL 
       UNION ALL
             SELECT --People Folder.Population
                      idFolder AS [id_item]
                    , -3 AS [id_module]
                    , 1 AS [id_itemtype]
                    , NULL AS [id_hierarchy]
                    , -105 AS [id_accordion_module]
                    , nameFolder AS [Text]
                    , ISNULL(idOwner, 0) AS [id_owner]
             FROM [dbo].[pop_Folders] WITH (NOLOCK)
       UNION ALL
             SELECT --People.Population
                      idPop AS [id_item]
                    , -3 AS [id_module]
                    , 2 AS [id_itemtype]
                    , NULL AS [id_hierarchy]
                    , -105 AS [id_accordion_module]
                    , name AS [Text]
                    , ISNULL(idOwner, 0) AS [id_owner]
             FROM [dbo].[pop_Population] WITH (NOLOCK)
			 WHERE ISNULL(isSimulated, 0) = 0
       UNION ALL
             SELECT --Setup.Process 
                      id_plan AS [id_item]
                    , -4 AS [id_module]
                    , 9 AS [id_itemtype]
                    , NULL AS [id_hierarchy]
                    , -107 AS [id_accordion_module]
                    , P.name_plan AS [Text]
                    , ISNULL(id_owner, 0) AS [id_owner]                    
             FROM [dbo].[k_m_plans] AS P  WITH (NOLOCK)
		UNION ALL
             SELECT --Setup.ProcessFolder
                      id_folder AS [id_item]
                    , -4 AS [id_module]
                    , 8 AS [id_itemtype]
                    , NULL AS [id_hierarchy]
                    , -107 AS [id_accordion_module]
                    , P.name_folder AS [Text]
                    , ISNULL(id_owner, 0) AS [id_owner]
             FROM [dbo].[k_m_plans_folders] AS P WITH (NOLOCK)
		UNION ALL
            SELECT --Rule Folder
                      id_folder AS [id_item]
                    , -5 AS [id_module]
                    , 5 AS [id_itemtype]
                    , NULL AS [id_hierarchy]
                    , -110 AS [id_accordion_module]
                    , P.name_folder AS [Text]
                    , ISNULL(id_owner, 0) AS [id_owner]
			FROM [dbo].[k_program_folders] AS P WITH (NOLOCK)
		UNION ALL
            SELECT --Rule
                      id_prog AS [id_item]
                    , -5 AS [id_module]
                    , 6 AS [id_itemtype]
                    , NULL AS [id_hierarchy]
                    , -110 AS [id_accordion_module]
                    , name_prog AS [Text]
                    , ISNULL(id_owner, 0) AS [id_owner]
            FROM [dbo].[k_program] WITH (NOLOCK)
			WHERE ISNULL(is_simulated, 0) = 0
		UNION ALL
			SELECT -- Rule Conditions
                      C.id_cond AS [id_item]
                    , -5 AS [id_module]
					,CASE WHEN C.sql_calc = '' OR C.sql_cond = '' THEN 7 ELSE 29 END AS [id_itemtype]
                    , null AS [id_hierarchy]
                    , -110 AS [id_accordion_module]
                    , C.name_cond AS [Text]
                    , ISNULL(C.id_owner, 0) AS [id_owner]
			FROM [dbo].[k_program_cond] AS C WITH (NOLOCK)
			INNER JOIN [dbo].[k_program] AS P WITH (NOLOCK) ON C.id_prog = P.id_prog
			WHERE ISNULL(P.is_simulated,0) = 0
		UNION ALL
			SELECT -- Rule Execution Plan
				  id_schedule AS [id_item]
				, -5 AS [id_module]
				, 34 AS [id_itemtype]
				, null AS [id_hierarchy]
				, -109 AS [id_accordion_module]
				, name_schedule AS [Text]
				, ISNULL(id_owner, 0) AS [id_owner]
			FROM [dbo].[k_program_execution_plan] WITH (NOLOCK)
		UNION ALL
            SELECT -- Rule Execution Plan Folder
				  id_folder AS [id_item]
				, -5 AS [id_module]
				, 33 AS [id_itemtype]
				, null AS [id_hierarchy]
				, -109 AS [id_accordion_module]
				, name_folder AS [Text]
				, ISNULL(id_owner, 0) AS [id_owner]
			FROM [dbo].[k_scheduler_folders] WITH (NOLOCK)
       UNION ALL
             SELECT -- Data Grid Folder
                      id_folder AS [id_item]
                    , -6 AS [id_module]
                    , 3 AS [id_itemtype]
                    , null AS [id_hierarchy]
                    , -111 AS [id_accordion_module]
                    , name_folder AS [Text]
                    , ISNULL(id_owner, 0) AS [id_owner]
                    FROM [dbo].[k_referential_grid_folders] WITH (NOLOCK)
					WHERE ISNULL(visibility, 1) = 1
		UNION ALL
            SELECT -- Comm Portal.Notification
                      id AS [id_item]
                    , -7 AS [id_module]
                    , 64 AS [id_itemtype]
                    , null AS [id_hierarchy]
                    , -119 AS [id_accordion_module]
                    , title AS [Text]
                    , ISNULL(idOwner, 0) AS [id_owner]
			FROM [dbo].[nc_Notification] WITH (NOLOCK)
		UNION ALL
            SELECT -- Comm Portal.Task
                      id AS [id_item]
                    , -7 AS [id_module]
                    , 65 AS [id_itemtype]
                    , null AS [id_hierarchy]
                    , -119 AS [id_accordion_module]
                    , title AS [Text]
                    , ISNULL(idOwner, 0) AS [id_owner]
            FROM [dbo].[nc_Task] WITH (NOLOCK)
       UNION ALL
             SELECT -- Comm Portal.Document
                      id AS [id_item]
                    , -7 AS [id_module]
                    , 66 AS [id_itemtype]
                    , null AS [id_hierarchy]
                    , -119 AS [id_accordion_module]
                    , title AS [Text]
                    , ISNULL(idOwner, 0) AS [id_owner]            
            FROM [dbo].[nc_Document] WITH (NOLOCK)
		UNION ALL
			SELECT -- Comm Portal.Report
                      id AS [id_item]
                    , -7 AS [id_module]
                    , 67 AS [id_itemtype]
                    , null AS [id_hierarchy]
                    , -119 AS [id_accordion_module]
                    , title AS [Text]
                    , ISNULL(idOwner, 0) AS [id_owner]
			FROM [dbo].[nc_Report] WITH (NOLOCK)
		UNION ALL
            SELECT -- Comm Portal.Folder
                      id_folder AS [id_item]
                    , -7 AS [id_module]
                    , NF.type_folder AS [id_itemtype]
                    , null AS [id_hierarchy]
                    , -119 AS [id_accordion_module]
                    , name_folder AS [Text]
                    , 0 AS [id_owner]
            FROM [dbo].[nc_Folder] NF WITH (NOLOCK)
       UNION ALL
            SELECT -- Analysis
				  id_report AS [id_item]
                , -9 AS [id_module]
                , 39 AS [id_itemtype]
                , null AS [id_hierarchy]
                , -117 AS [id_accordion_module]
                , name_report AS [Text]
                , ISNULL(id_owner, 0) AS [id_owner]
			FROM [dbo].[k_reports] WITH (NOLOCK)
       UNION ALL
             SELECT -- Analysis Folder
                      id_folder AS [id_item]
                    , -9 AS [id_module]
                    , 35 AS [id_itemtype]
                    , null AS [id_hierarchy]
                    , -117 AS [id_accordion_module]
                    , name_folder AS [Text]
                    , 0 AS [id_owner]
            FROM [dbo].[k_reports_folders] WITH (NOLOCK)
       UNION ALL
             SELECT -- Simulation
                      simulation_id AS [id_item]
                    , -10 AS [id_module]
                    , 53 AS [id_itemtype]
                    , null AS [id_hierarchy]
                    , -118 AS [id_accordion_module]
                    , simulation_name AS [Text]
                    , 0 AS [id_owner]                    
            FROM [dbo].[cm_simulation] WITH (NOLOCK)
       ) Q
	   LEFT JOIN rps_Localization L WITH (NOLOCK) ON Q.[Text] = L.[name] AND (L.item_id IS NULL OR L.item_id = Q.id_item)