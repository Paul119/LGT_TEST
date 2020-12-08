CREATE PROCEDURE [dbo].[Kernel_SP_Staging_Grid_DML]
  (
  	@IdGrid	int,
  	@UniqueKey	varchar(50),
  	@WhereCriteria nvarchar(max),
  	@IdUser int,
  	@ImportDate datetime,
  	@FileName nvarchar(max)
  )
  AS
  
  DECLARE @Table_Name nvarchar(max);
  SELECT @Table_Name = name_table_view
  FROM k_referential_tables_views tv
  JOIN k_referential_grids g
  	ON tv.id_table_view = g.id_table_view
  WHERE g.id_grid = @IdGrid
  
  --Staging Table Name => Format: TableName_stg_idGrid
  DECLARE @Staging_Table_Name nvarchar(max) = @Table_Name + '_stg_' + Convert(nvarchar(max),@IdGrid)

  --Errors
  DECLARE @ErrorCode INT = 0;
  DECLARE @ErrorMessage  NVARCHAR(MAX)=N'';
  
  declare @PK_ColumnAndTypes nvarchar(255) = N''
  declare @PK_Column nvarchar(max)=N''
  declare @ColumnsAndTypes nvarchar(max)=N''
  declare @ColumnsAndTypesForTemp2 nvarchar(max)=N''
  declare @Columns nvarchar(max)=N''
  declare @ColumnsWithNullCheck nvarchar(max)=N''
  declare @ColumnsForMerge nvarchar(max)=N''
  declare @ColumnsForInsert nvarchar(max)=N'' --If idsim == 0 
  declare @MergedColumns nvarchar(max) =N''
  declare @Staging_PK_Column nvarchar(max)= N'id_'+@Staging_Table_Name;
  
  select @PK_Column = col_name(ic.object_id,ic.column_id)
  	   , @PK_ColumnAndTypes = col_name(ic.object_id,ic.column_id) + ' ' +  krtvf.type_field  + ',' 
    from sys.indexes as i
  	inner join sys.index_columns as ic
  		on i.object_id = ic.object_id
  		and i.index_id = ic.index_id
  	inner join k_referential_tables_views krtv
  		on object_id(krtv.name_table_view ) =  i.object_id
  	inner join k_referential_tables_views_fields krtvf
  		on krtvf.id_table_view = krtv.id_table_view
  		and krtvf.name_field = col_name(ic.object_id,ic.column_id)
   where i.is_primary_key = 1
     and i.object_id = object_id(@Table_Name)
  -- If table has not primary key , getting is_unique column name
  if (@PK_Column IS NULL OR @PK_Column = '')
  begin
  	select  @PK_Column = f.name_field, @PK_ColumnAndTypes= f.name_field + ' ' + f.type_field  + ',' 
  	  from k_referential_tables_views_fields f
  		inner join k_referential_tables_views t
  			on t.id_table_view = f.id_table_view
  	 where f.is_unique = 1
  	   and t.name_table_view =  @Table_Name
  end
  
  
  --Temp Table
  if object_id(N'tempdb..#Temp') is not null
  	drop table #Temp
  
  create table #Temp
  (
  	C229313B5B83E4DDEADE3C11680AA4F5F int identity(1,1) primary key,
  	IsApplied bit default(0)
  )

  --Creating #TempGridDataResult
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
  
  
  --Generate necessary params
  ;with ComputedExpressionForFields
  as
  (
  select 
  col.COLUMN_NAME name_field
  , col.DATA_TYPE type_field
  , col.CHARACTER_MAXIMUM_LENGTH length_field
  , col.IS_NULLABLE constraint_null_field
  , COLUMNPROPERTY(OBJECT_ID(TABLE_NAME),COLUMN_NAME,'IsComputed') is_computed
  , type_field_with_length = 'NVARCHAR(MAX)'
  , default_value_definition = case when col.COLUMN_DEFAULT is not null
										 then N' default(' + col.COLUMN_DEFAULT+ N')'
										 else N''
									 end
  from INFORMATION_SCHEMA.COLUMNS col
  where col.TABLE_NAME = @Staging_Table_Name
  and col.COLUMN_NAME <> @Staging_PK_Column
  and COLUMNPROPERTY(OBJECT_ID(TABLE_NAME),COLUMN_NAME,'IsComputed') <> 1
  )
  select 
  		@ColumnsAndTypes = @ColumnsAndTypes + ' ,[' +  ce.name_field + '] ' + ce.type_field_with_length + ce.default_value_definition,
  		@ColumnsAndTypesForTemp2 = @ColumnsAndTypesForTemp2 + ' ,[' +  ce.name_field + '] NVARCHAR(MAX)' + ce.default_value_definition + case when type_field IN(N'char',N'nchar',N'nvarchar',N'varchar') then ' COLLATE DATABASE_DEFAULT ' else '' end,
  		@ColumnsForInsert=@ColumnsForInsert + ' ,' + case when ce.name_field='idSim' then '0 as idSim' else '[' + ce.name_field + ']' end,
  		@Columns = @Columns + ' , [' + ce.name_field +']',
  		@MergedColumns = @MergedColumns + + CASE WHEN ce.type_field='xml' THEN ' ,ISNULL(CAST(PT.['+ ce.name_field + '] AS nVARCHAR(max)) ,CAST(MT.['+ ce.name_field + '] AS nVARCHAR(max))) AS ['+ ce.name_field + ']' ELSE ' , ISNULL(PT.['+ ce.name_field + '], MT.['+ ce.name_field + ']) AS ['+ ce.name_field + ']' END, 
  		@ColumnsWithNullCheck = @ColumnsWithNullCheck + ' , ' + CASE WHEN ce.name_field IN ('idSim','idOrg','typeModification') THEN +'[' + ce.name_field + ']' ELSE 'CONVERT(' + type_field_with_length + ',' + 'NULLIF([' + ce.name_field + '],''_null_'')) [' + ce.name_field  +']' END ,
  		@ColumnsForMerge=@ColumnsForMerge + ' , source.[' + ce.name_field +']'
    from ComputedExpressionForFields ce
  
  --Remove first character
  SET @ColumnsAndTypes=stuff(@ColumnsAndTypes, charindex(',', @ColumnsAndTypes, 0), 1, '')
  SET @ColumnsForInsert=stuff(@ColumnsForInsert, charindex(',', @ColumnsForInsert, 0), 1, '')
  SET @Columns=stuff(@Columns, charindex(',', @Columns, 0), 1, '')
  SET @ColumnsWithNullCheck=stuff(@ColumnsWithNullCheck, charindex(',', @ColumnsWithNullCheck, 0), 1, '')
  SET @ColumnsAndTypesForTemp2=stuff(@ColumnsAndTypesForTemp2, charindex(',', @ColumnsAndTypesForTemp2, 0), 1, '')
  set @ColumnsForMerge=stuff(@ColumnsForMerge,charindex(',',@ColumnsForMerge,0),1,'')
  SET @MergedColumns=stuff(@MergedColumns,charindex(',',@MergedColumns,0),1,'')
  SET @ColumnsAndTypesForTemp2 = @Staging_PK_Column +' int ,' + @ColumnsAndTypesForTemp2
  
  --Alter temp tables with table columns
  declare @TableAlterScript nvarchar(max);
  SET @TableAlterScript = N'ALTER TABLE #Temp ADD Process_Type CHAR(3) COLLATE DATABASE_DEFAULT,' + @ColumnsAndTypesForTemp2
  execute sp_executesql @TableAlterScript
  
  --Insert Data For Temp Table From grid_data_temp_values
  DECLARE @SQL NVARCHAR(MAX)  =''
  SET @SQL = @SQL + 
  '
  insert into #Temp(' + @Staging_PK_Column + N',Process_Type,' + @Columns + N')
  SELECT PK_Id,Process_Type,' + @MergedColumns + ' FROM
  (
  	select PK_Id,Process_Type,' + @ColumnsForInsert + '
  	  from (
  			select PK_Id,Process_Type,Column_Name,Column_Value
  			  from grid_data_temp_values
  			 where Unique_Key = @unqKey
  		   ) src
  	 pivot
  	 (
  		min(src.Column_Value)
  		for Column_Name in (' + @Columns + ')
  	 ) pvt
  ) PT
  LEFT JOIN '+@Staging_Table_Name+' MT
  	ON PT.PK_Id = MT.'+@Staging_PK_Column + '
  WHERE 1=1 
  '
  declare @ParmDefinition nvarchar(500)
  set @ParmDefinition = N'@unqKey varchar(50)'
  execute sp_executesql @SQL,@ParmDefinition,@unqKey = @UniqueKey


    ----if default exists
