



CREATE     PROCEDURE [dbo].[sp_report_CRP_Compensation_Letter_Sub]  
(@id_payee INT, @id_plan INT)  
AS  
BEGIN  


;WITH cte_1 AS (
	SELECT  [id_histo]
		  ,[start_date_histo]
		  ,[end_date_histo]
		  ,vcpt.[id_plan]
		  ,[FreezeDate]
		  ,vcpt.[idPayee]
		  ,[codePayee]
		  ,[lastname]
		  ,vcpt.[firstname]
		  ,[fullname]
		  ,vcpt.[PersonnelNumber]
		  ,vcpt.[BirthDate]
		  ,[Age]
		  ,vcpt.[Gender]
		  ,CASE WHEN vcpt.Gender = 'F' THEN 'Ms' ELSE 'Mr' END AS Gender_Title
		  ,vcpt.[EntryDate]
		  ,vcpt.[LeavingDate]
		  ,vcpt.[EmployeeClass]
		  ,[Org_BeginDate]
		  ,[Org_EndDate]
		  ,[Org_ReportManager]
		  ,[Org_CostCenter_Code]
		  ,[Org_CostCenter_Desc]
		  ,[Org_BusinessUnit_Code]
		  ,[Org_BusinessUnit_Desc]
		  ,[Org_BusinessArea_Code]
		  ,[Org_BusinessArea_Desc]
		  ,[Org_Department_Code]
		  ,[Org_Department_Desc]
		  ,[Org_LegalEntity_Code]
		  ,[Org_LegalEntity_Desc]
		  ,rle.CompanyDescription AS ref_CompanyDescription
		  ,rle.Adress AS ref_Adress
		  ,rle.Phone AS ref_Phone
		  ,rle.Website AS ref_Website
		  ,rle.Email AS ref_Email
		  ,rle.Fax AS ref_Fax
		  ,TRIM(RIGHT(rle.Location,LEN(rle.Location)-CHARINDEX('-',rle.Location))) AS ref_Location
		  ,'16 March' AS Letter_Date
		  ,[FTE_BeginDate]
		  ,[FTE_Enddate]
		  ,[FTE_Current]
		  ,[FTE_Future]
		  ,[Job_BeginDate]
		  ,[Job_EndDate]
		  ,[JobCode_Current]
		  ,[CurrentTitleCode]
		  ,[CurrentTitle]
		  ,[Base_Salary_Currency]
		  ,[Base_Salary_Current]
		  ,[Bonus_Year]
		  ,[Bonus_Currency]
		  ,[Target_Bonus_Prof_Staff]
		  ,[Target_Bonus_Admin_Staff]
		  ,ISNULL(COALESCE(NULLIF([Target_Bonus_Prof_Staff],0),NULLIF([Target_Bonus_Admin_Staff],0)),0) AS Target_Bonus_YM1
		  ,[Bonus_Signon]
		  ,[Bonus_Exit]
		  ,[Target_HF_Point_Min]
		  ,[Target_HF_Point_Max]
		  ,[Target_PE_Point_Min]
		  ,[Target_PE_Point_Max]
		  ,[HF_Point_Value] HF_Point_Value_CCY
		  ,[PE_Point_Value] PE_Point_Value_CCY
		  ,ISNULL([LTIS_Current],0) AS [LTIS_Current]
		  ,[Target_Bonus_Year]
		  ,[Target_Bonus_Currency]
		  ,vcpp.NewTitle AS CRP_NewTitle
		  ,vcpp.NewBaseSalary AS CRP_NewBaseSalary
		  ,ISNULL(vcpp.TBProfStaff,0) AS CRP_TBProfStaff
		  ,ISNULL(vcpp.BonusAdminStaff,0) AS CRP_BonusAdminStaff
		  ,ISNULL(vcpp.DiscrBonus,0) AS CRP_DiscrBonus
		  ,ISNULL(vcpp.SalesComm,0) AS CRP_SalesComm
		  ,ISNULL(vcpp.HFP,0) AS CRP_HFP
		  ,ISNULL(vcpp.PEP,0) AS CRP_PEP
		  ,ISNULL(vcpp.TargetTBProfStaff,0) AS CRP_TargetTBProfStaff
		  ,ISNULL(vcpp.TargetBonusAdminStaff,0) AS CRP_TargetBonusAdminStaff
		  ,ISNULL(COALESCE(NULLIF(vcpp.TargetTBProfStaff,0),NULLIF(vcpp.TargetBonusAdminStaff,0)),0) AS Target_Bonus_Y1
		  ,ISNULL(vcpp.TargetSignOnBonus,0) AS CRP_TargetSignOnBonus
		  ,ISNULL(vcpp.TargetExiBonus,0) AS CRP_TargetExiBonus
		  ,ISNULL(vcpp.TargetHFmin,0) AS CRP_TargetHFmin
		  ,ISNULL(vcpp.TargetHFmax,0) AS CRP_TargetHFmax
		  ,ISNULL(vcpp.TargetPEmin,0) AS CRP_TargetPEmin
		  ,ISNULL(vcpp.TargetPEmax,0) AS CRP_TargetPEmax
		  ,ISNULL(vcpp.LTISY1,0) AS CRP_LTISY1
		  ,vcpp.Bemerkungen AS CRP_Bemerkungen
		  ,vcpp.Academy AS CRP_Academy
		  ,teis.Deferall_3Y_pct
		  ,teis.Coinv_Overall_pct
		  ,teis.SS_pct
		  ,teis.Taxes_pct
		  ,teis.Deffered_Amount_Ym2
		  ,teis.Deffered_Amount_Ym1
		  ,10000 AS LTI_Point_Value
		  ,tpv.HFValue AS HF_Point_Value
		  ,tpv.PEValue AS PE_Point_Value
	  FROM _vw_CRP_Process_Template vcpt
	  LEFT JOIN _vw_CRP_Process_Pivot vcpp ON vcpp.id_payee = vcpt.idPayee
	  LEFT JOIN _ref_LegalEntity rle ON rle.CompanyCode = vcpt.Org_LegalEntity_Code
	  LEFT JOIN _tb_employee_identified_staff teis ON vcpt.PersonnelNumber = teis.PersonnelNumber
	  LEFT JOIN _tb_Point_Values tpv ON tpv.year = [Bonus_Year]
	  WHERE vcpt.idPayee = @id_payee AND vcpt.id_plan = @id_plan
)

