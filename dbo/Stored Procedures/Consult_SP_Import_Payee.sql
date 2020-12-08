

CREATE PROCEDURE [dbo].[Consult_SP_Import_Payee]    
AS    
-- This stored procedure loads Payee data to py_payee table from py_payeeimport data. After, please run Consult_SP_Import_PayeeHisto

--Insert new payees which does not exist in py_Payee table    
INSERT INTO py_Payee (    
 codePayee    
 ,is_active    
 ,ss_nb    
 ,lastname    
 ,firstname    
 ,email    
 ,birth_date    
 ,home_phone    
 ,mobile_phone    
 ,address_street    
 ,address_postal_code    
 ,address_city    
 ,address_country    
 ,family_situation    
 ,children_nb    
 ,IMAGE    
 ,attachment    
 )    
SELECT ppi.codePayee    
 ,1 as is_active    
 ,ppi.ss_nb    
 ,ppi.lastname    
 ,ppi.firstname    
 ,ppi.email    
 ,ppi.birth_date    
 ,ppi.home_phone    
 ,ppi.mobile_phone    
 ,ppi.address_street    
 ,ppi.address_postal_code    
 ,ppi.address_city    
 ,ppi.address_country    
 ,dfs.code_family_situation    
 ,ppi.children_nb    
 ,ppi.IMAGE    
 ,ppi.attachment    
FROM py_PayeeImport ppi    
LEFT JOIN Dim_Family_Situation dfs    
 ON dfs.code_family_situation = ppi.family_situation    
WHERE codePayee NOT IN (    
  SELECT codePayee    
  FROM py_Payee    
  )    
    
--Update py_Payee data which exist in py_PayeeImport table    
UPDATE pp    
SET ss_nb = ppi.ss_nb    
 ,is_active=1    
 ,lastname = ppi.lastname    
 ,firstname = ppi.firstname    
 ,email = ppi.email    
 ,birth_date = ppi.birth_date    
 ,home_phone = ppi.home_phone    
 ,mobile_phone = ppi.mobile_phone    
 ,address_street = ppi.address_street    
 ,address_postal_code = ppi.address_postal_code    
 ,address_city = ppi.address_city    
 ,address_country = ppi.address_country    
 ,family_situation = dfs.id_family_situation    
 ,children_nb = ppi.children_nb    
 ,IMAGE = ppi.IMAGE    
 ,attachment = ppi.attachment    
FROM py_PayeeImport ppi    
INNER JOIN py_Payee pp      
 ON PP.codePayee = ppi.codePayee    
LEFT JOIN Dim_Family_Situation dfs    
 ON dfs.code_family_situation = ppi.family_situation    
     
--Update py_Payee data as 'not active'  which do not exist in py_PayeeImport table   
UPDATE py_payee    
SET is_active=0    
WHERE codepayee not in (select distinct codepayee from py_PayeeImport)    
    
--Update id_sup info in py_Payee table    
UPDATE pp    
SET id_sup = ppsup.idPayee    
FROM py_PayeeImport ppi    
INNER JOIN py_Payee pp    
 ON pp.codePayee = ppi.codePayee    
INNER JOIN py_Payee ppsup    
 ON ppsup.codePayee = ppi.code_sup