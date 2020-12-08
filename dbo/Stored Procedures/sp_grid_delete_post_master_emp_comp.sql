﻿
CREATE PROCEDURE [dbo].[sp_grid_delete_post_master_emp_comp]
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

--DECLARE @idpayee INT = (SELECT idpayee FROM _tb_employee_compensation WHERE employeecompensationId = @primaryKey)


--DECLARE @employeeGUID NVARCHAR(50) = (SELECT codepayee FROM py_Payee pp WHERE pp.idPayee = @idpayee)
--DECLARE @startdate date = (SELECT AwardDate FROM _tb_employee_compensation WHERE employeecompensationId = @primaryKey)
--DECLARE @MaximunEndDate DATE =  (SELECT MAX(EndDate) FROM _tb_employee_compensation WHERE idPayee =  @idpayee AND employeecompensationId != @primaryKey) 



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

	--we update the values of the newly inserted line
	--UPDATE _tb_employee_compensation
	--SET PersonnelNumber = @employeeGUID
	--WHERE employeecompensationId = @primaryKey

			;WITH cte AS (
	SELECT PersonnelNumber, PayrollType, AwardDate, Lead(DATEADD("day",-1,AwardDate),1,'01-01-2999') over (PARTITION BY PersonnelNumber, PayrollType order by AwardDate) AS EndDate
	FROM _tb_employee_compensation
	--WHERE IdPayee = @IdPayee
	)

	UPDATE f
	SET f.EndDate = c.EndDate
	FROM _tb_employee_compensation f
	JOIN  cte c ON f.PersonnelNumber = c.PersonnelNumber AND f.PayrollType = c.PayrollType AND f.AwardDate = c.AwardDate
	--WHERE IdPayee = @IdPayee 

	/**************************************************/


	
END TRY
BEGIN CATCH
    SET @ResultStatus = 0
	SET @ResultMessage = 'Fail Delete Post'
END CATCH
SELECT @ResultStatus, @ResultMessage
END