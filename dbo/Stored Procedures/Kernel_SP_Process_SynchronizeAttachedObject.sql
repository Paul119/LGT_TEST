
CREATE PROCEDURE Kernel_SP_Process_SynchronizeAttachedObject
AS

BEGIN TRY
BEGIN TRANSACTION;

DECLARE @EmptyGuid NVARCHAR(MAX) = '00000000-0000-0000-0000-000000000000';
DECLARE @ProcessAttachmentForManager NVARCHAR(MAX)  = '73D5BCB9-FA21-436D-8582-6A4FFB33E179';
DECLARE @ProcessAttachmentForEmployee NVARCHAR(MAX)  = 'B7E5C3AF-8B11-4CCF-8952-E556FE596A3B';
DECLARE @ObjectTypeReport NVARCHAR(MAX)  = '1960A35E-9E2F-4A2B-A6F5-C476D9D10628';
DECLARE @ObjectTypePlan NVARCHAR(MAX)  = '8707ECB1-C14E-41D1-9413-D01BD297CAF6';
DECLARE @ObjectStatusActive NVARCHAR(MAX)  = 'BC203FBB-02BA-4BA0-BA85-C47F82667BD7';
DECLARE @DatasourceTypePlan NVARCHAR(MAX)  = '2BFB5EC3-451E-47C1-8084-715934729926';
DECLARE @DatasourceStatusActive NVARCHAR(MAX)  = 'BC203FBB-02BA-4BA0-BA85-C47F82667BD7';
DECLARE @ObjectAccessRoleView NVARCHAR(MAX) = 'CF42837A-B509-4542-8FEC-08AE7DBA42C3';
DECLARE @ObjectAccessRoleManage NVARCHAR(MAX) = 'BC203FBB-02BA-4BA0-BA85-C47F82667BD7';
DECLARE @ReportOwnerUid UNIQUEIDENTIFIER;

-- Delete Object Relation
MERGE  obj.bqm_object_relation relation
   USING obj.bqm_object objt
      ON relation.uid_object_related = objt.uid_object
	     AND uid_object_type = @ObjectTypeReport
         AND relation.uid_relation_type IN(@ProcessAttachmentForManager, @ProcessAttachmentForEmployee)
WHEN MATCHED THEN DELETE;

-- Cursor k_m_plans_form_report Table
DECLARE @PlanId INT
DECLARE @ReportId INT
DECLARE @Name NVARCHAR(MAX)
DECLARE @NamePlan NVARCHAR(MAX)
DECLARE @PlanFormReportType INT
DECLARE @SortOrder INT
DECLARE @PlanFormReportId INT
 
DECLARE ReportObjectCursor CURSOR LOCAL FOR
SELECT  pfr.id, pfr.id_plan, pfr.id_report, pfr.name_form, pfr.id_plan_form_report_type, pfr.sort_order , p.name_plan
FROM dbo.k_m_plans_form_report pfr
INNER JOIN dbo.k_m_plans p ON p.id_plan = pfr.id_plan 
WHERE pfr.id_plan_form_report_type IN(-1,-2) -- Manager And Emplyee Report
 AND p.id_plan_layout_type = -1 -- Grid Type
 
OPEN ReportObjectCursor
FETCH NEXT FROM ReportObjectCursor INTO @PlanFormReportId, @PlanId, @ReportId, @Name, @PlanFormReportType, @SortOrder, @NamePlan
 
WHILE(@@FETCH_STATUS = 0)
BEGIN

DECLARE @UidTenant UNIQUEIDENTIFIER;
SET @UidTenant = (SELECT TOP(1) uidTenant FROM dbo.app_tenantInfo);

