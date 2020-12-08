CREATE VIEW [dbo].[Kernel_View_Setup_FormReport]
AS
SELECT
	  FR.id
	, FR.name_form AS [tab_name]
	, FRT.name_plan_form_report_type AS [item_type]
	, ISNULL(R.name_report, ISNULL(RF.form_name, ISNULL(W.name_widget, S.name_plan_tab_standard))) AS [item_name]
	, FR.id_plan
	, CASE 
		WHEN FR.id_plan_form_report_type = -1 OR FR.id_plan_form_report_type = -5 OR FR.id_plan_form_report_type = -3 THEN -1 
		ELSE FR.id_plan_form_report_type END AS id_plan_form_tab_type
    , FR.id_plan_form_report_type AS [type]
	, CASE 
		WHEN FR.id_plan_form_report_type = -1 OR FR.id_plan_form_report_type = -2 THEN 'GF_Report' 
		WHEN FR.id_plan_form_report_type = -3 THEN 'GF_Form'
		WHEN FR.id_plan_form_report_type = -5 THEN 'GF_Standart' 
		WHEN FR.id_plan_form_report_type = -4 THEN 'GF_Widget' END AS [type_name]
	, FR.show_by_default
	, FR.sort_order
FROM            
	dbo.k_m_plans_form_report AS FR LEFT OUTER JOIN
    dbo.k_m_plans_form_report_type AS FRT ON FR.id_plan_form_report_type = FRT.id_plan_form_report_type LEFT OUTER JOIN
    dbo.k_reports AS R ON FR.id_report = R.id_report AND FR.id_plan_form_report_type IN (-1, -2) LEFT OUTER JOIN
    dbo.k_referential_form AS RF ON FR.id_report = RF.form_id AND FR.id_plan_form_report_type = -3 LEFT OUTER JOIN
    dbo.k_widget AS W ON FR.id_report = W.id_widget AND FR.id_plan_form_report_type = -4 LEFT OUTER JOIN
    dbo.k_m_plan_tab_standard AS S ON FR.id_report = S.id_plan_tab_standard AND FR.id_plan_form_report_type = -5