, cte_2 AS (
	SELECT *,  
	CRP_HFP*HF_Point_Value AS HF_Value_Current, 
	CRP_PEP*PE_Point_Value AS PE_Value_Current, 
	CRP_HFP*HF_Point_Value_CCY AS HF_Value_Current_CCY, 
	CRP_PEP*PE_Point_Value_CCY AS PE_Value_Current_CCY, 
	CRP_LTISY1*LTI_Point_Value AS LTI_Value  
	FROM cte_1 )

, cte_3 AS (
	SELECT *, 
	CRP_TBProfStaff+CRP_BonusAdminStaff+CRP_DiscrBonus+CRP_SalesComm AS Total_Bonus_Gross 
	FROM cte_2 )

,cte_4 AS (
	SELECT *, 
	Total_Bonus_Gross+HF_Value_Current+PE_Value_Current AS Total_Bonus,
	Total_Bonus_Gross+HF_Value_Current_CCY+PE_Value_Current_CCY AS Total_Bonus_CCY
	FROM cte_3)

,cte_5 AS (
	SELECT *, 
	CRP_NewBaseSalary+Total_Bonus+LTI_Value AS Total_Income FROM cte_4)

, cte_6 AS (
	SELECT *, 
	CASE WHEN Org_LegalEntity_Code = '013' -- Ireland
	THEN CASE WHEN  Total_Bonus+LTI_Value > 50000 THEN 'Yes' ELSE 'No' END 
	ELSE CASE WHEN  Total_Bonus+LTI_Value > 100000 THEN 'Yes' ELSE 'No' END 
	END AS Variable_grt_100K, 
	CASE WHEN  Total_Bonus+LTI_Value < Total_Income*0.3 THEN 'No' ELSE 'Yes' END AS Variable_grt_30pct_Total,
	100-SS_pct-Taxes_pct AS Net_Variable_Pct
	FROM cte_5 )
