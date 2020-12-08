CREATE PROCEDURE [dbo].[Kernel_SP_Grid_DML]
(
	@Table_Name			nvarchar(255),
	@UniqueKey			varchar(50),
	@id_sim				int,
	@culture			nchar(5),
	@idGrid				int,
	@isTemplateExcel	bit,
	@IdGridTab			int = NULL,
	@SelectedRowId		nvarchar(255) = NULL,
	@idUser             int,
	@idProfile          int,
	@WhereCriteria      nvarchar(max),
	@EnableSecurityColumn nvarchar(max),
	@NotifyAfter		int = 500
)
AS

-----------***************************************-----------
--This sp is using update, delete, insert data for grids and excel offline which is related grids and tables.
--------------------------------------------------------Parameters
--@Table_Name		: Related table with grid.
--@UniqueKey		: Added data key on grid_data_temp_values.
--@id_sim			: Simulation id.
--@culture			: The logon user culture.
--@idGrid			: Grid id.
--@isTemplateExcel	: Import excel sheet with only column headers
--@IdGridTab		: When importing a child grid, tab id to identify parent grid
--@SelectedRowId    : the selected row in the parent grid
--@idUser           : Active user id
--@idProfile        : Active profile id
--@WhereCriteria    : Object AND Hierarchy Security Where Criteria
--@EnableSecurityColumn:Grid column table name which is set enabled_security_row as true

DECLARE @IsBatch BIT;

DECLARE @SpAddPre NVARCHAR(255) = N''
DECLARE @SpAddPost NVARCHAR(255) = N''
DECLARE @SpSavePre NVARCHAR(255) = N''
DECLARE @SpSavePost NVARCHAR(255) = N''
DECLARE @SpDeletePre NVARCHAR(255) = N''
DECLARE @SpDeletePost NVARCHAR(255) = N''

DECLARE @SpAddPreGridDataCount INT = 0
DECLARE @SpSavePreGridDataCount INT = 0 
DECLARE @SpDeletePreGridDataCount INT = 0

DECLARE @SpAddPreResult BIT = 1
DECLARE @SpAddPreResultMessage NVARCHAR(MAX) = N''
DECLARE @SpSavePreResult BIT = 1
DECLARE @SpSavePreResultMessage NVARCHAR(MAX) = N''
DECLARE @SpDeletePreResult BIT = 1
DECLARE @SpDeletePreResultMessage NVARCHAR(MAX) = N''

DECLARE @SpAddPostResult BIT = 1
DECLARE @SpAddPostResultMessage NVARCHAR(MAX) = N''
DECLARE @SpSavePostResult BIT = 1
DECLARE @SpSavePostResultMessage NVARCHAR(MAX) = N''
DECLARE @SpDeletePostResult BIT = 1
DECLARE @SpDeletePostResultMessage NVARCHAR(MAX) = N''

DECLARE @SimulatedId INT
DECLARE @PK_ColumnAndTypes NVARCHAR(255) = N''
DECLARE @PK_Column NVARCHAR(MAX)=N''
DECLARE @ColumnsAndTypes NVARCHAR(MAX)=N''
DECLARE @ColumnsAndTypesForTemp2 NVARCHAR(MAX)=N''
DECLARE @ColumnsAndTypesForStagingTemp NVARCHAR(MAX)=N''
DECLARE @Columns NVARCHAR(MAX)=N''
DECLARE @ColumnsWithNullCheck NVARCHAR(MAX)=N''
DECLARE @ColumnsForMerge NVARCHAR(MAX)=N''
DECLARE @ColumnsForInsert NVARCHAR(MAX)=N''
DECLARE @SQL NVARCHAR(MAX) = N''
DECLARE @MergedColumns nvarchar(max) =N''
DECLARE @MergedColumnsForTemp2 nvarchar(max) =N''
DECLARE @ColumnsWithNullCheckWithAs NVARCHAR(MAX)=N''
DECLARE @StagingColumns NVARCHAR(MAX)=N''
DECLARE @StagingNvarcharColumns NVARCHAR(MAX)=N''


--APPLY OBJECT SECURITY
DECLARE @TotalCount INT = 0;
DECLARE @AcceptedCount INT = 0;
DECLARE @RejectedCount INT = 0;
DECLARE @RejectedCountToObjectSecurity INT;
DECLARE @TempDeleteScriptForSecurity  NVARCHAR(MAX)=N'';
DECLARE @Temp2DeleteScriptForSecurity  NVARCHAR(MAX)=N'';
DECLARE @TempStagingDeleteScriptForSecurity  NVARCHAR(MAX)=N'';
DECLARE @insertErrorRecordForSecurity  NVARCHAR(MAX)=N'';
DECLARE @ErrorCode INT = 0;
DECLARE @ErrorMessage  NVARCHAR(MAX)=N'';

--PrimaryKey For Pre-Post Sp

Declare @primaryKey INT = 0;



--Set @isBatch 
select @IsBatch = KRG.is_bulk_insert from k_referential_grids KRG where KRG.id_grid = @idGrid

-- Get PK Column
SELECT 
	@PK_Column = [PKColumn], 
	@PK_ColumnAndTypes = [PKColumnAndType]
FROM GetTablePK(@Table_Name)

--Creating temp tables 
if object_id(N'tempdb..#Temp') is not null
	drop table #Temp

create table #Temp
(
	C229313B5B83E4DDEADE3C11680AA4F5F int identity(1,1) primary key,
	IsApplied bit default(0)
)

if object_id(N'tempdb..#Temp2') is not null
	drop table #Temp2

create table #Temp2
(
	C229313B5B83E4DDEADE3C11680AA4F5F int identity(1,1) primary key,
	IsApplied bit default(0)
)

--Creating temp > grid_data_temp_result tables 
if object_id(N'tempdb..#TempGridDataResult') is not null
	drop table #TempGridDataResult

create table #TempGridDataResult
(
  C229313B5B83E4DDEADE3C11680AA4F5F INT IDENTITY(1,1) PRIMARY KEY,
  unique_key VARCHAR(50) COLLATE DATABASE_DEFAULT,
  pk_id NVARCHAR(MAX) COLLATE DATABASE_DEFAULT,
  is_bulk BIT,
  number_of_records INT,
  number_of_rejected INT,
  number_of_applied INT,
  custom_error_message NVARCHAR(MAX) COLLATE DATABASE_DEFAULT,
  sql_error_code INT,
  process_type VARCHAR(3) COLLATE DATABASE_DEFAULT,
)

