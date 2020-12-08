
CREATE PROCEDURE [dbo].[Consult_SP_Import_PayeeExt]
AS

-- This stored procedure loads Payees extras data to py_payeeext table from py_payeeimport data. After, please run Consult_SP_Import_PayeeSituation

INSERT INTO py_PayeeExt (
	   [id_histo]
	  ,[idPayee]
      ,[login]
      ,[code_performance_rating]
      ,[code_jobfamily]
      ,[code_host_country]
      ,[code_home_country]
      ,[code_division]
      ,[code_businessunit]
      ,[code_band]
      ,[FTE]
      ,[annual_fulltime_basesalary_usd]
      ,[annual_fulltime_basesalary_lc]
      ,[effective_basesalary_lc]
      ,[payment_periods]
      ,[benefit_companycar]
      ,[benefit_housingallowance]
      ,[benefit_healthcare]
      ,[wealth_pensionplan]
      ,[code_potential_rating]
	)
SELECT pph.id_histo
	  ,pph.idPayee
      ,[login]
      ,[code_performance_rating]
      ,[code_jobfamily]
      ,[code_host_country]
      ,[code_home_country]
      ,[code_division]
      ,[code_businessunit]
      ,[code_band]
      ,[FTE]
      ,[annual_fulltime_basesalary_usd]
      ,[annual_fulltime_basesalary_lc]
      ,[effective_basesalary_lc]
      ,[payment_periods]
      ,[benefit_companycar]
      ,[benefit_housingallowance]
      ,[benefit_healthcare]
      ,[wealth_pensionplan]
      ,[code_potential_rating]
FROM dbo.py_PayeeImport ppi
INNER JOIN py_PayeeHisto pph
	ON pph.codePayee = ppi.codePayee
		AND pph.end_date_histo IS NULL