, cte_7 AS (
	SELECT *,  
	(Total_Bonus+LTI_Value)*Net_Variable_Pct/100 AS Net_Variable_Income
	FROM cte_6 )
, cte_8 AS (
	SELECT *,
	Net_Variable_Income*Deferall_3Y_pct/100 AS Deferal_Quota_Amount
	FROM cte_7)
, cte_9 AS (
	SELECT *,
	CASE WHEN Variable_grt_100K = 'Yes' THEN Deferal_Quota_Amount-LTI_Value ELSE 0 END AS Deferred_Cash_Bonus,
	CASE WHEN Variable_grt_100K = 'Yes' THEN CASE WHEN Deferal_Quota_Amount-LTI_Value >0 THEN Deferal_Quota_Amount-LTI_Value ELSE 0 END ELSE 0 END AS Deferred_Cash_Bonus_Amount
	FROM cte_8 )
, cte_10 AS (
	SELECT *, 
	Net_Variable_Income*Coinv_Overall_pct/100 AS Quota_Amount
	FROM cte_9)
, cte_11 AS (
	SELECT *, 
	CASE WHEN Quota_Amount-LTI_Value > 0 THEN Quota_Amount-LTI_Value ELSE 0 END AS CoInv_Quota_Amount,
	Deffered_Amount_Ym2/3*2 AS Deffered_Amount_Ym2_2third,
	Deffered_Amount_Ym2/3 AS Deffered_Amount_Ym2_1third,
	Deffered_Amount_Ym1/3*2 AS Deffered_Amount_Ym1_2third,
	Deffered_Amount_Ym1/3 AS Deffered_Amount_Ym1_1third,
	Deferred_Cash_Bonus_Amount/3*2 AS Deferred_Cash_Bonus_Amount_2third,
	Deferred_Cash_Bonus_Amount/3 AS Deferred_Cash_Bonus_Amount_1third
	FROM cte_10)
, cte_12 AS (
	SELECT *, 
	Deffered_Amount_Ym2 AS Total_Restrictired_Ym2,
	Deffered_Amount_Ym2_2third+Deffered_Amount_Ym1 AS Total_Restrictired_Ym1,
	Deffered_Amount_Ym2_1third+Deffered_Amount_Ym1_2third+Deferred_Cash_Bonus_Amount AS Total_Restrictired_Y
	FROM cte_11)

