




CREATE     PROCEDURE [dbo].[sp_report_CRP_Compensation_Letter_Regular_Main]  
(@id_plan INT, @legalentity NVARCHAR(MAX), @costcenter NVARCHAR(MAX), @department NVARCHAR(MAX) )  
AS  
BEGIN  

	SELECT vcpt.idPayee, vcpt.id_plan
	  FROM _vw_CRP_Process_Template vcpt
	  LEFT JOIN _tb_employee_identified_staff teis ON vcpt.PersonnelNumber = teis.PersonnelNumber
	  WHERE 1=1
	  AND vcpt.id_plan = @id_plan AND teis.EmpIdStaffId IS NULL
	  AND vcpt.Org_LegalEntity_Code in (SELECT Item FROM udf_Split(@legalentity,','))
	  AND vcpt.Org_CostCenter_Code in (SELECT Item FROM udf_Split(@costcenter,',') )
	  AND vcpt.Org_Department_Code in (SELECT Item FROM udf_Split(@department,','))
	  AND GETDATE() <=ISNULL(vcpt.LeavingDate,'9999-12-31')
ORDER BY vcpt.Org_LegalEntity_Code, vcpt.Org_CostCenter_Code,vcpt.Org_Department_Code, vcpt.lastname


--	SELECT vcpt.idPayee, vcpt.id_plan
--	  FROM _vw_CRP_Process_Template vcpt
--	  LEFT JOIN _ref_JobTitle rjt ON rjt.JobTitleCode = vcpt.CurrentTitleCode
--	  WHERE vcpt.id_plan = @id_plan AND rjt.IdentifiedStaff = 'No'
--ORDER BY vcpt.Org_LegalEntity_Code, vcpt.Org_CostCenter_Code, vcpt.lastname
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