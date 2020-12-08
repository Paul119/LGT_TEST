


CREATE    PROCEDURE [dbo].[sp_report_CRP_Promotion_Letter]  
(@id_payee INT, @id_plan INT)  
AS  
BEGIN  


	SELECT [id_histo]
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
		  ,[CurrentTitleCode]
		  ,[CurrentTitle]
		  ,vcpp.NewTitle AS CRP_NewTitleCode
		  ,rjt.JobTitleDescription AS CRP_NewTitleDesc
		  ,CASE WHEN vcpp.NewTitle = 'Principal' OR vcpp.NewTitle = 'Partner' THEN 'election' ELSE 'promotion' END AS process
	  FROM _vw_CRP_Process_Template vcpt
	  JOIN _vw_CRP_Process_Pivot vcpp ON vcpp.id_payee = vcpt.idPayee
	  JOIN _ref_JobTitle rjt ON vcpp.NewTitle = rjt.JobTitleDescription
	  JOIN _ref_LegalEntity rle ON rle.CompanyCode = vcpt.Org_LegalEntity_Code
	  WHERE vcpt.idPayee = @id_payee AND vcpt.id_plan = @id_plan
  

END