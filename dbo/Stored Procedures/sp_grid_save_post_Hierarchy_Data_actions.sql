
CREATE   PROCEDURE [dbo].[sp_grid_save_post_Hierarchy_Data_actions]  
 @UniqueKey NVARCHAR(max)
,@idUser INT
,@idProfile INT
,@primaryKey INT
AS
BEGIN
SET NOCOUNT ON;


DECLARE @ResultStatus BIT;
DECLARE @ResultMessage NVARCHAR(max) = ''

DECLARE @Category NVARCHAR(255) = 'Client';
DECLARE @Process NVARCHAR(255) = 'Hierarchy';
DECLARE @SubProcess NVARCHAR(255) = OBJECT_NAME(@@PROCID);
DECLARE @StartDate DATETIME = GETDATE();
DECLARE @qc_audit_key INT = -1;
DECLARE @UserId INT = @idUser
DECLARE @Txt NVARCHAR(255)
DECLARE @Anz INT


DECLARE @ActionId INT = ( SELECT ActionId FROM _stg_xls_HierarchyData_Action sxhda WHERE Id = @primaryKey)
DECLARE @TruncateSource INT = 1 
DECLARE @LoadFInal INT = 2 
DECLARE @Publish INT = 3


BEGIN TRY		
	--=================================================================


    SET @ResultStatus = 1
	SET @ResultMessage = 'Success Save Post'


	IF @ActionId = @TruncateSource
	BEGIN
				
				SET @Txt = 'Action requested: "Truncate source"'
				EXEC sp_audit_log @Category, @Process, @SubProcess, @StartDate, @Txt, @qc_audit_key, @UserId

				TRUNCATE TABLE _stg_xls_HierarchyData 
				TRUNCATE TABLE _stg_xls_HierarchyData_Error

				--Reset the action
				UPDATE _stg_xls_HierarchyData_Action
				SET ActionId = 0
					
	END

	ELSE IF @ActionId = @LoadFInal
	BEGIN
				SET @Txt = 'Action requested: "Load final"'

				EXEC sp_load_Hierarchy_Data_information_import_log @qc_audit_key, @UserId

				EXEC sp_load_Hierarchy_Data @qc_audit_key, @UserId

				--Reset the action
				UPDATE _stg_xls_HierarchyData_Action
				SET ActionId = 0

	END
	ELSE IF @ActionId = @Publish
	BEGIN
				SET @Txt = 'Action requested: "Publish Hierarchy"'

				EXEC sp_publish_Hierarchy @qc_audit_key, @UserId


				--Reset the action
				UPDATE _stg_xls_HierarchyData_Action
				SET ActionId = 0
		

	END
	ELSE 
	BEGIN
				SET @Txt = 'Action requested: "N/A"'
				--EXEC sp_audit_log @Category, @Process, @SubProcess, @StartDate, @Txt, @qc_audit_key, @UserId

				--Reset the action
				UPDATE _stg_xls_HierarchyData_Action
				SET ActionId = 0

	END


	--=================================================================
END TRY
BEGIN CATCH
    SET @ResultStatus = 0
	SET @ResultMessage = 'Fail Save Post'
END CATCH
SELECT @ResultStatus, @ResultMessage

END