



 CREATE    VIEW [dbo].[_vw_CRP_Population_Universe_all_employee]
 AS
 SELECT tei.IdPayee
	   ,pp.codePayee
	   ,tei.PersonnelNumber
	   ,tei.BirthDate
	   ,tei.Gender
	   ,tei.EntryDate
	   ,ISNULL(tei.LeavingDate, '2099-12-31') AS LeavingDate
	   ,tei.Canton
	   ,tei.Country
	   ,tei.EmployeeClass
	   ,teo.CostCenter
	   ,teo.BusinessUnit
	   ,teo.BusinessArea
	   ,teo.Department
	   ,teo.LegalEntity
	   ,GETDATE() AS date_now
		 FROM _tb_employee_information tei
       JOIN _tb_ProcessDefinition tpd ON tpd.IsActive = 1
	   LEFT JOIN py_Payee pp ON tei.IdPayee = pp.idPayee
	   LEFT JOIN k_users ku ON ku.id_external_user = tei.idPayee
	   LEFT JOIN _tb_employee_organization teo ON tei.IdPayee = teo.IdPayee AND tpd.FreezeDate BETWEEN teo.EffectiveDate AND teo.EndDate