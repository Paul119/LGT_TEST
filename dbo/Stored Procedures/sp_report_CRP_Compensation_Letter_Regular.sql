



CREATE     PROCEDURE [dbo].[sp_report_CRP_Compensation_Letter_Regular]  
(@id_payee INT, @id_plan INT)  
AS  
BEGIN  



	SELECT  [id_histo]
		  ,[start_date_histo]
		  ,[end_date_histo]
		  ,vcpt.[id_plan]
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
		  ,[LTIS_Current]
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
	  FROM _vw_CRP_Process_Template vcpt
	  LEFT JOIN _vw_CRP_Process_Pivot vcpp ON vcpp.id_payee = vcpt.idPayee
	  LEFT JOIN _ref_LegalEntity rle ON rle.CompanyCode = vcpt.Org_LegalEntity_Code
	  WHERE vcpt.idPayee = @id_payee AND vcpt.id_plan = @id_plan
  
  

END