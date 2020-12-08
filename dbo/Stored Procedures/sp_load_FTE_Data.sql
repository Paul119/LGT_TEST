-----SP-------
 -----LOAD
CREATE     PROCEDURE [dbo].[sp_load_FTE_Data]  
(@qc_audit_key INT, @UserId INT = -1)  
AS  
BEGIN  
SET NOCOUNT ON;  
  
DECLARE @Category NVARCHAR(255) = 'Client';  
DECLARE @Process NVARCHAR(255) = 'ImportLog';  
DECLARE @SubProcess NVARCHAR(255) = OBJECT_NAME(@@PROCID);  
DECLARE @StartDate DATETIME = GETDATE();  
--DECLARE @UserId INT = -1 --SuperAdmin  
DECLARE @Txt NVARCHAR(255);  
DECLARE @Anz INT;  
  
BEGIN TRY  
    BEGIN TRANSACTION @SubProcess;  
	
	
  DECLARE @sql NVARCHAR(MAX) = 'SELECT * INTO _tb_employee_fte'+'_'+convert(varchar, getdate(), 112)	 + replace(convert(varchar, getdate(),108),':','')+' FROM _tb_employee_fte'

  EXEC sys.sp_executesql @sql

  TRUNCATE TABLE _tb_employee_fte
  INSERT INTO _tb_employee_fte (IdPayee,PersonnelNumber,EffectiveDate,EndDate,FTE,id_user,CreatedDate,ModificationDate,ParentId)
  SELECT IdPayee
		,PersonnelNumber
		,convert(DATETIME,EffectiveDate,103)
		,Lead(DATEADD("day",-1,convert(DATETIME,EffectiveDate,103)),1,'01-01-2999') over (PARTITION BY sourcetable.PersonnelNumber order by EffectiveDate) AS EndDate
		,FTE
		,-1
		,GETDATE()
		,NULL
		--,AuditId
		--,DateLoading
		--,FileName
		--,QcStatusCode
		,1
		 FROM _stg_xls_FTEData sourcetable
		INNER JOIN py_Payee pp
		ON sourcetable.PersonnelNumber = pp.codePayee
  WHERE QcStatusCode NOT LIKE '%1%'
  
   
 COMMIT TRANSACTION @SubProcess  
END TRY  
BEGIN CATCH   

  
 DECLARE @ErrorFlag BIT = 1;  
 DECLARE @EventText NVARCHAR(MAX) = 'Error';  
 DECLARE @ErrorText NVARCHAR(MAX) = error_message();  
 DECLARE @ErrorLine INT = error_line();  
 DECLARE @xstate INT = XACT_STATE()  
   
  
 IF @xstate != 0   
  ROLLBACK TRANSACTION @SubProcess;  

  EXEC [sp_audit_log]  
   @Category  = @Category  --Events Hierarchy level 1  
  ,@Process  = @Process   --Events Hierarchy level 2  
  ,@SubProcess = @SubProcess  --Events (Names of the stored procedures)  
  ,@StartDate  = @StartDate --Start date to be used as a key (to know which records belong to each other)  
  ,@EventText  = @EventText  
  ,@AuditId  = @qc_audit_key  
  ,@UserId  = @UserId  --For application only  
  ,@ErrorFlag  = @ErrorFlag  
  ,@ErrorText  = @ErrorText  
  ,@ErrorLine  = @ErrorLine  
     
END CATCH  
END 
----END LOAD
----QC