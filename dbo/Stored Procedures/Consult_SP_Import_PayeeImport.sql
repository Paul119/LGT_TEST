CREATE PROCEDURE [dbo].[Consult_SP_Import_PayeeImport]
AS
-- This stored procedure loads Payee data to py_payeeimport table from base payee data. After, please run Consult_SP_Import_PayeeAll
TRUNCATE TABLE py_payeeimport;

WITH dummyimport -- a simple tree with a top level and two brunchs 
AS (
	SELECT 'ZDN000' AS codePayee
		,NULL AS code_sup
		,'ZDN' AS lastname
		,'000' AS firstname
	
	UNION ALL
	
	SELECT 'ZDN010' AS codePayee
		,'ZDN000' AS code_sup
		,'ZDN' AS lastname
		,'010' AS firstname
	
	UNION ALL
	
	SELECT 'ZDN020' AS codePayee
		,'ZDN000' AS code_sup
		,'ZDN' AS lastname
		,'020' AS firstname
		
	)
INSERT py_payeeimport (
	codePayee
	,code_sup
	,lastname
	,firstname
	,email
	,code_gender
	,code_job
	,code_structure_1
	,date_loading
	,start_date_histo
	)
SELECT codePayee
	,code_sup
	,lastname
	,firstname
	,'zdn@excentive.com' AS email
	,'N/A' AS code_gender --required for some kernel views
	,'N/A' AS code_job --required for job filter in PROCESS tab 
	,'N/A' AS code_structure_1 --required for organization filter in PROCESS tab 
	,getdate() AS date_loading
	,getdate() AS start_date_histo
FROM dummyimport