CREATE   PROCEDURE [dbo].[sp_load_Title_Data_information_import_log]  
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
  UPDATE _stg_xls_TitleData   
  SET QcStatusCode=(replicate('0',(150)))  
  
   /**CONTROLS, SAME AS IN QUALITYCONTROL COLLAB PERSONNEL**/  
   DECLARE @unicitycheckTable TABLE(  
          PersonnelNumber NVARCHAR(500) NULL  
   )  
   DECLARE @position INT;
   
   DECLARE @errorfound TABLE(
   ID INT NULL,
   Error NVARCHAR(255)
   ) 

   
   ---------------------- BLOCKING ERRORS -------------------------  
   ---------------------- Primary Key ----------------------  
   INSERT INTO @unicitycheckTable   
    SELECT sourcetable.PersonnelNumber  
    FROM _stg_xls_TitleData sourcetable  
    WHERE 1=1  
    GROUP BY sourcetable.PersonnelNumber, sourcetable.EffectiveDate
    HAVING COUNT(1)>1  
      
     
   --The positions are in table tb_etl_referential_quality_control  
   SET @position = 1  
   UPDATE sourceTable  
   SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'  
   FROM _stg_xls_TitleData AS sourceTable  
   INNER JOIN @unicitycheckTable checkTable  
    ON sourceTable.PersonnelNumber = checkTable.PersonnelNumber 
   WHERE 1=1  
   AND NULLIF(sourceTable.PersonnelNumber,'') IS NOT NULL  
  
   DELETE FROM @unicitycheckTable  
  
  
   ---------------------- PersonnelNumber null ----------------------  
   SET @position = 2  
   UPDATE sourceTable  
   SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'  
   FROM _stg_xls_TitleData AS sourceTable  
   WHERE 1=1  
   AND NULLIF(sourceTable.PersonnelNumber,'') IS NULL

   ---------------------- PersonnelNumber do not exist ----------------------  
   SET @position = 3  
   UPDATE sourceTable  
   SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'  
   FROM _stg_xls_TitleData AS sourceTable
   Left JOIN py_Payee pp
   ON sourceTable.PersonnelNumber = pp.codePayee 
   WHERE 1=1  
   AND pp.idPayee IS NULL  
  
   ---------------------- EffectiveDate null ----------------------  
   SET @position = 4  
   UPDATE sourceTable  
   SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'  
   FROM _stg_xls_TitleData AS sourceTable  
   WHERE 1=1  
   AND NULLIF(sourceTable.EffectiveDate,'') IS NULL  
  
  
   ---------------------- TitleCode null ----------------------  
   SET @position = 5 
   UPDATE sourceTable  
   SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'  
   FROM _stg_xls_TitleData AS sourceTable  
   WHERE 1=1  
   AND NULLIF(sourceTable.TitleCode,'') IS NULL  
  
  ---------------------- LEN(TitleCode) > 1 ----------------------  
   SET @position = 6 
   UPDATE sourceTable  
   SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'  
   FROM _stg_xls_TitleData AS sourceTable  
   WHERE 1=1  
   AND LEN(sourceTable.TitleCode) > 6  
   ---------------------- TitleCode do not exist ----------------------  
   SET @position = 7 
   UPDATE sourceTable  
   SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'  
   FROM _stg_xls_TitleData AS sourceTable
   LEFT JOIN _ref_JobTitle jc
   ON sourceTable.TitleCode = jc.JobTitleCode
   WHERE 1=1  
   AND jc.JobTitleId IS NULL 

  --Delete previous logs  
  TRUNCATE TABLE _stg_xls_TitleData_Error

  INSERT INTO @errorfound (ID)
   SELECT stgTitleDataId FROM _stg_xls_TitleData
   WHERE QcStatusCode LIKE '%1%'

   DECLARE @ErrorMessage NVARCHAR(255) = NULL


   SET @position = 1
   UPDATE errorfound
   SET Error = CONCAT(Error,'|','Duplicates')
   FROM @errorfound AS errorfound
   INNER JOIN _stg_xls_TitleData sourcetable
   ON errorfound.ID = sourcetable.stgTitleDataId
   where 1=1
   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

   SET @position = 2
   UPDATE errorfound
   SET Error = CONCAT(Error,'|','PersonnelNumber null')
   FROM @errorfound AS errorfound
   INNER JOIN _stg_xls_TitleData sourcetable
   ON errorfound.ID = sourcetable.stgTitleDataId
   where 1=1
   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

   SET @position = 3
   UPDATE errorfound
   SET Error = CONCAT(Error,'|','PersonnelNumber do not exist')
   FROM @errorfound AS errorfound
   INNER JOIN _stg_xls_TitleData sourcetable
   ON errorfound.ID = sourcetable.stgTitleDataId
   where 1=1
   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

   SET @position = 4
   UPDATE errorfound
   SET Error = CONCAT(Error,'|','EffectiveDate null')
   FROM @errorfound AS errorfound
   INNER JOIN _stg_xls_TitleData sourcetable
   ON errorfound.ID = sourcetable.stgTitleDataId
   where 1=1
   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

   SET @position = 5
   UPDATE errorfound
   SET Error = CONCAT(Error,'|','TitleCode null')
   FROM @errorfound AS errorfound
   INNER JOIN _stg_xls_TitleData sourcetable
   ON errorfound.ID = sourcetable.stgTitleDataId
   where 1=1
   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

   SET @position = 6
   UPDATE errorfound
   SET Error = CONCAT(Error,'|','Lenght of TitleCode > 6')
   FROM @errorfound AS errorfound
   INNER JOIN _stg_xls_TitleData sourcetable
   ON errorfound.ID = sourcetable.stgTitleDataId
   where 1=1
   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

   SET @position = 7
   UPDATE errorfound
   SET Error = CONCAT(Error,'|','TitleCode do not exist')
   FROM @errorfound AS errorfound
   INNER JOIN _stg_xls_TitleData sourcetable
   ON errorfound.ID = sourcetable.stgTitleDataId
   where 1=1
   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

   --SELECT * FROM @errorfound
   --SELECT RIGHT(LEFT(QcStatusCode, 150-6),1),* FROM _stg_xls_TitleData
   --where LEFT(QcStatusCode, 150 - 6 - 1) + '1' + LEFT(RIGHT(QcStatusCode, 6),6 - 1) + '1'  = 1


  -- Insert errors into log table  
  INSERT INTO _stg_xls_TitleData_Error (PersonnelNumber,error,EffectiveDate ,TitleCode, ParentId)  
  SELECT   
       sourcetable.PersonnelNumber
		,ef.Error
		,sourcetable.EffectiveDate
		,sourcetable.TitleCode
      --,sourcetable.AuditId  
      --,sourcetable.DateLoading  
      --,sourcetable.FileName  
      --,sourcetable.QcStatusCode  
      ,sourcetable.ParentId  
   FROM _stg_xls_TitleData sourcetable
   INNER JOIN @errorfound ef
   ON sourcetable.stgTitleDataId = ef.ID
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
-----END QC----
-----ACTIONS---