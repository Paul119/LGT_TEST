


CREATE   PROCEDURE [dbo].[sp_global_user_creation]
(@qc_audit_key INT)
AS
BEGIN
SET NOCOUNT ON;

DECLARE @Category NVARCHAR(255) = 'ETL';
DECLARE @Process NVARCHAR(255) = 'UserCreation';
DECLARE @SubProcess NVARCHAR(255) = OBJECT_NAME(@@PROCID);
DECLARE @StartDate DATETIME = GETDATE();
DECLARE @UserId INT = -1 --SuperAdmin
DECLARE @Txt NVARCHAR(255);
DECLARE @Anz INT;
DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20));


DECLARE @idPayee int ;
DECLARE @codePayee nvarchar(max) ;
DECLARE @firstname nvarchar(max) ;
DECLARE @lastname nvarchar(max);
DECLARE @email nvarchar(max);

DECLARE @profileId INT = (SELECT TOP 1 id_profile FROM k_profiles where name_profile='Employee')
DECLARE @parameterId INT
DECLARE @id_user INT

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

		-- Check, if User Generation is active (e.g. not on pre-prod)
		--IF (	SELECT TOP 1 ParamValue 
		--		FROM tb_global_parameters 
		--		WHERE ParamType = 'UserManagement' 
		--		AND ParamCode = 'IsUserGenerationActive' ) = '1'
		--BEGIN
		
		
		-- Run a cursor to create all new users
		------------------------------------------------------------------------------------
		SELECT @Anz = COUNT(*) 
		FROM py_Payee pp 
		WHERE NOT EXISTS(SELECT 1 FROM k_users u WHERE U.id_external_user = pp.idPayee)

		SET @Txt = 'Number of Users to create: ' + CAST(@Anz AS varchar(10)) 
		EXEC sp_audit_log @Category, @Process, @SubProcess, @StartDate, @Txt, @qc_audit_key, @UserId



		DECLARE Payee_Cursor CURSOR FOR
		SELECT pp.idPayee, pp.codePayee, pp.lastname, pp.firstname, pp.email
		FROM py_Payee pp 
		WHERE 1=1
		AND NOT EXISTS(SELECT 1 FROM k_users u WHERE U.id_external_user = pp.idPayee)


		OPEN Payee_Cursor
		FETCH NEXT FROM Payee_Cursor Into @idPayee, @codePayee, @lastname, @firstname, @email
		WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO k_users_parameters (
					defaultProfileId,
					cultureParamsUsed,
					thousandSeparator,
					decimalSeparator,
					datetimeFormat,
					[dateFormat],
					hideUserPanelAlways,
					numberOfDaysBoxItems,
					dynamicNotification,
					autoLoadLastSelectedProcess,
					autoLoadCurrentPeriod,
					culture,
					defaultTree,
					messagePosition,
					cultureUsedInReports)
				VALUES (
					@profileId, --defaultProfileId
					1, --cultureParamsUsed
					'.',--thousandSeparator
					',',--decimalSeparator
					'd/m/y H:i:s',--datetimeFormat
					'd/m/y',--[dateFormat]
					0,--hideUserPanelAlways
					30,--numberOfDaysBoxItems
					1,--dynamicNotification change 27.11.2017
					1, --autoLoadLastSelectedProcess change 27.11.2017
					1, --autoLoadCurrentPeriod change 27.11.2017
					'en-US',--culture
					0,--defaultTree
					'br',--messagePosition
					0--cultureUsedInReports
					)
				SELECT @parameterId = SCOPE_IDENTITY() FROM k_users_parameters
			
				INSERT INTO k_users (  
					id_external_user,
					firstname_user,
					lastname_user,
					login_user,
					password_user,
					isadmin_user,
					date_created_user,
					date_modified_user,
					culture_user,
					stylesheet_user,
					active_user,
					mail_user,
					id_owner,
					id_user_parameter,
					date_modified_password)
				VALUES (
					@idPayee,
					@Firstname,
					@Lastname,
					@Email,
					N'u5dgr1Z22bTMmpgZwVXnCg==',   -- not used but mandatory
					0,
					GetDate(),
					GetDate(),
					'fr-FR',
					-1,
					1,
					@Email,
					-1,
					@parameterId,
					GetDate())
				SELECT @id_user =  SCOPE_IDENTITY() FROM k_users
			
				INSERT INTO dbo.k_users_profiles (id_user, id_profile)
				VALUES (@id_user, @profileId)


				SET @Txt = 'New UserId ' + CAST(@id_user AS varchar(10)) + ' created for idPayee ' + CAST(@idPayee AS varchar(10))
				EXEC sp_audit_log @Category, @Process, @SubProcess, @StartDate, @Txt, @qc_audit_key, @UserId

				FETCH NEXT FROM Payee_Cursor Into @idPayee, @codePayee, @lastname, @firstname, @email
			END
		CLOSE Payee_Cursor
		DEALLOCATE Payee_Cursor
		--END
		--ELSE
		--EXEC sp_audit_log @Category, @Process, @SubProcess, @StartDate, 'User Generation deactivated', @qc_audit_key, @UserId






		-- changing email logic
		--------------------------------------------------------------
		--Logic: some employees change their email
		--as the email is the key for the SSO login, we need to update it in passport, otherwise their new email is not able to log in in beqom
		--But, as we cannot update passport, we will set the ExternalSSO null so a new passport account is created with the new email
		UPDATE u SET idExternalSSO=NULL, login_user=pp.Email, mail_user=pp.Email
		FROM py_Payee pp
		INNER JOIN k_users u ON pp.idPayee = u.id_external_user
		WHERE pp.Email!= u.login_user --the email has changed

			SET @Anz = @@rowcount
			SET @Txt = 'k_users.idExternalSSO set to NULL and login_user updated for payees with new emails (' + CAST(@Anz AS varchar(10)) + ' rows)'
			EXEC sp_audit_log @Category, @Process, @SubProcess, @StartDate, @Txt, @qc_audit_key, @UserId



		 --Deleting the duplicates SSO 
		 UPDATE u
		 SET idExternalSSO='--'
		 FROM k_users u 
		 INNER JOIN py_Payee pp ON pp.idPayee = u.id_external_user
		 WHERE u.idExternalSSO IN (
			 SELECT idExternalSSO FROM k_users GROUP BY idExternalSSO HAVING COUNT(1)>1
		 )

			SET @Anz = @@rowcount
			SET @Txt = 'k_users.idExternalSSO set to "--" for duplicated SSOs (' + CAST(@Anz AS varchar(10)) + ' rows)'
			EXEC sp_audit_log @Category, @Process, @SubProcess, @StartDate, @Txt, @qc_audit_key, @UserId


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