CREATE VIEW [dbo].[Kernel_View_Data_Admin_Grid_HierarchySecurity]
AS
SELECT 
	  [G].id_grid
	, [HS].id_tree_security
	, [HS].user_name
	, [HS].profile_name
	, [HS].id_profile
	, [HS].tree_name 
	, [HS].begin_date 
	, [HS].end_date 
	, [HS].name_tree_security_type 
	, [HS].filters 
	, [HS].node 
	, [HS].exclusions 
	, [HS].description_security 
	, [HS].id_user 
	, [HS].id_owner 
	, [HS].owner_name 
	, [HS].pop_filter_used  

	FROM Kernel_View_Admin_HierarchySecurity [HS]
	INNER JOIN [k_profiles_modules_rights] AS [PMR] on [PMR].id_profile = [HS].id_profile
	INNER JOIN [k_modules_rights] AS [MR] on [MR].[id_module_right] = [PMR].id_module_right AND [MR].id_right = -1
	INNER JOIN [k_modules] AS [M] on [MR].id_module = [M].id_module AND [M].[id_module_type] = 2
	INNER JOIN [k_referential_grids] AS [G] ON [M].[id_item] = [G].[id_grid]
WHERE [G].id_grid > 0