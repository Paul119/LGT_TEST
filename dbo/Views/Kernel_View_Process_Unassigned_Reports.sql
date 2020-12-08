CREATE view [dbo].[Kernel_View_Process_Unassigned_Reports]
as
SELECT * FROM (
select 
	S.id_plan_tab_standard AS [id] ,
	S.name_plan_tab_standard AS tab_name,
	P.id_plan as id_plan,
	-1 AS id_plan_form_tab_type,
	-5 AS [type],
	'GF_Standart' AS [type_name] 
	 from k_m_plans P
	 cross join k_m_plan_tab_standard S
	 left join k_m_plans_form_report KF on KF.id_plan=P.id_plan and KF.id_plan_form_report_type = -5 and KF.id_report = S.id_plan_tab_standard
	 Where KF.id IS NULL
UNION ALL 
	select 
	R.id_report AS [id] ,
	R.name_report AS tab_name,
	P.id_plan as id_plan,
	-1 AS id_plan_form_tab_type ,
    -1 AS [type],
	'GF_Report' AS [type_name] 
	 from k_m_plans P
	 cross join (select * from k_reports where type=77 /*77:ProcessReport*/) R
	 left join k_m_plans_form_report KF on KF.id_plan=P.id_plan and KF.id_plan_form_report_type = -1  and KF.id_report = R.id_report
	 Where KF.id IS NULL
UNION ALL 
	select 
	RF.form_id AS [id] ,
	RF.form_name AS tab_name,
	P.id_plan as id_plan,
	-1 AS id_plan_form_tab_type ,
    -3 AS [type],
	'GF_Form' AS [type_name] 
	 from k_m_plans P
	 cross join k_referential_form RF
	 left join k_m_plans_form_report KF on KF.id_plan=P.id_plan and KF.id_plan_form_report_type = -3  and KF.id_report = RF.form_id
	 Where KF.id IS NULL AND RF.table_view_id IS NOT NULL
UNION ALL 
	select 
	W.id_widget AS [id] ,
	W.name_widget AS tab_name,
	P.id_plan as id_plan,
	-4 AS id_plan_form_tab_type ,
	-4 AS [type],
	'GF_Widget' AS [type_name] 
	 from k_m_plans P
	 cross join k_widget W
	 left join k_m_plans_form_report KF on KF.id_plan=P.id_plan and KF.id_plan_form_report_type = -4 and KF.id_report = W.id_widget
	 Where KF.id IS NULL
UNION ALL 
	select 
	R.id_report AS [id] ,
	R.name_report AS tab_name,
	P.id_plan as id_plan,
	-2 AS id_plan_form_tab_type ,
	-2 AS [type],
	'GF_Report' AS [type_name] 
		from k_m_plans P
		cross join (select * from k_reports where type=77 /*77:ProcessReport*/) R
		left join k_m_plans_form_report KF on KF.id_plan=P.id_plan and KF.id_plan_form_report_type = -2  and KF.id_report = R.id_report
		Where KF.id IS NULL
 ) Q