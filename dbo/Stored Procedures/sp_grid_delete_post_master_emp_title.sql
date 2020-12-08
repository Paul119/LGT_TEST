





CREATE PROCEDURE [dbo].[sp_grid_delete_post_master_emp_title]
 @UniqueKey NVARCHAR(max)
,@idUser INT
,@idProfile INT
,@primaryKey INT
AS
BEGIN
SET NOCOUNT ON;
/*   
==========================================================================
Called by:		tb_master_emp_org_info

Parameters:      
				 @UniqueKey NVARCHAR(max) =	internal temporary key
				,@idUser INT			  = user executing the action in the grid
				,@idProfile INT			  = profile of the user executing the action in the grid
				,@primaryKey INT		  = primary of the table

Returns:        result message and result code

Description:    Post save 

==========================================================================
  Date       Author      Change
---------------------------------------------
02/10/2019   M. Kulig    Creation
==========================================================================
*/

DECLARE @ResultStatus BIT;
DECLARE @ResultMessage NVARCHAR(max) = '';



--DECLARE @IsPublishFlagChanged INT = 0;

--DECLARE @idpayee INT = (SELECT idpayee FROM _tb_employee_Title tet WHERE tet.employeeTitleId = @primaryKey)

--DECLARE @employeeGUID NVARCHAR(50) = (SELECT codepayee FROM py_Payee pp WHERE pp.idPayee = @idpayee)
--DECLARE @startdate date = (SELECT EffectiveDate FROM _tb_employee_Title WHERE employeeTitleId = @primaryKey)
--DECLARE @MaximunEndDate DATE =  (SELECT MAX(EndDate) FROM _tb_employee_Title WHERE idPayee =  @idpayee AND employeeTitleId != @primaryKey) 



BEGIN TRY

	--=================================================================

    SET @ResultStatus = 1
	SET @ResultMessage = 'Success Delete Post'
	--=================================================================
	--BEGIN

	--IF @startdate <>  (SELECT CONVERT(varchar, DATEADD(d,1,@MaximunEndDate), 1)) 
	--BEGIN 
	--	SET @ResultStatus = 0;
	--	SELECT @ResultMessage = 'Start date of the new situation must be defined one day after end date of the previous situation.'   -- 'Start date of the new record must be defined one day after end date'


	--END
	--END 

	----we update the values of the newly inserted line
	--UPDATE _tb_employee_Title
	--SET PersonnelNumber = @employeeGUID
	--WHERE employeeTitleId = @primaryKey

			;WITH cte AS (
	SELECT PersonnelNumber, EffectiveDate, Lead(DATEADD("day",-1,EffectiveDate),1,'01-01-2999') over (PARTITION BY PersonnelNumber order by EffectiveDate) AS EndDate
	FROM _tb_employee_Title
	--WHERE IdPayee = @IdPayee
	)

	UPDATE f
	SET f.EndDate = c.EndDate
	FROM _tb_employee_Title f
	JOIN  cte c ON f.PersonnelNumber = c.PersonnelNumber AND f.EffectiveDate = c.EffectiveDate
	--WHERE IdPayee = @IdPayee 


	

	/**************************************************/
	DECLARE @id_field INT = (SELECT kmf.id_field FROM k_m_fields kmf WHERE kmf.name_field = 'New Title')

	DELETE FROM k_m_fields_values WHERE id_field = @id_field --AND id_payee = @idpayee

	INSERT INTO k_m_fields_values (id_field, label, value, culture, id_source_tenant, id_source, id_change_set, id_payee, start_date, end_date)
	SELECT DISTINCT @id_field, rjt2.JobTitleDescription, rjt2.JobTitleCode,-3,NULL,NULL,NULL, vcpt.IdPayee, NULL/*kmp1.start_date*/, NULL/*kmp1.end_date*/ FROM _vw_CRP_Process_Template vcpt
	JOIN _ref_JobTitle rjt ON vcpt.CurrentTitleCode = rjt.JobTitleCode
	JOIN _ref_JobTitle rjt2 ON (rjt2.Ranking = rjt.Ranking AND rjt.JobTitleCode <> rjt2.JobTitleCode) OR rjt2.Ranking = rjt.Ranking+1
	JOIN k_m_plans kmp ON vcpt.id_plan = kmp.id_plan
	JOIN k_m_period kmp1 ON kmp.id_period = kmp1.id_period
	--WHERE vcpt.IdPayee = @idpayee


	
END TRY
BEGIN CATCH
    SET @ResultStatus = 0
	SET @ResultMessage = 'Fail Delete Post'
END CATCH
SELECT @ResultStatus, @ResultMessage
END