IF @IdGridTab IS NOT NULL AND @SelectedRowId IS NOT NULL
BEGIN
	-- Fetch the linked column values from the parent grid
	-- For update it is only needed for visible columns (to make sure you do not overwrite the value)
	-- For add both visible and hidden must be taken from parent.
	-- Adding it to grid_data_temp_values so the PRE SPs can access it too.
	DECLARE @ParentPK NVARCHAR(MAX)
	DECLARE @ParentPKType NVARCHAR(MAX)
	DECLARE @ParentTable NVARCHAR(MAX)

	SELECT @ParentTable = [TV].[name_table_view] FROM
		[k_referential_grid_tab] [GT]
		INNER JOIN [k_referential_grids] [G] ON [GT].[id_parent_grid] = [G].[id_grid]
		INNER JOIN [k_referential_tables_views] [TV] ON [G].[id_table_view] = [TV].[id_table_view]
		WHERE [GT].[id_grid_tab] = @IdGridTab

	SELECT 
		@ParentPK = [PKColumn], 
		@ParentPKType = [PKColumnAndType]
	FROM GetTablePK(@ParentTable)

	DECLARE @ColumnMap NVARCHAR(MAX)
	DECLARE @ColumnList NVARCHAR(MAX)

	SELECT 
		@ColumnMap = COALESCE(@ColumnMap + ', ', '') + 'CAST([' + P.name_field + '] AS NVARCHAR(MAX)) AS [' + C.name_field + ']',
		@ColumnList = COALESCE(@ColumnList + ', ', '') + '[' + C.name_field + ']'
	FROM k_referential_grid_tab_field_mapping AS M
		INNER JOIN k_referential_tables_views_fields AS P ON M.id_parent_table_view_field = P.id_field
		INNER JOIN k_referential_tables_views_fields AS C ON M.id_table_view_field = C.id_field
	WHERE M.id_grid_tab = @IdGridTab	
		
	DECLARE @ParentValuesOverrideQuery NVARCHAR(MAX) = '
		MERGE INTO [grid_data_temp_values] T
		USING (SELECT A.[PK_id], A.[Process_Type], B.*, C.[Field_Id] FROM
			(SELECT DISTINCT [PK_id], [Process_Type] FROM [grid_data_temp_values] WHERE [Process_Type] IN(''UPD'', ''ADD'') AND Unique_Key = ''' + @UniqueKey + ''') AS A,
			(SELECT * FROM
				(SELECT ' + @ColumnMap + ' FROM [' + @ParentTable + '] WHERE [' + @ParentPK + '] = ''' + @SelectedRowId + ''') AS CS
				UNPIVOT 
				(
					[Column_value] FOR [Column_name] IN (' + @ColumnList + ')
				) AS U) AS B
				INNER JOIN (
					SELECT C.[name_field] AS [FName], C.[id_field] AS [Field_Id] FROM k_referential_grid_tab_field_mapping AS M
						INNER JOIN k_referential_tables_views_fields AS C ON M.[id_table_view_field] = C.[id_field]
					WHERE M.[id_grid_tab] = ' + CAST(@IdGridTab AS NVARCHAR(MAX)) + '
			) AS C ON B.[Column_name] = C.[FName]) AS V
			ON T.[PK_id] = V.[PK_id] AND T.[Column_Name] = V.[Column_name] AND T.[Unique_Key] = ''' + @UniqueKey + '''
			WHEN MATCHED THEN UPDATE SET T.[Column_Value] = V.[Column_value]
			WHEN NOT MATCHED BY TARGET AND V.[Process_Type] = ''ADD'' THEN
				INSERT ([Unique_Key], [PK_Id], [Column_Name], [Column_Value], [Field_Id], [Process_Type]) 
				VALUES (''' + @UniqueKey + ''', PK_Id, [Column_Name], [Column_Value], [Field_Id], ''ADD'');'

	EXECUTE sp_executesql @ParentValuesOverrideQuery;
END

--Generate necessary params
;with ComputedExpressionForFields
as
(
select 
		krtvf.[id_field], krtvf.[id_table_view], krtvf.[name_field], krtvf.[type_field], krtvf.[length_field], krtvf.[constraint_null_field]
		,krtvf.[constraint_field], krtvf.[order_field], krtvf.[encrypt_field], krtvf.[is_unique], krtvf.[is_localizable], krtvf.[is_key_field]
		,krtvf.[is_display_field], krtvf.[is_computed], krtvf.[has_default_value]
		,type_field_with_length = case when krtvf.type_field IN(N'binary',N'char',N'datetimeoffset',N'nchar',N'nvarchar',N'time',N'varbinary',N'varchar') 
										then krtvf.type_field + case when length_field is null then N'' 
																	 when length_field = -1 then N'(MAX)' 
																	 else N'(' + replace(convert(nvarchar,ISNULL(krtvf.length_field,N'')),'.',',') + N')' end
                                       when krtvf.type_field IN(N'decimal',N'numeric') 
										then krtvf.type_field + case when [precision] is null then N'(' + replace(convert(nvarchar,ISNULL(krtvf.length_field,N'')),'.',',') + N')'
																	 else N'(' + convert(nvarchar,krtvf.[precision])+','+convert(nvarchar,krtvf.scale) + N')' end

	                             else replace(krtvf.type_field,'.',',') 
								end
		,type_field_with_length_withCollation =case when krtvf.type_field IN(N'binary',N'char',N'datetimeoffset',N'nchar',N'nvarchar',N'time',N'varbinary',N'varchar') 
									             	 then krtvf.type_field  +  case when length_field is null then N'' 
																	 when length_field = -1 then N'(MAX)' 
																	 else N'(' + replace(convert(nvarchar,ISNULL(krtvf.length_field,N'')),'.',',') + N')' end + case when krtvf.type_field IN(N'char',N'nchar',N'nvarchar',N'varchar') then ' COLLATE DATABASE_DEFAULT ' else '' end

                                                    when krtvf.type_field IN(N'decimal',N'numeric') 
									                 then krtvf.type_field  +  case when [precision] is null then N'(' + replace(convert(nvarchar,ISNULL(krtvf.length_field,N'')),'.',',') + N')'
																	else N'(' + convert(nvarchar,krtvf.[precision])+','+convert(nvarchar,krtvf.scale) + N')' end 
									          else replace(krtvf.type_field,'.',',') 
								              end
		,default_value_definition = case when ISNULL(krtvf.has_default_value, 0) = 1
										 then N' default(' + krtvf.default_value_definition + N')'
										 else N''
									 end
  from k_referential_tables_views_fields krtvf 
	inner join k_referential_tables_views krtv on krtv.id_table_view=krtvf.id_table_view 
 where krtv.name_table_view = @Table_Name
   and krtvf.name_field <> @PK_Column
)
select 
		@ColumnsAndTypes = @ColumnsAndTypes + ' ,[' +  ce.name_field + '] ' + ce.type_field_with_length_withCollation + ce.default_value_definition,
		@ColumnsAndTypesForTemp2 = @ColumnsAndTypesForTemp2 + ' ,[' +  ce.name_field + '] NVARCHAR(MAX) COLLATE DATABASE_DEFAULT',
		@ColumnsForInsert=@ColumnsForInsert + ' ,' + case when ce.name_field='idSim' then '0 as idSim' else '[' + ce.name_field + ']' end,
		@Columns = @Columns + ' , [' + ce.name_field +']',
		@ColumnsWithNullCheck = @ColumnsWithNullCheck + ' , ' + CASE WHEN ce.name_field IN ('idSim','idOrg','typeModification') THEN +'[' + ce.name_field + ']' ELSE 'CONVERT(' + type_field_with_length + ',' + 'NULLIF([' + ce.name_field + '],''_null_''))' END ,
		@ColumnsWithNullCheckWithAs = @ColumnsWithNullCheckWithAs + ' , ' + CASE WHEN ce.name_field IN ('idSim','idOrg','typeModification') THEN +'[' + ce.name_field + ']' ELSE 'CONVERT(' + type_field_with_length + ',' + 'NULLIF([' + ce.name_field + '],''_null_'')) AS ['+ ce.name_field + ']' END ,
		@ColumnsForMerge=@ColumnsForMerge + ' , source.[' + ce.name_field +']',
		@MergedColumns = @MergedColumns + ' , ISNULL(PT.['+ ce.name_field + '], MT.['+ ce.name_field + ']) AS ['+ ce.name_field + ']',
		@MergedColumnsForTemp2 = @MergedColumnsForTemp2 + CASE WHEN ce.type_field='xml' THEN ' ,ISNULL(CAST(PT.['+ ce.name_field + '] AS nVARCHAR(max)) ,CAST(MT.['+ ce.name_field + '] AS nVARCHAR(max))) AS ['+ ce.name_field + ']'
		ELSE ' , ISNULL(PT.['+ ce.name_field + '], MT.['+ ce.name_field + ']) AS ['+ ce.name_field + ']' END,
		@StagingNvarcharColumns = @StagingNvarcharColumns + ' ,[' +  ce.name_field + '_nvarchar' + '] NVARCHAR(MAX) COLLATE DATABASE_DEFAULT',
		@StagingColumns = @StagingColumns + ' , [' + ce.name_field +']'+ ' , [' + ce.name_field + '_nvarchar' +']'
  from ComputedExpressionForFields ce

