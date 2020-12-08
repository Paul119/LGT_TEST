-----SP-------
 -----LOAD
CREATE PROCEDURE [dbo].[sp_load_Hierarchy_Data]  
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

  DECLARE @sql NVARCHAR(MAX) = 'SELECT * INTO _tb_hierarchy_data'+'_'+convert(varchar, getdate(), 112)	 + replace(convert(varchar, getdate(),108),':','')+' FROM _tb_hierarchy_data'

  EXEC sys.sp_executesql @sql

  TRUNCATE TABLE _tb_hierarchy_data
  INSERT INTO _tb_hierarchy_data (Emp_IdPayee, Emp_Id, Emp_FirstName, Emp_Lastname, Emp_ShortSign, Mgr_IdPayee, Mgr_ID, Mgr_FirstName, Mgr_LastName, FirstInput_Idpayee, FirstInput_Id, FirstInput_ShortSign, SecondInput_IdPayee, SecondInput_Id, SecondInput_ShortSign, View_IdPayee, View_Id, View_ShortSign, FinalInput_IdPayee, FinalInput_Id, FinalInput_ShortSign, ParentId)
  SELECT distinct
		 pp1.idPayee
		,sourcetable.Emp_Id
		,sourcetable.Emp_FirstName
		,sourcetable.Emp_Lastname
		,sourcetable.Emp_ShortSign
		,pp2.idPayee
		,sourcetable.Mgr_ID
		,NULL --sourcetable.Mgr_FirstName
		,NULL --sourcetable.Mgr_LastName
		,pp3.idPayee
		,FI.Item AS FirstInput_Id
		,NULL --sourcetable.FirstInput_ShortSign
		,pp4.idPayee
		,SI.Item AS SecondInput_Id
		,NULL --sourcetable.SecondInput_ShortSign
		,pp5.idPayee
		,VI.Item AS View_Id
		,NULL --sourcetable.View_ShortSign
		,pp6.idPayee
		,sourcetable.FinalInput_Id
		,NULL --sourcetable.FinalInput_ShortSign
		,sourcetable.ParentId
		 FROM _stg_xls_HierarchyData sourcetable
		 CROSS APPLY dbo.udf_Split(ISNULL(sourcetable.FirstInput_Id,''),'/') FI
         CROSS APPLY dbo.udf_Split(ISNULL(sourcetable.SecondInput_Id,''),'/') SI
         CROSS APPLY dbo.udf_Split(ISNULL(sourcetable.View_Id,''),'/') VI
		 INNER JOIN py_Payee pp1 ON pp1.codePayee = sourcetable.Emp_Id
		 LEFT JOIN py_Payee pp2 ON pp2.codePayee = sourcetable.Mgr_ID
		 LEFT JOIN py_Payee pp3 ON pp3.codePayee = FI.Item
		 LEFT JOIN py_Payee pp4 ON pp4.codePayee = SI.Item
		 LEFT JOIN py_Payee pp5 ON pp5.codePayee = VI.Item
		 LEFT JOIN py_Payee pp6 ON pp6.codePayee = sourcetable.FinalInput_Id
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