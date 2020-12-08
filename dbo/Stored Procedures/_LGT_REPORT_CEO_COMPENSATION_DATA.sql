-- =============================================
-- 
-- =============================================
CREATE PROCEDURE [dbo].[_LGT_REPORT_CEO_COMPENSATION_DATA]
(
	@id_plan INT
	--@id_user INT,
	--@id_profile INT,
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT  
		   YEAR(vcpt.FreezeDate) AS Process_Year 
		  ,vcpt.[idPayee]
		  ,[codePayee]
		  --Entity
		  ,[Org_LegalEntity_Code]
		  ,[Org_LegalEntity_Desc]
		  -- Name
	      ,vcpt.[PersonnelNumber]
		  ,[lastname]
		  ,[firstname]
		  -- Title
		  ,[CurrentTitle]
		  ,vcpp.NewTitle AS CRP_NewTitle
		  -- Job Data
		  ,[Org_Department_Code]
		  ,[Org_CostCenter_Code]
		  ,[Org_CostCenter_Desc]
		  , 1 AS HeadCount
		  ,[FTE_Current] 
          --
		  ,[EntryDate]
		  ,[LeavingDate]
		  ,[Age]
		  -- Base Salary
		  ,[Base_Salary_Currency]
		  ,bsy2.PaidValue AS Base_Salary_Y_2
		  ,bsy1.PaidValue AS Base_Salary_Y_1
		  ,[Base_Salary_Current]
		  ,vcpp.NewBaseSalary AS CRP_NewBaseSalary
		  -- Target Bonus Y - 2
		  ,COALESCE(bpsy2.Currency,basy2.Currency,disy2.Currency,scy2.Currency,hfy2.Currency,pey2.Currency) AS Bonus_Y_2_Currency
		  ,bpsy2.PaidValue AS TBProfStaff_Y_2
		  ,basy2.PaidValue AS BonusAdminStaff_Y_2
		  ,disy2.PaidValue AS DiscrBonus_Y_2
		  -- // Spec_Payment to change
		  ,0 as Spec_Payment_Y_2
		  ,scy2.PaidValue AS SalesComm_Y_2
		  ,hfy2.TargetValue AS HP_P_Y_2
		  ,hfy2.PaidValue AS HP_Value_Y_2
		  ,pey2.TargetValue AS PE_P_Y_2
		  ,pey2.PaidValue AS PE_Value_Y_2
		  -- // Spec_Payment to change
		  ,bpsy2.PaidValue + basy2.PaidValue + disy2.PaidValue + 0 + scy2.PaidValue + hfy2.PaidValue + pey2.PaidValue as Total_Bonus_Y_2
		  -- // Spec_Payment to change
		  ,(bpsy2.PaidValue + basy2.PaidValue + disy2.PaidValue + 0 + scy2.PaidValue + hfy2.PaidValue + pey2.PaidValue) * [FTE_Current] as Total_Bonus_Full_Y_2
		  -- Target Bonus Y - 1
		  ,COALESCE(bpsy1.Currency,basy1.Currency,disy1.Currency,scy1.Currency,hfy1.Currency,pey1.Currency) AS Bonus_Y_1_Currency
		  ,bpsy1.PaidValue AS TBProfStaff_Y_1
		  ,basy1.PaidValue AS BonusAdminStaff_Y_1
		  ,disy1.PaidValue AS DiscrBonus_Y_1
		  ,scy1.PaidValue AS SalesComm_Y_1
		  ,hfy1.TargetValue AS HP_P_Y_1
		  ,hfy1.PaidValue AS HP_Value_Y_1
		  ,pey1.TargetValue AS PE_P_Y_1
		  ,pey1.PaidValue AS PE_Value_Y_1
		  -- // Spec_Payment to change
		  ,bpsy1.PaidValue + basy1.PaidValue + disy1.PaidValue + scy1.PaidValue + hfy1.PaidValue + pey1.PaidValue as Total_Bonus_Y_1
		  -- // Spec_Payment to change
		  ,(bpsy1.PaidValue + basy1.PaidValue + disy1.PaidValue + scy1.PaidValue + hfy1.PaidValue + pey1.PaidValue) * [FTE_Current] as Total_Bonus_Full_Y_1
		  -- Target Bonus Current Year
		  ,[Bonus_Year]
		  ,[Bonus_Currency]
		  ,[Target_Bonus_Prof_Staff]
		  ,[Target_Bonus_Admin_Staff]
		  -- // Discretionary to insert here
		  ,[Target_HF_Point_Min]
		  ,[Target_HF_Point_Max]
		  ,[Target_PE_Point_Min]
		  ,[Target_PE_Point_Max]
		  -- Bonus Current Year
		  ,vcpp.TBProfStaff AS CRP_TBProfStaff
		  ,vcpp.BonusAdminStaff AS CRP_BonusAdminStaff
		  ,vcpp.DiscrBonus AS CRP_DiscrBonus
		  ,vcpp.SalesComm AS CRP_SalesComm
		  ,vcpp.HFP AS CRP_HFP
		  ,CAST((CAST(vcpp.HFP AS DECIMAL(18,2)) * pv.HFValue)  / ISNULL(tfrtc.Rate,1) AS INT) AS HF_Value
		  ,vcpp.PEP AS CRP_PEP
		  ,CAST((CAST(vcpp.PEP AS DECIMAL(18,2)) * pv.PEValue) / ISNULL(tfrtc.Rate,1) AS INT) AS PE_Value
		  ,vcpp.TBProfStaff + vcpp.BonusAdminStaff + vcpp.DiscrBonus + vcpp.SalesComm + CAST((CAST(vcpp.HFP AS DECIMAL(18,2)) * pv.HFValue)  / ISNULL(tfrtc.Rate,1) AS INT) + CAST((CAST(vcpp.PEP AS DECIMAL(18,2)) * pv.PEValue) / ISNULL(tfrtc.Rate,1) AS INT) as Total_Bonus
		  ,(vcpp.TBProfStaff + vcpp.BonusAdminStaff + vcpp.DiscrBonus + vcpp.SalesComm + CAST((CAST(vcpp.HFP AS DECIMAL(18,2)) * pv.HFValue)  / ISNULL(tfrtc.Rate,1) AS INT) + CAST((CAST(vcpp.PEP AS DECIMAL(18,2)) * pv.PEValue) / ISNULL(tfrtc.Rate,1) AS INT)) * [FTE_Current] as Total_Bonus_Full
		  -- Target Bonus Next year
		  ,[Bonus_Currency] AS Target_Bonus_Currency
		  ,vcpp.TargetTBProfStaff AS CRP_TargetTBProfStaff
		  ,vcpp.TargetBonusAdminStaff AS CRP_TargetBonusAdminStaff
		  ,vcpp.TargetSignOnBonus AS CRP_TargetSignOnBonus
		  ,vcpp.TargetExiBonus AS CRP_TargetExiBonus
		  ,vcpp.TargetHFmin AS CRP_TargetHFmin
		  ,vcpp.TargetHFmax AS CRP_TargetHFmax
		  ,vcpp.TargetPEmin AS CRP_TargetPEmin
		  ,vcpp.TargetPEmax AS CRP_TargetPEmax
		  -- LTIS
		  ,LTISY2.PaidValue AS LTISY_2
		  ,LTISY1.PaidValue AS LTISY_1
		  ,[LTIS_Current]
		  ,vcpp.LTISY1 AS CRP_LTISY1
		  -- add Total comp
		  , vcpp.Bemerkungen AS Comment
		  -- CEO Direct
		  ,CASE WHEN thd.Emp_IdPayee IS NOT NULL THEN 'YES' ELSE NULL END AS CEO_Direct

		  ----

	  FROM _vw_CRP_Process_Template vcpt
	  LEFT JOIN _vw_CRP_Process_Pivot vcpp ON vcpp.id_payee = vcpt.idPayee AND vcpt.id_plan = vcpp.id_plan
	  -- Base Salary History
	  LEFT JOIN _tb_employee_compensation bsy1 ON bsy1.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-1,vcpt.FreezeDate) BETWEEN bsy1.AwardDate AND bsy1.EndDate AND bsy1.PayrollType IN('000001','000002') --base salary  y-1
	  LEFT JOIN _tb_employee_compensation bsy2 ON bsy2.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-2,vcpt.FreezeDate) BETWEEN bsy2.AwardDate AND bsy2.EndDate AND bsy2.PayrollType IN('000001','000002') --base salary  y-2
	  -- Bonus Histo Y -1
	  LEFT JOIN _tb_employee_compensation bpsy1 ON bpsy1.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-1,vcpt.FreezeDate) BETWEEN bpsy1.AwardDate AND bpsy1.EndDate AND bpsy1.PayrollType IN('000006') --TB prof Staff  y-1
	  LEFT JOIN _tb_employee_compensation basy1 ON basy1.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-1,vcpt.FreezeDate) BETWEEN basy1.AwardDate AND basy1.EndDate AND basy1.PayrollType IN('0000000060') --B Admin Staff  y-1
	  LEFT JOIN _tb_employee_compensation disy1 ON disy1.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-1,vcpt.FreezeDate) BETWEEN disy1.AwardDate AND disy1.EndDate AND disy1.PayrollType IN('0000000020') --Discr  y-1
	  LEFT JOIN _tb_employee_compensation scy1 ON scy1.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-1,vcpt.FreezeDate) BETWEEN scy1.AwardDate AND scy1.EndDate AND scy1.PayrollType IN('0000000050') --Sales Comm  y-1
	  LEFT JOIN _tb_employee_compensation hfy1 ON hfy1.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-1,vcpt.FreezeDate) BETWEEN hfy1.AwardDate AND hfy1.EndDate AND hfy1.PayrollType IN('000008') --HF P  y-1
	  LEFT JOIN _tb_employee_compensation pey1 ON pey1.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-1,vcpt.FreezeDate) BETWEEN pey1.AwardDate AND pey1.EndDate AND pey1.PayrollType IN('000009') --PE P salary  y-1 
	  --Bonus Histo Y -2
	  LEFT JOIN _tb_employee_compensation bpsy2 ON bpsy2.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-2,vcpt.FreezeDate) BETWEEN bpsy2.AwardDate AND bpsy2.EndDate AND bpsy2.PayrollType IN('000006') --TB prof Staff  y-2
	  LEFT JOIN _tb_employee_compensation basy2 ON basy2.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-2,vcpt.FreezeDate) BETWEEN basy2.AwardDate AND basy2.EndDate AND basy2.PayrollType IN('0000000060') --B Admin Staff  y-2
	  LEFT JOIN _tb_employee_compensation disy2 ON disy2.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-2,vcpt.FreezeDate) BETWEEN disy2.AwardDate AND disy2.EndDate AND disy2.PayrollType IN('0000000020') --Discr  y-2
	  LEFT JOIN _tb_employee_compensation scy2 ON scy2.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-2,vcpt.FreezeDate) BETWEEN scy2.AwardDate AND scy2.EndDate AND scy2.PayrollType IN('0000000050') --Sales Comm  y-2
	  LEFT JOIN _tb_employee_compensation hfy2 ON hfy2.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-2,vcpt.FreezeDate) BETWEEN hfy2.AwardDate AND hfy2.EndDate AND hfy2.PayrollType IN('000008') --HF P  y-2
	  LEFT JOIN _tb_employee_compensation pey2 ON pey2.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-2,vcpt.FreezeDate) BETWEEN pey2.AwardDate AND pey2.EndDate AND pey2.PayrollType IN('000009') --PE P salary  y-2 
	  
	  -- LTIS
	  LEFT JOIN _tb_employee_compensation ltisy1 ON ltisy1.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-1,vcpt.FreezeDate) BETWEEN ltisy1.AwardDate AND ltisy1.EndDate AND ltisy1.PayrollType IN('000010') --LTIS y - 1 
	  LEFT JOIN _tb_employee_compensation ltisy2 ON ltisy2.IdPayee = vcpt.idPayee AND DATEADD(YEAR,-2,vcpt.FreezeDate) BETWEEN ltisy2.AwardDate AND ltisy2.EndDate AND ltisy2.PayrollType IN('000010') --LTIS y - 2
	 

	  --PE HF Values
	  LEFT JOIN _tb_fx_rates_to_chf tfrtc ON tfrtc.year = YEAR(vcpt.FreezeDate) AND vcpt.[Bonus_Currency] = tfrtc.CurrencyCode
	  LEFT JOIN _tb_Point_Values pv ON pv.Year = YEAR(vcpt.FreezeDate) 

	  --CEO Direct
	  LEFT JOIN _tb_hierarchy_data thd ON thd.Emp_IdPayee = vcpt.IdPayee AND thd.FinalInput_IdPayee = thd.FirstInput_Idpayee 

	  WHERE 1=1
	  AND vcpt.id_plan = @id_plan
	  --AND tec1.PersonnelNumber = '10036'
	  ORDER BY [Org_LegalEntity_Desc], [Org_CostCenter_Code], lastname, firstname

END