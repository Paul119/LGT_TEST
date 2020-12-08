CREATE PROCEDURE [dbo].[sp_grid_delete_post_Job_title]  
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
DECLARE @Process NVARCHAR(255) = 'Employee Import';
DECLARE @SubProcess NVARCHAR(255) = OBJECT_NAME(@@PROCID);
DECLARE @StartDate DATETIME = GETDATE();
DECLARE @qc_audit_key INT = -1;
DECLARE @UserId INT = -1
DECLARE @Txt NVARCHAR(255)
DECLARE @Anz INT

BEGIN TRY		
	--=================================================================


    SET @ResultStatus = 1
	SET @ResultMessage = 'Success Add Post'


;WITH cte_source AS (
	SELECT 
		id_field, 
		JobTitleDescription AS label, 
		JobTitleCode AS value,
		-3 as culture
	FROM k_m_fields kmf
	CROSS JOIN _ref_JobTitle
	WHERE kmf.code_field LIKE 'CRP-LGT-NewTitle'
)

MERGE k_m_fields_values AS TARGET
USING cte_source AS SOURCE  ON (TARGET.id_field	= SOURCE.id_field)
							AND	(TARGET.label	= SOURCE.label)
--When records not in target we insert 
WHEN NOT MATCHED BY TARGET
THEN INSERT (id_field, label, value, culture)
VALUES (SOURCE.id_field, SOURCE.label, SOURCE.value, SOURCE.culture)

WHEN NOT MATCHED BY SOURCE
THEN DELETE
;

END TRY
BEGIN CATCH
    SET @ResultStatus = 0
	SET @ResultMessage = 'Fail Add Post'
END CATCH
SELECT @ResultStatus, @ResultMessage

END