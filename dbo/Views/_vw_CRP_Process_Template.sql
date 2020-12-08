CREATE VIEW [dbo].[_vw_CRP_Process_Template] 
AS 

WITH tec1 AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY IdPayee ORDER BY AwardDate DESC) AS row_num FROM 
_tb_employee_compensation
JOIN _tb_ProcessDefinition tpd ON IsActive = 1 
WHERE 1=1
AND PayrollType IN('000001','000002')
AND tpd.FreezeDate BETWEEN AwardDate AND EndDate
)
 
SELECT distinct
 pph.id_histo
    , pph.start_date_histo
    , pph.end_date_histo
    , tpd.id_plan
    , kmp.name_plan
    , tpd.FreezeDate
    , pp.idPayee
    , pp.codePayee
    , pp.lastname
    , pp.firstname
    , pp.lastname +' '+ pp.firstname AS fullname
    , tei.PersonnelNumber 
	--,tei.FirstName
    , tei.BirthDate
    , YEAR((CASE WHEN GETDATE() < tpd.FreezeDate THEN GETDATE() ELSE tpd.FreezeDate END)) - YEAR(tei.BirthDate) AS Age
    , tei.Gender
    , tei.EntryDate
    , DATEDIFF(YEAR,tei.EntryDate,(CASE WHEN GETDATE() < tpd.FreezeDate THEN GETDATE() ELSE tpd.FreezeDate END)) AS Anniversary
    , tei.LeavingDate
    , rec.EmployeeClassDescription AS EmployeeClass
    , teo.EffectiveDate  AS Org_BeginDate
    , teo.EndDate    AS Org_EndDate
    , teim.[Name]+ ' '+ teim.FirstName /*teo.ReportManager*/ AS Org_ReportManager
    , teo.CostCenter  AS Org_CostCenter_Code
    , rcc.CostCenterDescription  AS Org_CostCenter_Desc
    , teo.BusinessUnit AS Org_BusinessUnit_Code
    , rbu.BusinessUnitDescription AS Org_BusinessUnit_Desc
    , teo.BusinessArea AS Org_BusinessArea_Code
    , rba.BusinessAreaDescription AS Org_BusinessArea_Desc
    , rd.DepartmentShortCode AS Org_Department_Code
    , rd.DepartmentShortDescription   AS Org_Department_Desc
    , teo.LegalEntity AS Org_LegalEntity_Code
    , rle.CompanyDescription AS Org_LegalEntity_Desc
    , tef.EffectiveDate AS FTE_BeginDate
    , tef.EndDate AS FTE_Enddate
    , tef.FTE AS FTE_Current
    , tefnext.FTE AS FTE_Future
    , tej.EffectiveDate AS Job_BeginDate
    , tej.EffectiveDate AS Job_EndDate
    , rjc.JobCodeDescription AS JobCode_Current
    , rjt.JobTitleCode AS CurrentTitleCode
    , rjt.JobTitleDescription    AS CurrentTitle
	, CAST(CASE WHEN tec9.employeecompensationId IS NOT NULL THEN 'Yes' ELSE '' END AS NVARCHAR(50)) AS has_allowances
    , tec1.Currency   AS Base_Salary_Currency
    , tec1.PaidValue  AS Base_Salary_Current
    , YEAR(tpd.FreezeDate)-1  AS Bonus_Year
    , COALESCE(tec2.Currency,tec3.Currency,tec4.Currency,tec5.Currency,tec1.Currency) AS Bonus_Currency
    , tec2.TargetValue AS Target_Bonus_Prof_Staff
    , tec3.TargetValue AS Target_Bonus_Admin_Staff
    , tec7.TargetValue AS Bonus_Signon
    , CAST(0 AS INT)  AS Bonus_Exit --> Missing in ref
    , ISNULL(tec4.TargetValueMin,tec4.TargetValue)  AS Target_HF_Point_Min
    , ISNULL(tec4.TargetValueMax,tec4.TargetValue)  AS Target_HF_Point_Max
    , ISNULL(tec5.TargetValueMin,tec5.TargetValue)  AS Target_PE_Point_Min
    , ISNULL(tec5.TargetValueMax,tec5.TargetValue)  AS Target_PE_Point_Max
    --, CAST(pv.HFValue/ISNULL(tfrtc.Rate,1) AS INT)  AS HF_Point_Value
    --, CAST(pv.PEValue/ISNULL(tfrtc.Rate,1) AS INT)  AS PE_Point_Value
	, CAST(pv.HFValue/ISNULL(tfrtc.Rate,1) AS DECIMAL(32,2))  AS HF_Point_Value
    , CAST(pv.PEValue/ISNULL(tfrtc.Rate,1) AS DECIMAL(32,2))  AS PE_Point_Value
    , tec6.PaidValue  AS LTIS_Current
    , YEAR(tpd.FreezeDate)AS Target_Bonus_Year
    , COALESCE(tec2.Currency,tec3.Currency,tec4.Currency,tec5.Currency,tec1.Currency) AS Target_Bonus_Currency
   
	FROM py_PayeeHisto pph
	JOIN py_Payee pp ON pph.idPayee = pp.idPayee
	JOIN _tb_ProcessDefinition tpd ON IsActive = 1
	JOIN k_m_plans kmp ON tpd.id_plan = kmp.id_plan AND kmp.start_date_plan = pph.start_date_histo AND kmp.end_date_plan = pph.end_date_histo    
	LEFT JOIN _tb_employee_information tei ON tei.idPayee = pp.idPayee
	LEFT JOIN _tb_employee_fte tef ON tef.IdPayee = pp.idPayee AND (CASE WHEN GETDATE() < tpd.FreezeDate THEN GETDATE() ELSE tpd.FreezeDate END) /*tpd.FreezeDate*/ BETWEEN tef.EffectiveDate AND tef.EndDate -- put date as parameter
	LEFT JOIN _tb_employee_fte tefnext ON tefnext.IdPayee = pp.idPayee AND DATEADD("day",+1,tef.EndDate)=tefnext.EffectiveDate --AND CONVERT(DATETIME,'31/12/2019', 103) BETWEEN tefnext.EffectiveDate AND tefnext.EndDate -- put date as parameter
	LEFT JOIN _tb_employee_Job tej ON tej.IdPayee = pp.idPayee AND (CASE WHEN GETDATE() < tpd.FreezeDate THEN GETDATE() ELSE tpd.FreezeDate END) /*tpd.FreezeDate*/ BETWEEN tej.EffectiveDate AND tej.EndDate    
	LEFT JOIN _tb_employee_Title tet ON tet.IdPayee = pp.idPayee AND (CASE WHEN GETDATE() < tpd.FreezeDate THEN GETDATE() ELSE tpd.FreezeDate END) /*tpd.FreezeDate*/ BETWEEN tet.EffectiveDate AND tet.EndDate -- put date as parameter
	LEFT JOIN _tb_employee_organization teo ON teo.IdPayee = pp.idPayee AND (CASE WHEN GETDATE() < tpd.FreezeDate THEN GETDATE() ELSE tpd.FreezeDate END) /*tpd.FreezeDate*/ BETWEEN teo.EffectiveDate AND teo.EndDate -- put date as parameter
	LEFT JOIN _tb_employee_information teim ON teim.PersonnelNumber = teo.ReportManager    
	LEFT JOIN _ref_CostCenter rcc ON teo.CostCenter = rcc.CostCenterCode
	LEFT JOIN _ref_BusinessUnit rbu ON rbu.BusinessUnitCode = teo.BusinessUnit
	LEFT JOIN _ref_BusinessArea rba ON rba.BusinessAreaCode = teo.BusinessArea
	LEFT JOIN _ref_Department rd ON rd.DepartmentCode = teo.Department
	LEFT JOIN _ref_LegalEntity rle ON rle.CompanyCode = teo.LegalEntity  
	LEFT JOIN _ref_JobCode rjc ON rjc.JobCode = tej.JobCode    
	LEFT JOIN _ref_JobTitle rjt ON rjt.JobTitleCode = tet.TitleCode  
	LEFT JOIN _ref_EmployeeClass rec ON rec.EmployeeClassCode = tei.EmployeeClass
	LEFT JOIN _tb_Point_Values pv ON pv.Year = YEAR(tpd.FreezeDate)-1  
	--LEFT JOIN _tb_employee_compensation tec1 ON tec1.IdPayee = pp.idPayee AND tpd.FreezeDate BETWEEN tec1.AwardDate AND tec1.EndDate AND tec1.PayrollType IN('000001','000002') --base salary    
	LEFT JOIN  tec1 ON tec1.IdPayee = pp.idPayee AND tec1.row_num = 1
	LEFT JOIN _tb_employee_compensation tec2 ON tec2.IdPayee = pp.idPayee AND tpd.FreezeDate BETWEEN tec2.AwardDate AND tec2.EndDate AND YEAR(tpd.FreezeDate)-1 = YEAR(tec2.AwardDate) AND tec2.PayrollType = '000006' --TB prof Staff    
	LEFT JOIN _tb_employee_compensation tec3 ON tec3.IdPayee = pp.idPayee AND tpd.FreezeDate BETWEEN tec3.AwardDate AND tec3.EndDate AND YEAR(tpd.FreezeDate)-1 = YEAR(tec3.AwardDate) AND tec3.PayrollType = '0000000060' --Admin Staff    
	LEFT JOIN _tb_employee_compensation tec4 ON tec4.IdPayee = pp.idPayee AND tpd.FreezeDate BETWEEN tec4.AwardDate AND tec4.EndDate AND YEAR(tpd.FreezeDate)-1 = YEAR(tec4.AwardDate) AND tec4.PayrollType = '000008' --HF Point    
	LEFT JOIN _tb_employee_compensation tec5 ON tec5.IdPayee = pp.idPayee AND tpd.FreezeDate BETWEEN tec5.AwardDate AND tec5.EndDate AND YEAR(tpd.FreezeDate)-1 = YEAR(tec5.AwardDate) AND tec5.PayrollType = '000009' --PE Point    
	LEFT JOIN _tb_employee_compensation tec6 ON tec6.IdPayee = pp.idPayee AND tpd.FreezeDate BETWEEN tec6.AwardDate AND tec6.EndDate AND YEAR(tpd.FreezeDate)-1 = YEAR(tec6.AwardDate) AND tec6.PayrollType = '000010' --LTIS    
	LEFT JOIN _tb_employee_compensation tec7 ON tec7.IdPayee = pp.idPayee AND tpd.FreezeDate BETWEEN tec7.AwardDate AND tec7.EndDate AND YEAR(tpd.FreezeDate)-1 = YEAR(tec7.AwardDate) AND tec7.PayrollType = '0000000040' --Sign On    
	LEFT JOIN _tb_employee_compensation tec8 ON tec8.IdPayee = pp.idPayee AND tpd.FreezeDate BETWEEN tec8.AwardDate AND tec8.EndDate AND YEAR(tpd.FreezeDate)-1 = YEAR(tec8.AwardDate) AND tec8.PayrollType = '0000000070' --Exit    
	LEFT JOIN _tb_employee_compensation tec9 ON tec9.IdPayee = pp.idPayee AND tpd.FreezeDate BETWEEN tec9.AwardDate AND tec9.EndDate AND YEAR(tpd.FreezeDate)-1 = YEAR(tec9.AwardDate) AND tec9.PayrollType IN('000011', '000012', '000013', '000014') --Allowances    
	LEFT JOIN _tb_fx_rates_to_chf tfrtc ON tfrtc.year = YEAR(tpd.FreezeDate)-1 AND  COALESCE(tec2.Currency,tec3.Currency,tec4.Currency,tec5.Currency,tec1.Currency) = tfrtc.CurrencyCode    
	--WHERE pph.IdPayee = 612

	UNION ALL

	SELECT tcpta.id_histo
		  ,tcpta.start_date_histo
		  ,tcpta.end_date_histo
		  ,tcpta.id_plan
		  ,tcpta.name_plan
		  ,tcpta.FreezeDate
		  ,tcpta.idPayee
		  ,tcpta.codePayee
		  ,tcpta.lastname
		  ,tcpta.firstname
		  ,tcpta.fullname
		  ,tcpta.PersonnelNumber
		  ,tcpta.BirthDate
		  ,tcpta.Age
		  ,tcpta.Gender
		  ,tcpta.EntryDate
		  ,tcpta.Anniversary
		  ,tcpta.LeavingDate
		  ,tcpta.EmployeeClass
		  ,tcpta.Org_BeginDate
		  ,tcpta.Org_EndDate
		  ,tcpta.Org_ReportManager
		  ,tcpta.Org_CostCenter_Code
		  ,tcpta.Org_CostCenter_Desc
		  ,tcpta.Org_BusinessUnit_Code
		  ,tcpta.Org_BusinessUnit_Desc
		  ,tcpta.Org_BusinessArea_Code
		  ,tcpta.Org_BusinessArea_Desc
		  ,tcpta.Org_Department_Code
		  ,tcpta.Org_Department_Desc
		  ,tcpta.Org_LegalEntity_Code
		  ,tcpta.Org_LegalEntity_Desc
		  ,tcpta.FTE_BeginDate
		  ,tcpta.FTE_Enddate
		  ,tcpta.FTE_Current
		  ,tcpta.FTE_Future
		  ,tcpta.Job_BeginDate
		  ,tcpta.Job_EndDate
		  ,tcpta.JobCode_Current
		  ,tcpta.CurrentTitleCode
		  ,tcpta.CurrentTitle
		  ,tcpta.has_allowances
		  ,tcpta.Base_Salary_Currency
		  ,tcpta.Base_Salary_Current
		  ,tcpta.Bonus_Year
		  ,tcpta.Bonus_Currency
		  ,tcpta.Target_Bonus_Prof_Staff
		  ,tcpta.Target_Bonus_Admin_Staff
		  ,tcpta.Bonus_Signon
		  ,tcpta.Bonus_Exit
		  ,tcpta.Target_HF_Point_Min
		  ,tcpta.Target_HF_Point_Max
		  ,tcpta.Target_PE_Point_Min
		  ,tcpta.Target_PE_Point_Max
		  ,tcpta.HF_Point_Value
		  ,tcpta.PE_Point_Value
		  ,tcpta.LTIS_Current
		  ,tcpta.Target_Bonus_Year
		  ,tcpta.Target_Bonus_Currency 
	FROM tb_CRP_Process_Template_archive tcpta
	JOIN _tb_ProcessDefinition tpd ON IsActive = 0
	AND  tcpta.id_plan = tpd.id_plan