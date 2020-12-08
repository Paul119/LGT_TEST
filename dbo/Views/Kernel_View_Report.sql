CREATE VIEW [dbo].[Kernel_View_Report]
AS
	SELECT [id_report]
      ,[id_folder]
      ,[name_report]
      ,[id_bar]
      ,[url_report]
      ,[sort_report]
      ,[type]
      ,[visual_type]
      ,[description]
      ,[id_owner]
      ,[id_source_tenant]
      ,[id_source]
      ,[id_change_set]
      ,[configuration_report]
      ,[id_report_model]
	  ,[is_password_protection_enabled]
,
STUFF
	(
		(
			SELECT 
			', ' + k_profiles.name_profile  AS [text()] 
			
			FROM k_modules
			INNER JOIN k_modules_rights ON k_modules_rights.id_module = k_modules.id_module AND k_modules_rights.id_right=-1
			LEFT JOIN k_profiles_modules_rights ON k_profiles_modules_rights.id_module_right = k_modules_rights.id_module_right
			LEFT JOIN k_profiles ON k_profiles.id_profile = k_profiles_modules_rights.id_profile
			WHERE k_modules.id_item = r.id_report AND id_module_type = 12
			FOR XML PATH('')
		)
	,1,2,''
	) AS allowed_profiles
,
ISNULL(
STUFF
	(
		(
			SELECT 
			', ' + k_profiles.name_profile  AS [text()] 
			
			FROM k_modules
			INNER JOIN k_modules_rights ON k_modules_rights.id_module = k_modules.id_module AND k_modules_rights.id_right=-1
			LEFT JOIN k_profiles_modules_rights ON k_profiles_modules_rights.id_module_right = k_modules_rights.id_module_right
			LEFT JOIN k_profiles ON k_profiles.id_profile = k_profiles_modules_rights.id_profile
			WHERE k_modules.id_item = r.id_report AND id_module_type = 12
			AND ( k_profiles_modules_rights.start_date IS NOT NULL OR k_profiles_modules_rights.end_date IS NOT NULL)
			FOR XML PATH('')
		)
		
	,1,2,''
	),'GV_No_Limitations') AS visibility_limitations
FROM k_reports r
WHERE r.type!=40