
CREATE PROCEDURE [dbo].[Consult_SP_Import_PayeeHisto]  
AS  
begin
-- This stored procedure loads Payee data as historic to py_payeehisto table from py_payee data. After, please run Consult_SP_Import_PayeeExt
--Close the py_Payeehisto data which do not exist in py_Payeeimport table   
 UPDATE pph  
 SET end_date_histo = GETDATE()  
 FROM py_PayeeHisto pph  
 WHERE pph.end_date_histo IS NULL  
  AND pph.codePayee NOT IN (  
   SELECT DISTINCT codePayee  
   FROM py_PayeeImport  
   )  
--Close the py_Payeehisto data which exist in py_Payeeimport and py_Payee tables   
 UPDATE pph  
 SET end_date_histo = getdate()  
 FROM py_Payee pp  
 INNER JOIN py_PayeeImport ppi  
  ON ppi.codePayee = pp.codePayee  
 INNER JOIN py_PayeeHisto pph  
  ON pph.idPayee = pp.idPayee  
 WHERE end_date_histo IS NULL  
  
--Insert new histo data from py_Payeeimport  
 INSERT INTO py_PayeeHisto (  
  start_date_histo  
  ,end_date_histo  
  ,idPayee  
  ,codePayee  
  ,id_sup  
  ,firstname  
  ,lastname  
  ,email  
  ,birth_date  
  ,age  
  ,start_date_company  
  ,end_date_company  
  ,start_date_group  
  ,end_date_group  
  ,start_date_job  
  ,end_date_job  
  ,base_salary  
  ,base_salary_period  
  ,variable_period  
  ,nb_year_experience  
  ,months_per_year  
  ,hours_per_month  
  ,weight_structure_1  
  ,weight_structure_2  
  ,variable  
  ,company_car  
  ,id_category  
  ,id_grade  
  ,id_contract  
  ,id_agreement  
  ,id_cost_center  
  ,id_gender  
  ,id_activity_status  
  ,id_job  
  ,id_department  
  ,id_organization  
  ,id_structure_1  
  ,id_structure_2  
  ,id_geography  
  ,id_territory  
  ,id_variable_currency  
  ,id_title  
  ,id_nationality  
  ,id_pool  
  ,id_job_country  
  ,id_benefit  
  ,id_salary_currency  
  ,id_version  
  ,date_loading  
  )  
 SELECT getdate() AS start_date_histo  
  ,'2099-01-01 00:00:00.000' AS end_date_histo  
  ,pp.idPayee  
  ,ppi.codePayee  
  ,pp.id_sup  
  ,ppi.firstname  
  ,ppi.lastname  
  ,ppi.email  
  ,ppi.birth_date  
  ,age  
  ,start_date_company  
  ,end_date_company  
  ,start_date_group  
  ,end_date_group  
  ,start_date_job  
  ,end_date_job  
  ,base_salary  
  ,base_salary_period  
  ,variable_period  
  ,nb_year_experience  
  ,months_per_year  
  ,hours_per_month  
  ,weight_structure_1  
  ,weight_structure_2  
  ,variable  
  ,company_car  
  ,dce.id_category_employee  
  ,dg.id_grade  
  ,dc.id_contract  
  ,da.id_agreement  
  ,dcc.id_cost_center  
  ,dge.id_gender  
  ,das.id_activity_status  
  ,dj.id_job  
  ,dd.id_department  
  ,do.id_organization  
  ,ds1.id_structure AS id_structure_1  
  ,ds2.id_structure AS id_structure_2  
  ,dgeo.id_geography  
  ,dt.id_territory  
  ,dcv.id_currency AS id_variable_currency  
  ,rt.id_title  
  ,dn.id_nationality  
  ,dp.id_pool  
  ,dgeoc.id_geography AS id_job_country  
  ,rb.id_benefit  
  ,dcs.id_currency AS id_salary_currency  
  ,ppi.id_version  
  ,date_loading  
 FROM py_PayeeImport ppi  
 INNER JOIN py_Payee pp  
  ON pp.codePayee = ppi.codePayee  
 LEFT JOIN dim_category_employee dce  
  ON dce.code_category_employee = ppi.code_category  
 LEFT JOIN dim_grade dg  
  ON dg.code_grade = ppi.code_grade  
 LEFT JOIN dim_contract dc  
  ON dc.code_contract = ppi.code_contract  
 LEFT JOIN dim_agreement da  
  ON da.code_agreement = ppi.code_agreement  
 LEFT JOIN dim_cost_center dcc  
  ON dcc.code_cost_center = ppi.code_cost_center  
 LEFT JOIN dim_gender dge  
  ON dge.code_gender = ppi.code_gender  
 LEFT JOIN dim_activity_status das  
  ON das.code_activity_status = ppi.code_activity_status  
 LEFT JOIN dim_job dj  
  ON dj.code_job = ppi.code_job  
 LEFT JOIN dim_department dd  
  ON dd.code_department = ppi.code_department  
 LEFT JOIN dim_organization do  
  ON do.code_organization = ppi.code_organization  
 LEFT JOIN dim_structure ds1  
  ON ds1.code_structure = ppi.code_structure_1  
 LEFT JOIN dim_structure ds2  
  ON ds2.code_structure = ppi.code_structure_2  
 LEFT JOIN dim_geography dgeo  
  ON dgeo.code_geography = ppi.code_geography  
 LEFT JOIN dim_geography dgeoc  
  ON dgeoc.code_geography = ppi.code_job_country  
 LEFT JOIN dim_territory dt  
  ON dt.code_territory = ppi.code_territory  
 LEFT JOIN dim_currency dcv  
  ON dcv.code_currency = ppi.code_variable_currency  
 LEFT JOIN dim_currency dcs  
  ON dcs.code_currency = ppi.code_salary_currency  
 LEFT JOIN dim_nationality dn  
  ON dn.code_nationality = ppi.code_nationality  
 LEFT JOIN dim_pool dp  
  ON dp.code_pool = ppi.code_pool  
 LEFT JOIN dim_title rt  
  ON rt.code_title = ppi.code_title  
 LEFT JOIN dim_benefit rb  
  ON rb.code_benefit = ppi.code_benefit
  end