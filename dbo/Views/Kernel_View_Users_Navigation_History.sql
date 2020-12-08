
CREATE VIEW [dbo].[Kernel_View_Users_Navigation_History]
	AS SELECT 
		  H.[id_users_navigation_history]
		, H.[id_item]
		, H.[id_module]
		, H.[id_itemtype]
		, H.[id_hierarchy]
		, H.[id_accordion_module]
		, H.[id_user]
		, H.[id_profile]
		, H.[last_visit_time]
		, ISNULL([pop_Folders].nameFolder, 
			ISNULL([pop_Population].name, 
			ISNULL([k_referential_grid_folders].name_folder,
			ISNULL([k_referential_grids].name_grid,
			ISNULL([k_program_folders].name_folder,
			ISNULL([k_program].name_prog,
			ISNULL([k_program_cond].name_cond,
			ISNULL([k_m_plans_folders].name_folder,
			ISNULL([k_scheduler_folders].name_folder,
			ISNULL([k_program_execution_plan].name_schedule,
			ISNULL([cm_simulation].simulation_name,
			ISNULL([k_m_plans].name_plan,			
			ISNULL(CASE WHEN [py_Payee].[firstname] IS NOT NULL THEN [py_Payee].[firstname] + ' ' + [py_Payee].[lastname] ELSE NULL END,
			ISNULL([k_modules].name_module,
			ISNULL([k_reports].name_report,
			ISNULL([nc_Folder].name_folder,
			ISNULL([nc_Notification].title,
			ISNULL([nc_Task].title,
			ISNULL([nc_Document].title,
			ISNULL([nc_Report].title,
			ISNULL([k_reports_folders].name_folder,
			NULL))))))))))))))))))))) AS [Text]
	FROM [dbo].[k_users_navigation_history] AS H WITH (NOLOCK) 
		LEFT JOIN [dbo].[pop_Folders] WITH (NOLOCK) ON [pop_Folders].[idFolder] = H.[id_item] AND H.[id_itemtype] = 1
		LEFT JOIN [dbo].[pop_Population] WITH (NOLOCK) ON [pop_Population].[idPop] = H.[id_item] AND H.[id_itemtype] = 2
		LEFT JOIN [dbo].[k_referential_grid_folders] WITH (NOLOCK) ON [k_referential_grid_folders].[id_folder] = H.[id_item] AND H.[id_itemtype] = 3
		LEFT JOIN [dbo].[k_referential_grids] WITH (NOLOCK) ON [k_referential_grids].[id_grid] = H.[id_item] AND H.[id_itemtype] = 4
		LEFT JOIN [dbo].[k_program_folders] WITH (NOLOCK) ON [k_program_folders].[id_folder] = H.[id_item] AND H.[id_itemtype] = 5
		LEFT JOIN [dbo].[k_program] WITH (NOLOCK) ON [k_program].[id_prog] = H.[id_item] AND H.[id_itemtype] = 6
		LEFT JOIN [dbo].[k_program_cond] WITH (NOLOCK) ON [k_program_cond].[id_cond] = H.[id_item] AND H.[id_itemtype] IN (7, 29)
		LEFT JOIN [dbo].[k_m_plans_folders] WITH (NOLOCK) ON [k_m_plans_folders].[id_folder] = H.[id_item] AND H.[id_itemtype] = 8
		LEFT JOIN [dbo].[k_m_plans] WITH (NOLOCK) ON [k_m_plans].[id_plan] = H.[id_item] AND H.[id_itemtype] = 9
		LEFT JOIN [dbo].[py_Payee] WITH (NOLOCK) ON [py_Payee].[idPayee] = H.[id_item] AND H.[id_itemtype] = 14
		LEFT JOIN [dbo].[k_scheduler_folders] WITH (NOLOCK) ON [k_scheduler_folders].[id_folder] = H.[id_item] AND H.[id_itemtype] = 33
		LEFT JOIN [dbo].[k_program_execution_plan] WITH (NOLOCK) ON [k_program_execution_plan].[id_schedule] = H.[id_item] AND H.[id_itemtype] = 34
		LEFT JOIN [dbo].[k_reports] WITH (NOLOCK) ON [k_reports].[id_report] = H.[id_item] AND H.[id_itemtype] in (39,40)
		LEFT JOIN [dbo].[k_modules] WITH (NOLOCK) ON ([k_modules].[id_module] =H.id_item AND H.[id_itemtype] in (43,71,4,44)) OR ([k_modules].[id_item] =H.id_item AND H.[id_itemtype] = 72)
		LEFT JOIN [dbo].[cm_simulation] WITH (NOLOCK) ON [cm_simulation].[simulation_id] = H.[id_item] AND H.[id_itemtype] = 53
		LEFT JOIN [dbo].[nc_Folder] WITH (NOLOCK) ON [nc_Folder].[id_folder] = H.[id_item] AND H.[id_itemtype] in (62,61,63,60)
		LEFT JOIN [dbo].[nc_Notification] WITH (NOLOCK) ON [nc_Notification].[id] = H.[id_item] AND H.[id_itemtype] = 64
		LEFT JOIN [dbo].[nc_Task] WITH (NOLOCK) ON [nc_Task].[id] = H.[id_item] AND H.[id_itemtype] = 65
		LEFT JOIN [dbo].[nc_Document] WITH (NOLOCK) ON [nc_Document].[id] = H.[id_item] AND H.[id_itemtype] in (66,68)
		LEFT JOIN [dbo].[nc_Report] WITH (NOLOCK) ON [nc_Report].[id] = H.[id_item] AND H.[id_itemtype] = 67
		LEFT JOIN [dbo].[k_reports_folders] WITH (NOLOCK) ON [k_reports_folders].[id_folder] = H.[id_item] AND H.[id_itemtype] in (35,36)