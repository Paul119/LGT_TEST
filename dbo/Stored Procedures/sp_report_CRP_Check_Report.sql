
CREATE     PROCEDURE [dbo].[sp_report_CRP_Check_Report]  
(@id_plan INT, @id_user INT, @id_profile INT)  
AS  
BEGIN  



	SELECT  [id_histo]
		  ,[start_date_histo]
		  ,[end_date_histo]
		  ,vcpt.[id_plan]
		  ,vcpt.name_plan
		  ,[FreezeDate]
		  ,[idPayee]
		  ,[codePayee]
		  ,[lastname]
		  ,[firstname]
		  ,[fullname]
		  ,[PersonnelNumber]
		  ,[BirthDate]
		  ,[Age]
		  ,[Gender]
		  ,[EntryDate]
		  ,[LeavingDate]
		  ,[EmployeeClass]
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
		  ,[LTIS_Current]
		  ,[Target_Bonus_Year]
		  ,[Target_Bonus_Currency]
		  ,vcpp.NewTitle AS CRP_NewTitle
		  ,vcpp.NewBaseSalary AS CRP_NewBaseSalary
		  ,vcpp.TBProfStaff AS CRP_TBProfStaff
		  ,vcpp.BonusAdminStaff AS CRP_BonusAdminStaff
		  ,vcpp.DiscrBonus AS CRP_DiscrBonus
		  ,vcpp.SalesComm AS CRP_SalesComm
		  ,vcpp.HFP AS CRP_HFP
		  ,vcpp.PEP AS CRP_PEP
		  ,vcpp.TargetTBProfStaff AS CRP_TargetTBProfStaff
		  ,vcpp.TargetBonusAdminStaff AS CRP_TargetBonusAdminStaff
		  ,vcpp.TargetSignOnBonus AS CRP_TargetSignOnBonus
		  ,vcpp.TargetExiBonus AS CRP_TargetExiBonus
		  ,vcpp.TargetHFmin AS CRP_TargetHFmin
		  ,vcpp.TargetHFmax AS CRP_TargetHFmax
		  ,vcpp.TargetPEmin AS CRP_TargetPEmin
		  ,vcpp.TargetPEmax AS CRP_TargetPEmax
		  ,vcpp.LTISY1 AS CRP_LTISY1
		  ,vcpp.Bemerkungen AS CRP_Bemerkungen
		  ,vcpp.Academy AS CRP_Academy
		  ,kmws.name_step
		  ,kmws1.name_status
	  FROM _vw_CRP_Process_Template vcpt
	  LEFT JOIN _vw_CRP_Process_Pivot vcpp ON vcpp.id_payee = vcpt.idPayee AND vcpt.id_plan = vcpp.id_plan
	  --LEFT JOIN k_m_plans kmp ON kmp.id_plan = vcpp.id_plan
	  --LEFT JOIN k_m_workflow kmw ON kmp.id_workflow = kmw.id_workflow
	  LEFT JOIN k_m_plans_payees_steps_workflow kmppsw ON vcpp.id_step = kmppsw.id_step
	  LEFT JOIN k_m_workflow_step kmws ON kmppsw.id_workflow_step = kmws.id_wflstep
	  LEFT JOIN k_m_workflow_status kmws1 ON kmws1.id_status = kmppsw.statut_step

	  WHERE vcpt.id_plan = @id_plan

	  UNION ALL
		
		SELECT  [id_histo]
		  ,[start_date_histo]
		  ,[end_date_histo]
		  ,vcpt.[id_plan]
		  ,vcpt.name_plan
		  ,[FreezeDate]
		  ,[idPayee]
		  ,[codePayee]
		  ,[lastname]
		  ,[firstname]
		  ,[fullname]
		  ,[PersonnelNumber]
		  ,[BirthDate]
		  ,[Age]
		  ,[Gender]
		  ,[EntryDate]
		  ,[LeavingDate]
		  ,[EmployeeClass]
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
		  ,[LTIS_Current]
		  ,[Target_Bonus_Year]
		  ,[Target_Bonus_Currency]
		  ,vcpp.NewTitle AS CRP_NewTitle
		  ,vcpp.NewBaseSalary AS CRP_NewBaseSalary
		  ,vcpp.TBProfStaff AS CRP_TBProfStaff
		  ,vcpp.BonusAdminStaff AS CRP_BonusAdminStaff
		  ,vcpp.DiscrBonus AS CRP_DiscrBonus
		  ,vcpp.SalesComm AS CRP_SalesComm
		  ,vcpp.HFP AS CRP_HFP
		  ,vcpp.PEP AS CRP_PEP
		  ,vcpp.TargetTBProfStaff AS CRP_TargetTBProfStaff
		  ,vcpp.TargetBonusAdminStaff AS CRP_TargetBonusAdminStaff
		  ,vcpp.TargetSignOnBonus AS CRP_TargetSignOnBonus
		  ,vcpp.TargetExiBonus AS CRP_TargetExiBonus
		  ,vcpp.TargetHFmin AS CRP_TargetHFmin
		  ,vcpp.TargetHFmax AS CRP_TargetHFmax
		  ,vcpp.TargetPEmin AS CRP_TargetPEmin
		  ,vcpp.TargetPEmax AS CRP_TargetPEmax
		  ,vcpp.LTISY1 AS CRP_LTISY1
		  ,vcpp.Bemerkungen AS CRP_Bemerkungen
		  ,vcpp.Academy AS CRP_Academy
		  ,kmws.name_step
		  ,kmws1.name_status
	  FROM tb_CRP_Process_Template_archive vcpt
	  LEFT JOIN _vw_CRP_Process_Pivot vcpp ON vcpp.id_payee = vcpt.idPayee AND vcpt.id_plan = vcpp.id_plan
	  --LEFT JOIN k_m_plans kmp ON kmp.id_plan = vcpp.id_plan
	  --LEFT JOIN k_m_workflow kmw ON kmp.id_workflow = kmw.id_workflow
	  LEFT JOIN k_m_plans_payees_steps_workflow kmppsw ON vcpp.id_step = kmppsw.id_step
	  LEFT JOIN k_m_workflow_step kmws ON kmppsw.id_workflow_step = kmws.id_wflstep
	  LEFT JOIN k_m_workflow_status kmws1 ON kmws1.id_status = kmppsw.statut_step

	  WHERE vcpt.id_plan = @id_plan

END