

CREATE   PROCEDURE [dbo].[sp_load_employee_information_import_log]
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

DECLARE @errorfound TABLE(
   ID INT NULL,
   Error NVARCHAR(500)
   ) 

BEGIN TRY
    BEGIN TRANSACTION @SubProcess;

		--============================================================================================================
		EXEC [sp_audit_log]
			 @Category		= @Category		--Events Hierarchy level 1
			,@Process		= @Process 		--Events Hierarchy level 2
			,@SubProcess	= @SubProcess 	--Events (Names of the stored procedures)
			,@StartDate		= @StartDate	--Start date to be used as a key (to know which records belong to each other)
			,@EventText		= 'ProcedureStart'
			,@AuditId		= @qc_audit_key
			,@UserId		= @UserId		--For application only
		--============================================================================================================
		
		/*************************************************************************************************************/
		/************************************** ACTIONS BEGIN ********************************************************/
		/*************************************************************************************************************/

		--Set back the controls:
		UPDATE _stg_xls_EmployeeData 
		SET QcStatusCode=(replicate('0',(150)))

			
			DECLARE @unicitycheckTable TABLE(
										PersonnelNumber NVARCHAR(500) NULL
			)
			DECLARE @position INT;
			---------------------- BLOCKING ERRORS -------------------------
			---------------------- Primary Key ----------------------
			INSERT INTO @unicitycheckTable 
				SELECT sourcetable.PersonnelNumber
				FROM _stg_xls_EmployeeData sourcetable
				WHERE 1=1
				GROUP BY sourcetable.PersonnelNumber
				HAVING COUNT(1)>1
				
			
			--The positions are in table tb_etl_referential_quality_control
			SET @position = 1
			UPDATE sourceTable
			SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'
			FROM _stg_xls_EmployeeData AS sourceTable
			INNER JOIN @unicitycheckTable checkTable
				ON sourceTable.PersonnelNumber = checkTable.PersonnelNumber
			WHERE 1=1
			AND NULLIF(sourceTable.PersonnelNumber,'') IS NOT NULL

			DELETE FROM @unicitycheckTable


			---------------------- PersonnelNumber null ----------------------
			SET @position = 2
			UPDATE sourceTable
			SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'
			FROM _stg_xls_EmployeeData AS sourceTable
			WHERE 1=1
			AND NULLIF(sourceTable.PersonnelNumber,'') IS NULL

			---------------------- Nom null ----------------------
			SET @position = 3
			UPDATE sourceTable
			SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'
			FROM _stg_xls_EmployeeData AS sourceTable
			WHERE 1=1
			AND NULLIF(sourceTable.Name,'') IS NULL


			---------------------- Prenom null ----------------------
			SET @position = 4
			UPDATE sourceTable
			SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'
			FROM _stg_xls_EmployeeData AS sourceTable
			WHERE 1=1
			AND NULLIF(sourceTable.FirstName,'') IS NULL

			---------------------- Mail null ----------------------
			SET @position = 5
			UPDATE sourceTable
			SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'
			FROM _stg_xls_EmployeeData AS sourceTable
			WHERE 1=1
			AND NULLIF(sourceTable.EMailAddress,'') IS NULL

			---------------------- matricle has more than 50 characters not accepted in py_payee ----------------------
			SET @position = 6
			UPDATE sourceTable
			SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'
			FROM _stg_xls_EmployeeData AS sourceTable
			WHERE 1=1
			AND LEN(ISNULL(sourceTable.PersonnelNumber,'')) > 50

			---------------------- Gender does not exists in referential ----------------------
			SET @position = 7
			UPDATE sourceTable
			SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'
			FROM _stg_xls_EmployeeData AS sourceTable
			LEFT JOIN _ref_Gender rg ON sourceTable.Gender = rg.GenderCode
			WHERE 1=1
			AND rg.GenderId IS NULL

			---------------------- Employee Class does not exists in referential ----------------------
			SET @position = 8
			UPDATE sourceTable
			SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + LEFT(RIGHT(QcStatusCode, @position),@position - 1) + '1'
			FROM _stg_xls_EmployeeData AS sourceTable
			LEFT JOIN _ref_EmployeeClass rec ON sourceTable.EmployeeClass = rec.EmployeeClassCode
			WHERE 1=1
			AND rec.EmployeeClassCode IS NULL


			---------------------- NON BLOCKING ERRORS ------------------------- 
			---------------------- Birthdate null ----------------------
			SET @position = 9
			UPDATE sourceTable
			SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + RIGHT(QcStatusCode, @position)
			FROM _stg_xls_EmployeeData AS sourceTable
			WHERE 1=1
			AND NULLIF(sourceTable.BirthDate,'') IS NULL 

			---------------------- EntryDate null ----------------------
			SET @position = 10
			UPDATE sourceTable
			SET QcStatusCode = LEFT(QcStatusCode, 150 - @position - 1) + '1' + RIGHT(QcStatusCode, @position)
			FROM _stg_xls_EmployeeData AS sourceTable
			WHERE 1=1
			AND NULLIF(sourceTable.EntryDate,'') IS NULL 
			--------------------------------------------------------------------


		--Delete previous logs
		TRUNCATE TABLE _stg_xls_EmployeeData_Error

				INSERT INTO @errorfound (ID)
		   SELECT stgEmployeeDataId FROM _stg_xls_EmployeeData
		   WHERE QcStatusCode LIKE '%1%'

		   DECLARE @ErrorMessage NVARCHAR(255) = NULL


		   SET @position = 1
		   UPDATE errorfound
		   SET Error = CONCAT(Error,'|','Duplicates')
		   FROM @errorfound AS errorfound
		   INNER JOIN _stg_xls_EmployeeData sourcetable
		   ON errorfound.ID = sourcetable.stgEmployeeDataId
		   where 1=1
		   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

		   SET @position = 2
		   UPDATE errorfound
		   SET Error = CONCAT(Error,'|','PersonnelNumber null')
		   FROM @errorfound AS errorfound
		   INNER JOIN _stg_xls_EmployeeData sourcetable
		   ON errorfound.ID = sourcetable.stgEmployeeDataId
		   where 1=1
		   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

		   SET @position = 3
		   UPDATE errorfound
		   SET Error = CONCAT(Error,'|','Name null')
		   FROM @errorfound AS errorfound
		   INNER JOIN _stg_xls_EmployeeData sourcetable
		   ON errorfound.ID = sourcetable.stgEmployeeDataId
		   where 1=1
		   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

		   SET @position = 4
		   UPDATE errorfound
		   SET Error = CONCAT(Error,'|','Firstname Null')
		   FROM @errorfound AS errorfound
		   INNER JOIN _stg_xls_EmployeeData sourcetable
		   ON errorfound.ID = sourcetable.stgEmployeeDataId
		   where 1=1
		   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

		   SET @position = 5
		   UPDATE errorfound
		   SET Error = CONCAT(Error,'|','Mail null')
		   FROM @errorfound AS errorfound
		   INNER JOIN _stg_xls_EmployeeData sourcetable
		   ON errorfound.ID = sourcetable.stgEmployeeDataId
		   where 1=1
		   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

		   SET @position = 6
		   UPDATE errorfound
		   SET Error = CONCAT(Error,'|','PersNumber > 50 char')
		   FROM @errorfound AS errorfound
		   INNER JOIN _stg_xls_EmployeeData sourcetable
		   ON errorfound.ID = sourcetable.stgEmployeeDataId
		   where 1=1
		   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

		   		   SET @position = 7
		   UPDATE errorfound
		   SET Error = CONCAT(Error,'|','Gender not in ref')
		   FROM @errorfound AS errorfound
		   INNER JOIN _stg_xls_EmployeeData sourcetable
		   ON errorfound.ID = sourcetable.stgEmployeeDataId
		   where 1=1
		   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

		   		   SET @position = 8
		   UPDATE errorfound
		   SET Error = CONCAT(Error,'|','Employee Class not in ref')
		   FROM @errorfound AS errorfound
		   INNER JOIN _stg_xls_EmployeeData sourcetable
		   ON errorfound.ID = sourcetable.stgEmployeeDataId
		   where 1=1
		   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)
		   
		   		   SET @position = 9
		   UPDATE errorfound
		   SET Error = CONCAT(Error,'|','Birthdate null')
		   FROM @errorfound AS errorfound
		   INNER JOIN _stg_xls_EmployeeData sourcetable
		   ON errorfound.ID = sourcetable.stgEmployeeDataId
		   where 1=1
		   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)


		   		   SET @position = 10
		   UPDATE errorfound
		   SET Error = CONCAT(Error,'|','Entrydate null')
		   FROM @errorfound AS errorfound
		   INNER JOIN _stg_xls_EmployeeData sourcetable
		   ON errorfound.ID = sourcetable.stgEmployeeDataId
		   where 1=1
		   AND 1 = RIGHT(LEFT(QcStatusCode, 150-@position),1)

		-- Insert errors into log table
		INSERT INTO _stg_xls_EmployeeData_Error (PersonnelNumber, Name, FirstName, BirthDate, Gender, EntryDate, LeavingDate, Adress, PostalCode, City, Canton, Country, EmployeeClass, EMailAddress, Infotext, ErrorMessage, ParentId)
		SELECT 
				   sourcetable.PersonnelNumber
				  ,sourcetable.Name
				  ,sourcetable.FirstName
				  ,sourcetable.BirthDate
				  ,sourcetable.Gender
				  ,sourcetable.EntryDate
				  ,sourcetable.LeavingDate
				  ,sourcetable.Adress
				  ,sourcetable.PostalCode
				  ,sourcetable.City
				  ,sourcetable.Canton
				  ,sourcetable.Country
				  ,sourcetable.EmployeeClass
				  ,sourcetable.EMailAddress
				  ,sourcetable.Infotext
				  --,sourcetable.AuditId
				  --,sourcetable.DateLoading
				  --,sourcetable.FileName
				  --,sourcetable.QcStatusCode
				  ,ef.Error
				  ,1 AS ParentId--sourcetable.ParentId
			FROM _stg_xls_EmployeeData sourcetable 
			INNER JOIN @errorfound ef ON sourcetable.stgEmployeeDataId = ef.ID
			WHERE RIGHT(sourcetable.QcStatusCode,1)='1'	




		/*************************************************************************************************************/
		/************************************** ACTIONS END **********************************************************/
		/*************************************************************************************************************/
		--============================================================================================================
		EXEC [sp_audit_log]
			 @Category		= @Category		--Events Hierarchy level 1
			,@Process		= @Process 		--Events Hierarchy level 2
			,@SubProcess	= @SubProcess 	--Events (Names of the stored procedures)
			,@StartDate		= @StartDate	--Start date to be used as a key (to know which records belong to each other)
			,@EventText		= 'ProcedureEnd'
			,@AuditId		= @qc_audit_key
			,@UserId		= @UserId			--For application only
		--============================================================================================================
	
	
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
		 @Category		= @Category		--Events Hierarchy level 1
		,@Process		= @Process 		--Events Hierarchy level 2
		,@SubProcess	= @SubProcess 	--Events (Names of the stored procedures)
		,@StartDate		= @StartDate	--Start date to be used as a key (to know which records belong to each other)
		,@EventText		= @EventText
		,@AuditId		= @qc_audit_key
		,@UserId		= @UserId		--For application only
		,@ErrorFlag		= @ErrorFlag
		,@ErrorText		= @ErrorText
		,@ErrorLine		= @ErrorLine


END CATCH
END