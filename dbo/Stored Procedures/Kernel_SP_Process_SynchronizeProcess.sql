
CREATE PROCEDURE Kernel_SP_Process_SynchronizeProcess
AS

BEGIN TRY
BEGIN TRANSACTION;

DECLARE @EmptyGuid NVARCHAR(MAX) = '00000000-0000-0000-0000-000000000000';
DECLARE @ObjectTypeReport NVARCHAR(MAX)  = '1960A35E-9E2F-4A2B-A6F5-C476D9D10628';
DECLARE @ObjectTypePlan NVARCHAR(MAX)  = '8707ECB1-C14E-41D1-9413-D01BD297CAF6';
DECLARE @ObjectStatusActive NVARCHAR(MAX)  = 'BC203FBB-02BA-4BA0-BA85-C47F82667BD7';
DECLARE @DatasourceTypePlan NVARCHAR(MAX)  = '2BFB5EC3-451E-47C1-8084-715934729926';
DECLARE @DatasourceStatusActive NVARCHAR(MAX)  = 'BC203FBB-02BA-4BA0-BA85-C47F82667BD7';
DECLARE @ObjectAccessRoleView NVARCHAR(MAX) = 'CF42837A-B509-4542-8FEC-08AE7DBA42C3';
DECLARE @ObjectAccessRoleManage NVARCHAR(MAX) = 'BC203FBB-02BA-4BA0-BA85-C47F82667BD7';

-- Cursor k_m_plans_form_report Table
DECLARE @PlanId INT, @COUNTER INT = 0
DECLARE @NamePlan NVARCHAR(MAX)
DECLARE @PlanUid NVARCHAR(MAX)
DECLARE @UidTenant UNIQUEIDENTIFIER;
SET @UidTenant = (SELECT TOP(1) uidTenant FROM dbo.app_tenantInfo);
		
DECLARE ProcessCursor CURSOR LOCAL FOR
SELECT  p.id_plan, p.name_plan, uid_object
FROM dbo.k_m_plans p
WHERE 1 = 1
 AND p.id_plan_layout_type = -1 -- Grid Type
 
OPEN ProcessCursor
FETCH NEXT FROM ProcessCursor INTO @PlanId, @NamePlan, @PlanUid
 
WHILE(@@FETCH_STATUS = 0)
BEGIN

	IF NOT EXISTS(SELECT * FROM obj.bqm_object WHERE uid_object = @PlanUid AND uid_object_type = @ObjectTypePlan)
	BEGIN
		SET @COUNTER = @COUNTER + 1;

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

	FETCH NEXT FROM ProcessCursor INTO @PlanId, @NamePlan, @PlanUid
END
CLOSE ProcessCursor
DEALLOCATE ProcessCursor

 SELECT @COUNTER;

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