--Remove first character
SET @ColumnsAndTypes=stuff(@ColumnsAndTypes, charindex(',', @ColumnsAndTypes, 0), 1, '')
SET @ColumnsForInsert=stuff(@ColumnsForInsert, charindex(',', @ColumnsForInsert, 0), 1, '')
SET @Columns=stuff(@Columns, charindex(',', @Columns, 0), 1, '')
SET @ColumnsWithNullCheck=stuff(@ColumnsWithNullCheck, charindex(',', @ColumnsWithNullCheck, 0), 1, '')
SET @ColumnsAndTypesForTemp2=stuff(@ColumnsAndTypesForTemp2, charindex(',', @ColumnsAndTypesForTemp2, 0), 1, '')
set @ColumnsForMerge=stuff(@ColumnsForMerge,charindex(',',@ColumnsForMerge,0),1,'')
SET @MergedColumns=stuff(@MergedColumns,charindex(',',@MergedColumns,0),1,'')
SET @MergedColumnsForTemp2=stuff(@MergedColumnsForTemp2,charindex(',',@MergedColumnsForTemp2,0),1,'')
SET @ColumnsWithNullCheckWithAs=stuff(@ColumnsWithNullCheckWithAs, charindex(',', @ColumnsWithNullCheckWithAs, 0), 1, '')
SET @StagingNvarcharColumns=stuff(@StagingNvarcharColumns, charindex(',', @StagingNvarcharColumns, 0), 1, '')
SET @StagingColumns=stuff(@StagingColumns, charindex(',', @StagingColumns, 0), 1, '')

declare @ForTempColumnsAndTypes nvarchar(max)
SET @ForTempColumnsAndTypes = @PK_ColumnAndTypes + @ColumnsAndTypes
SET @ColumnsAndTypesForStagingTemp = @ColumnsAndTypes + ',' + @StagingNvarcharColumns
SET @ColumnsAndTypesForTemp2 = @PK_ColumnAndTypes + @ColumnsAndTypesForTemp2

--Alter temp tables with table columns
declare @TableAlterScript nvarchar(max) = N'ALTER TABLE #Temp ADD Process_Type CHAR(3) COLLATE DATABASE_DEFAULT,' + REPLACE(@ForTempColumnsAndTypes,N'varchar(-1)',N'varchar(max)')
execute sp_executesql @TableAlterScript

SET @TableAlterScript = N'ALTER TABLE #Temp2 ADD Process_Type CHAR(3) COLLATE DATABASE_DEFAULT,' + @ColumnsAndTypesForTemp2
execute sp_executesql @TableAlterScript


--Set pivot on TableType
SET @SQL = @SQL + '
insert into #Temp(' + @PK_Column + N',Process_Type,' + @Columns + N')
  SELECT PK_Id,Process_Type,' + @MergedColumns + ' FROM
  (
select PK_Id,Process_Type,' + @ColumnsWithNullCheckWithAs + '
  from (
		select PK_Id,Process_Type,Column_Name,Column_Value
		  from grid_data_temp_values
		 where Unique_Key = @unqKey
	   ) src
 pivot
 (
	min(src.Column_Value)
	for Column_Name in (' + @Columns + ')
 ) pvt) PT
   LEFT JOIN '+@Table_Name+' MT
  	ON PT.PK_Id = MT.'+@PK_Column + ' AND PT.Process_Type <> ''ADD'' 
  WHERE 1=1 '

