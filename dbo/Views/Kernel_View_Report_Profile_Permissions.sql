CREATE VIEW [dbo].[Kernel_View_Report_Profile_Permissions]
AS
	SELECT
		k_profiles_modules_rights.id_profile_module_right,
		k_profiles.name_profile,
		k_modules.name_module,
		k_profiles_modules_rights.start_date,
		k_profiles_modules_rights.end_date,
		k_modules.id_module,
		k_modules.id_item,
		CASE
		WHEN (k_profiles_modules_rights.start_date IS NOT  NULL OR k_profiles_modules_rights.end_date IS  NOT NULL)  THEN 'GV_Limited'
		ELSE 'GV_No_Limitations'
		END AS visibility_limitations     
	FROM k_profiles_modules_rights
	INNER JOIN k_profiles ON k_profiles.id_profile = k_profiles_modules_rights.id_profile
	INNER JOIN k_modules_rights ON k_modules_rights.id_module_right = k_profiles_modules_rights.id_module_right
	INNER JOIN k_modules ON k_modules.id_module = k_modules_rights.id_module
	WHERE 
		k_modules.id_module_type = 12 
		AND k_modules.id_parent_module=-408 
		AND k_modules_rights.id_right=-1