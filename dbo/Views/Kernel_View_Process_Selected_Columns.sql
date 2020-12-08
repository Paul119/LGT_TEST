CREATE VIEW [dbo].[Kernel_View_Process_Selected_Columns]
AS
	SELECT
		[PI].id_plan,
		'IC_' + CAST([RGF].id_column as nvarchar(50)) as id_column,
		[RGF].name_column as name_column,
		'' as name_indicator,
		'GV_Column_Type_Information' as type_column,
		[PI].sort as sort_order_item,
		0 as id_ind,
		NULL as filter_visibility,
		0 as is_calculated
		, CASE WHEN [RTVF].name_field = 'fullname' THEN 1 ELSE 0 END AS [mandatory]
		, CASE WHEN [RTVF].type_field in ('bigint','numeric','bit','smallint','decimal','smallmoney','int','tinyint','money','float','real') THEN 1 ELSE 0 END AS is_calculatable
	FROM k_m_plans_informations AS [PI]
	INNER JOIN k_referential_grids_fields [RGF] on [RGF].id_column = [PI].id_field_grid
	INNER JOIN k_referential_tables_views_fields AS [RTVF] ON [RGF].id_field = [RTVF].id_field
UNION ALL
	SELECT
		  [I].id_plan
		, 'IF_' + CAST([F].id_field as nvarchar(50)) as [id_column]
		, [IS].name_ind as [name_column]
		, [F].label_field as [name_indicator]
		, 'GV_Column_Type_Indicator' as [type_column]
		, [IF].sort as [sort_order_item]
		, [IS].id_ind
		, NULL as filter_visibility
		, case [F].id_control_type when -5 then 1 else 0 end as [is_calculated]
		, 0 AS [mandatory]
		, case when [F].type_value  = 1 OR [F].type_value = 3 then 0 else 1 end as is_calculatable
	FROM k_m_plans_indicators AS [I]
		INNER JOIN k_m_indicators AS [IS] on [IS].id_ind = [I].id_ind
		INNER JOIN k_m_indicators_fields AS [IF] on [IF].id_ind = [I].id_ind
		INNER JOIN k_m_fields AS [F] on [F].id_field = [IF].id_field
UNION ALL
	SELECT 
		id_plan
		,'S_1' as id_column
		,'GV_start_date' as name_column
		,'' as name_indicator
		,'GV_Column_Type_Standard' as type_column
		,0 as sort_order_item 
		,0 as id_ind
		,filter_start_date_visibility as filter_visibility
		,0 as is_calculated
		, 0 AS [mandatory]
                , 0 as is_calculatable
		FROM k_m_plans where ISNULL(available_start_date, 1) = 1
UNION ALL
	SELECT 
		id_plan
		,'S_2' as id_column
		,'GV_end_date' as name_column
		,'' as name_indicator
		,'GV_Column_Type_Standard' as type_column
		,0 as sort_order_item 
		,0 as id_ind
		,filter_end_date_visibility as filter_visibility 
		,0 as is_calculated
		, 0 AS [mandatory]
                , 0 as is_calculatable
		FROM k_m_plans where ISNULL(available_end_date,1) = 1
UNION ALL
	SELECT 
		id_plan
		,'S_3' as id_column
		,'GV_workflow_status' as name_column
		,'' as name_indicator
		,'GV_Column_Type_Standard' as type_column
		,0 as sort_order_item 
		,0 as id_ind
		, NULL as filter_visibility 
		,0 as is_calculated
		, 0 AS [mandatory]
                , 0 as is_calculatable
		FROM k_m_plans where ISNULL(available_workflow_status,1) = 1  AND is_workflow_active = 1
UNION ALL
	SELECT 
		id_plan
		,'S_4' as id_column
		,'GV_workflow_step_name' as name_column
		,'' as name_indicator
		,'GV_Column_Type_Standard' as type_column
		,0 as sort_order_item 
		,0 as id_ind
		,filter_workflow_step_visibility 
		,0 as is_calculated
		, 0 AS [mandatory]
                , 0 as is_calculatable
		FROM k_m_plans where ISNULL(available_workflow_step_name,1) = 1 AND is_workflow_active = 1