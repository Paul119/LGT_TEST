




CREATE PROCEDURE [dbo].[sp_report_CRP_Compensation_Letter_Process]  
(@id_plan INT, @id_payee INT, @id_user INT, @id_profile INT)  
AS  
BEGIN




	SELECT vcpt.idPayee, 
			vcpt.id_plan, 
			CASE WHEN ISNULL(kmppsw.statut_step,0) = -2 THEN 1 ELSE 1 END AS validated,
			CASE WHEN teis.EmpIdStaffId IS NOT NULL THEN 1 ELSE 0 END AS identified
	  FROM _vw_CRP_Process_Template vcpt
	  JOIN k_m_plans_payees_steps kmpps ON vcpt.id_plan = kmpps.id_plan AND vcpt.IdPayee = kmpps.id_payee
	  LEFT JOIN k_m_plans_payees_steps_workflow kmppsw ON kmpps.id_step = kmppsw.id_step AND kmppsw.current_sort = kmppsw.max_sort
	  LEFT JOIN _tb_employee_identified_staff teis ON vcpt.PersonnelNumber = teis.PersonnelNumber
	  WHERE 1=1
	  AND vcpt.id_plan = @id_plan
	  AND vcpt.IdPayee = @id_payee
	  --2019 filter
	  AND vcpt.Org_LegalEntity_Code <> '014'
	  AND vcpt.PersonnelNumber NOT IN ('16535',
'16432',
'16511',
'12833',
'15727',
'16250',
'14681',
'16523',
'16450',
'12153',
'16536',
'16046',
'16437',
'15271',
'16549',
'7417',
'16409',
'16388',
'14262',
'16598',
'13232',
'14552',
'16382',
'16168',
'16429',
'14822',
'12115',

'11926',
'12856',
'11538',
'15935',
'14964',
'15798',
'15519',
'15963',
'15934',
'12201',
'14160',
'7620',
'13229',
'16578',
'15868',
'13691',
'16484',
'14574',
'11976',
'16569',
'14527',
'15684',
'11552',
'12257',
'4718',
'5284',
'15753',
'13187',
'15029',
'11822',
'14757',
'16096',
'13634',
'11565',
'14166',
'7928',
'7422',
'14526',
'12554',
'15256',
'13040',
'16008',
'13613',
'11542',
'7423',
'12270',
'12940',
'11316')


END 

SELECT * FROM _ref_LegalEntity rle