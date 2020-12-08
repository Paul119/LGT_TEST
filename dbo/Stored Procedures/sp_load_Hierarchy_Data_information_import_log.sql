
CREATE    PROCEDURE [dbo].[sp_load_Hierarchy_Data_information_import_log]  
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
  
  --Set back the controls:  
  UPDATE _stg_xls_HierarchyData
  SET QcStatusCode=(replicate('0',(150)))  
  
  SELECT DISTINCT
        sxhd.stgHierarchydataId
		 ,sxhd.Emp_Id
		,sxhd.Emp_FirstName
		,sxhd.Emp_Lastname
		,sxhd.Emp_ShortSign
		,sxhd.Mgr_ID
		,sxhd.Mgr_FirstName
		,sxhd.Mgr_LastName
		--,sxhd.FirstInput_Id
		--,sxhd.FirstInput_ShortSign
		,FI.Item AS FirstInput_Id
		--,sxhd.SecondInput_Id
		--,sxhd.SecondInput_ShortSign
		,SI.Item AS SecondInput_Id
		--,sxhd.View_Id
		--,sxhd.View_ShortSign
		,VI.Item AS View_Id
		,sxhd.FinalInput_Id
		,sxhd.FinalInput_ShortSign
		,sxhd.AuditId
		,sxhd.DateLoading
		,sxhd.FileName
		,sxhd.QcStatusCode
		,sxhd.ParentId 
		INTO #temp_hier
		FROM    _stg_xls_HierarchyData sxhd
  CROSS APPLY dbo.udf_Split(ISNULL(sxhd.FirstInput_Id,''),'/') FI
  CROSS APPLY dbo.udf_Split(ISNULL(sxhd.SecondInput_Id,''),'/') SI
  CROSS APPLY dbo.udf_Split(ISNULL(sxhd.View_Id,''),'/') VI


   DECLARE @position INT;
   
   DECLARE @errorfound TABLE(
   ID INT NULL,
   Error NVARCHAR(255)
   ) 


  
   ---------------------- Emp_Id null ----------------------  
   SET @position = 2  
   UPDATE sourceTable  
   SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'  
   FROM #temp_hier AS sourceTable  
   WHERE 1=1  
   AND NULLIF(sourceTable.Emp_id,'') IS NULL

   ---------------------- Emp_Id do not exist ----------------------  
   SET @position = 3  
   UPDATE sourceTable  
   SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'  
   FROM #temp_hier AS sourceTable
   Left JOIN _tb_employee_information pp
   ON sourceTable.Emp_id = pp.PersonnelNumber 
   WHERE 1=1  
   AND pp.idPayee IS NULL  
  
   ---------------------- Mgr_Id do not exists ----------------------  
   --SET @position = 4  
   --UPDATE sourceTable  
   --SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'  
   --FROM _stg_xls_HierarchyData AS sourceTable
   --Left JOIN py_Payee pp
   --ON sourceTable.Mgr_Id = pp.codePayee 
   --WHERE 1=1  
   --AND pp.idPayee IS NULL  
  
  
   ---------------------- FirstInput_Id do not exists ----------------------  
   SET @position = 5 
   UPDATE sourceTable  
   SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'  
   FROM #temp_hier AS sourceTable
   Left JOIN py_Payee pp
   ON sourceTable.FirstInput_Id = pp.codePayee 
   WHERE 1=1  
   AND pp.idPayee IS NULL   
  
  ---------------------- SecondInput_Id do not exists (can be empty) ----------------------  
   SET @position = 6 
   UPDATE sourceTable  
   SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'  
   FROM #temp_hier AS sourceTable
   Left JOIN py_Payee pp
   ON sourceTable.SecondInput_Id = pp.codePayee 
   WHERE 1=1  
   AND pp.idPayee IS NULL and ISNULL(sourceTable.SecondInput_Id,'')<>''

     ---------------------- View_Id do not exists (can be empty) ----------------------  
   SET @position = 7 
   UPDATE sourceTable  
   SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'  
   FROM #temp_hier AS sourceTable
   Left JOIN py_Payee pp
   ON sourceTable.View_Id = pp.codePayee 
   WHERE 1=1  
   AND pp.idPayee IS NULL  and ISNULL(sourceTable.View_Id,'')<>''

        ---------------------- FinalInput_Id do not exists----------------------  
   SET @position = 8
   UPDATE sourceTable  
   SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'  
   FROM #temp_hier AS sourceTable
   Left JOIN py_Payee pp
   ON sourceTable.FinalInput_Id = pp.codePayee 
   WHERE 1=1  
   AND pp.idPayee IS NULL  
   
   UPDATE s SET s.QcStatusCode = th.QcStatusCode FROM _stg_xls_HierarchyData s
   JOIN #temp_hier th ON s.stgHierarchydataId = th.stgHierarchydataId

  --Delete previous logs  
  TRUNCATE TABLE _stg_xls_HierarchyData_Error

  INSERT INTO @errorfound (ID)
   SELECT stgHierarchydataId FROM _stg_xls_HierarchyData
   WHERE QcStatusCode LIKE '%1%'

   DECLARE @ErrorMessage NVARCHAR(255) = NULL


   SET @position = 2
   UPDATE errorfound
   SET Error = CONCAT(Error,'|','Emp_Id null')
   FROM @errorfound AS errorfound
   INNER JOIN _stg_xls_HierarchyData sourcetable
   ON errorfound.ID = sourcetable.stgHierarchydataId
   where 1=1
   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

   SET @position = 3
   UPDATE errorfound
   SET Error = CONCAT(Error,'|','Emp_Id do not exists')
   FROM @errorfound AS errorfound
   INNER JOIN _stg_xls_HierarchyData sourcetable
   ON errorfound.ID = sourcetable.stgHierarchydataId
   where 1=1
   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

   --SET @position = 4
   --UPDATE errorfound
   --SET Error = CONCAT(Error,'|','Mgr_ID do not exist')
   --FROM @errorfound AS errorfound
   --INNER JOIN _stg_xls_HierarchyData sourcetable
   --ON errorfound.ID = sourcetable.stgHierarchydataId
   --where 1=1
   --AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

   SET @position = 5
   UPDATE errorfound
   SET Error = CONCAT(Error,'|','FirstInput_Id do not exists')
   FROM @errorfound AS errorfound
   INNER JOIN _stg_xls_HierarchyData sourcetable
   ON errorfound.ID = sourcetable.stgHierarchydataId
   where 1=1
   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

   SET @position = 6
   UPDATE errorfound
   SET Error = CONCAT(Error,'|','SecondInput_Id do not exists')
   FROM @errorfound AS errorfound
   INNER JOIN _stg_xls_HierarchyData sourcetable
   ON errorfound.ID = sourcetable.stgHierarchydataId
   where 1=1
   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

   SET @position = 7
   UPDATE errorfound
   SET Error = CONCAT(Error,'|','View_Id do not exists')
   FROM @errorfound AS errorfound
   INNER JOIN _stg_xls_HierarchyData sourcetable
   ON errorfound.ID = sourcetable.stgHierarchydataId
   where 1=1
   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

    SET @position = 8
   UPDATE errorfound
   SET Error = CONCAT(Error,'|','FinalInput_Id do not exists')
   FROM @errorfound AS errorfound
   INNER JOIN _stg_xls_HierarchyData sourcetable
   ON errorfound.ID = sourcetable.stgHierarchydataId
   where 1=1
   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)



  -- Insert errors into log table  
  INSERT INTO _stg_xls_HierarchyData_Error ([Error]
           ,[Emp_Id]
           ,[Emp_FirstName]
           ,[Emp_Lastname]
           ,[Emp_ShortSign]
           ,[Mgr_ID]
           ,[Mgr_FirstName]
           ,[Mgr_LastName]
           ,[FirstInput_Id]
           ,[FirstInput_ShortSign]
           ,[SecondInput_Id]
           ,[SecondInput_ShortSign]
           ,[View_Id]
           ,[View_ShortSign]
           ,[FinalInput_Id]
           ,[FinalInput_ShortSign]
           ,[ParentId])
  SELECT   
	    	ef.Error 
		   ,[Emp_Id]
           ,[Emp_FirstName]
           ,[Emp_Lastname]
           ,[Emp_ShortSign]
           ,[Mgr_ID]
           ,[Mgr_FirstName]
           ,[Mgr_LastName]
           ,[FirstInput_Id]
           ,[FirstInput_ShortSign]
           ,[SecondInput_Id]
           ,[SecondInput_ShortSign]
           ,[View_Id]
           ,[View_ShortSign]
           ,[FinalInput_Id]
           ,[FinalInput_ShortSign]
           ,[ParentId]
   FROM _stg_xls_HierarchyData sourcetable
   INNER JOIN @errorfound ef
   ON sourcetable.stgHierarchydataId = ef.ID
   WHERE RIGHT(sourcetable.QcStatusCode,1)='1'   
 
 COMMIT TRANSACTION @SubProcess  
END TRY  
BEGIN CATCH   
--If something goes wrong on the TRY, the actions of it are not executed and we get the into the CATCH     
      
--As a transaction was created on the TRY (even if the actions of it are not executed) we have to commit it or rollback it:  
--Test xact_state() for 1 or -1  
--xact_state() = 0 means there is no transaction and a commit or rollback would generate an error  
  
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