DECLARE @PlanUid UNIQUEIDENTIFIER;
SET @PlanUid = (SELECT uid_object FROM dbo.k_m_plans WHERE id_plan = @PlanId);


	-- Datasource And Plan
	IF NOT EXISTS(SELECT * FROM obj.bqm_object WHERE uid_object = @PlanUid AND uid_object_type = @ObjectTypePlan)
	BEGIN

		DECLARE @PlanOwnerUid UNIQUEIDENTIFIER;
		SET @PlanOwnerUid = ISNULL((SELECT uid_user FROM dbo.k_users WHERE id_user = (SELECT id_owner FROM dbo.k_m_plans WHERE id_plan = @PlanId)), @EmptyGuid);
		
		-- Datasource
		DECLARE @DatasourceExtendedConfiguration NVARCHAR(MAX);
		SET @DatasourceExtendedConfiguration = '[{"key":"plan_id","value":' + CAST(@PlanId as varchar(10)) + '}]';
		DECLARE @DatasourceUid UNIQUEIDENTIFIER;
		SET  @DatasourceUid = NEWID(); 

		INSERT INTO ds.bqm_datasource 
			VALUES(@DatasourceUid , @UidTenant, @NamePlan, 'Rednimbus', @DatasourceTypePlan, @DatasourceStatusActive, @DatasourceExtendedConfiguration, NULL, 0, 0, NULL, @PlanOwnerUid, GETUTCDATE(), @PlanOwnerUid, GETUTCDATE(), 0) 
		

		-- Datasource Attribute
		-- Cursor
		DECLARE @IndicatorName NVARCHAR(MAX);
		DECLARE @IndicatorId INT;
		DECLARE @FieldId INT;
		DECLARE @FieldFormatType INT;
		DECLARE @DecimalPrecision INT;
		DECLARE @IdIndicatorUserCreate INT;
		
		DECLARE IndicatorFieldCursor  CURSOR LOCAL FOR

		SELECT kmi.name_ind, kmi.id_ind, kmf.id_field, kmf.type_value, kmf.decimal_precision, kmi.id_owner FROM k_m_plans_indicators kmpi 
			JOIN k_m_indicators_fields kmif ON kmif.id_ind = kmpi.id_ind 
			JOIN k_m_indicators kmi ON kmi.id_ind = kmif.id_ind 
			JOIN k_m_fields kmf ON kmf.id_field = kmif.id_field 
		WHERE kmpi.id_plan = @PlanId
		
		OPEN IndicatorFieldCursor
		FETCH NEXT FROM IndicatorFieldCursor INTO @IndicatorName, @IndicatorId, @FieldId, @FieldFormatType, @DecimalPrecision, @IdIndicatorUserCreate

		WHILE(@@FETCH_STATUS = 0)
		BEGIN
		
		DECLARE @Alias NVARCHAR(MAX);
		SET @Alias = 'F' + CAST(@IndicatorId as varchar(10)) + '_' + CAST(@FieldId as varchar(10)); 

		DECLARE @AttributeType NVARCHAR(MAX);
		DECLARE @MaxLength INT = 0;
		DECLARE @Scale INT = 0;

		IF @FieldFormatType = 1
		BEGIN 
			SET @MaxLength = 4000;
			SET @AttributeType = '0CE2F7DF-D52D-4A2C-8E65-8B5EB5EE2480' -- nvarchar
		END
		ELSE IF @FieldFormatType = 2
		BEGIN
			SET @Scale = 18;
			SET @AttributeType = 'B0695B05-11A4-471F-A5E8-C4961EC66B41' -- numeric
		END
		ELSE IF @FieldFormatType = 3
		BEGIN
			SET @AttributeType = '984836B3-B944-43C8-9C8F-D27E00656C1D' -- datetime
		END
		ELSE IF @FieldFormatType = 4
		BEGIN
			SET @Scale = 12;
			SET @AttributeType = 'EFB1691D-6E84-45B7-B6EF-A713C106BED0' -- int
		END

		DECLARE @IsMandatory BIT = 0;

		DECLARE @IndicatorOwnerUid UNIQUEIDENTIFIER;
		SET @IndicatorOwnerUid = ISNULL((SELECT uid_user FROM dbo.k_users WHERE id_user = @IdIndicatorUserCreate), @EmptyGuid);

		INSERT INTO ds.bqm_datasource_attribute
			VALUES(NEWID() , @UidTenant, @IndicatorName, @Alias, @IndicatorName, @AttributeType, @DatasourceStatusActive, @DatasourceUid, @MaxLength, @DecimalPrecision, @Scale, @IsMandatory, @IndicatorOwnerUid, GETUTCDATE(), @IndicatorOwnerUid, GETUTCDATE(), 0) 


		FETCH NEXT FROM IndicatorFieldCursor INTO @IndicatorName, @IndicatorId, @FieldId, @FieldFormatType, @DecimalPrecision, @IdIndicatorUserCreate
		END
		
		CLOSE IndicatorFieldCursor
		DEALLOCATE IndicatorFieldCursor



		-- Plan
		DECLARE @ExtendedConfigurationPlan NVARCHAR(MAX);
		SET @ExtendedConfigurationPlan = '[{"key":"id_main_datasource","value":' + CAST(@DatasourceUid as varchar(50)) + '}' + ',{"key":"plan_id","value":' + CAST(@PlanId as varchar(10)) + '}' + ']';
		INSERT INTO obj.bqm_object 
			VALUES(@PlanUid, @UidTenant, @NamePlan, 'Rednimbus', @ObjectTypePlan, @ObjectStatusActive, @ExtendedConfigurationPlan, NULL, @PlanOwnerUid, GETUTCDATE(), @PlanOwnerUid, GETUTCDATE(), 0)

	END


	-- Report
    DECLARE @ReportObjectUid UNIQUEIDENTIFIER; 

    DECLARE @ExtendedConfigurationReport NVARCHAR(MAX);
	SET @ExtendedConfigurationReport = '{"key":"idReport","value":' + CAST(@ReportId as varchar(10)) + '}';

    IF NOT EXISTS(SELECT * FROM obj.bqm_object WHERE extended_configuration LIKE '%' + @ExtendedConfigurationReport + '%' AND uid_object_type = @ObjectTypeReport)
    BEGIN

	    SET @ReportObjectUid = NEWID();
		SET @ExtendedConfigurationReport = '[' + @ExtendedConfigurationReport + ']'

		SET @ReportOwnerUid = ISNULL((SELECT uid_user FROM dbo.k_users WHERE id_user = (SELECT id_owner FROM dbo.k_reports WHERE id_report = @ReportId)),@EmptyGuid);
    	INSERT INTO obj.bqm_object 
			VALUES(@ReportObjectUid , @UidTenant, @Name, 'Rednimbus', @ObjectTypeReport, @ObjectStatusActive, @ExtendedConfigurationReport, NULL, @ReportOwnerUid, GETUTCDATE(), @ReportOwnerUid, GETUTCDATE(), 0) 

    END
	ELSE
	BEGIN
		SET @ReportObjectUid = (SELECT TOP(1) uid_object FROM obj.bqm_object WHERE extended_configuration LIKE '%' + @ExtendedConfigurationReport + '%' AND uid_object_type = @ObjectTypeReport)
	END


	-- Object Relation
	DECLARE @RelationTypeUid NVARCHAR(MAX);
	SET @RelationTypeUid = (CASE WHEN @PlanFormReportType = -1 THEN @ProcessAttachmentForEmployee ELSE @ProcessAttachmentForManager END);

	DECLARE @MaxSortOrder INT;
	SET @MaxSortOrder = ISNULL((SELECT TOP(1) sort_order FROM obj.bqm_object_relation ORDER BY sort_order DESC),0)

    INSERT INTO obj.bqm_object_relation 
		VALUES(NEWID() , @UidTenant, @Name, 'Rednimbus', @RelationTypeUid, @PlanUid, @SortOrder + @MaxSortOrder + 1, @ReportObjectUid, @EmptyGuid, GETUTCDATE(), @EmptyGuid, GETUTCDATE(), 0)



	-- Cursor k_m_plan_display_tab Table
