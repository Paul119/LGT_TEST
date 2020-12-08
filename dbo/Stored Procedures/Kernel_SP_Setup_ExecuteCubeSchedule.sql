
-- Alter [Kernel_SP_Setup_ExecuteCubeSchedule] SP for V2
CREATE PROCEDURE [dbo].[Kernel_SP_Setup_ExecuteCubeSchedule]
	-- Add the parameters for the stored procedure here
@id_plan int,
@id_ind int,
@id_field int,

@link_field NVARCHAR(MAX),
@type_value nvarchar(max) = N'',
@start_step datetime,
@end_step datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	delete from k_m_values
	where id_ind=@id_ind and id_field=@id_field
	and id_step in 
	(select id_step from k_m_plans_payees_steps pps where
	id_plan=@id_plan and 
pps.start_step = @start_step and pps.end_step = @end_step)
	DECLARE @cast_value nvarchar(max)
	DECLARE @cast_column nvarchar(max)
	DECLARE @SQL NVARCHAR(MAX)
	SELECT @cast_value = 
		CASE @type_value 
			WHEN 'numeric' then 'CAST(input_value_cube AS numeric(18,4))'
			WHEN 'int' then 'CAST(CAST(input_value_cube AS numeric(18,0)) AS int)'
			END	
	SELECT @cast_column = 
		CASE @type_value 
			WHEN 'numeric' then 'input_value_numeric'
			WHEN 'int' then 'input_value_int'
			END	
    -- Insert statements for procedure here
		SET @SQL = N'
	insert into k_m_values(id_step,  id_ind, id_field, input_value, input_date, id_user, source_value'
	IF (@cast_column != '')
	SET @SQL=@SQL+','+@cast_column
	SET @SQL=@SQL+')';

	SET @SQL = @SQL + N'
select pc.id_step, id_ind, id_field, kvc.input_value_cube, getutcdate(), -1 as id_user, kvc.source_value'
	IF (@cast_column != '')
	SET @SQL=@SQL+','+@cast_value

	SET @SQL = @SQL + N'
	from k_m_plans_payees_steps as pc
	inner join py_payeeHisto as kch on pc.id_payee = kch.idPayee
	AND (kch.start_date_histo <= pc.end_step and kch.end_date_histo > pc.end_step )
	inner join k_m_values_cube kvc on kvc.id_perimeter = kch.' + @link_field + ' and kvc.id_step = pc.id_step
	inner join k_m_plans p on p.id_plan = pc.id_plan	
	where pc.id_plan = @id_plan
	and id_ind = @id_ind
	and id_field = @id_field
	and pc.start_step = @start_step and pc.end_step = @end_step'

	--SELECT @SQL

	EXECUTE sp_executesql @SQL, N'@id_plan int,@id_ind int,@id_field int,@start_step datetime,@end_step datetime', @id_plan,@id_ind,@id_field,@start_step,@end_step
END