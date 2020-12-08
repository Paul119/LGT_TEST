-- =============================================
-- Author:      Pawel Mazur
-- Create Date: 18-11-2020
-- Description: Initial version
-- Version:		v0.1
-- =============================================
CREATE PROCEDURE [dbo].[_LGT_REPORT_CEO_SUMMARY_DATA]
(
	@id_plan INT,
	@id_user INT,
	@id_profile INT
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT  
	-- Base Salary
		  YEAR(vcpt.FreezeDate) AS Process_Year
		  ,Org_CostCenter_Code
		  ,Org_CostCenter_Desc
		  ,Base_Salary_Currency
		  ,ISNULL( bsy1.PaidValue, 0 ) AS Prev_Year
		  ,ISNULL( Base_Salary_Current, 0 ) AS Curr_Year
		  ,ISNULL( vcpp.NewBaseSalary, 0 ) AS Fut_Year
		 ,ISNULL( CAST ( CASE 
		  WHEN Base_Salary_Currency <> 'CHF' THEN bsy1.PaidValue * fxchfp.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS Prev_YearCHF
		  ,ISNULL( CAST ( CASE 
		  WHEN Base_Salary_Currency <> 'CHF' THEN Base_Salary_Current  * fxchfc.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS Curr_YearCHF
		  ,ISNULL( CAST ( CASE 
		  WHEN Base_Salary_Currency <> 'CHF' THEN vcpp.NewBaseSalary * fxchff.Rate
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS Fut_YearCHF
	-- Target Bonus Y - 1 -> Bonus 2019
		  ,COALESCE(bpsy1.Currency,basy1.Currency,disy1.Currency,scy1.Currency,hfy1.Currency,pey1.Currency) AS Bonus_Y_1_Currency
		  ,bpsy1.PaidValue AS TBProfStaff_Y_1
		  ,basy1.PaidValue AS BonusAdminStaff_Y_1
		  ,disy1.PaidValue AS DiscrBonus_Y_1
		  ,scy1.PaidValue AS SalesComm_Y_1
		  ,hfy1.TargetValue AS HP_P_Y_1 -- points
		  ,hfy1.PaidValue AS HP_Value_Y_1
		  ,pey1.TargetValue AS PE_P_Y_1 -- points
		  ,pey1.PaidValue AS PE_Value_Y_1
		  -- // Spec_Payment to change
		  ,bpsy1.PaidValue + basy1.PaidValue + disy1.PaidValue + scy1.PaidValue + hfy1.PaidValue + pey1.PaidValue as Total_Bonus_Y_1
		  -- // Spec_Payment to change
		  ,(bpsy1.PaidValue + basy1.PaidValue + disy1.PaidValue + scy1.PaidValue + hfy1.PaidValue + pey1.PaidValue) * [FTE_Current] as Total_Bonus_Full_Y_1
	-- Target Bonus Y - 1 -> Bonus 2019 in CHF
		  ,ISNULL( CAST ( CASE 
		  WHEN COALESCE(bpsy1.Currency,basy1.Currency,disy1.Currency,scy1.Currency,hfy1.Currency,pey1.Currency) <> 'CHF' THEN bpsy1.PaidValue * fxchfp.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS TBProfStaff_Y_1CHF
		  ,ISNULL( CAST ( CASE 
		  WHEN COALESCE(bpsy1.Currency,basy1.Currency,disy1.Currency,scy1.Currency,hfy1.Currency,pey1.Currency) <> 'CHF' THEN basy1.PaidValue * fxchfp.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS BonusAdminStaff_Y_1CHF
		  ,ISNULL( CAST ( CASE 
		  WHEN COALESCE(bpsy1.Currency,basy1.Currency,disy1.Currency,scy1.Currency,hfy1.Currency,pey1.Currency) <> 'CHF' THEN disy1.PaidValue * fxchfp.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS DiscrBonus_Y_1CHF
		  ,ISNULL( CAST ( CASE 
		  WHEN COALESCE(bpsy1.Currency,basy1.Currency,disy1.Currency,scy1.Currency,hfy1.Currency,pey1.Currency) <> 'CHF' THEN scy1.PaidValue * fxchfp.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS SalesComm_Y_1CHF
		  ,ISNULL( CAST ( CASE 
		  WHEN COALESCE(bpsy1.Currency,basy1.Currency,disy1.Currency,scy1.Currency,hfy1.Currency,pey1.Currency) <> 'CHF' THEN hfy1.PaidValue * fxchfp.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS HP_Value_Y_1CHF
		  ,ISNULL( CAST ( CASE 
		  WHEN COALESCE(bpsy1.Currency,basy1.Currency,disy1.Currency,scy1.Currency,hfy1.Currency,pey1.Currency) <> 'CHF' THEN pey1.PaidValue * fxchfp.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS PE_Value_Y_1CHF
		  ,ISNULL( CAST ( CASE 
		  WHEN COALESCE(bpsy1.Currency,basy1.Currency,disy1.Currency,scy1.Currency,hfy1.Currency,pey1.Currency) <> 'CHF' 
		  THEN (bpsy1.PaidValue + basy1.PaidValue + disy1.PaidValue + scy1.PaidValue + hfy1.PaidValue + pey1.PaidValue) * fxchfp.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS Total_Bonus_Y_1CHF
		  ,ISNULL( CAST ( CASE 
		  WHEN COALESCE(bpsy1.Currency,basy1.Currency,disy1.Currency,scy1.Currency,hfy1.Currency,pey1.Currency) <> 'CHF' 
		  THEN ((bpsy1.PaidValue + basy1.PaidValue + disy1.PaidValue + scy1.PaidValue + hfy1.PaidValue + pey1.PaidValue) * [FTE_Current]) * fxchfp.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS Total_Bonus_Full_Y_1CHF
	-- Target Bonus Current Year
		  ,[Bonus_Year]
		  ,[Bonus_Currency]
		  ,[Target_Bonus_Prof_Staff] 
		  ,[Target_Bonus_Admin_Staff] 
		  ,[Target_HF_Point_Min]
		  ,[Target_HF_Point_Max]
		  ,[Target_PE_Point_Min]
		  ,[Target_PE_Point_Max]
	-- Target Bonus Current Year in CHF
		 ,ISNULL( CAST ( CASE 
		  WHEN [Bonus_Currency] <> 'CHF' 
		  THEN  [Target_Bonus_Prof_Staff] * fxchfc.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS TarBonProfStaffCHF
		  ,ISNULL( CAST ( CASE 
		  WHEN [Bonus_Currency] <> 'CHF' 
		  THEN  [Target_Bonus_Admin_Staff] * fxchfc.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS TarBonAdminStaffCHF
	-- Bonus Current Year
		  ,vcpp.TBProfStaff AS CRP_TBProfStaff
		  ,vcpp.BonusAdminStaff AS CRP_BonusAdminStaff
		  ,vcpp.DiscrBonus AS CRP_DiscrBonus
		  ,vcpp.SalesComm AS CRP_SalesComm
		  ,vcpp.HFP AS CRP_HFP -- points
		  ,CAST((CAST(vcpp.HFP AS DECIMAL(18,2)) * pv.HFValue)  / ISNULL(tfrtc.Rate,1) AS INT) AS HF_Value
		  ,vcpp.PEP AS CRP_PEP -- points
		  ,CAST((CAST(vcpp.PEP AS DECIMAL(18,2)) * pv.PEValue) / ISNULL(tfrtc.Rate,1) AS INT) AS PE_Value
		  ,vcpp.TBProfStaff + vcpp.BonusAdminStaff + vcpp.DiscrBonus + vcpp.SalesComm + CAST((CAST(vcpp.HFP AS DECIMAL(18,2)) * pv.HFValue)  / ISNULL(tfrtc.Rate,1) AS INT) + CAST((CAST(vcpp.PEP AS DECIMAL(18,2)) * pv.PEValue) / ISNULL(tfrtc.Rate,1) AS INT) as Total_Bonus
		  ,(vcpp.TBProfStaff + vcpp.BonusAdminStaff + vcpp.DiscrBonus + vcpp.SalesComm + CAST((CAST(vcpp.HFP AS DECIMAL(18,2)) * pv.HFValue)  / ISNULL(tfrtc.Rate,1) AS INT) + CAST((CAST(vcpp.PEP AS DECIMAL(18,2)) * pv.PEValue) / ISNULL(tfrtc.Rate,1) AS INT)) * [FTE_Current] as Total_Bonus_Full
	-- Bonus Current Year in CHF
		  ,ISNULL( CAST ( CASE 
		  WHEN [Bonus_Currency] <> 'CHF' 
		  THEN  vcpp.TBProfStaff * fxchfc.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS CRpTbProfStaffCHF
		  ,ISNULL( CAST ( CASE 
		  WHEN [Bonus_Currency] <> 'CHF' 
		  THEN  vcpp.BonusAdminStaff * fxchfc.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS CRpBonusAdminStaffCHF
		  ,ISNULL( CAST ( CASE 
		  WHEN [Bonus_Currency] <> 'CHF' 
		  THEN  vcpp.DiscrBonus * fxchfc.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS CRpDiscrBonusCHF
		  ,ISNULL( CAST ( CASE 
		  WHEN [Bonus_Currency] <> 'CHF' 
		  THEN  vcpp.SalesComm * fxchfc.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS CRpSalesCommCHF
		  ,ISNULL( CAST ( CASE 
		  WHEN [Bonus_Currency] <> 'CHF' 
		  THEN  CAST((CAST(vcpp.HFP AS DECIMAL(18,2)) * pv.HFValue)  / ISNULL(tfrtc.Rate,1) AS INT)* fxchfc.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS HF_ValueCHF
		  ,ISNULL( CAST ( CASE 
		  WHEN [Bonus_Currency] <> 'CHF' 
		  THEN  CAST((CAST(vcpp.PEP AS DECIMAL(18,2)) * pv.PEValue) / ISNULL(tfrtc.Rate,1) AS INT) * fxchfc.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS PE_ValueCHF
		  ,ISNULL( CAST ( CASE 
		  WHEN [Bonus_Currency] <> 'CHF' 
		  THEN  vcpp.TBProfStaff + vcpp.BonusAdminStaff + vcpp.DiscrBonus + vcpp.SalesComm + CAST((CAST(vcpp.HFP AS DECIMAL(18,2)) * pv.HFValue)  / ISNULL(tfrtc.Rate,1) AS INT) + CAST((CAST(vcpp.PEP AS DECIMAL(18,2)) * pv.PEValue) / ISNULL(tfrtc.Rate,1) AS INT) * fxchfc.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS TotalBonusCHF
		  ,ISNULL( CAST ( CASE 
		  WHEN [Bonus_Currency] <> 'CHF' 
		  THEN (vcpp.TBProfStaff + vcpp.BonusAdminStaff + vcpp.DiscrBonus + vcpp.SalesComm + CAST((CAST(vcpp.HFP AS DECIMAL(18,2)) * pv.HFValue)  / ISNULL(tfrtc.Rate,1) AS INT) + CAST((CAST(vcpp.PEP AS DECIMAL(18,2)) * pv.PEValue) / ISNULL(tfrtc.Rate,1) AS INT)) * [FTE_Current] * fxchfc.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS TotalBonusFullCHF
	-- Target Bonus Next year
		  ,[Bonus_Currency] AS Target_Bonus_Currency
		  ,vcpp.TargetTBProfStaff AS CRP_TargetTBProfStaff --
		  ,vcpp.TargetBonusAdminStaff AS CRP_TargetBonusAdminStaff --
		  ,vcpp.TargetSignOnBonus AS CRP_TargetSignOnBonus --
		  ,vcpp.TargetExiBonus AS CRP_TargetExiBonus --
		  ,vcpp.TargetHFmin AS CRP_TargetHFmin
		  ,vcpp.TargetHFmax AS CRP_TargetHFmax
		  ,vcpp.TargetPEmin AS CRP_TargetPEmin
		  ,vcpp.TargetPEmax AS CRP_TargetPEmax
	-- Target Bonus Next year in CHF
		  ,ISNULL( CAST ( CASE 
		  WHEN [Bonus_Currency] <> 'CHF' 
		  THEN vcpp.TargetTBProfStaff * fxchff.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS CRPTargetTBProfStaffCHF
		  ,ISNULL( CAST ( CASE 
		  WHEN [Bonus_Currency] <> 'CHF' 
		  THEN vcpp.TargetBonusAdminStaff * fxchff.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS CRPTargetBonusAdminStaffCHF
		  ,ISNULL( CAST ( CASE 
		  WHEN [Bonus_Currency] <> 'CHF' 
		  THEN vcpp.TargetSignOnBonus * fxchff.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS CRPTargetSignOnBonusCHF
		  ,ISNULL( CAST ( CASE 
		  WHEN [Bonus_Currency] <> 'CHF' 
		  THEN vcpp.TargetExiBonus * fxchff.Rate 
		  ELSE 0
		  END AS DECIMAL(11,2) ), 0 ) AS CRPTargetExiBonusCHF
	-- LTIS
		  ,LTISY2.PaidValue AS LTISY_2
		  ,LTISY1.PaidValue AS LTISY_1
		  ,[LTIS_Current]
		  ,vcpp.LTISY1 AS CRP_LTISY1
		  --
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
	  -- Rates
	  left JOIN _tb_fx_rates_to_chf fxchfp ON [Base_Salary_Currency] = fxchfp.CurrencyCode AND YEAR(vcpt.FreezeDate)-1 = fxchfp.year
	  left JOIN _tb_fx_rates_to_chf fxchfc ON [Base_Salary_Currency] = fxchfc.CurrencyCode AND YEAR(vcpt.FreezeDate) = fxchfc.year
	  left JOIN _tb_fx_rates_to_chf fxchff ON [Base_Salary_Currency] = fxchff.CurrencyCode AND YEAR(vcpt.FreezeDate)+1 = fxchff.year

	  WHERE vcpt.id_plan = @id_plan
	  AND Org_CostCenter_Code IS NOT NULL
	  ORDER BY YEAR(vcpt.FreezeDate), Org_CostCenter_Code

END