CREATE VIEW [dbo].[Kernel_View_Payee_List]  
AS  
select top(100) percent   
[py_Payee].[codePayee],[py_Payee].[idPayee],[py_Payee].[id_sup],[py_Payee].[ss_nb],[py_Payee].[lastname],[py_Payee].[firstname],[py_Payee].[email],[py_Payee].[birth_date],[py_Payee].[home_phone],[py_Payee].[mobile_phone],[py_Payee].[address_street],[py_Payee].[address_postal_code],[py_Payee].[address_city],[py_Payee].[address_country],[py_Payee].[family_situation],[py_Payee].[children_nb],[py_Payee].[image],[py_Payee].[attachment],  
ext.[id_histo],ext.[start_date_histo],ext.[end_date_histo],convert(int,ext.[age]) as age,ext.[start_date_company],ext.[end_date_company],ext.[start_date_group],ext.[end_date_group],ext.[start_date_job],ext.[end_date_job],ext.[base_salary],convert(int,ext.[base_salary_period]) as base_salary_period,convert(int,ext.[variable_period]) as variable_period,ext.[nb_year_experience],ext.[months_per_year],ext.[hours_per_month],ext.[weight_structure_1],ext.[variable],ext.[company_car],ext.[id_category],ext.[id_grade],ext.[id_contract],ext.[id_agreement],ext.[id_cost_center],ext.[id_gender],ext.[id_activity_status],ext.[id_job],ext.[id_department],ext.[id_organization],ext.[id_structure_1],ext.[id_structure_2],ext.[id_nationality],ext.[id_pool],ext.[id_job_country],ext.[id_benefit],ext.[id_salary_currency],ext.[short_name_job],ext.[short_name_structure],ext.[id_title],ext.[id_payment_currency],ext.[short_name_grade],
ext.id_performance_rating
from py_Payee   
inner join Kernel_View_Payee_Ext ext on py_Payee.idPayee = ext.idPayee  
WHERE GETDATE() >= ext.start_date_histo and GETDATE() < ext.end_date_histo
order by [py_Payee].codePayee