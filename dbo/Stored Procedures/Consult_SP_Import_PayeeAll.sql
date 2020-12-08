CREATE PROCEDURE [dbo].[Consult_SP_Import_PayeeAll]
AS
-- This stored procedures loads Payee informations to tables. After run the stored procedure, please run 'Consult_SP_Import_TreeTemplate'

BEGIN

	SET NOCOUNT ON;
	
  EXEC dbo.Consult_SP_Import_Payee
  EXEC dbo.Consult_SP_Import_PayeeHisto
  --EXEC dbo.Consult_SP_Import_PayeeSituation
  EXEC dbo.Consult_SP_Import_PayeeExt

END