SELECT id_histo
	  ,start_date_histo
	  ,end_date_histo
	  ,id_plan
	  ,FreezeDate
	  ,idPayee
	  ,codePayee
	  ,lastname
	  ,firstname
	  ,fullname
	  ,PersonnelNumber
	  ,BirthDate
	  ,Age
	  ,Gender
	  ,Gender_Title
	  ,EntryDate
	  ,LeavingDate
	  ,EmployeeClass
	  ,Org_BeginDate
	  ,Org_EndDate
	  ,Org_ReportManager
	  ,Org_CostCenter_Code
	  ,Org_CostCenter_Desc
	  ,Org_BusinessUnit_Code
	  ,Org_BusinessUnit_Desc
	  ,Org_BusinessArea_Code
	  ,Org_BusinessArea_Desc
	  ,Org_Department_Code
	  ,Org_Department_Desc
	  ,Org_LegalEntity_Code
	  ,Org_LegalEntity_Desc
	  ,ref_CompanyDescription
	  ,ref_Adress
	  ,ref_Phone
	  ,ref_Website
	  ,ref_Email
	  ,ref_Fax
	  ,ref_Location
	  ,Letter_Date
	  ,FTE_BeginDate
	  ,FTE_Enddate
	  ,FTE_Current
	  ,FTE_Future
	  ,Job_BeginDate
	  ,Job_EndDate
	  ,JobCode_Current
	  ,CurrentTitleCode
	  ,CurrentTitle
	  ,Base_Salary_Currency
	  ,Base_Salary_Current
	  ,Bonus_Year
	  ,Bonus_Currency
	  ,Target_Bonus_Prof_Staff
	  ,Target_Bonus_Admin_Staff
	  ,ROUND(Target_Bonus_YM1,0) AS Target_Bonus_YM1
	  ,Bonus_Signon
	  ,Bonus_Exit
	  ,Target_HF_Point_Min
	  ,Target_HF_Point_Max
	  ,Target_PE_Point_Min
	  ,Target_PE_Point_Max
	  ,HF_Point_Value_CCY
	  ,PE_Point_Value_CCY
	  ,LTIS_Current
	  ,Target_Bonus_Year
	  ,Target_Bonus_Currency
	  ,CRP_NewTitle
	  ,ROUND(CRP_NewBaseSalary,0) AS CRP_NewBaseSalary
	  ,CRP_TBProfStaff
	  ,CRP_BonusAdminStaff
	  ,CRP_DiscrBonus
	  ,CRP_SalesComm
	  ,CRP_HFP
	  ,CRP_PEP
	  ,CRP_TargetTBProfStaff
	  ,CRP_TargetBonusAdminStaff
	  ,ROUND(Target_Bonus_Y1, 0) AS Target_Bonus_Y1
	  ,CRP_TargetSignOnBonus
	  ,CRP_TargetExiBonus
	  ,CRP_TargetHFmin
	  ,CRP_TargetHFmax
	  ,CRP_TargetPEmin
	  ,CRP_TargetPEmax
	  ,CRP_LTISY1
	  ,CRP_Bemerkungen
	  ,CRP_Academy
	  ,Deferall_3Y_pct
	  ,Coinv_Overall_pct
	  ,SS_pct
	  ,Taxes_pct
	  ,ROUND(Deffered_Amount_Ym2,0) AS Deffered_Amount_Ym2
	  ,ROUND(Deffered_Amount_Ym1,0) AS Deffered_Amount_Ym1
	  ,LTI_Point_Value
	  ,HF_Point_Value
	  ,PE_Point_Value
	  ,HF_Value_Current
	  ,PE_Value_Current
	  ,ROUND(HF_Value_Current_CCY,0) AS HF_Value_Current_CCY
	  ,ROUND(PE_Value_Current_CCY,0) AS PE_Value_Current_CCY
	  ,LTI_Value
	  ,ROUND(Total_Bonus_Gross,0) AS Total_Bonus_Gross
	  ,Total_Bonus
	  ,ROUND(Total_Bonus_CCY,0) AS Total_Bonus_CCY
	  ,Total_Income
	  ,Variable_grt_100K
	  ,Variable_grt_30pct_Total
	  ,Net_Variable_Pct
	  ,Net_Variable_Income
	  ,Deferal_Quota_Amount
	  ,Deferred_Cash_Bonus
	  ,ROUND(Deferred_Cash_Bonus_Amount,0) AS Deferred_Cash_Bonus_Amount 
	  ,Quota_Amount
	  ,ROUND(CoInv_Quota_Amount,0) AS CoInv_Quota_Amount
	  ,Deffered_Amount_Ym2_2third
	  ,ROUND(Deffered_Amount_Ym2_1third,0) AS Deffered_Amount_Ym2_1third
	  ,ROUND(Deffered_Amount_Ym1_2third,0) AS Deffered_Amount_Ym1_2third
	  ,Deffered_Amount_Ym1_1third
	  ,Deferred_Cash_Bonus_Amount_2third
	  ,Deferred_Cash_Bonus_Amount_1third
	  ,Total_Restrictired_Ym2
	  ,Total_Restrictired_Ym1
	  ,ROUND(Total_Restrictired_Y,0) AS Total_Restrictired_Y
FROM cte_12

END