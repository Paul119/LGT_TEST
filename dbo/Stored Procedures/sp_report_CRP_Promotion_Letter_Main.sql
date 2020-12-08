



CREATE    PROCEDURE [dbo].[sp_report_CRP_Promotion_Letter_Main]  
(@id_plan INT)  
AS  
BEGIN  


	SELECT 
		   vcpt.[idPayee],
		   vcpt.[id_plan]
	  FROM _vw_CRP_Process_Template vcpt
	  JOIN _vw_CRP_Process_Pivot vcpp ON vcpp.id_payee = vcpt.idPayee
	  JOIN _ref_JobTitle rjt ON vcpp.NewTitle = rjt.JobTitleDescription
	  JOIN _ref_LegalEntity rle ON rle.CompanyCode = vcpt.Org_LegalEntity_Code
	  WHERE ISNULL(vcpt.[CurrentTitleCode],'') <> ISNULL(vcpp.NewTitle,ISNULL(vcpt.[CurrentTitleCode],'')) AND vcpt.[id_plan] = @id_plan
            AND GETDATE() <=ISNULL(vcpt.LeavingDate,'9999-12-31')
	        ORDER BY vcpt.Org_LegalEntity_Code, vcpt.Org_CostCenter_Code,vcpt.Org_Department_Code, vcpt.lastname
--  SELECT kmpps.id_payee, kmpps.id_plan
--FROM k_m_plans_payees_steps kmpps
--JOIN k_m_plans_payees_steps_workflow kmppsw ON kmpps.id_step = kmppsw.id_step
--WHERE 
--kmppsw.id_workflow_step = 
--(SELECT MAX(kmws.id_wflstep) FROM k_m_plans kmp
--JOIN k_m_workflow_step kmws ON kmp.id_workflow = kmws.id_workflow)
--AND kmppsw.statut_step = -2
--and kmpps.id_plan = @id_plan

  

END