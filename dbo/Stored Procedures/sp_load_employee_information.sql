CREATE    PROCEDURE [dbo].[sp_load_employee_information]
(@UserId INT = -1, @qc_audit_key INT =-1)
AS
BEGIN
SET NOCOUNT ON;


DECLARE @Category NVARCHAR(255) = 'Client';
DECLARE @Process NVARCHAR(255) = 'LoadFinalTable';
DECLARE @SubProcess NVARCHAR(255) = OBJECT_NAME(@@PROCID);
DECLARE @StartDate DATETIME = GETDATE();
--DECLARE @UserId INT = -1 --SuperAdmin
DECLARE @Txt NVARCHAR(255);
DECLARE @Anz INT;
DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20));

--SET @IsScrambleActive = (SELECT TOP 1 ParamValue FROM tb_global_parameters WHERE ParamCode='IsToScramble');
--IF @IsScrambleActive IS NULL SET @IsScrambleActive=0;


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


		----------------------------------------------------------------------
		--All data into temp
		IF(OBJECT_ID('tempdb..#AllData') IS NOT NULL) DROP TABLE #AllData
			SELECT A.idPayee 
				  ,A.PersonnelNumber
				  ,A.Name
				  ,A.FirstName
				  ,A.BirthDate
				  ,A.Gender
				  ,A.EntryDate
				  ,A.LeavingDate
				  ,A.Adress
				  ,A.PostalCode
				  ,A.City
				  ,A.Canton
				  ,A.Country
				  ,A.EmployeeClass
				  ,A.EMailAddress
				  ,A.Infotext
				  ,A.AuditId
				  ,A.DateLoading
				  ,A.FileName
			INTO #AllData
			FROM (
						--we take data from the manually imported data
						SELECT pp.idPayee 
							  ,sxed.PersonnelNumber
							  ,sxed.Name
							  ,sxed.FirstName
							  ,sxed.BirthDate
							  ,sxed.Gender
							  ,sxed.EntryDate
							  ,sxed.LeavingDate
							  ,sxed.Adress
							  ,sxed.PostalCode
							  ,sxed.City
							  ,sxed.Canton
							  ,sxed.Country
							  ,sxed.EmployeeClass
							  ,sxed.EMailAddress
							  ,sxed.Infotext
							  ,sxed.AuditId
							  ,sxed.DateLoading
							  ,sxed.FileName
							  ,sxed.QcStatusCode
						FROM _stg_xls_EmployeeData sxed
						JOIN py_Payee pp ON sxed.PersonnelNumber = pp.codePayee
						WHERE RIGHT(sxed.QcStatusCode,1)!='1'

			) A


		--Insert into duplicates:
		IF(OBJECT_ID('tempdb..#Duplicates') IS NOT NULL) DROP TABLE #Duplicates
			SELECT b.IdPayee,  b.PersonnelNumber INTO #Duplicates
			FROM #AllData  b
			GROUP BY b.idPayee, b.PersonnelNumber HAVING COUNT(1)>1



		--Get data avoiding duplicates
		IF(OBJECT_ID('tempdb..#FilteredData') IS NOT NULL) DROP TABLE #FilteredData
		SELECT * INTO #FilteredData 
		FROM (
					SELECT bigdata.idPayee 
						  ,bigdata.PersonnelNumber
						  ,bigdata.Name
						  ,bigdata.FirstName
						  ,CONVERT(DATETIME,bigdata.BirthDate,103) AS BirthDate
						  ,bigdata.Gender
						  ,CONVERT(DATETIME,bigdata.EntryDate,103) AS EntryDate
						  ,CONVERT(DATETIME,bigdata.LeavingDate,103) AS LeavingDate
						  ,bigdata.Adress
						  ,bigdata.PostalCode
						  ,bigdata.City
						  ,bigdata.Canton
						  ,bigdata.Country
						  ,bigdata.EmployeeClass
						  ,bigdata.EMailAddress
						  ,bigdata.Infotext
						  ,bigdata.AuditId
						  ,bigdata.DateLoading
						  ,bigdata.FileName
						  FROM #AllData bigdata
					--avoiding ducplicates
					WHERE NOT EXISTS(SELECT 1 FROM #Duplicates dup WHERE dup.idPayee = bigdata.idPayee)
		) A
	

			
			--SET IDENTITY_INSERT _tb_employee_information ON;  
 

			--Merge data _tb_employee_information
			MERGE _tb_employee_information AS TARGET
			USING #FilteredData AS SOURCE ON TARGET.idPayee = SOURCE.idPayee
									--AND TARGET.StartDate = SOURCE.StartDate	 
									--AND TARGET.EndDate = SOURCE.EndDate	 

			----When records are not in the source, we delete the records
			--WHEN NOT MATCHED BY SOURCE 
			--THEN DELETE

			--When records do not match the target we insert the records
			WHEN NOT MATCHED BY TARGET 
			THEN INSERT ([IdPayee]
						,[PersonnelNumber]
						,[Name]
						,[FirstName]
						,[BirthDate]
						,[Gender]
						,[EntryDate]
						,[LeavingDate]
						,[Adress]
						,[PostalCode]
						,[City]
						,[Canton]
						,[Country]
						,[EmployeeClass]
						,[EMailAddress]
						,[Infotext]
						,[id_user]
						,[CreatedDate]
						,[ModificationDate]
						,ParentId)
			VALUES (           
						SOURCE.[IdPayee]
					   ,SOURCE.[PersonnelNumber]
					   ,SOURCE.[Name]
					   ,SOURCE.[FirstName]
					   ,SOURCE.[BirthDate]
					   ,SOURCE.[Gender]
					   ,SOURCE.[EntryDate]
					   ,SOURCE.[LeavingDate]
					   ,SOURCE.[Adress]
					   ,SOURCE.[PostalCode]
					   ,SOURCE.[City]
					   ,SOURCE.[Canton]
					   ,SOURCE.[Country]
					   ,SOURCE.[EmployeeClass]
					   ,SOURCE.[EMailAddress]
					   ,SOURCE.[Infotext]
					   ,@UserId
					   ,GETDATE()
					   ,GETDATE()
					   ,1)
		
			--When records match, at least of the field has changed, we update
			WHEN MATCHED 
			--AND @IsScrambleActive = 0 --only when scramble is not active
			AND (  ISNULL(SOURCE.[Name],'') != ISNULL(TARGET.[Name],'')
				OR ISNULL(SOURCE.[FirstName],'') != ISNULL(TARGET.[FirstName],'')
				OR ISNULL(SOURCE.[BirthDate],'1900-01-01') != ISNULL(TARGET.[BirthDate],'1900-01-01')
				OR ISNULL(SOURCE.[Gender],'') != ISNULL(TARGET.[Gender],'')
				OR ISNULL(SOURCE.[EntryDate],'1900-01-01') != ISNULL(TARGET.[EntryDate],'1900-01-01')
				OR ISNULL(SOURCE.[LeavingDate],'9999-01-01') != ISNULL(TARGET.[LeavingDate],'9999-01-01')
				OR ISNULL(SOURCE.[Adress],'') != ISNULL(TARGET.[Adress],'')
				OR ISNULL(SOURCE.[PostalCode],'') != ISNULL(TARGET.[PostalCode],'')
				OR ISNULL(SOURCE.[City],'') != ISNULL(TARGET.[City],'')
				OR ISNULL(SOURCE.[Canton],'') != ISNULL(TARGET.[Canton],'')
				OR ISNULL(SOURCE.[Country],'') != ISNULL(TARGET.[Country],'')
				OR ISNULL(SOURCE.[EmployeeClass],'') != ISNULL(TARGET.[EmployeeClass],'')
				OR ISNULL(SOURCE.[EMailAddress],'') != ISNULL(TARGET.[EMailAddress],'')
				OR ISNULL(SOURCE.[Infotext],'') != ISNULL(TARGET.[Infotext],'')			 
				-- [AuditId], [DateLoading], [FileName]
				)
			

			THEN UPDATE SET 
				    [Name]=SOURCE.[Name]
				   ,[FirstName]=SOURCE.[FirstName]
				   ,[BirthDate]=SOURCE.[BirthDate]
				   ,[Gender]=SOURCE.[Gender]
				   ,[EntryDate]=SOURCE.[EntryDate]
				   ,[LeavingDate]=SOURCE.[LeavingDate]
				   ,[Adress]=SOURCE.[Adress]
				   ,[PostalCode]=SOURCE.[PostalCode]
				   ,[City]=SOURCE.[City]
				   ,[Canton]=SOURCE.[Canton]
				   ,[Country]=SOURCE.[Country]
				   ,[EmployeeClass]=SOURCE.[EmployeeClass]
				   ,[EMailAddress]=SOURCE.[EMailAddress]
				   ,[Infotext]=SOURCE.[Infotext]
				   ,[id_user]=@UserId
				   --,[CreatedDate]=
				   ,[ModificationDate]=GETDATE()
				   ,ParentId =1;
			
			 

			
       -- UPDATE POP
		DECLARE @idpop INT

		DECLARE pop_cursor CURSOR FOR 
		SELECT idpop FROM pop_Population pp

		OPEN pop_cursor  
		FETCH NEXT FROM pop_cursor INTO @idpop  

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
      
			  EXEC sp_global_refresh_population @idpop
			  --SELECT @idPop

			  FETCH NEXT FROM pop_cursor INTO @idpop 
		END 

		CLOSE pop_cursor  
		DEALLOCATE pop_cursor 

		-- Add to Process
		INSERT INTO k_m_plans_payees_steps (id_plan, id_assignment, id_payee, start_step, end_step, id_user_create, date_create_assignment, id_user_update, date_update_assignment, locked, frequency_index)
		SELECT kmp.id_plan, kmpa.id_affectation, pvc.idColl, kmp.start_date_plan, kmp.end_date_plan, -1, GETDATE(), NULL, NULL, 0, 1 FROM k_m_plans_affectations kmpa
		JOIN pop_Population pp ON pp.idPop = kmpa.id_assignee
		JOIN pop_VersionContent pvc ON pp.lastVersion = pvc.idPopVersion
		JOIN k_m_plans kmp ON kmp.id_plan = kmpa.id_plan
		LEFT JOIN k_m_plans_payees_steps kmpps ON kmpa.id_plan = kmpps.id_plan AND pvc.idColl = kmpps.id_payee
		WHERE type_affectation = 'P'
		AND kmpps.id_step IS NULL





		--Delete temp tables
		IF(OBJECT_ID('tempdb..#AllData') IS NOT NULL) DROP TABLE #AllData
		IF(OBJECT_ID('tempdb..#Duplicates') IS NOT NULL) DROP TABLE #Duplicates
		IF(OBJECT_ID('tempdb..#FilteredData') IS NOT NULL) DROP TABLE #FilteredData



		SET @Txt = 'Succès'
		--Updating the status in the procedure execution table



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
	DECLARE @EventText NVARCHAR(MAX) = 'Erreur';
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