--update #Temp set 
--(defalut col) = DEFAULT WHERE (defalut col) IS NULL

DECLARE @UpdSql NVARCHAR(MAX)  
SELECT  @UpdSql = COALESCE(@updSql, '') + 'UPDATE #Temp SET [' + name_field + '] = DEFAULT WHERE [' + name_field + '] IS NULL AND (Process_Type =''ADD'' and IsApplied=0)' 
FROM k_referential_tables_views_fields krf 
inner  join k_referential_tables_views krtv on krf.id_table_view=krtv.id_table_view
WHERE  krf.has_default_value=1 and krtv.name_table_view = @Table_Name --AND constraint_null_field=0

EXECUTE (@UpdSql)
  
  --Call Validate Sp
  exec [dbo].[Kernel_SP_Validate_TableValues] @Table_Name, '#Temp','C229313B5B83E4DDEADE3C11680AA4F5F'

  --Delete Rejected Data and Get Count Information
  declare @TotalCount int;
  declare @AcceptedCount int;
  declare @RejectedCount int;
  declare @TempDeleteScriptForSecurity nvarchar(max);
  declare @TempDeleteScriptByType nvarchar(max);
  declare @TempImportColumnsUpdate nvarchar(max);
  
  set @TotalCount = (select count(*) From #Temp)
   --Delete data by stg_error_status

  Declare @IdSecurityView INT;
  SELECT @IdSecurityView = id_object_security_table_view FROM k_referential_tables_views where name_table_view = @Table_Name

  --Delete data by security
  declare @insertErrorRecordForSecurity nvarchar(max) = N'';
  declare @PrmsResult2 nvarchar(max) = N'@uniqueKey varchar(50), @totalCount int';


  IF @IdSecurityView IS NOT NULL AND @WhereCriteria <> '' and @WhereCriteria is not null
  begin

  --Not Valid
 --Insert record not therefore validated into TempGridDataResult
	declare @notValidRecord nvarchar(max) = 
    N'insert into #TempGridDataResult
    select @uniqueKey, '+ @Staging_PK_Column + ', 1, @totalCount, 0, 0, NULL, 60006, Process_Type  from #Temp 
	where stg_error_status = 2 and 
	stg_error_status is not null and CHARINDEX(''['' + stg_error_status_description + '']'', '''+REPLACE(@WhereCriteria,'''','''''')+''' , 0) > 0' --60006: Not Valid Record
	execute sp_executesql @notValidRecord, @PrmsResult2, @uniqueKey = @UniqueKey, @totalCount = @TotalCount 	 
 --Delete Not Valid Record
    set @TempDeleteScriptByType = 'delete #Temp where stg_error_status = 2 and stg_error_status is not null and CHARINDEX(''['' + stg_error_status_description + '']'', '''+REPLACE(@WhereCriteria,'''','''''')+''' , 0) > 0'
    execute sp_executesql @TempDeleteScriptByType

  --Object Security
 --Insert record not therefore Object Security into TempGridDataResult
	set @insertErrorRecordForSecurity  =   
    N'insert into #TempGridDataResult
    select @uniqueKey, '+ @Staging_PK_Column + ', 1, @totalCount, 0, 0, NULL, 10011, Process_Type  from #Temp
    where C229313B5B83E4DDEADE3C11680AA4F5F not in (select C229313B5B83E4DDEADE3C11680AA4F5F from #Temp as MAINTABLE where ' + @WhereCriteria + ')' --10011 : Access denied.
    execute sp_executesql @insertErrorRecordForSecurity, @PrmsResult2, @uniqueKey = @UniqueKey, @totalCount = @TotalCount 

 --DontMatchReocords Delete
  set @TempDeleteScriptForSecurity = 
  N'delete #Temp where C229313B5B83E4DDEADE3C11680AA4F5F not in 
          (select C229313B5B83E4DDEADE3C11680AA4F5F from #Temp as MAINTABLE where ' + @WhereCriteria + ')'
  execute sp_executesql @TempDeleteScriptForSecurity
  end

   --For Column Filter
  IF @IdSecurityView IS NULL OR @IdSecurityView = '' AND @WhereCriteria <> '' and @WhereCriteria is not null
  BEGIN
   --Insert record not therefore Object Security into TempGridDataResult
	set @insertErrorRecordForSecurity  =   
    N'insert into #TempGridDataResult
    select @uniqueKey, '+ @Staging_PK_Column + ', 1, @totalCount, 0, 0, NULL, 10011, Process_Type  from #Temp
    where C229313B5B83E4DDEADE3C11680AA4F5F not in (select C229313B5B83E4DDEADE3C11680AA4F5F from #Temp as MAINTABLE where ' + @WhereCriteria + ')' --10011 : Access denied.
    execute sp_executesql @insertErrorRecordForSecurity, @PrmsResult2, @uniqueKey = @UniqueKey, @totalCount = @TotalCount 

	--DontMatchReocords Delete 
    set @TempDeleteScriptForSecurity = 
    N'delete #Temp where C229313B5B83E4DDEADE3C11680AA4F5F not in 
           (select C229313B5B83E4DDEADE3C11680AA4F5F from #Temp as MAINTABLE where ' + @WhereCriteria + ')'
  execute sp_executesql @TempDeleteScriptForSecurity
  END

       --Update  import columns in Temp Table
  set @TempImportColumnsUpdate = 'update #Temp set stg_import_id_user  = ' + Convert(nvarchar(max),@IdUser) + ', stg_import_date = GETUTCDATE()'
  execute sp_executesql @TempImportColumnsUpdate

  set @AcceptedCount = (select count(*) from #Temp) -- Accepted data count
  set @RejectedCount = @TotalCount - @AcceptedCount; -- Rejected data count
  update #TempGridDataResult set number_of_applied = @AcceptedCount, number_of_rejected = @RejectedCount  --Update Accepted and Rejected Data Count In #TempGridDataResult
  
  declare @updateQueryColumns nvarchar(max)=N''
  declare @updateQueryColumnsNotSim nvarchar(max)=N''
  declare @updateQueryAllColumns nvarchar(max)=N''
  declare @allColumns nvarchar(max)=N''
  declare @UpdateForMerge nvarchar(max)=N''
  declare @stagingTableStandardColumns nvarchar(max) = N'[stg_import_id_user],[stg_import_date],[stg_validate_id_user],[stg_validate_date],
  													   [stg_validate_status],[stg_validate_reject_status],[stg_error_status],[stg_error_status_description]'
  
  select 
  		@updateQueryAllColumns=@updateQueryAllColumns + (', t.['+tvc.name_field + '] = CASE WHEN s.[' + tvc.name_field  + '] = ''_null_'' THEN NULL ELSE s.[' +tvc.name_field +'] END '+ ', t.['+tvc.name_field + '_nvarchar] =  s.[' +tvc.name_field +'_nvarchar]'),
  		@allColumns=@allColumns +( ' ,['+tvc.name_field+']' + ' ,['+tvc.name_field+'_nvarchar]')
  from k_referential_tables_views_fields tvc 
  	inner join k_referential_tables_views tv
  		ON tvc.id_table_view = tv.id_table_view
  WHERE tv.name_table_view=@Table_Name
  and tvc.is_computed<>1 
  
  SET @updateQueryAllColumns=stuff(@updateQueryAllColumns,charindex(',',@updateQueryAllColumns,0),1,'')
  SET @allColumns=stuff(@allColumns,charindex(',',@allColumns,0),1,'')

begin try
begin transaction  
        
      declare @delQuery nvarchar(max);
      declare @modQuery nvarchar(max);
      
      
      --delete from table with temp table	
      set @delQuery ='MERGE INTO ' + @Staging_Table_Name + ' t
      	            USING #Temp s 
      		        ON  t.'+@Staging_PK_Column + ' = s.'+ @Staging_PK_Column + '
      	            WHEN MATCHED and Process_Type=''DLT''
      	            THEN DELETE;'
      exec(@delQuery)
      
      --modify table with temp table
      set @modQuery ='MERGE INTO ' + @Staging_Table_Name + ' t
      	            USING  #Temp s
      		        ON t.'+@Staging_PK_Column + ' = s.'+@Staging_PK_Column + '
      	            WHEN MATCHED and Process_Type=''UPD''
      	            THEN UPDATE SET ' + @updateQueryAllColumns + ', t.[stg_error_status] =  s.[stg_error_status];'
      exec(@modQuery)
      
      --insert to table with temp table
      declare @insertQuery nvarchar(max) = 'insert into ' + @Staging_Table_Name + '( ' + @allColumns + ',' + @stagingTableStandardColumns + ')
      										select ' + @allColumns + ',' + @stagingTableStandardColumns + ' from #Temp where Process_Type=''ADD'''
      exec(@insertQuery)
      
      --Insert histo record in k_referential_grid_import_histo
      if @FileName <> '' and @FileName is not null
      begin
      insert into k_referential_grid_import_histo([id_user], [import_date], [file_name], [number_of_records_in_file], [number_of_records_accepted], [number_of_records_rejected], [id_grid])
      values(@IdUser, @ImportDate, @FileName, @TotalCount, @AcceptedCount, @RejectedCount, @IdGrid)
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
	   	  --Insert Error Record Information Into #TempGridDataResult
   set @ErrorCode = (select ERROR_NUMBER());
   set @ErrorMessage = (select ERROR_MESSAGE())
   insert into #TempGridDataResult values (@UniqueKey, -1, 1, @TotalCount, @AcceptedCount, @RejectedCount, @ErrorMessage, @ErrorCode, 'Btc')
   
   delete from grid_data_temp_values where Unique_Key = @UniqueKey;

    end;
end catch

 exec [dbo].[Kernel_SP_Validate_TableValues] @Table_Name, @Staging_Table_Name,''
  --Delete temp data in grid_data_temp_values by Unique_Key
 delete grid_data_temp_values where Unique_Key = @UniqueKey

 --Return Operation Error Results
 select * from #TempGridDataResult