--SELECT * FROM _vw_CRP_Process_Pivot
--SELECT * FROM _tb_ProcessDefinition
--SELECT * FROM _vw_CRP_Process_Template

CREATE procedure [dbo].[_sp_client_report_process_employee_histo] (@idPayee INT,@id_plan INT)  
AS   
--DECLARE @idPayee INT = 7
--DECLARE @id_plan INT = 6

SELECT tpd.id_plan
	  ,tpd.FreezeDate
	  ,vcpp.id_payee
	  ,vcpp.NewTitle
	  ,vcpp.TBProfStaff
	  ,vcpp.BonusAdminStaff
	  ,vcpp.DiscrBonus
	  ,vcpp.SalesComm
	  ,vcpp.HFP
	  ,vcpp.PEP
	  ,vcpp.TargetTBProfStaff
	  ,vcpp.TargetBonusAdminStaff
	  ,vcpp.TargetSignOnBonus
	  ,vcpp.TargetExiBonus
	  ,vcpp.TargetHFmin
	  ,vcpp.TargetHFmax
	  ,vcpp.TargetPEmin
	  ,vcpp.TargetPEmax
	  ,vcpp.LTISY1
	  ,vcpp.Bemerkungen
	  ,vcpt.id_histo
	  ,vcpt.start_date_histo
	  ,vcpt.end_date_histo
	  ,vcpt.idPayee
	  ,vcpt.codePayee
	  ,vcpt.lastname
	  ,vcpt.firstname
	  ,vcpt.fullname
	  ,vcpt.PersonnelNumber
	  ,vcpt.BirthDate
	  ,vcpt.Age
	  ,vcpt.Gender
	  ,vcpt.EntryDate
	  ,vcpt.LeavingDate
	  ,vcpt.EmployeeClass
	  ,vcpt.Org_BeginDate
	  ,vcpt.Org_EndDate
	  ,vcpt.Org_ReportManager
	  ,vcpt.Org_CostCenter_Code
	  ,vcpt.Org_CostCenter_Desc
	  ,vcpt.Org_BusinessUnit_Code
	  ,vcpt.Org_BusinessUnit_Desc
	  ,vcpt.Org_BusinessArea_Code
	  ,vcpt.Org_BusinessArea_Desc
	  ,vcpt.Org_Department_Code
	  ,vcpt.Org_Department_Desc
	  ,vcpt.Org_LegalEntity_Code
	  ,vcpt.Org_LegalEntity_Desc
	  ,vcpt.FTE_BeginDate
	  ,vcpt.FTE_Enddate
	  ,vcpt.FTE_Current
	  ,vcpt.FTE_Future
	  ,vcpt.Job_BeginDate
	  ,vcpt.Job_EndDate
	  ,vcpt.JobCode_Current
	  ,vcpt.CurrentTitle
	  ,vcpt.Base_Salary_Currency
	  ,vcpt.Base_Salary_Current
	  ,vcpt.Bonus_Year
	  ,vcpt.Bonus_Currency
	  ,vcpt.Target_Bonus_Prof_Staff
	  ,vcpt.Target_Bonus_Admin_Staff
	  ,vcpt.Bonus_Signon
	  ,vcpt.Bonus_Exit
	  ,vcpt.Target_HF_Point_Min
	  ,vcpt.Target_HF_Point_Max
	  ,vcpt.Target_PE_Point_Min
	  ,vcpt.Target_PE_Point_Max
	  ,vcpt.HF_Point_Value
	  ,vcpt.PE_Point_Value
	  ,vcpt.LTIS_Current
	  ,vcpt.Target_Bonus_Year
	  ,vcpt.Target_Bonus_Currency FROM _tb_ProcessDefinition tpd
LEFT JOIN _vw_CRP_Process_Pivot vcpp
ON vcpp.id_plan = tpd.id_plan
LEFT JOIN _vw_CRP_Process_Template vcpt
ON vcpt.id_plan = tpd.id_plan
AND vcpt.idPayee = vcpp.id_payee
WHERE vcpt.idPayee = @idPayee
AND vcpp.id_plan = @id_plan