DECLARE @ProfileUid UNIQUEIDENTIFIER

DECLARE DisplayTabCursor  CURSOR LOCAL FOR
	SELECT kp.uid_profile
	FROM dbo.k_m_plan_display_tab displaytab
	INNER JOIN dbo.k_m_plan_display display ON displaytab.id_plan_display = display.id_plan_display
	INNER JOIN dbo.k_profiles kp ON kp.id_profile = display.id_profile
	WHERE display.id_plan = @PlanId
		AND id_plan_form_report = @PlanFormReportId
 
OPEN DisplayTabCursor
FETCH NEXT FROM DisplayTabCursor INTO @ProfileUid
 
WHILE(@@FETCH_STATUS = 0)
BEGIN

    IF NOT EXISTS(SELECT * FROM obj.bqm_object_access WHERE uid_object = @ReportObjectUid AND uid_object_access_role = @ObjectAccessRoleView AND uid_profile = @ProfileUid)
    BEGIN
		SET @ReportOwnerUid = ISNULL((SELECT uid_user FROM dbo.k_users WHERE id_user = (SELECT id_owner FROM dbo.k_reports WHERE id_report = @ReportId)),@EmptyGuid);
		INSERT INTO [obj].[bqm_object_access]
			VALUES(NEWID(), @UidTenant, @Name, 'Rednimbus', @ObjectStatusActive, @ReportObjectUid, NULL, @ProfileUid, @ObjectAccessRoleView, 
			CONVERT(DATETIME, -53690), CAST('12/31/9999 23:59:59' AS DATETIME), @ReportOwnerUid, GETUTCDATE(), @ReportOwnerUid, GETUTCDATE(), 0 )
	END

	FETCH NEXT FROM DisplayTabCursor INTO @ProfileUid
END
 
CLOSE DisplayTabCursor
DEALLOCATE DisplayTabCursor



	FETCH NEXT FROM ReportObjectCursor INTO @PlanFormReportId, @PlanId, @ReportId, @Name, @PlanFormReportType, @SortOrder, @NamePlan
END
 
CLOSE ReportObjectCursor
DEALLOCATE ReportObjectCursor

COMMIT TRANSACTION; 

END TRY
BEGIN CATCH 

       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;
	       PRINT 'GET ERRORS DETAILS OR THROW ERROR'
	       SELECT ERROR_MESSAGE() AS ErrorMessage;

END CATCH;