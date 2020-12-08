




CREATE PROCEDURE [dbo].[sp_grid_add_pre_master_emp_org]
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

Parameters:      @UniqueKey NVARCHAR(max) =	internal temporary key
				,@idUser INT			  = user executing the action in the grid
				,@idProfile INT			  = profile of the user executing the action in the grid
				,@primaryKey INT		  = primary of the tb_crav_process table

Returns:        result message and result code

Description:    Pre add sp for tb_master_emp_org_info 

==========================================================================
  Date       Author      Change
---------------------------------------------
02.10.2019   M. Kulig	Creation
03.10.2019   A. BARRY   Modify (Start date must be after last end date) and Add (end date must be 01/01/2099)
18.10.2019	 M. Kulig	Corrected logic: 'End date must be 31/12/9999'
==========================================================================
*/

DECLARE @ResultStatus BIT;
DECLARE @ResultMessage NVARCHAR(max) = ''



BEGIN TRY

    SET @ResultStatus = 1
	SET @ResultMessage = 'Success Add Pre'

	--DECLARE @DocumentAdminPayeee INT = 
	--	(SELECT Column_Value
	--		FROM grid_data_temp_values
	--		WHERE Unique_Key = @UniqueKey
	--		AND PK_Id = @primaryKey
	--		AND Column_Name = 'DocumentType')
	DECLARE @startdate date = 
		(SELECT Column_Value
			FROM grid_data_temp_values
			WHERE Unique_Key = @UniqueKey
			AND PK_Id = @primaryKey
			AND Column_Name = 'EffectiveDate')
--SET @startdate = (SELECT CONVERT(varchar, @startdate, 1))
	DECLARE @enddate date = 
		(SELECT Column_Value
			FROM grid_data_temp_values
			WHERE Unique_Key = @UniqueKey
			AND PK_Id = @primaryKey
			AND Column_Name = 'EndDate')
			--SET @enddate = (SELECT CONVERT(varchar, @startdate, 1))

--SELECT * FROM py_Payee pp WHERE firstname = 'Jef'
	DECLARE @idpayee INT = (SELECT idpayee FROM _tb_employee_organization teo   WHERE teo.employeeOrganizationId = @primaryKey)

	--DECLARE @MaximunEndDate DATE =  (SELECT MAX(End_Date) FROM tb_master_emp_org_info WHERE idPayee =  @idpayee ) 
		--	SELECT * FROM tb_master_emp_org_info tmeoi



	--1. We can't create new record if start and end dates are not specified
	--IF ((SELECT @startdate) IS null OR (SELECT @enddate) IS null)
	IF ((SELECT @startdate) IS NULL)

	BEGIN 
		SET @ResultStatus = 0;
		SELECT @ResultMessage = 'Start date must be specified.'--'Start and end dates must be specified.'


	END
	-----2. Start date can not stacked
	IF exists (SELECT 1 FROM  _tb_employee_organization WHERE idPayee = @idpayee AND @startdate = EffectiveDate  ) 
	
	BEGIN 
		SET @ResultStatus = 0;
		SELECT @ResultMessage = 'the new start date is overlapping the previous period'


	END

	-----------End date must be 12-31-9999
	--IF @enddate <> '12/31/2099'
	--BEGIN 
	--	SET @ResultStatus = 0;
	--	SELECT @ResultMessage = 'End date must be 31/12/2099'


	--END

	--3. End date must be after start date
	--IF @startdate > @enddate
	--BEGIN 
	--	SET @ResultStatus = 0;
	--	SELECT @ResultMessage = 'Start date must be before end date'

	--	END 
--SELECT CONVERT(date,@t)
	--END

	--4. End date must be 12-31-9999

--IF @enddate <> '12/31/9999'
--	BEGIN 
--		SET @ResultStatus = 0;
--		SELECT @ResultMessage = 'End date must be 31/12/9999'


--	END
	----5. End date must be after last end date
	--5. Start date must be after last end date

	--IF @startdate <>  (SELECT CONVERT(varchar, DATEADD(d,1,@MaximunEndDate), 1)) 
	--BEGIN 
	--	SET @ResultStatus = 0;
	--	SELECT @ResultMessage = @idpayee   -- 'Start date of the new record must be defined one day after end date'


	--END


END TRY
BEGIN CATCH
    SET @ResultStatus = 0;
	SET @ResultMessage = 'Fail Add Pre';

END CATCH
SELECT @ResultStatus, @ResultMessage

END