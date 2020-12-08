



CREATE     PROCEDURE [dbo].[sp_report_CRP_Compensation_Letter_Identified]  
(@id_payee INT, @id_plan INT)  
AS  
BEGIN  


WITH cte AS (
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
		  ,rle.Location AS ref_Location
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
		  ,[Bonus_Signon]
		  ,[Bonus_Exit]
		  ,[Target_HF_Point_Min]
		  ,[Target_HF_Point_Max]
		  ,[Target_PE_Point_Min]
		  ,[Target_PE_Point_Max]
		  ,[HF_Point_Value]
		  ,[PE_Point_Value]
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
		  ,ISNULL(vcpp.TargetSignOnBonus,0) AS CRP_TargetSignOnBonus
		  ,ISNULL(vcpp.TargetExiBonus,0) AS CRP_TargetExiBonus
		  ,ISNULL(vcpp.TargetHFmin,0) AS CRP_TargetHFmin
		  ,ISNULL(vcpp.TargetHFmax,0) AS CRP_TargetHFmax
		  ,ISNULL(vcpp.TargetPEmin,0) AS CRP_TargetPEmin
		  ,ISNULL(vcpp.TargetPEmax,0) AS CRP_TargetPEmax
		  ,ISNULL(vcpp.LTISY1,0) AS CRP_LTISY1
		  ,vcpp.Bemerkungen AS CRP_Bemerkungen
		  ,vcpp.Academy AS CRP_Academy
		  ,rjt.DeferallQuotaPct
		  ,rjt.[Co-InvestQuotaPct] AS CoInvestQuotaPct
		  ,(vcpt.Base_Salary_Current+ISNULL(vcpp.TBProfStaff,0)+ISNULL(vcpt.LTIS_Current,0)*(10000/ISNULL(tfrtc.Rate,1))) AS Total_Gross
		  ,(ISNULL(vcpp.TBProfStaff,0)+ISNULL(vcpt.LTIS_Current,0)*(10000/ISNULL(tfrtc.Rate,1))) AS Variable_Gross
		  ,CASE WHEN (ISNULL(vcpp.TBProfStaff,0)+ISNULL(vcpt.LTIS_Current,0)*(10000/ISNULL(tfrtc.Rate,1))) > 100000 THEN 'Yes' ELSE 'No' END AS Variable_Greater_Than_100K
		  ,CASE WHEN (ISNULL(vcpp.TBProfStaff,0)+ISNULL(vcpt.LTIS_Current,0)*(10000/ISNULL(tfrtc.Rate,1))) < ((vcpt.Base_Salary_Current+ISNULL(vcpp.TBProfStaff,0)+ISNULL(vcpt.LTIS_Current,0)*(10000/ISNULL(tfrtc.Rate,1)))*0.3) THEN 'No' ELSE 'Yes' END AS Variable_Greater_Than_30_Pct_Total
		  ,rc.TaxRate
		  ,(vcpt.Base_Salary_Current+ISNULL(vcpp.TBProfStaff,0)+ISNULL(vcpt.LTIS_Current,0)*(10000/ISNULL(tfrtc.Rate,1)))*((100.00-(rc.TaxRate+14.00))/100) AS Net_Variable
		  ,((vcpt.Base_Salary_Current+ISNULL(vcpp.TBProfStaff,0)+ISNULL(vcpt.LTIS_Current,0)*(10000/ISNULL(tfrtc.Rate,1)))*((100.00-(rc.TaxRate+14.00))/100))*(CAST(rjt.DeferallQuotaPct AS DECIMAL(5,2))/100) AS Deferal_Quota
		  ,ISNULL([LTIS_Current],0)*(10000/ISNULL(tfrtc.Rate,1)) AS [LTIS_Current_Amount]
		  ,((vcpt.Base_Salary_Current+ISNULL(vcpp.TBProfStaff,0)+ISNULL(vcpt.LTIS_Current,0)*(10000/ISNULL(tfrtc.Rate,1)))*((100.00-(rc.TaxRate+14.00))/100))*(CAST(rjt.DeferallQuotaPct AS DECIMAL(5,2))/100)-(ISNULL(vcpt.LTIS_Current,0)*(10000/ISNULL(tfrtc.Rate,1))) AS Defered_Cash_Amount
		  ,((vcpt.Base_Salary_Current+ISNULL(vcpp.TBProfStaff,0)+ISNULL(vcpt.LTIS_Current,0)*(10000/ISNULL(tfrtc.Rate,1)))*((100.00-(rc.TaxRate+14.00))/100))*(CAST(rjt.[Co-InvestQuotaPct] AS DECIMAL(5,2))/100) AS Co_Investment_Quota
		  ,((vcpt.Base_Salary_Current+ISNULL(vcpp.TBProfStaff,0)+ISNULL(vcpt.LTIS_Current,0)*(10000/ISNULL(tfrtc.Rate,1)))*((100.00-(rc.TaxRate+14.00))/100))*(CAST(rjt.[Co-InvestQuotaPct] AS DECIMAL(5,2))/100)-(ISNULL(vcpt.LTIS_Current,0)*(10000/ISNULL(tfrtc.Rate,1))) AS Co_Investment_Amount
	  FROM _vw_CRP_Process_Template vcpt
	  LEFT JOIN _vw_CRP_Process_Pivot vcpp ON vcpp.id_payee = vcpt.idPayee
	  LEFT JOIN _ref_LegalEntity rle ON rle.CompanyCode = vcpt.Org_LegalEntity_Code
	  LEFT JOIN _ref_JobTitle rjt ON vcpt.CurrentTitleCode = rjt.JobTitleCode
	  LEFT JOIN _tb_employee_information tei ON vcpt.idPayee = tei.IdPayee
	  LEFT JOIN _ref_Canton rc ON rc.CantonCode = tei.Canton
	  LEFT JOIN _tb_fx_rates_to_chf tfrtc ON tfrtc.CurrencyCode = vcpt.Bonus_Currency AND tfrtc.year = vcpt.Bonus_Year
	  WHERE vcpt.idPayee = @id_payee AND vcpt.id_plan = @id_plan
  )

  SELECT *
		, CASE WHEN Variable_Greater_Than_100K = 'Yes' AND Variable_Greater_Than_30_Pct_Total = 'Yes' AND Defered_Cash_Amount > 0 THEN Defered_Cash_Amount ELSE 0 END AS Defered_Cash_Amount_Final  
		, CASE WHEN Variable_Greater_Than_100K = 'Yes' AND Variable_Greater_Than_30_Pct_Total = 'Yes' AND Co_Investment_Amount > 0 THEN Co_Investment_Amount ELSE 0 END AS Co_Investment_Amount_Final
		FROM cte
  

END