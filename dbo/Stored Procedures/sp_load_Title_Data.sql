CREATE    PROCEDURE [dbo].[sp_load_Title_Data]  
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

  DECLARE @sql NVARCHAR(MAX) = 'SELECT * INTO _tb_employee_Title'+'_'+convert(varchar, getdate(), 112)	 + replace(convert(varchar, getdate(),108),':','')+' FROM _tb_employee_Title'

  EXEC sys.sp_executesql @sql

  TRUNCATE TABLE _tb_employee_Title
  INSERT INTO _tb_employee_Title (IdPayee,PersonnelNumber,EffectiveDate,EndDate,TitleCode,id_user,CreatedDate,ModificationDate,ParentId)
  SELECT IdPayee
		,PersonnelNumber
		,EffectiveDate
		,Lead(DATEADD("day",-1,CONVERT(DATETIME,EffectiveDate,103)),1,'01-01-2999') over (PARTITION BY sourcetable.PersonnelNumber order by EffectiveDate) AS EndDate
		,sourcetable.TitleCode
		,-1
		,GETDATE()
		,NULL
		--,AuditId
		--,DateLoading
		--,FileName
		--,QcStatusCode
		,1
		 FROM _stg_xls_TitleData sourcetable
		INNER JOIN py_Payee pp
		ON sourcetable.PersonnelNumber = pp.codePayee
  WHERE QcStatusCode NOT LIKE '%1%'
  
  -- Fill in k_m_fields_values
	DECLARE @id_field INT = (SELECT kmf.id_field FROM k_m_fields kmf WHERE kmf.name_field = 'New Title')

	DELETE FROM k_m_fields_values WHERE id_field = @id_field

	INSERT INTO k_m_fields_values (id_field, label, value, culture, id_source_tenant, id_source, id_change_set, id_payee, start_date, end_date)
	SELECT DISTINCT @id_field, rjt2.JobTitleDescription, rjt2.JobTitleCode,-3,NULL,NULL,NULL, vcpt.IdPayee, NULL/*kmp1.start_date*/, NULL/*kmp1.end_date*/ FROM _vw_CRP_Process_Template vcpt
	JOIN _ref_JobTitle rjt ON vcpt.CurrentTitleCode = rjt.JobTitleCode
	JOIN _ref_JobTitle rjt2 ON (rjt2.Ranking = rjt.Ranking AND rjt.JobTitleCode <> rjt2.JobTitleCode) OR rjt2.Ranking = rjt.Ranking+1
	JOIN k_m_plans kmp ON vcpt.id_plan = kmp.id_plan
	JOIN k_m_period kmp1 ON kmp.id_period = kmp1.id_period
	--ORDER BY 1
   
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