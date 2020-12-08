CREATE PROCEDURE dbo.sp_client_delete_separate_grids
(
	@id_grid INT
	,@msg_return NVARCHAR(MAX) OUTPUT
)
/**
# ===============================================================
Description: |
    Delete grid with given id
Called by:
 - Developer
# ===============================================================
Changes:
 - Date: 2019-03-13
   Author: Sebastian Dziula
   Change: Creation
 - Date: 2019-03-19
   Author: Sebastian Dziula
   Change: Add delete from k_modules
# ===============================================================
**/
AS BEGIN
	SET NOCOUNT ON;
	DECLARE @Category NVARCHAR(255) = 'Global';
	DECLARE @Process NVARCHAR(255) = 'Grids Management';
	DECLARE @SubProcess NVARCHAR(255) = OBJECT_NAME(@@PROCID);
	DECLARE @StartDate DATETIME = GETDATE();
	DECLARE @qc_audit_key INT = -1
	DECLARE @idUser INT = -1
	DECLARE @LoggingStep NVARCHAR(500) = 'Start';
	
	BEGIN TRY
	BEGIN TRANSACTION @SubProcess;
		EXEC [sp_audit_log] @Category		= @Category			
							,@Process		= @Process			
							,@SubProcess	= @SubProcess		
							,@StartDate		= @StartDate		
							,@EventText		= @LoggingStep
							,@AuditId		= @qc_audit_key
							,@UserId		= @idUser
		SET @LoggingStep = ''
		IF EXISTS(SELECT * FROM k_referential_grids krg WHERE krg.id_grid = @id_grid)
		BEGIN
			/**** START Not supported deleton ****/
				IF EXISTS(SELECT * FROM ads_gridRelation WHERE idBase = @id_grid OR idRelated = @id_grid) SET @LoggingStep = CONCAT(@LoggingStep, 'id_grid in ads_gridRelation, ')
				IF EXISTS(SELECT * FROM cm_processgrid WHERE id_grid = @id_grid) SET @LoggingStep = CONCAT(@LoggingStep, 'id_grid in cm_processgrid, ')
				IF EXISTS(SELECT * FROM k_DynamicCombo WHERE idSourceGrid = @id_grid) SET @LoggingStep = CONCAT(@LoggingStep, 'id_grid in k_DynamicCombo, ')
				IF EXISTS(SELECT * FROM k_m_type_plan WHERE id_base_grid = @id_grid) SET @LoggingStep = CONCAT(@LoggingStep, 'id_grid in k_m_type_plan, ')
				IF EXISTS(SELECT * FROM k_program_cond_grids WHERE idGrid = @id_grid) SET @LoggingStep = CONCAT(@LoggingStep, 'id_grid in k_program_cond_grids, ')
				IF EXISTS(SELECT * FROM nc_DocuSignMapping ndsm INNER JOIN k_referential_grids_fields krgf ON ndsm.id_grid_field = krgf.id_column WHERE krgf.id_grid = @id_grid) SET @LoggingStep = CONCAT(@LoggingStep, 'id_grid_field in nc_DocuSignMapping, ')
			/**** END Not supported deleton ****/

			/**** START Delete grid ****/
				IF @LoggingStep = ''
				BEGIN
					DELETE FROM k_user_grid WHERE id_grid = @id_grid
			
					DELETE krgfvfi
					FROM k_referential_grid_field_validation_formula_items krgfvfi
					INNER JOIN k_referential_grid_field_validation krgfv ON krgfvfi.id_grid_field_validation = krgfv.id_grid_field_validation
					WHERE krgfv.id_grid = @id_grid

					DELETE FROM k_referential_grid_field_validation WHERE id_grid = @id_grid

					DELETE FROM k_referential_grid_import_histo WHERE id_grid = @id_grid
					DELETE FROM k_referential_grid_publish_histo WHERE id_user = @id_grid

					DELETE krgsta
					FROM k_referential_grid_security_tree_assignment krgsta
					INNER JOIN k_referential_grid_security_tree krgst ON krgsta.id_grid_security_tree = krgst.id_grid_security_tree
					WHERE krgst.id_grid = @id_grid

					DELETE FROM k_referential_grid_security_tree WHERE id_grid = @id_grid
			
					DELETE krgtfm
					FROM k_referential_grid_tab_field_mapping krgtfm
					INNER JOIN k_referential_grid_tab krgt ON krgtfm.id_grid_tab = krgt.id_grid_tab
					WHERE krgt.id_grid = @id_grid OR krgt.id_parent_grid = @id_grid
			
					DELETE FROM k_referential_grid_tab WHERE id_grid = @id_grid OR id_parent_grid = @id_grid

					DELETE krgfr
					FROM k_referential_grids_fields_relation krgfr
					INNER JOIN k_referential_grids_fields krgf ON krgfr.id_field_grid = krgf.id_column
					WHERE krgf.id_grid = @id_grid

					DELETE krgfr
					FROM k_referential_grids_fields_relation krgfr
					INNER JOIN k_referential_grids_fields krgf ON krgfr.id_field_grid_parent = krgf.id_column
					WHERE krgf.id_grid = @id_grid

					DELETE kugf
					FROM k_user_grid_field kugf
					INNER JOIN k_referential_grids_fields krgf ON kugf.id_grid_field = krgf.id_column
					WHERE krgf.id_grid = @id_grid

					DELETE kgcf
					FROM k_referentialGroupContentFilter kgcf
					INNER JOIN k_referentialGroupContent kgc ON kgcf.groupContentId = kgc.id
					INNER JOIN k_referentialGroup kg ON kgc.groupId = kg.id
					INNER JOIN k_referential_grids krg ON kg.masterGridId = krg.id_grid
					WHERE krg.id_grid = @id_grid

					DELETE kgc
					FROM k_referentialGroupContent kgc
					INNER JOIN k_referentialGroup kg ON kgc.groupId = kg.id
					INNER JOIN k_referential_grids krg ON kg.masterGridId = krg.id_grid
					WHERE krg.id_grid = @id_grid

					DELETE kg
					FROM k_referentialGroup kg
					INNER JOIN k_referential_grids krg ON kg.masterGridId = krg.id_grid
					WHERE krg.id_grid = @id_grid

					DELETE kpmr
					FROM k_profiles_modules_rights kpmr
					INNER JOIN k_modules_rights kmr ON kpmr.id_module_right = kmr.id_module_right
					INNER JOIN k_modules km ON kmr.id_module = km.id_module
					WHERE km.id_item = @id_grid AND km.id_tab = -6

					DELETE kmr
					FROM k_modules_rights kmr
					INNER JOIN k_modules km ON kmr.id_module = km.id_module
					WHERE km.id_item = @id_grid AND km.id_tab = -6

					DELETE km FROM k_modules km WHERE km.id_item = @id_grid AND km.id_tab = -6

					DELETE FROM k_referential_grids_fields WHERE id_grid = @id_grid
					DELETE FROM k_referential_grids WHERE id_grid = @id_grid
				END
				SET @LoggingStep = 'Successful deletion'
			/**** END Delete grid ****/
		END
		ELSE BEGIN
			SET @LoggingStep = 'No grid with given ID'
		END

		SET @msg_return = @LoggingStep
		EXEC [sp_audit_log] @Category		= @Category			
							,@Process		= @Process			
							,@SubProcess	= @SubProcess		
							,@StartDate		= @StartDate		
							,@EventText		= @LoggingStep
							,@AuditId		= @qc_audit_key
							,@UserId		= @idUser
	COMMIT TRANSACTION @SubProcess
	END TRY

	BEGIN CATCH
		DECLARE @ErrorFlag BIT = 1;
		DECLARE @EventText NVARCHAR(MAX) = @LoggingStep;
		DECLARE @ErrorText NVARCHAR(MAX) = ERROR_MESSAGE();
		DECLARE @ErrorLine INT = ERROR_LINE();
		DECLARE @xstate INT = XACT_STATE()

		SET @msg_return = @ErrorText

		IF @xstate != 0
			ROLLBACK TRANSACTION @SubProcess;

		EXEC [sp_audit_log] @Category		= @Category
						   ,@Process		= @Process
						   ,@SubProcess		= @SubProcess
						   ,@StartDate		= @StartDate
						   ,@EventText		= @EventText
						   ,@AuditId		= @qc_audit_key
						   ,@UserId			= @idUser
						   ,@ErrorFlag		= @ErrorFlag
						   ,@ErrorText		= @ErrorText
						   ,@ErrorLine		= @ErrorLine	
	END CATCH
END