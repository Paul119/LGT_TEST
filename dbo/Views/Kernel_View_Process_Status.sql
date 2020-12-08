CREATE VIEW [Kernel_View_Process_Status] AS 
SELECT DISTINCT
psg.id_plan_profile_status_group as [id_plan_profile_status_group],
kmp.id_plan AS [id_plan],
prf.id_profile
,culture.value AS [active_culture]
,prf.name_profile AS [profile]
,ISNULL([Current].[CurrentActiveStatusName], [DefaultStatus].[DefaultStatus]) AS [currentActiveStatusName]
,CAST(ISNULL(CONVERT(varchar(50), [Next].[CurrentStatusUntil]) ,'2999-12-31' ) as date) AS [currentStatusUntil]
,[Current].[currentStatusComment] AS [currentStatusComment]
,(SELECT STUFF(REPLACE(
	(SELECT ','+ s1.name_plan_status AS 'text()'
		FROM k_m_plan_profile_status_group psg1 
			INNER JOIN k_m_plan_profile_status ps1 ON psg1.id_plan_profile_status_group = ps1.id_plan_profile_status_group
			INNER JOIN k_m_plan_status s1 ON ps1.id_plan_status = s1.id_plan_status
			LEFT JOIN [rps_Localization] AS RPSLOC ON s1.name_plan_status = RPSLOC.name AND RPSLOC.item_id IS NULL AND RPSLOC.[module_type] = 17 AND culture.value = RPSLOC.culture
			WHERE psg1.id_profile = prf.id_profile AND psg1.id_plan = psg.id_plan AND ps1.[start_date] > GETUTCDATE()
			ORDER BY ps1.[start_date]
		FOR XML PATH ('')),'',', '),1,1,'')) AS [otherStatusesPlanned]
,psg.[description] AS [description]
 FROM  k_cultures AS culture 
 CROSS JOIN k_m_plans AS kmp  
 CROSS JOIN k_profiles prf
		LEFT JOIN k_m_plan_profile_status_group psg ON psg.id_profile = prf.id_profile AND psg.id_plan = kmp.id_plan
		OUTER APPLY ( SELECT TOP 1 DATEADD(dd, -1, start_date) [CurrentStatusUntil] 
						FROM  k_m_plan_profile_status opps 
						WHERE opps.id_plan_profile_status_group =psg.id_plan_profile_status_group and start_date > GETUTCDATE() 
						order by start_date) [Next]
		OUTER APPLY ( SELECT TOP 1 ps.name_plan_status AS [CurrentActiveStatusName],opps.[description] AS [currentStatusComment]
						FROM  k_m_plan_profile_status opps 
						INNER JOIN k_m_plan_status ps ON opps.id_plan_status = ps.id_plan_status
						WHERE opps.id_plan_profile_status_group = psg.id_plan_profile_status_group and start_date <= GETUTCDATE() 
						ORDER BY [start_date] DESC) AS [Current]
		OUTER APPLY (SELECT TOP 1 ps.[name_plan_status] AS [DefaultStatus]
						FROM k_m_plan_status AS ps
						WHERE [is_default] = 1
					) AS [DefaultStatus]