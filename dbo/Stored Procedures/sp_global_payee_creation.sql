CREATE   PROCEDURE [dbo].[sp_global_payee_creation]
(@qc_audit_key INT,  @PayeeList PayeeCreationTableType READONLY)
AS
BEGIN
SET NOCOUNT ON;

DECLARE @Category NVARCHAR(255) = 'ETL';
DECLARE @Process NVARCHAR(255) = 'PayeeCreation';
DECLARE @SubProcess NVARCHAR(255) = OBJECT_NAME(@@PROCID);
DECLARE @StartDate DATETIME = GETDATE();
DECLARE @UserId INT = -1 --SuperAdmin
DECLARE @Txt NVARCHAR(255);
DECLARE @Anz INT;
DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20));


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

				;WITH _SOURCE AS (
						SELECT codePayee, email, lastname, firstname , 1 AS is_active 
						FROM @PayeeList
				)
				MERGE py_Payee AS TARGET
				USING _Source AS SOURCE ON TARGET.codePayee = SOURCE.codePayee	 

				----When records are not in the source, we delete the records
				--WHEN NOT MATCHED BY SOURCE 
				--THEN DELETE

				--When records do not match the target we insert the records
				WHEN NOT MATCHED BY TARGET 
				THEN INSERT (codePayee, email,lastname, firstname, is_active)
				VALUES (SOURCE.codePayee, SOURCE.email, SOURCE.lastname, SOURCE.firstname, SOURCE.is_active)
		
				--When records match, at least of the field has changed, we update
				WHEN MATCHED 
				AND (
					ISNULL(SOURCE.email,'') != ISNULL(TARGET.email,'')
					OR ISNULL(SOURCE.lastname,'') != ISNULL(TARGET.lastname,'')
					OR ISNULL(SOURCE.firstname,'') != ISNULL(TARGET.firstname,'')
					OR ISNULL(SOURCE.is_active,0) != ISNULL(TARGET.is_active,0)
				)

				THEN UPDATE SET email		= SOURCE.email,
								lastname	= SOURCE.lastname,
								firstname	= SOURCE.firstname,
								is_active	= SOURCE.is_active
					

				--Logs of merge (we need to remove this if the SP is to be called from the procedure execution grid)
				OUTPUT $action INTO @SummaryOfChanges;

				-------------Merge Log:
				INSERT INTO _tb_audit_log(Category, PROCESS, SubProcess, StartDate, EventText, EventDate, AuditId, UserId)
					SELECT 
						@Category, @Process, @SubProcess, @StartDate
					,Change+ ' in "py_Payee"  (' + CAST(COUNT(1) AS varchar(10)) + ' rows)' AS Txt
					,@StartDate, @qc_audit_key, @UserId
					FROM @SummaryOfChanges GROUP BY Change
				DELETE FROM @SummaryOfChanges				


				INSERT INTO py_PayeeHisto (start_date_histo, end_date_histo, idPayee, codePayee)
				SELECT kmp.start_date_plan, kmp.end_date_plan, pp.idPayee, pp.codepayee FROM py_Payee pp
				JOIN _tb_ProcessDefinition tpd ON tpd.IsActive = 1
				JOIN k_m_plans kmp ON tpd.id_plan = kmp.id_plan
				LEFT JOIN py_PayeeHisto pph ON pp.idPayee = pph.idPayee
				WHERE pph.idPayee IS NULL



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