
CREATE   PROCEDURE [dbo].[sp_load_employee_import]
(@qc_audit_key INT=-1, @UserId INT = -1)
AS
BEGIN
SET NOCOUNT ON;

DECLARE @PayeeList AS PayeeCreationTableType;



/********** DELETE SPACES **********/  

UPDATE _stg_xls_EmployeeData 
SET PersonnelNumber  =NULLIF(LTRIM(RTRIM(PersonnelNumber)),'')
   ,Name = NULLIF(LTRIM(RTRIM(Name)),'')
   ,FirstName =NULLIF(LTRIM(RTRIM(FirstName)),'')
   ,BirthDate =NULLIF(LTRIM(RTRIM(BirthDate)),'')
   ,Gender =NULLIF(LTRIM(RTRIM(Gender)),'')
   ,EntryDate =NULLIF(LTRIM(RTRIM(EntryDate)),'')
   ,LeavingDate =NULLIF(LTRIM(RTRIM(LeavingDate)),'')
   ,Adress =NULLIF(LTRIM(RTRIM(Adress)),'')
   ,PostalCode =NULLIF(LTRIM(RTRIM(PostalCode)),'')
   ,City =NULLIF(LTRIM(RTRIM(City)),'')
   ,Canton =NULLIF(LTRIM(RTRIM(Canton)),'')
   ,Country =NULLIF(LTRIM(RTRIM(Country)),'')
   ,EmployeeClass =NULLIF(LTRIM(RTRIM(EmployeeClass)),'')
   ,EMailAddress =NULLIF(LTRIM(RTRIM(EMailAddress)),'')
   ,Infotext =NULLIF(LTRIM(RTRIM(Infotext)),'')

/********** CONTROLS AND LOGS **********/ 
EXEC sp_load_employee_information_import_log @qc_audit_key



/********** PAYEE CREATION **********/ 
INSERT INTO @PayeeList(codePayee, email,lastname, firstname)
	SELECT sourcetable.PersonnelNumber, sourcetable.EMailAddress, sourcetable.Name, sourcetable.FirstName 
	FROM _stg_xls_EmployeeData sourcetable
	WHERE 1=1
	AND RIGHT(sourceTable.QcStatusCode,1)!='1' --avoid blocked rows
	AND NOT EXISTS (SELECT 1 FROM py_Payee pp WHERE pp.codePayee = sourcetable.PersonnelNumber) --not already present payees
	----these fields are mandatory, so we check they are not null
	--AND NULLIF(LTRIM(RTRIM(sourcetable.Matricule)),'') IS NOT NULL 
	--AND NULLIF(LTRIM(RTRIM(sourcetable.Email)),'') IS NOT NULL 
	--AND NULLIF(LTRIM(RTRIM(sourcetable.Nom)),'')  IS NOT NULL 
	--AND NULLIF(LTRIM(RTRIM(sourcetable.Prenom)),'')  IS NOT NULL 

EXEC sp_global_payee_creation @qc_audit_key, @PayeeList 

--here we need to call sp_global_user_creation
EXEC sp_global_user_creation @qc_audit_key

/********** FINAL TABLE **********/ 
EXEC sp_load_employee_information @qc_audit_key

END