DECLARE @SQL2 NVARCHAR(MAX)  =''
SET @SQL2 = @SQL2 + '
insert into #Temp2(' + @PK_Column + N',Process_Type,' + @Columns + N')
 select PK_Id,Process_Type,' + @MergedColumnsForTemp2 + ' from
  (
select PK_Id,Process_Type,' + @Columns + '
  from (
		select PK_Id,Process_Type,Column_Name,Column_Value
		  from grid_data_temp_values
		 where Unique_Key = @unqKey
	   ) src
 pivot
 (
	min(src.Column_Value)
	for Column_Name in (' + @Columns + ')
 ) pvt ) PT
   left join '+@Table_Name+' MT
  	on PT.PK_Id = MT.' + @PK_Column + ' and PT.Process_Type <> ''ADD'' 
  where 1=1 '
 IF @isTemplateExcel <> 1
 BEGIN
   declare @ParmDefinition nvarchar(500)
   set @ParmDefinition = N'@unqKey varchar(50)'
   execute sp_executesql @SQL,@ParmDefinition,@unqKey = @UniqueKey
   execute sp_executesql @SQL2,@ParmDefinition,@unqKey = @UniqueKey

   set @TotalCount = (select count(*) From #Temp)
   --Insert record therefore object security into TempGridDataResult
   if @EnableSecurityColumn !=''
   BEGIN		
   set @insertErrorRecordForSecurity =  
   N'insert into #TempGridDataResult
   select @uniqueKey, '+ @PK_Column + ', @isBatch, @totalCount, 0, 0, NULL, 10011, Process_Type  from #Temp  
   where C229313B5B83E4DDEADE3C11680AA4F5F not in (select C229313B5B83E4DDEADE3C11680AA4F5F from #Temp as MAINTABLE 
   LEFT JOIN ' +@Table_Name+ ' gridTable ON MAINTABLE.'+@PK_Column+ '  = gridTable.'+ @PK_Column + '
   where ' + @WhereCriteria + ' AND (gridTable.'+@EnableSecurityColumn+ ' = ''False'' OR MAINTABLE.Process_Type =''ADD''))' --10011 : Access denied.
   END
   ELSE
   BEGIN
   set @insertErrorRecordForSecurity = 
   N'insert into #TempGridDataResult
   select @uniqueKey, '+ @PK_Column + ', @isBatch, @totalCount, 0, 0, NULL, 10011, Process_Type  from #Temp  
   where C229313B5B83E4DDEADE3C11680AA4F5F not in (select C229313B5B83E4DDEADE3C11680AA4F5F from #Temp as MAINTABLE 
   where ' + @WhereCriteria + ')' --10011 : Access denied.
   END
   declare @PrmsResult nvarchar(max) = N'@uniqueKey varchar(50), @isBatch bit, @totalCount int'
   execute sp_executesql @insertErrorRecordForSecurity, @PrmsResult, @uniqueKey = @UniqueKey, @isBatch = @IsBatch, @totalCount = @TotalCount 

   --Delete dont match record with object security
   IF @EnableSecurityColumn !=''
   BEGIN	
   set @TempDeleteScriptForSecurity = 
   N'delete #Temp where C229313B5B83E4DDEADE3C11680AA4F5F not in 
           (select C229313B5B83E4DDEADE3C11680AA4F5F from #Temp as MAINTABLE 
		   LEFT JOIN ' +@Table_Name+ ' gridTable ON MAINTABLE.'+@PK_Column+ '  = gridTable.'+ @PK_Column + '
           where ' + @WhereCriteria + ' AND (gridTable.'+@EnableSecurityColumn+ ' = ''False'' OR MAINTABLE.Process_Type =''ADD''))'
   set @Temp2DeleteScriptForSecurity = 
   N'delete #Temp2 where C229313B5B83E4DDEADE3C11680AA4F5F not in 
           (select C229313B5B83E4DDEADE3C11680AA4F5F from #Temp2 as MAINTABLE  LEFT JOIN ' +@Table_Name+ ' gridTable ON MAINTABLE.'+@PK_Column+ '  = gridTable.'+ @PK_Column + '
           where ' + @WhereCriteria + ' AND (gridTable.'+@EnableSecurityColumn+ ' = ''False'' OR MAINTABLE.Process_Type =''ADD''))' 
	END
	ELSE
	BEGIN
	set @TempDeleteScriptForSecurity = 
    N'delete #Temp where C229313B5B83E4DDEADE3C11680AA4F5F not in 
           (select C229313B5B83E4DDEADE3C11680AA4F5F from #Temp as MAINTABLE where ' + @WhereCriteria + ')'
	set @Temp2DeleteScriptForSecurity = 
    N'delete #Temp2 where C229313B5B83E4DDEADE3C11680AA4F5F not in 
    (select C229313B5B83E4DDEADE3C11680AA4F5F from #Temp2 as MAINTABLE where ' + @WhereCriteria + ')' 
	END

   execute sp_executesql @TempDeleteScriptForSecurity
   execute sp_executesql @Temp2DeleteScriptForSecurity
   
   set @RejectedCountToObjectSecurity = @TotalCount - (select count(*) from #Temp);
 END




----if default exists
--update #Temp set 
--(defalut col) = DEFAULT WHERE (defalut col) IS NULL

DECLARE @UpdSql VARCHAR(8000)  
SELECT  @UpdSql = COALESCE(@updSql, '') + 'UPDATE #Temp SET [' + name_field + '] = DEFAULT WHERE [' + name_field + '] IS NULL AND (Process_Type =''ADD'' and IsApplied=0)' 
FROM k_referential_tables_views_fields krf 
inner  join k_referential_tables_views krtv on krf.id_table_view=krtv.id_table_view
where  krf.has_default_value=1 and krtv.name_table_view = @Table_Name --AND constraint_null_field=0

execute (@UpdSql)



--Generate necessary params
declare @updateQueryColumns nvarchar(max)=N''
declare @updateQueryColumnsNotSim nvarchar(max)=N''
declare @updateQueryAllColumns nvarchar(max)=N''
declare @allColumns nvarchar(max)=N''
declare @allColumnsWithTemp nvarchar(max)=N''
declare @UpdateForMerge nvarchar(max)=N''
select 
		@updateQueryColumns=@updateQueryColumns + ', t.['+tvc.name_field + '] = CASE WHEN t2.[' + tvc.name_field  + '] = ''_null_'' THEN NULL ELSE isnull(t.[' + tvc.name_field + '], s.[' +tvc.name_field + ']) END',   
		@UpdateForMerge=@UpdateForMerge + ', target.['+tvc.name_field + '] = source.['+tvc.name_field+']',
		@updateQueryColumnsNotSim=@updateQueryColumnsNotSim + ' ,' +
		case
			when  tvc.name_field='idSim' THEN CAST(@id_sim AS NVARCHAR(10)) + ' as idSim'
			else  ', t.['+tvc.name_field + '] = isnull(t.[' + tvc.name_field + '], s.[' +tvc.name_field + '])'
		end

from k_referential_tables_views_fields tvc 
	inner join k_referential_tables_views tv
		ON tvc.id_table_view = tv.id_table_view
WHERE tv.name_table_view=@Table_Name AND tvc.name_field<>@PK_Column and tvc.is_computed<>1
									and tvc.name_field NOT IN ('idSim','idOrg','typeModification')

select 
		@updateQueryAllColumns=@updateQueryAllColumns + ', t.['+tvc.name_field + '] =  s.[' +tvc.name_field +']'	,
		@allColumns=@allColumns + ' ,['+tvc.name_field+']',
		@allColumnsWithTemp=@allColumnsWithTemp + ' ,#Temp.['+tvc.name_field+']'
from k_referential_tables_views_fields tvc 
	inner join k_referential_tables_views tv
		ON tvc.id_table_view = tv.id_table_view
WHERE tv.name_table_view=@Table_Name AND tvc.name_field<>@PK_Column and tvc.is_computed<>1 

SET @updateQueryColumns=stuff(@updateQueryColumns, charindex(',', @updateQueryColumns, 0), 1, '')
SET @updateQueryAllColumns=stuff(@updateQueryAllColumns, charindex(',', @updateQueryAllColumns, 0), 1, '')
SET @updateQueryColumnsNotSim=stuff(@updateQueryColumnsNotSim, charindex(',', @updateQueryColumnsNotSim, 0), 1, '')
SET @allColumns=stuff(@allColumns, charindex(',', @allColumns, 0), 1, '')
SET @UpdateForMerge=stuff(@UpdateForMerge, charindex(',', @UpdateForMerge, 0), 1, '')
SET @allColumnsWithTemp=stuff(@allColumnsWithTemp, charindex(',', @allColumnsWithTemp, 0), 1, '')

if @id_sim = 0
	begin
		--Update temp column values for UPD values
		declare @UpdateQuery nvarchar(max) = 'update t set ' + @updateQueryColumns + ' ,t.IsApplied=1,t.Process_Type=''UPD'' from #Temp t inner join #Temp2 t2 on t. ' + @PK_Column + ' = t2.' + @PK_Column + ' inner join ' + @Table_Name + ' s on t.' + @PK_Column + ' = s.' + @PK_Column + ' where t.Process_Type=''UPD'' and t.IsApplied=0'
		exec (@UpdateQuery)
		--If table has idSim column set idSim null to 0
		if exists (select null from sys.columns where name = 'idSim' and object_id=object_id(@Table_Name))
			update #Temp set idSim= 0 where (Process_Type ='UPD' and IsApplied=1) or (Process_Type ='ADD' and IsApplied=0)
		 --Set localization changes
		 if object_id(N'tempdb..#localizations') is not null
			drop table #localizations
		 create table #localizations
		 (
			localization_id int identity(1,1) primary key,
			tab_id int NULL,
			module_type int NOT NULL,
			item_id int NULL,
			name nvarchar(max) NOT NULL,
			value nvarchar(max) NOT NULL,
			culture nvarchar(10) NOT NULL,
			type_source int NULL,
			ref_localization_id int NULL
		 )
		 insert into #localizations (tab_id,module_type,item_id,name,value,culture,type_source,ref_localization_id)
		 select 
			0,17,Field_Id,'GV_' + Column_Value, Column_Value,@culture,1,null 
		 from 
			grid_data_temp_values tmp inner join k_referential_tables_views_fields fi on tmp.Field_Id=fi.id_field 
		 where fi.is_localizable=1 and tmp.Unique_Key=@UniqueKey and  tmp.Column_Value != null and not exists 
		 (select null from rps_Localization where item_id=tmp.Field_Id and name=tmp.Column_Value and module_type=17 and culture=@culture)
		 
		 
		 update tloc set tloc.ref_localization_id=loc.localization_id from #localizations tloc inner join rps_Localization loc 
			on tloc.module_type=loc.module_type and tloc.item_id=loc.item_id and tloc.name=loc.name collate SQL_Latin1_General_CP1250_CI_AS
			where loc.culture=@culture
		 insert into rps_Localization (tab_id,module_type,item_id,name,value,culture,type_source,ref_localization_id)
		 select tab_id,module_type,item_id,name,value,culture,type_source,ref_localization_id from #localizations
	end
else
	begin
		--In case you upload the same excel file twice then check if the PK is already used as an idOrg
		DECLARE @setPrimaryKeyValue NVARCHAR(MAX) = 'UPDATE t SET t.'+@PK_Column + ' = s.'+@PK_Column + ', t.idOrg = s.idOrg, t.typeModification=0 FROM #Temp t inner join ' + @Table_Name + ' s on t.' + @PK_Column + ' = s.[idOrg] AND s.[idSim] = ' + CAST(@id_sim AS NVARCHAR(MAX)) + ' where t.Process_Type=''UPD''';
		exec(@setPrimaryKeyValue);
		--set idsim value to temp table
		declare @setSimColumn nvarchar(max) = 'update t set t.idSim=s.idSim from #Temp t inner join ' + @Table_Name + ' s on t.' + @PK_Column + ' = s.' +  @PK_Column + ' where t.Process_Type<>''ADD'''
		exec(@setSimColumn)
		--delete simulated grid,if the data is original, update temp table and set Process_Type DLT to ADD
		declare @SimDeleteOrgQuery nvarchar(max) = 'update t set ' + @updateQueryColumns + ',t.idOrg=t.' + @PK_Column + ',t.idSim=' + cast(@id_sim as nvarchar(10)) + ',t.typeModification=2,t.IsApplied=1,t.Process_Type=''ADD'' from #Temp t inner join #temp2 t2 on t. ' + @PK_Column + ' = t2.' + @PK_Column + ' inner join '+ @Table_Name + ' s on t.' + @PK_Column + ' = s.' + @PK_Column + ' where t.Process_Type=''DLT'' and s.idOrg is null and s.idSim=0 and t.IsApplied=0'
		exec (@SimDeleteOrgQuery)
		--delete simulated grid,if the data is simulated, update temp table and set Process_Type DLT to UPD
		declare @SimDeleteQuery nvarchar(max) = 'update t set ' + @updateQueryColumns + ',t.idOrg=s.idOrg,t.idSim=' + cast(@id_sim as nvarchar(10)) + ',t.typeModification=2,t.IsApplied=1,t.Process_Type=''UPD'' from #Temp t inner join #Temp2 t2 on t. ' + @PK_Column + ' = t2.' + @PK_Column + ' inner join '+ @Table_Name + ' s on t.' + @PK_Column + ' = s.' + @PK_Column + ' where t.Process_Type=''DLT'' and s.idOrg is not null and t.IsApplied=0'
		exec (@SimDeleteQuery)
		--delete simulated grid,if the data is added on sim tab (idOrg is null and idSim is not 0), update temp table and set Process_Type DLT to UPD
		declare @SimDeleteSimQuery nvarchar(max) = 'update t set ' + @updateQueryColumns + ',t.idOrg=null,t.idSim=' + cast(@id_sim as nvarchar(10)) + ',t.typeModification=2,t.IsApplied=1,t.Process_Type=''UPD'' from #Temp t inner join #Temp2 t2 on t. ' + @PK_Column + ' = t2.' + @PK_Column + ' inner join '+ @Table_Name + ' s on t.' + @PK_Column + ' = s.' + @PK_Column + ' where t.Process_Type=''DLT'' and s.idOrg is null and s.idSim<>0 and t.IsApplied=0'
		exec (@SimDeleteSimQuery)
		--modify simulated grid,if the data is original , update temp table and set Process_Type to UPD to ADD
		declare @SimModifyOrgQuery nvarchar(max) = 'update t set ' + @updateQueryColumns + ',t.idOrg=t.' + @PK_Column + ',t.idSim=' + cast(@id_sim as nvarchar(10)) + ',t.typeModification=0,t.IsApplied=1,t.Process_Type=''ADD'' from #Temp t inner join #temp2 t2 on t. ' + @PK_Column + ' = t2.' + @PK_Column + ' inner join '+ @Table_Name + ' s on t.' + @PK_Column + ' = s.' + @PK_Column + ' where t.Process_Type=''UPD'' and s.idOrg is null and s.idSim=0 and t.IsApplied=0'
		exec (@SimModifyOrgQuery)
		--modify simulated grid,if the data is added on sim tab (idOrg is null and idSim is not 0) , update temp table 
		declare @SimModifySimQuery nvarchar(max) = 'update t set ' + @updateQueryColumns + ',t.idOrg=null,t.idSim=' + cast(@id_sim as nvarchar(10)) + ',t.typeModification=0,t.IsApplied=1,t.Process_Type=''UPD'' from #Temp t inner join #Temp2 t2 on t. ' + @PK_Column + ' = t2.' + @PK_Column + ' inner join '+ @Table_Name + ' s on t.' + @PK_Column + ' = s.' + @PK_Column + ' where t.Process_Type=''UPD'' and s.idOrg is null and s.idSim<>0 and t.IsApplied=0'
		exec (@SimModifySimQuery)
		--modify simulated grid,if the data is simulated, update temp table 
		declare @SimModifyQuery nvarchar(max) = 'update t set ' + @updateQueryColumns + ',t.idOrg=s.idOrg,t.idSim=' + cast(@id_sim as nvarchar(10)) + ',t.typeModification=0,t.IsApplied=1,t.Process_Type=''UPD'' from #Temp t inner join #Temp2 t2 on t. ' + @PK_Column + ' = t2.' + @PK_Column + ' inner join '+ @Table_Name + ' s on t.' + @PK_Column + ' = s.' + @PK_Column + ' where t.Process_Type=''UPD'' and s.idOrg is not null and t.IsApplied=0'
		exec (@SimModifyQuery)
		--update temp table idSim and typeModification column when Process_Type is ADD 
		declare @SimInsertQuery nvarchar(max) = 'update #Temp set idSim= ' + cast(@id_sim as nvarchar(10)) + ' ,typeModification=1 where Process_Type=''ADD'' and IsApplied=0'
		exec (@SimInsertQuery)
	end



--Temp Excel Import Partition For Production
if(@isTemplateExcel = 1)                    
begin

--Temp Table For Staging
  if object_id(N'tempdb..#TempStaging') is not null
  	drop table #TempStaging
  
  create table #TempStaging
  (
  	C229313B5B83E4DDEADE3C11680AA4F5F int identity(1,1) primary key,
  	IsApplied bit default(0)
  )	


   --Delete Rejected Data and Get Count Information
  declare @TempDeleteScriptByType nvarchar(max);

  declare @PkNvarcharColumn nvarchar(max) = @PK_Column + '_nvarchar';
  declare @PkNvarcharColumnAndType nvarchar(max) = @PkNvarcharColumn  + ' NVARCHAR(MAX)';
  declare @StagingTableStandardColumnsAndTypes nvarchar(max) = N'[stg_import_id_user] NVARCHAR(MAX), [stg_import_date] NVARCHAR(MAX),
                                                                 [stg_validate_id_user] NVARCHAR(MAX), [stg_validate_date] NVARCHAR(MAX),
                                                                 [stg_validate_status] NVARCHAR(MAX), [stg_validate_reject_status] NVARCHAR(MAX),
																 [stg_error_status] NVARCHAR(MAX), [stg_error_status_description] NVARCHAR(MAX)';

--Alter #TempStaging tables with table columns
  declare @TableStagingAlterScript nvarchar(max) = N'ALTER TABLE #TempStaging ADD Process_Type CHAR(3),' +
                                                   @PK_ColumnAndTypes + @PkNvarcharColumnAndType + ',' + 
												   @ColumnsAndTypesForStagingTemp + ',' + @StagingTableStandardColumnsAndTypes
  execute sp_executesql @TableStagingAlterScript

--Set pivot on TableType
  DECLARE @StagingTempTableInsert NVARCHAR(MAX)  =''
  SET @StagingTempTableInsert = @StagingTempTableInsert + '
  insert into #TempStaging(' + @PK_Column + N',Process_Type,' + @StagingColumns + N')
  select PK_Id,Process_Type,' + @StagingColumns + '
    from (
  		select PK_Id,Process_Type,Column_Name,Column_Value
  		  from grid_data_temp_values
  		 where Unique_Key = @unqKey
  	   ) src
   pivot
   (
  	min(src.Column_Value)
  	for Column_Name in (' + @StagingColumns + ')
   ) pvt'

 declare @ParmStagingDefinition nvarchar(500)
 set @ParmStagingDefinition = N'@unqKey varchar(50)'
 execute sp_executesql @StagingTempTableInsert,@ParmStagingDefinition,@unqKey = @UniqueKey

 if @id_sim = 0
	begin
	if exists (select null from sys.columns where name = 'idSim' and object_id=object_id(@Table_Name))
		BEGIN
			update #TempStaging set idSim= 0 where (Process_Type ='UPD' and IsApplied=1) or (Process_Type ='ADD' and IsApplied=0)
		END
	end

  --Call Validate Sp
   exec [dbo].[Kernel_SP_Validate_TableValues] @Table_Name, '#TempStaging','C229313B5B83E4DDEADE3C11680AA4F5F'
  
   set @TotalCount = (select COUNT(*) from #TempStaging)
  --Insert error record from coming object security to #TempGridDataResult

    declare @PrmsResult2 nvarchar(max) = N'@uniqueKey varchar(50), @isBatch bit, @totalCount int';


	--Insert record not therefore validated into TempGridDataResult
	declare @notValidRecord nvarchar(max) = 
    N'insert into #TempGridDataResult
    select @uniqueKey, '+ @PK_Column + ', @isBatch, @totalCount, 0, 0, NULL, 60006, Process_Type  from #TempStaging where stg_error_status > 1 ' --60006: Not Valid Record
	execute sp_executesql @notValidRecord, @PrmsResult2, @uniqueKey = @UniqueKey, @isBatch = @IsBatch, @totalCount = @TotalCount 

    --Delete data by stg_error_status and Object Security
    set @TempDeleteScriptByType = 'delete #TempStaging where stg_error_status > 1'
    execute sp_executesql @TempDeleteScriptByType

	--Insert record not therefore Object Security into TempGridDataResult
	set @insertErrorRecordForSecurity =  
    N'insert into #TempGridDataResult
    select @uniqueKey, '+ @PK_Column + ', @isBatch, @totalCount, 0, 0, NULL, 10011, Process_Type  from #TempStaging  
    where C229313B5B83E4DDEADE3C11680AA4F5F not in (select C229313B5B83E4DDEADE3C11680AA4F5F from #TempStaging as MAINTABLE where ' + @WhereCriteria + ')' --10011 : Access denied.
    execute sp_executesql @insertErrorRecordForSecurity, @PrmsResult2, @uniqueKey = @UniqueKey, @isBatch = @IsBatch, @totalCount = @TotalCount 

	--Delete data by Object Security
    set @TempStagingDeleteScriptForSecurity = 
    N'delete #TempStaging where C229313B5B83E4DDEADE3C11680AA4F5F not in 
           (select C229313B5B83E4DDEADE3C11680AA4F5F from #TempStaging as MAINTABLE where ' + @WhereCriteria + ')'
    execute sp_executesql @TempStagingDeleteScriptForSecurity

   set @RejectedCountToObjectSecurity = @TotalCount - (select count(*) from #TempStaging); -- Rejected data count

   --move valid data into #Temp
   delete #Temp;
   declare @InsertScriptToTempTable nvarchar(max)
   set @InsertScriptToTempTable = 'insert into #Temp(' + @PK_Column + ', Process_Type, ' + @Columns + ')
                                             select ' + @PK_Column + ', Process_Type, ' + @Columns + ' from #TempStaging';
   execute sp_executesql @InsertScriptToTempTable
end


--ACCESS DENIED AND NOT VALIDATED RECORDS DELETE
delete grid_data_temp_values where PK_Id in (select pk_id from #TempGridDataResult)


--Create #trackChanges table for xhisto tables
IF OBJECT_ID('tempdb.dbo.#trackChanges') IS NOT NULL
	DROP TABLE #trackChanges
create table #trackChanges
(
	pk int,
	pkOld int,
	changes_type varchar(3)
)

declare @isTrackChanges bit
declare @tractChangesUpd nvarchar(max)='
		insert into #trackChanges (pk, changes_type) 
		select  ' + @PK_Column + ', ''UPD''  
		from #Temp where Process_Type = ''UPD''' 


-- try
-- if any of them is false then it Pre-SP should be called here.
-- if any of the SP return false then execute > 
-- delete from grid_data_temp_values where UniqueKey = @uniqueKey and ProcessType = ''
-- 
--end try



--Set SP names in k_referantial_grids
select @SpAddPre = KRG.sp_grid_add_pre,
       @SpAddPost = KRG.sp_grid_add_post,
	   @SpSavePre = KRG.sp_grid_save_pre,
	   @SpSavePost = KRG.sp_grid_save_post,
	   @SpDeletePre = KRG.sp_grid_delete_pre,
	   @SpDeletePost = KRG.sp_grid_delete_post,
	   @IsBatch = KRG.is_bulk_insert,
	   @isTrackChanges = KRG.is_track_change
from k_referential_grids KRG where KRG.id_grid = @idGrid



--Pre
select @SpAddPreGridDataCount = count(*) from grid_data_temp_values where Unique_Key = @UniqueKey and Process_Type = 'ADD'
select @SpSavePreGridDataCount = count(*) from grid_data_temp_values where Unique_Key = @UniqueKey and Process_Type = 'UPD'
select @SpDeletePreGridDataCount = count(*) from grid_data_temp_values where Unique_Key = @UniqueKey and Process_Type = 'DLT'

--Pre SP Results

if object_id(N'tempdb..#tmpSpResult') is not null
	drop table #tmpSpResult

create table #tmpSpResult
(
 --PKEY int,
 ResultStatus bit,
 ResultMessage nvarchar(max)
)

declare @spErrorMsg nvarchar(max)='';
declare @SpErrorNumber int


IF @IsBatch <> 1
BEGIN

DECLARE @CurrentProcessed INT=0;
DECLARE @PkeyValue INT;

DECLARE db_cursor CURSOR FOR

select C229313B5B83E4DDEADE3C11680AA4F5F from #Temp
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @PkeyValue   

WHILE @@FETCH_STATUS = 0   
BEGIN

--Get PkValue and ProcessType
declare @PkValueToRecord nvarchar(max);
declare @ProcessTypeToRecord varchar(3);
declare @OutputPKey nvarchar(100) =  N'@PkValueToRecord NVARCHAR(MAX) OUTPUT'
declare @OutputPType nvarchar(100) =  N'@ProcessTypeToRecord NVARCHAR(MAX) OUTPUT'

declare @queryPKey nvarchar(max) = 'select  @PkValueToRecord = ' + @PK_Column + ' from #Temp where [C229313B5B83E4DDEADE3C11680AA4F5F] = ' + CAST(@PkeyValue AS NVARCHAR(10));
EXECUTE sp_executesql @queryPKey, @OutputPKey, @PkValueToRecord OUTPUT

declare @queryPType nvarchar(max) = 'select  @ProcessTypeToRecord = Process_Type from #Temp where [C229313B5B83E4DDEADE3C11680AA4F5F] = ' + CAST(@PkeyValue AS NVARCHAR(10));
EXECUTE sp_executesql @queryPType, @OutputPType, @ProcessTypeToRecord OUTPUT

set @primaryKey = @PkValueToRecord;

begin try
begin transaction
	
	delete #tmpSpResult
	if @ProcessTypeToRecord = 'ADD' and @SpAddPreGridDataCount > 0 and @SpAddPre <> '' and exists(select * from sys.procedures where name = @SpAddPre) 
	   begin
		   insert into #tmpSpResult
				execute @SpAddPre @UniqueKey, @idUser, @idProfile, @primaryKey
				set @SpAddPreResult = (select ResultStatus from  #tmpSpResult)
				set @SpAddPreResultMessage = (select ResultMessage from  #tmpSpResult)
	   end
	else if @ProcessTypeToRecord = 'ADD' and @SpAddPreGridDataCount > 0  and @SpAddPre <> '' and not exists(select * from sys.procedures where name = @SpAddPre) 
		 begin
			 set @SpAddPreResultMessage = 'FF_SpAddPreNotFound'
			 set @SpAddPreResult = 0
		 end 


	delete #tmpSpResult
	if @ProcessTypeToRecord = 'UPD' and @SpSavePreGridDataCount > 0 and @SpSavePre <> '' and exists( select * from sys.procedures where name = @SpSavePre) 
	   begin
		  insert into #tmpSpResult
				execute @SpSavePre @UniqueKey, @idUser, @idProfile, @primaryKey
				set @SpSavePreResult = (select ResultStatus from  #tmpSpResult)
				set @SpSavePreResultMessage = (select ResultMessage from  #tmpSpResult)
	   end
	else if @ProcessTypeToRecord = 'UPD' and @SpSavePreGridDataCount > 0 and @SpSavePre <> '' and not exists( select * from sys.procedures where name = @SpSavePre) 
		 begin
			 set @SpSavePreResultMessage = 'FF_SpSavePreNotFound'
			 set @SpSavePreResult = 0
		 end 


	delete #tmpSpResult
	if @ProcessTypeToRecord = 'DLT' and @SpDeletePreGridDataCount > 0 and @SpDeletePre <> '' and exists( select * from sys.procedures where name = @SpDeletePre)
	   begin
		  insert into #tmpSpResult
				execute @SpDeletePre @UniqueKey, @idUser, @idProfile, @primaryKey
				set @SpDeletePreResult = (select ResultStatus from  #tmpSpResult)
				set @SpDeletePreResultMessage = (select ResultMessage from  #tmpSpResult)
	   end
	else if @ProcessTypeToRecord = 'DLT' and @SpDeletePreGridDataCount > 0 and @SpDeletePre <> '' and not exists( select * from sys.procedures where name = @SpDeletePre)
		 begin
			 set @SpDeletePreResultMessage = 'FF_SpDeletePreNotFound'
			 set @SpDeletePreResult = 0
		 end

	if (@ProcessTypeToRecord = 'ADD' and @SpAddPreResult = 0)
	begin
	   set @SpErrorNumber = 60000 
	   ;THROW @SpErrorNumber, @SpAddPreResultMessage, 1;
	end

	if (@ProcessTypeToRecord = 'UPD' and @SpSavePreResult = 0)
	begin
	   set @SpErrorNumber = 60001
	   ;THROW @SpErrorNumber, @SpSavePreResultMessage, 1;
	end

	if (@ProcessTypeToRecord = 'DLT' and @SpDeletePreResult = 0)
	begin
	   set @SpErrorNumber = 60002
	   ;THROW @SpErrorNumber, @SpDeletePreResultMessage, 1;
	end









	--delete from table with temp table	
	if @ProcessTypeToRecord = 'DLT' and @SpDeletePreResult = 1
	begin
		declare @delQueryNB nvarchar(max) ='MERGE INTO ' + @Table_Name + ' t
	                USING #Temp s 
		            ON  t.'+@PK_Column + ' = s.'+ @PK_Column + '
	                WHEN MATCHED and Process_Type=''DLT'' AND C229313B5B83E4DDEADE3C11680AA4F5F = ' + Convert(nvarchar(max) , @PkeyValue) + '
	                THEN DELETE;'
	exec(@delQueryNB)
	end
	--modify table with temp table
	if @ProcessTypeToRecord = 'UPD' and @SpSavePreResult = 1
	begin
	  	declare @modQueryNB nvarchar(max) ='MERGE INTO ' + @Table_Name + ' t
	                USING  #Temp s
		            ON t.'+@PK_Column + ' = s.'+@PK_Column + '
	                WHEN MATCHED and Process_Type=''UPD'' AND C229313B5B83E4DDEADE3C11680AA4F5F = ' + Convert(nvarchar(max) , @PkeyValue) + '
	                THEN UPDATE SET ' + @updateQueryAllColumns + ';'
	exec(@modQueryNB)
    end 
	--insert to table with temp table
	if  @ProcessTypeToRecord = 'ADD' and @SpAddPreResult = 1 
	begin
      	declare @insertQueryNB nvarchar(max) = '
                     MERGE INTO '+ @Table_Name + '
                     USING #Temp 
                     ON 1 = 0
                     WHEN NOT MATCHED AND Process_Type=''ADD''  AND C229313B5B83E4DDEADE3C11680AA4F5F = ' + Convert(nvarchar(max) , @PkeyValue) + '
                     THEN INSERT (' + @allColumns + ') VALUES (' + @allColumnsWithTemp + ')
                     output inserted.' + @PK_Column + ' ,#Temp.' + @PK_Column + ' INTO #trackChanges (pk, pkOld);'
                     exec(@insertQueryNB)
end



    if @ProcessTypeToRecord = 'ADD'
    begin
      set @primaryKey = (SELECT TOP 1 pk FROM #trackChanges ORDER BY pk DESC);
    end

	
	delete #tmpSpResult
	if @ProcessTypeToRecord = 'ADD' and @SpAddPreGridDataCount > 0  and @SpAddPreResult = 1 and exists(select * from sys.procedures where name = @SpAddPost)  
	   begin
	   insert into #tmpSpResult
		   execute @SpAddPost @UniqueKey, @idUser, @idProfile, @primaryKey 
		   set @SpAddPostResult = (select ResultStatus from  #tmpSpResult)
		   set @SpAddPostResultMessage = (select ResultMessage from  #tmpSpResult)
	   end
	else if @ProcessTypeToRecord = 'ADD' and @SpAddPreGridDataCount > 0  and @SpAddPreResult = 1 and @SpAddPost <> '' and not exists( select * from sys.procedures where name = @SpAddPost) 
		begin
			set @SpAddPostResultMessage = 'FF_SpAddPostNotFound'
			set @SpAddPostResult = 0
		end 


	delete #tmpSpResult
	if @ProcessTypeToRecord = 'UPD' and @SpSavePreGridDataCount > 0 and @SpSavePreResult = 1 and exists(select * from sys.procedures where name = @SpSavePost) 
	   begin
	   insert into #tmpSpResult
		   execute @SpSavePost @UniqueKey, @idUser, @idProfile, @primaryKey
		   set @SpSavePostResult = (select ResultStatus from  #tmpSpResult)
		   set @SpSavePostResultMessage = (select ResultMessage from  #tmpSpResult) 
	   end
	else if @ProcessTypeToRecord = 'UPD' and @SpSavePreGridDataCount > 0 and @SpSavePreResult = 1 and @SpSavePost <> '' and not exists( select * from sys.procedures where name = @SpSavePost) 
		begin
			set @SpSavePostResultMessage = 'FF_SpSavePostNotFound'
			set @SpSavePostResult = 0
		end 


	delete #tmpSpResult
	if @ProcessTypeToRecord = 'DLT' and @SpDeletePreGridDataCount > 0 and @SpDeletePreResult = 1 and exists(select * from sys.procedures where name = @SpDeletePost) 
	   begin
	   insert into #tmpSpResult
		   execute @SpDeletePost @UniqueKey, @idUser, @idProfile, @primaryKey
		   set @SpDeletePostResult = (select ResultStatus from  #tmpSpResult)
		   set @SpDeletePostResultMessage = (select ResultMessage from  #tmpSpResult) 
	   end
	else if @ProcessTypeToRecord = 'DLT' and @SpDeletePreGridDataCount > 0 and @SpDeletePreResult = 1 and @SpDeletePost <> '' and not exists( select * from sys.procedures where name = @SpDeletePost) 
		begin
			set @SpDeletePostResultMessage = 'FF_SpDeletePostNotFound'
			set @SpDeletePostResult = 0
		end 

	if (@ProcessTypeToRecord = 'ADD' and @SpAddPostResult = 0)
	begin
		set @SpErrorNumber = 60003
		;THROW @SpErrorNumber, @SpAddPostResultMessage, 1;
	end

	if (@ProcessTypeToRecord = 'UPD' and @SpSavePostResult = 0)
	begin
	   set @SpErrorNumber = 60004
	   ;THROW @SpErrorNumber, @SpSavePostResultMessage, 1;
	end

	if (@ProcessTypeToRecord = 'DLT' and @SpDeletePostResult = 0)
	begin
	   set @SpErrorNumber = 60005
	   ;THROW @SpErrorNumber, @SpDeletePostResultMessage, 1;
	end


	commit transaction
end try
begin catch

  	if (xact_state()) = -1
    begin
        print
            N'The transaction is in an uncommittable state.' +
            'Rolling back transaction.'
        rollback transaction;
    end;
    -- Test whether the transaction is committable.
    if (xact_state()) = 1 and @@trancount >= 1
    begin
        print
            N'The transaction is committable.' +
            'But Rolling back transaction.'
       rollback transaction;
	end;

  --Insert Error Record Information Into #TempGridDataResult
  set @ErrorCode = (SELECT ERROR_NUMBER())
  set @ErrorMessage = (SELECT ERROR_MESSAGE())
  insert into #TempGridDataResult values (@UniqueKey, @PkValueToRecord, @IsBatch, @TotalCount, 0, 0, @ErrorMessage, @ErrorCode, @ProcessTypeToRecord)

end catch

SET @CurrentProcessed=@CurrentProcessed+1;
IF @CurrentProcessed % @NotifyAfter = 0
BEGIN
	RAISERROR(N'{Progress:%d}',10,1,@CurrentProcessed) WITH NOWAIT --Return current processed row count
END

    FETCH NEXT FROM db_cursor INTO @PkeyValue
END   

CLOSE db_cursor   
DEALLOCATE db_cursor


--Find Accept And Reject Count For Not Batch
set @RejectedCount = (select count(*) from #TempGridDataResult)
set @AcceptedCount = @TotalCount - @RejectedCount;
update #TempGridDataResult set number_of_applied = @AcceptedCount, number_of_rejected = @RejectedCount


  
	--If @isTrackChanges is 1 insert primary keys to #trackChanges table

	if @isTrackChanges=1
	begin
		DELETE #trackChanges WHERE pk IS NULL
		exec(@tractChangesUpd)
	end

	delete grid_data_temp_values where Unique_Key = @UniqueKey;

	update #trackChanges set changes_type= 'ADD' where changes_type is null
	select pk, pkOld, changes_type from #trackChanges
	select * from #TempGridDataResult

return;


END



--If exist records which don't match to object security
if @RejectedCountToObjectSecurity > 0 and @IsBatch = 1
begin
	 
	delete grid_data_temp_values where Unique_Key = @UniqueKey;
	update #TempGridDataResult set number_of_applied = @TotalCount - @RejectedCountToObjectSecurity, number_of_rejected = @RejectedCountToObjectSecurity, process_type = 'btc'	 
  	select pk,changes_type from #trackChanges where 1 = 2
	select * from #TempGridDataResult

	return;
end



begin try

begin transaction


delete #tmpSpResult
if @SpAddPreGridDataCount > 0 and @SpAddPre <> '' and exists(select * from sys.procedures where name = @SpAddPre) 
   begin
       insert into #tmpSpResult
            execute @SpAddPre @UniqueKey, @idUser, @idProfile, @primaryKey
			set @SpAddPreResult = (select ResultStatus from  #tmpSpResult)
			set @SpAddPreResultMessage = (select ResultMessage from  #tmpSpResult)
   end
else if @SpAddPreGridDataCount > 0  and @SpAddPre <> '' and not exists(select * from sys.procedures where name = @SpAddPre) 
     begin
         set @SpAddPreResultMessage = 'FF_SpAddPreNotFound'
	     set @SpAddPreResult = 0
     end 


delete #tmpSpResult
if @SpSavePreGridDataCount > 0 and @SpSavePre <> '' and exists( select * from sys.procedures where name = @SpSavePre) 
   begin
      insert into #tmpSpResult
            execute @SpSavePre @UniqueKey, @idUser, @idProfile, @primaryKey
			set @SpSavePreResult = (select ResultStatus from  #tmpSpResult)
			set @SpSavePreResultMessage = (select ResultMessage from  #tmpSpResult)
   end
else if @SpSavePreGridDataCount > 0 and @SpSavePre <> '' and not exists( select * from sys.procedures where name = @SpSavePre) 
     begin
         set @SpSavePreResultMessage = 'FF_SpSavePreNotFound'
		 set @SpSavePreResult = 0
     end 


delete #tmpSpResult
if @SpDeletePreGridDataCount > 0 and @SpDeletePre <> '' and exists( select * from sys.procedures where name = @SpDeletePre)
   begin
      insert into #tmpSpResult
            execute @SpDeletePre @UniqueKey, @idUser, @idProfile, @primaryKey
			set @SpDeletePreResult = (select ResultStatus from  #tmpSpResult)
			set @SpDeletePreResultMessage = (select ResultMessage from  #tmpSpResult)
   end
else if @SpDeletePreGridDataCount > 0 and @SpDeletePre <> '' and not exists( select * from sys.procedures where name = @SpDeletePre)
     begin
         set @SpDeletePreResultMessage = 'FF_SpDeletePreNotFound'
		 set @SpDeletePreResult = 0
     end

	  


if (@SpAddPreResult = 0)
begin
   set @SpErrorNumber = 60000 
   ;THROW @SpErrorNumber, @SpAddPreResultMessage, 1;
end

if (@SpSavePreResult = 0)
begin
   set @SpErrorNumber = 60001
   ;THROW @SpErrorNumber, @SpSavePreResultMessage, 1;
end

if (@SpDeletePreResult = 0)
begin
   set @SpErrorNumber = 60002
   ;THROW @SpErrorNumber, @SpDeletePreResultMessage, 1;
end


	
	--delete from table with temp table	
	if @SpDeletePreResult = 1
	begin
		declare @delQuery nvarchar(max) ='MERGE INTO ' + @Table_Name + ' t
	                USING #Temp s 
		            ON  t.'+@PK_Column + ' = s.'+ @PK_Column + '
	                WHEN MATCHED and Process_Type=''DLT''
	                THEN DELETE;'
	exec(@delQuery)
	end
	--modify table with temp table
	if @SpSavePreResult = 1
	begin
	  	declare @modQuery nvarchar(max) ='MERGE INTO ' + @Table_Name + ' t
	                USING  #Temp s
		            ON t.'+@PK_Column + ' = s.'+@PK_Column + '
	                WHEN MATCHED and Process_Type=''UPD''
	                THEN UPDATE SET ' + @updateQueryAllColumns + ';'
	exec(@modQuery)
    end 
	--insert to table with temp table
	if  @SpAddPreResult = 1
	begin
	declare @insertQuery nvarchar(max) = 'insert into ' + @Table_Name + '( ' + @allColumns + ')
										  output inserted.' + @PK_Column + ' into #trackChanges (pk)
										  select ' + @allColumns + ' from #Temp where Process_Type=''ADD'''	
	exec(@insertQuery)
	 end
	--If @isTrackChanges is 1 insert primary keys to #trackChanges table
  if @SpAddPreResult = 1 or @SpSavePreResult = 1 or @SpDeletePreResult = 1
  begin
	if @isTrackChanges=1
	begin
		DELETE #trackChanges WHERE pk IS NULL
		exec(@tractChangesUpd)
	end
   end
   



--try
-- if any of them is false then it Post-SP should be called here.
--end try

--Post


delete #tmpSpResult
if @SpAddPreGridDataCount > 0  and @SpAddPreResult = 1 and exists(select * from sys.procedures where name = @SpAddPost)  
   begin
   insert into #tmpSpResult
       execute @SpAddPost @UniqueKey, @idUser, @idProfile, @primaryKey 
	   set @SpAddPostResult = (select ResultStatus from  #tmpSpResult)
	   set @SpAddPostResultMessage = (select ResultMessage from  #tmpSpResult)
   end
else if @SpAddPreGridDataCount > 0  and @SpAddPreResult = 1 and @SpAddPost <> '' and not exists( select * from sys.procedures where name = @SpAddPost) 
    begin
        set @SpAddPostResultMessage = 'FF_SpAddPostNotFound'
		set @SpAddPostResult = 0
    end 


delete #tmpSpResult
if @SpSavePreGridDataCount > 0 and @SpSavePreResult = 1 and exists(select * from sys.procedures where name = @SpSavePost) 
   begin
   insert into #tmpSpResult
       execute @SpSavePost @UniqueKey, @idUser, @idProfile, @primaryKey
	   set @SpSavePostResult = (select ResultStatus from  #tmpSpResult)
	   set @SpSavePostResultMessage = (select ResultMessage from  #tmpSpResult) 
   end
else if @SpSavePreGridDataCount > 0 and @SpSavePreResult = 1 and @SpSavePost <> '' and not exists( select * from sys.procedures where name = @SpSavePost) 
    begin
        set @SpSavePostResultMessage = 'FF_SpSavePostNotFound'
		set @SpSavePostResult = 0
    end 


delete #tmpSpResult
if @SpDeletePreGridDataCount > 0 and @SpDeletePreResult = 1 and exists(select * from sys.procedures where name = @SpDeletePost) 
   begin
   insert into #tmpSpResult
       execute @SpDeletePost @UniqueKey, @idUser, @idProfile, @primaryKey
	   set @SpDeletePostResult = (select ResultStatus from  #tmpSpResult)
	   set @SpDeletePostResultMessage = (select ResultMessage from  #tmpSpResult) 
   end
else if @SpDeletePreGridDataCount > 0 and @SpDeletePreResult = 1 and @SpDeletePost <> '' and not exists( select * from sys.procedures where name = @SpDeletePost) 
    begin
        set @SpDeletePostResultMessage = 'FF_SpDeletePostNotFound'
		set @SpDeletePostResult = 0
    end 

if (@SpAddPostResult = 0)
begin
	set @SpErrorNumber = 60003
    ;THROW @SpErrorNumber, @SpAddPostResultMessage, 1;
end

if (@SpSavePostResult = 0)
begin
   set @SpErrorNumber = 60004
   ;THROW @SpErrorNumber, @SpSavePostResultMessage, 1;
end

if (@SpDeletePostResult = 0)
begin
   set @SpErrorNumber = 60005
   ;THROW @SpErrorNumber, @SpDeletePostResultMessage, 1;
end



commit transaction



end try
begin catch
 
	if (xact_state()) = -1
    begin
        print
            N'The transaction is in an uncommittable state.' +
            'Rolling back transaction.'
        rollback transaction;
    end;
    -- Test whether the transaction is committable.
    if (xact_state()) = 1 and @@trancount >= 1
    begin
        print
            N'The transaction is committable.' +
            'But Rolling back transaction.'
       rollback transaction;
    end;
	
	  --Insert Error Record Information Into #TempGridDataResult
   set @ErrorCode = (select ERROR_NUMBER());
   set @ErrorMessage = (select ERROR_MESSAGE())
   insert into #TempGridDataResult values (@UniqueKey, -1, @IsBatch, @TotalCount, NULL, NULL, @ErrorMessage, @ErrorCode, 'Btc')

   delete from grid_data_temp_values where Unique_Key = @UniqueKey;

	--throw;
end catch


	delete grid_data_temp_values where Unique_Key = @UniqueKey


--returning primary keys for xhisto

update #trackChanges set changes_type= 'ADD' where changes_type is null
select pk,changes_type from #trackChanges
select * from #TempGridDataResult