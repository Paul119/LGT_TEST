-----SP-------
 -----LOAD
CREATE     PROCEDURE [dbo].[sp_load_Compensation_Data]  
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



  DECLARE @sql NVARCHAR(MAX) = 'SELECT * INTO _tb_employee_compensation'+'_'+convert(varchar, getdate(), 112)	 + replace(convert(varchar, getdate(),108),':','')+' FROM _tb_employee_compensation'

  EXEC sys.sp_executesql @sql

  TRUNCATE TABLE _tb_employee_compensation

  INSERT INTO _tb_employee_compensation (IdPayee, PersonnelNumber, PayrollType, AwardDate, EndDate, TargetValueMin, TargetValueMax, TargetValue, PaidDate, PaidValue, Currency, id_user, CreatedDate, ModificationDate, ParentId)
	SELECT pp.idPayee
		  ,sourcetable.PersonnelNumber
		  ,sourcetable.CompensationType
		  ,convert(DATETIME,sourcetable.AwardDate,103)
		  ,Lead(DATEADD("day",-1,convert(DATETIME,sourcetable.AwardDate,103)),1,'01-01-2999') over (PARTITION BY sourcetable.PersonnelNumber, sourcetable.CompensationType order by sourcetable.AwardDate) AS EndDate
		  ,sourcetable.TargetValueMin
		  ,sourcetable.TargetValueMax
		  ,sourcetable.TargetValue
		  ,convert(DATETIME,sourcetable.PaidDate,103)
		  ,sourcetable.PaidValue
		  ,sourcetable.Currency
		  --,sourcetable.AuditId
		  --,sourcetable.DateLoading
		  --,sourcetable.FileName
		  --,sourcetable.QcStatusCode
		  ,-1
		  ,GETDATE()
		  ,NULL
		  ,sourcetable.ParentId 
		  FROM _stg_xls_CompensationData  sourcetable
				INNER JOIN py_Payee pp
					ON sourcetable.PersonnelNumber = pp.codePayee
		  WHERE RIGHT(QcStatusCode,1) <> 1
  
  
   
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