


 CREATE    VIEW [dbo].[_vw_Pop_test]
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
	   ,GETDATE() AS date_now
		 FROM _tb_employee_information tei
	   LEFT JOIN py_Payee pp ON tei.IdPayee = pp.idPayee
	   LEFT JOIN k_users ku ON ku.id_external_user = tei.IdPayee