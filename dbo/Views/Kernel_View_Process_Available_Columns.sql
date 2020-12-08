CREATE VIEW [dbo].[Kernel_View_Process_Available_Columns]
AS
select 
	[P].id_plan
	, N'ic_' + CAST([RGF].id_column as nvarchar(50)) as id_column
	, [RGF].name_column as name_column
	, N'' AS [indicator_field_ids]
	, N'' AS [indicator_fields_names]
	, N'GV_Column_Type_Information' as type_column
	, NULL as filter_visibility
	, N'0' AS [indicator_fields_is_calculated]
	, CASE WHEN [RTVF].name_field = 'fullname' THEN 1 ELSE 0 END AS [mandatory]
	, c.culture
from 
k_cultures c,
k_m_plans AS [P]
	inner join k_m_type_plan AS [TP] on [TP].id_type_plan = [P].id_type_plan
	inner join k_referential_grids AS [RG] on [RG].id_grid = [TP].id_base_grid
	inner join k_referential_grids_fields AS [RGF] on [RGF].id_grid = [RG].id_grid
	inner join k_referential_tables_views_fields AS [RTVF] ON [RGF].id_field = [RTVF].id_field
where NOT EXISTS (  select *
  from k_m_plans_informations
 inner join k_referential_grids_fields on k_referential_grids_fields.id_column = k_m_plans_informations.id_field_grid
 WHERE k_m_plans_informations.id_plan = P.id_plan AND [RGF].id_column = k_referential_grids_fields.id_column
)
UNION ALL
SELECT
	  P.id_plan AS [id_plan]
	, 'if_' + CAST(I.id_ind as nvarchar(50)) as id_column
	, I.name_ind as name_column
	, FID.name_ids as indicator_field_ids
	,(
		SELECT LTRIM(RTRIM(STUFF((
			SELECT ', ' + ISNULL(loc.value,F.label_field) AS [text()]
			FROM k_m_indicators_fields AS [IF]
			INNER JOIN k_m_fields AS F ON [IF].id_field = F.id_field
			LEFT JOIN rps_Localization loc on loc.name = F.name_field and c.culture = loc.culture
			WHERE [IF].id_ind = [I].id_ind   order BY [IF].sort
			FOR XML PATH('')), 1, 1, ''))) AS [name_fields]
	) indicator_fields_names


	, 'GV_Column_Type_Indicator' as type_column
	, NULL as filter_visibility
	, FCALC.[name_calc] AS [indicator_fields_is_calculated]
	, 0 AS [mandatory]
	, c.culture
FROM 
k_cultures c,
[k_m_plans] AS P 
	CROSS APPLY k_m_indicators AS I
	LEFT JOIN k_m_plans_indicators AS [PI] on I.id_ind = [PI].id_ind AND PI.id_plan = P.id_plan	
	OUTER APPLY (
			SELECT TOP 1 [IF].id_indicator_field
			FROM k_m_indicators_fields AS [IF]
			INNER JOIN k_m_fields AS F ON [IF].id_field = F.id_field
			WHERE [IF].id_ind = [I].id_ind 
		) F
	OUTER APPLY (
		SELECT LTRIM(RTRIM(STUFF((
			SELECT ',' + CAST(F.id_field AS NVARCHAR) AS [text()]
			FROM k_m_indicators_fields AS [IF]
			INNER JOIN k_m_fields AS F ON [IF].id_field = F.id_field
			WHERE [IF].id_ind = [I].id_ind ORDER BY [IF].sort
			FOR XML PATH('')), 1, 1, ''))) AS [name_ids]
		) FID
	OUTER APPLY (
		SELECT LTRIM(RTRIM(STUFF((
			SELECT ',' + CAST(CASE [F].id_control_type WHEN -5 THEN 1 ELSE 0 END AS NVARCHAR) AS [text()]
			FROM k_m_indicators_fields AS [IF]
			INNER JOIN k_m_fields AS F ON [IF].id_field = F.id_field
			WHERE [IF].id_ind = [I].id_ind ORDER BY [IF].sort
			FOR XML PATH('')), 1, 1, ''))) AS [name_calc]
		) FCALC
		
	WHERE [PI].id_ind IS NULL AND id_indicator_field IS NOT NULL 
UNION ALL
SELECT 
	id_plan
	, 's_1' as id_column
	,'GV_start_date' as name_column
	, '' as indicator_field_ids
	, '' as indicator_fields_names
	,'GV_Column_Type_Standard' as type_column 
	, 0 as filter_visibility
	, N'0' AS [indicator_fields_is_calculated]
	, 0 AS [mandatory]
	, c.culture
	FROM
	k_cultures c,
	k_m_plans WHERE ISNULL(available_start_date, 1) = 0
UNION ALL
SELECT 
	id_plan
	,'s_2' as id_column
	,'GV_end_date' as name_column
	,'' AS [indicator_field_ids]
	,'' as [indicator_fields_names]
	,'GV_Column_Type_Standard' as type_column 
	, 0 as filter_visibility
	, N'0' AS [indicator_fields_is_calculated]
	, 0 AS [mandatory]
	, c.culture
	FROM
	k_cultures c,
	k_m_plans where ISNULL(available_end_date, 1) = 0
UNION ALL
SELECT 
	id_plan
	,'s_3' as id_column
	,'GV_workflow_status' as name_column
	, '' as indicator_field_ids
	,'' as indicator_fields_names
	,'GV_Column_Type_Standard' as type_column
	, 0 as filter_visibility
	, N'0' AS [indicator_fields_is_calculated]
	, 0 AS [mandatory]
	, c.culture
	FROM 
	k_cultures c,
	k_m_plans where ISNULL(available_workflow_status,1) = 0 AND is_workflow_active = 1
UNION ALL
SELECT 
	id_plan
	,'s_4' as id_column
	,'GV_workflow_step_name' as name_column
	, '' as indicator_field_ids
	,'' as indicator_fields_names
	,'GV_Column_Type_Standard' as type_column
	, 0 as filter_visibility
	, N'0' AS [indicator_fields_is_calculated]
	, 0 AS [mandatory]
	, c.culture
	FROM 
	k_cultures c,
	k_m_plans where ISNULL(available_workflow_step_name,1) = 0  AND is_workflow_active = 1