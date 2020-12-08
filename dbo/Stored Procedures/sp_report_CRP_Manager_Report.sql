


CREATE     PROCEDURE [dbo].[sp_report_CRP_Manager_Report]  
(@idPayee INT, @idUser INT = -1, @idProfile INT = -1, @idTree INT, @idProcess INT)  
AS  
BEGIN  

SELECT --*,
tei.IdPayee,
tei.PersonnelNumber,
tei.Name,
tei.FirstName,
tei.BirthDate,
tei.Gender,
tei.EntryDate,
tei.LeavingDate,
tec.PayrollType,
rpt.PayrollTypeDescription,
rpt.RateCodeType,
tec.AwardDate,
YEAR(tec.AwardDate) Year_AwardDate,
tec.TargetValueMin,
tec.TargetValueMax,
tec.TargetValue,
tec.PaidDate,
tec.PaidValue,
--LAG(tec.PaidValue,1,0) OVER (PARTITION BY tei.IdPayee,tec.PayrollType ORDER BY tec.AwardDate),
CASE WHEN rpt.RateCodeType = 'Flat Amt' Then (tec.PaidValue - (LAG(tec.PaidValue,1,0) OVER (PARTITION BY tei.IdPayee,tec.PayrollType ORDER BY tec.AwardDate))) / NULLIF((LAG(tec.PaidValue,1,0) OVER (PARTITION BY tei.IdPayee,tec.PayrollType ORDER BY tec.AwardDate)),0) * 100 ELSE NULL END AS Increase_Pct, 
tec.Currency,
CASE WHEN tec.PayrollType = '000008' THEN CAST(pv.HFValue/ISNULL(tfrtc.Rate,1) AS INT) ELSE NULL END AS HFValue,
CASE WHEN tec.PayrollType = '000009' THEN CAST(pv.PEValue/ISNULL(tfrtc.Rate,1) AS INT) ELSE NULL END AS PEValue


FROM k_m_plans kmp
JOIN _tb_ProcessDefinition tpd ON tpd.id_plan = kmp.id_plan
JOIN k_m_plans_payees_steps kmpps ON kmp.id_plan = kmpps.id_plan
JOIN _tb_employee_information tei ON tei.IdPayee = kmpps.id_payee
JOIN _tb_employee_compensation tec ON tei.IdPayee = tec.IdPayee
JOIN _ref_PayrollType rpt ON rpt.PayrollTypeCode =  tec.PayrollType
LEFT JOIN _tb_fx_rates_to_chf tfrtc ON tfrtc.year = YEAR(tec.AwardDate) AND tec.Currency = tfrtc.CurrencyCode
LEFT JOIN _tb_Point_Values pv ON pv.Year = YEAR(tec.AwardDate) 

WHERE kmp.id_plan = @idProcess
AND kmpps.id_payee IN (SELECT hnlph.idChild 
						FROM hm_NodeLinkPublishedHierarchy	hnlph
						JOIN py_Payee pp ON hnlph.idChild = pp.idPayee
						WHERE hnlph.idType = 14 AND hnlph.hid.IsDescendantOf(hnlph.hidParent) = 1 AND hnlph.idTree = @idTree)


order by tei.Name, idpayee, payrolltype, awarddate desc

END