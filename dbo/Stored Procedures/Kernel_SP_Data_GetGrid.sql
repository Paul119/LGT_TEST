CREATE  PROC [dbo].[Kernel_SP_Data_GetGrid]
(
	@IdGrid int,
	@PageNum int = -1,
	@PageSize int = -1,
	@WhereClause nvarchar(MAX),
	@SortBy nvarchar(MAX),
	@IdSim int = NULL,
	@HiddenWhereClause nvarchar(MAX),
	@Culture nvarchar(40),
	@ignoreAssocation bit = 0,
	@ForExcel bit = 0,
	@ParentWhereClause nvarchar(MAX) = N'',
	@isStaging bit = 0,
	@GetAllTableColumns bit =0,
	@FilterParameterType nvarchar(MAX),
	@FilterParameterValue nvarchar(MAX)
)
AS
BEGIN
DECLARE @NameTableView nvarchar(100);
DECLARE @SQL nvarchar(MAX);
DECLARE @IDTABLE_VIEW int;
DECLARE @RESULT nvarchar(4000);
DECLARE @RESULTWITHFOREIGN nvarchar(MAX) = '';
DECLARE @COLNAME nvarchar(255);
DECLARE @COLID nvarchar(255);
DECLARE @TYPE nvarchar(20);
DECLARE @ISFORONLYSORT bit;
DECLARE @GROUPINGFIELD int;
DECLARE @GROUPNAME nvarchar(100);
DECLARE @BetweenClause  Nvarchar(MAX);
declare @TableSize int;
DECLARE @IdSimStr nvarchar(MAX);
DECLARE @ISCONTAINPRIMARY bit = 0;
DECLARE @COLCOUNT bigint;
DECLARE @PRIMARYKEYNAME nvarchar(100);
DECLARE @IDSIMCHECK bit;
DECLARE @ISTREE bit;
DECLARE @OuterApplyJoins nvarchar(MAX)=N'';
DECLARE @HIDDENWHERECLAUSEWITHOUTSINGLEQUOTES nvarchar(MAX) = REPLACE(@HiddenWhereClause,'''','');
DECLARE @isLocalizationDisabled bit = 0;
DECLARE @LocalizationFields nvarchar(MAX) = '';
DECLARE @LocalizationJoin nvarchar(MAX) = '';
DECLARE @SQLDynamic nvarchar(max);

CREATE TABLE #tmp1 
(
cnt int
)
SELECT @isLocalizationDisabled = CASE WHEN value_parameter='True' THEN 1 ELSE 0 END FROM k_parameters where id_parameter = -44;

SELECT
	@IDTABLE_VIEW = ID_TABLE_VIEW ,
	@GROUPINGFIELD = grouping_field,
	@IDSIMCHECK = is_simulated,
	@ISTREE = is_tree
FROM dbo.k_referential_grids WITH (NOLOCK)
WHERE ID_GRID = @IdGrid;

SELECT @NameTableView = NAME_TABLE_VIEW
FROM dbo.K_REFERENTIAL_TABLES_VIEWS
WHERE ID_TABLE_VIEW = @IDTABLE_VIEW;

IF(@isStaging = 1)
BEGIN
	SET @NameTableView = @NameTableView + '_stg_' + CAST(@IdGrid AS nvarchar);
END

SELECT @PRIMARYKEYNAME = COL_NAME(ic.OBJECT_ID,ic.column_id)
FROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic
	ON i.OBJECT_ID = ic.OBJECT_ID AND i.index_id = ic.index_id
WHERE i.is_primary_key = 1
AND i.object_id= (SELECT object_id FROM sys.tables WHERE name = @NameTableView);

IF (@PRIMARYKEYNAME IS NULL OR @PRIMARYKEYNAME = '')
BEGIN
	SELECT  @PRIMARYKEYNAME = f.name_field
	FROM dbo.k_referential_tables_views_fields f
	INNER JOIN dbo.k_referential_tables_views t
		ON t.id_table_view = f.id_table_view
	WHERE f.is_unique = 1
		AND t.name_table_view =  @NameTableView
END

DECLARE @IDFIELD int;
SELECT @IDFIELD =	tbf.id_field
FROM dbo.k_referential_tables_views_fields tbf
INNER JOIN dbo.k_referential_tables_views tb
	ON tbf.id_table_view = tb.id_table_view
WHERE
	tb.name_table_view = @NameTableView
	AND tbf.name_field = @PRIMARYKEYNAME;

SELECT @GROUPNAME = NAME_FIELD
FROM dbo.k_referential_tables_views_fields
WHERE id_field = @GROUPINGFIELD;

IF @WhereClause = ''
BEGIN
	SET @WhereClause = NULL;
END

IF @SortBy = ''
BEGIN
	SET @SortBy = NULL;
END

IF @IdSim = 0
BEGIN
	SET @IdSim = NULL;
END

IF @IdSim IS NOT NULL
BEGIN
	SET @IdSimStr = CONVERT(nvarchar,@IdSim);
END

DECLARE @groupCol varchar(200);

SELECT @groupCol =CASE type_field WHEN 'xml' THEN 'CAST(['+name_field+'] AS VARCHAR(MAX))' ELSE '['+name_field+']' END          
FROM dbo.k_referential_tables_views_fields
WHERE id_field IN
(
	SELECT id_field
	FROM dbo.k_referential_grids_fields
	WHERE id_grid = @IdGrid AND group_index IS NOT NULL
)
IF @GetAllTableColumns=1
BEGIN
DECLARE CUSTLIST CURSOR FOR
	SELECT name_field, type_field, id_field, 0 AS [isForOnlySort]
	FROM dbo.k_referential_tables_views_fields  kf
	INNER JOIN dbo.k_referential_grids kg
		ON kf.id_table_view=kg.id_table_view
	WHERE kg.id_grid=@IdGrid
	ORDER BY order_field
END
ELSE
BEGIN
DECLARE CUSTLIST CURSOR FOR
SELECT name_field, type_field, id_field,[isForOnlySort] FROM
(
	SELECT name_field, type_field, id_field, order_field, 0 AS [isForOnlySort]
	FROM dbo.k_referential_tables_views_fields
	WHERE id_field IN (
		SELECT id_field FROM dbo.k_referential_grids_fields WHERE id_grid = @IdGrid
		UNION
		SELECT [child_id_table_view_field] AS id_field FROM dbo.k_referential_grids WHERE id_grid = @IdGrid AND [is_tree] = 1  AND (@IDFIELD IS NULL OR [child_id_table_view_field] <> @IDFIELD)
		UNION
		SELECT [parent_id_table_view_field] AS id_field FROM dbo.k_referential_grids WHERE id_grid = @IdGrid AND [is_tree] = 1  AND (@IDFIELD IS NULL OR [child_id_table_view_field] <> @IDFIELD)
		)
	UNION
	SELECT name_field, type_field, id_field, order_field, 0 AS [isForOnlySort]
	FROM dbo.k_referential_tables_views_fields
	WHERE id_field IN (
		SELECT formulaItem.id_field
		FROM dbo.k_referential_grid_field_validation_formula_items formulaItem
		INNER JOIN dbo.k_referential_tables_views_fields tableViewField ON formulaItem.id_field = tableViewField.id_field
		LEFT JOIN  [dbo].[k_referential_grids_fields] gridFields ON gridFields.id_field = tableViewField.id_field 
		WHERE tableViewField.id_table_view = @IDTABLE_VIEW 
		AND ((id_grid=@IdGrid AND @ForExcel = 1) OR @ForExcel = 0)
	)
	UNION
	SELECT name_field, type_field, id_field,order_field, 1 AS [isForOnlySort] FROM dbo.k_referential_tables_views_fields tvf
	INNER JOIN dbo.k_referential_grids g ON g.id_table_view = tvf.id_table_view
	WHERE g.id_grid = @IdGrid AND CHARINDEX('[' + tvf.name_field + ']', @SortBy) > -1 AND tvf.id_field NOT IN (
		SELECT id_field FROM dbo.k_referential_grids_fields WHERE id_grid = @IdGrid
		UNION
		SELECT [child_id_table_view_field] AS id_field FROM dbo.k_referential_grids WHERE id_grid = @IdGrid AND [is_tree] = 1  AND (@IDFIELD IS NULL OR [child_id_table_view_field] <> @IDFIELD)
		UNION
		SELECT [parent_id_table_view_field] AS id_field FROM dbo.k_referential_grids WHERE id_grid = @IdGrid AND [is_tree] = 1  AND (@IDFIELD IS NULL OR [child_id_table_view_field] <> @IDFIELD)
		UNION
		SELECT id_field FROM dbo.k_referential_tables_views_fields WHERE id_field IN (
			SELECT formulaItem.id_field
			FROM dbo.k_referential_grid_field_validation_formula_items formulaItem
			INNER JOIN dbo.k_referential_tables_views_fields tableViewField ON formulaItem.id_field = tableViewField.id_field
			LEFT JOIN  [dbo].[k_referential_grids_fields] gridFields ON gridFields.id_field = tableViewField.id_field 
		WHERE tableViewField.id_table_view = @IDTABLE_VIEW 
		AND ((id_grid=@IdGrid AND @ForExcel = 1) OR @ForExcel = 0)
		)
	) AND id_field <> @IDFIELD

) TABLE_FIELDS
ORDER BY order_field
END

OPEN CUSTLIST
FETCH NEXT FROM CUSTLIST
INTO @COLNAME, @TYPE, @COLID, @ISFORONLYSORT
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @FOREIGN_INCLUDED AS nvarchar(MAX)
	DECLARE @USECOMBO bit = 0
	DECLARE @USECOMBO_MULTI bit = 0

	IF EXISTS (SELECT TOP 1 1 FROM dbo.k_referential_grids_fields WHERE id_field = @COLID AND id_grid = @IdGrid AND [combo_type] IN (-1, -2))
		SET @USECOMBO = 1

	IF EXISTS (SELECT TOP 1 1 FROM dbo.k_referential_grids_fields WHERE id_field = @COLID AND id_grid = @IdGrid AND [combo_type] IN (-3, -4))
		SET @USECOMBO_MULTI = 1

	DECLARE @ISLOCALIZABLE AS bit = 0;

	IF @USECOMBO_MULTI = 0
	BEGIN
		IF @isLocalizationDisabled = 0
		BEGIN
			SET @ISLOCALIZABLE = (SELECT is_localizable FROM dbo.k_referential_tables_views_fields WHERE id_field = @COLID)
		END
		
		IF @ISLOCALIZABLE = 1
		BEGIN
			SET @ISLOCALIZABLE = 
				CASE
					WHEN EXISTS(
						SELECT 1 FROM  k_referential_tables_views_fields WHERE id_field = @COLID AND type_field in ('char', 'varchar', 'text', 'nchar', 'nvarchar', 'ntext')
					) THEN 1
					ELSE 0
				END

			IF @ISLOCALIZABLE = 1
			BEGIN
				SET @LocalizationJoin = @LocalizationJoin +  
				'LEFT JOIN
				(SELECT *
				 FROM (
							 SELECT  name, 
										value as rps_loc_value, 
										ROW_NUMBER() OVER(PARTITION BY name ORDER BY localization_id ASC) rps_localization_sub_query
									FROM rps_localization
									 WHERE [culture] = ''''' + @Culture + '''''
							) rps_localization_query
					 WHERE rps_localization_sub_query = 1) AS  [loc' + @COLNAME + '] on MAINTABLE.['+ @COLNAME + '] = [loc' + @COLNAME + '].[name]'
			END
		END
	END

	--FOREIGN KEY HANDLING--
	IF @USECOMBO = 1 OR (@USECOMBO_MULTI = 1 AND @ForExcel = 1)
	BEGIN
		DECLARE @COMBOSOURCE AS nvarchar(MAX);
		SET @COMBOSOURCE = (
			SELECT TOP 1 combo_datasource_name
			FROM dbo.k_referential_grids_fields
			WHERE id_field=@COLID AND id_grid=@IdGrid
		)

		DECLARE @COMBOTEXTFIELD AS nvarchar(MAX) = 
			(SELECT TOP 1 combo_datatextfield_name FROM dbo.k_referential_grids_fields WHERE id_field=@COLID AND id_grid=@IdGrid);
		DECLARE @COMBOVALUEFIELD AS nvarchar(MAX) = 
			(SELECT TOP 1 combo_datavaluefield_name FROM dbo.k_referential_grids_fields WHERE id_field=@COLID AND id_grid=@IdGrid);

		DECLARE @ISCOMBOFIELDLOCALIZABLE bit = 0;
		IF @isLocalizationDisabled = 0
		BEGIN
				SELECT TOP 1 @ISCOMBOFIELDLOCALIZABLE = is_localizable
				FROM dbo.k_referential_tables_views_fields
				WHERE id_table_view IN
				(
					SELECT TOP 1 id_table_view FROM dbo.k_referential_tables_views WHERE name_table_view = @COMBOSOURCE
				)
				AND name_field = @COMBOTEXTFIELD
		END

		IF @ISCOMBOFIELDLOCALIZABLE = 1
		BEGIN
			IF @USECOMBO = 1
			BEGIN
				IF @isStaging = 1
					SET @FOREIGN_INCLUDED = '(SELECT TOP 1 ISNULL(loc.rps_loc_value, [' + @COMBOTEXTFIELD + ']) AS ['+ @COMBOTEXTFIELD + ']' +
						' FROM [' + @COMBOSOURCE + ']' +
						' src LEFT JOIN (SELECT [value] AS dbo.rps_loc_value,name FROM dbo.rps_Localization l WHERE l.[culture] = '''''+@Culture+''''') AS loc ON src.'
						+ @COMBOTEXTFIELD +' = loc.[name] WHERE CAST(src.[' + @COMBOVALUEFIELD + '] AS nvarchar(MAX)) = MAINTABLE.['+@COLNAME +']) AS [' + @COLNAME + ']'+

						',(SELECT TOP 1 ISNULL(loc.rps_loc_value, [' + @COMBOVALUEFIELD + ']) AS ['+ @COMBOVALUEFIELD + ']' +
						' FROM [' + @COMBOSOURCE + ']' +
						' src LEFT JOIN (SELECT [value] AS dbo.rps_loc_value,name FROM dbo.rps_Localization l WHERE l.[culture] = '''''+@Culture+''''') AS loc ON CONVERT(VARCHAR,src.'
						+ @COMBOVALUEFIELD +') = loc.[name] WHERE CAST(src.[' + @COMBOVALUEFIELD + '] AS nvarchar(MAX)) = MAINTABLE.['+@COLNAME +']) AS [' + @COLNAME + '_id]'
				ELSE
					SET @FOREIGN_INCLUDED = '(SELECT TOP 1 ISNULL(loc.rps_loc_value, [' + @COMBOTEXTFIELD + ']) AS ['+ @COMBOTEXTFIELD + ']' +
						' FROM [' + @COMBOSOURCE + ']' +
						' src LEFT JOIN (SELECT [value] AS rps_loc_value,name FROM dbo.rps_Localization l WHERE l.[culture] = '''''+@Culture+''''') AS loc ON src.'
						+ @COMBOTEXTFIELD +' = loc.[name] WHERE src.[' + @COMBOVALUEFIELD + '] = MAINTABLE.['+@COLNAME +']) AS [' + @COLNAME + ']'+

						',(SELECT TOP 1 ISNULL(loc.rps_loc_value, [' + @COMBOVALUEFIELD + ']) AS ['+ @COMBOVALUEFIELD + ']' +
						' FROM [' + @COMBOSOURCE + ']' +
						' src LEFT JOIN (SELECT [value] AS rps_loc_value,name FROM dbo.rps_Localization l WHERE l.[culture] = '''''+@Culture+''''') AS loc ON  CONVERT(VARCHAR,src.'
						+ @COMBOVALUEFIELD +') = loc.[name] WHERE src.[' + @COMBOVALUEFIELD + '] = MAINTABLE.['+@COLNAME +']) AS [' + @COLNAME + '_id]'
			END
			IF @USECOMBO_MULTI = 1
			BEGIN
				SET @FOREIGN_INCLUDED = CAST(@COLNAME AS nvarchar(MAX)) + '.' + CAST(@COLNAME AS nvarchar(MAX));
				SET @OuterApplyJoins = @OuterApplyJoins + ' OUTER APPLY ( ' +
				' SELECT STUFF ( ( ' +
				' SELECT '''','''' + [value] AS rps_loc_value FROM ' +
				'(SELECT ISNULL(loc.rps_loc_value, [' + @COMBOTEXTFIELD + ']) AS [value] AS rps_loc_value FROM dbo.udf_Split2(MAINTABLE.[' + CAST(@COLNAME AS nvarchar(MAX)) + '],'''','''') s	' +
					'INNER JOIN '+@COMBOSOURCE+' p ON p.' + @COMBOVALUEFIELD + '= s.Item ' +
					'OUTER APPLY (SELECT TOP 1 * FROM dbo.rps_Localization l WHERE l.[culture] = '''''+@Culture+''''' AND l.[name] = p.[' + @COMBOTEXTFIELD + ']) loc' +
				') m ' +
				' FOR XML PATH('''''''') ' +
			' ) ,1,1,'''''''' ) as [' + CAST(@COLNAME AS nvarchar(MAX)) + '] ) ' + CAST(@COLNAME AS nvarchar(MAX)) + ' ';

			END
		END
		ELSE
		BEGIN
			IF @USECOMBO = 1
			BEGIN		
				SET @FOREIGN_INCLUDED = 
				CASE @ignoreAssocation
					WHEN 0 THEN 
					'(SELECT TOP 1 [' + @COMBOTEXTFIELD + '] FROM [' + @COMBOSOURCE + '] WHERE [' + @COMBOSOURCE + '].[' + @COMBOVALUEFIELD + '] = MAINTABLE.[' + @COLNAME + '] ) AS [' + @COLNAME + '] 
					, (SELECT TOP 1 [' + @COMBOVALUEFIELD + '] FROM [' + @COMBOSOURCE + '] WHERE [' + @COMBOSOURCE + '].[' + @COMBOVALUEFIELD + '] = MAINTABLE.[' + @COLNAME + '] ) AS [' + @COLNAME + '_id]'
					WHEN 1 THEN @COLNAME
				END
			END
					--SET @FOREIGN_INCLUDED = 
					--	CASE @ignoreAssocation
					--		WHEN 0 THEN '(SELECT TOP 1 [' + @COMBOTEXTFIELD + '] FROM [' + @COMBOSOURCE + '] WHERE [' + @COMBOSOURCE + '].[' + @COMBOVALUEFIELD + '] = MAINTABLE.[' + @COLNAME + '] ) AS [' + @COLNAME + ']'
					--		WHEN 1 THEN @COLNAME
					--	END
			IF @USECOMBO_MULTI = 1
			BEGIN
				SET @FOREIGN_INCLUDED = CAST(@COLNAME AS nvarchar(MAX)) + '.' + CAST(@COLNAME AS nvarchar(MAX));
				SET @OuterApplyJoins = @OuterApplyJoins + ' OUTER APPLY ( ' +
				' SELECT STUFF ( ( ' +
				' SELECT '''','''' + [' + @COMBOTEXTFIELD + '] FROM ' +
				'(SELECT * FROM dbo.udf_Split2(MAINTABLE.[' + CAST(@COLNAME AS nvarchar(MAX)) + '],'''','''') s	' +
					'JOIN '+@COMBOSOURCE+' p ON p.' + @COMBOVALUEFIELD + '= s.Item) m ' +
				' FOR XML PATH('''''''') ' +
			' ) ,1,1,'''''''' ) as [' + CAST(@COLNAME AS nvarchar(MAX)) + '] ) ' + CAST(@COLNAME AS nvarchar(MAX)) + ' ';

			END
		END
	END
	--@RESULTWITHFOREIGN
	IF @ISFORONLYSORT = 0
		SET @LocalizationFields = @LocalizationFields + ', ' + '[' + @COLNAME + ']';

	IF @USECOMBO = 1 AND @ForExcel = 0
	BEGIN
		SET @LocalizationFields = @LocalizationFields + ', ' + '[' + @COLNAME + '_id]';
	END

	IF @USECOMBO = 1 OR (@USECOMBO_MULTI = 1 AND @ForExcel = 1)
	BEGIN
		SET @RESULTWITHFOREIGN = @RESULTWITHFOREIGN + ', ' + @FOREIGN_INCLUDED;
	END
	ELSE
	BEGIN
		IF @ISLOCALIZABLE = 1
		BEGIN
			SET @RESULTWITHFOREIGN = @RESULTWITHFOREIGN + ', ISNULL(loc' + @COLNAME + '.rps_loc_value,' + 'MAINTABLE.[' + @COLNAME + ']) AS [' + @COLNAME + ']';
		END
		ELSE
		BEGIN
			SET @RESULTWITHFOREIGN = @RESULTWITHFOREIGN + ', ' + '[' + @COLNAME + ']';
		END
	END
	FETCH NEXT FROM CUSTLIST INTO @COLNAME, @TYPE, @COLID, @ISFORONLYSORT
END
CLOSE CUSTLIST
DEALLOCATE CUSTLIST

SET @LocalizationFields = SUBSTRING (@LocalizationFields, 2, LEN(@LocalizationFields))
SET @RESULTWITHFOREIGN = SUBSTRING (@RESULTWITHFOREIGN, 2, LEN(@RESULTWITHFOREIGN))

SELECT @PRIMARYKEYNAME = COL_NAME(ic.OBJECT_ID,ic.column_id)
FROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic
	ON i.OBJECT_ID = ic.OBJECT_ID AND i.index_id = ic.index_id
WHERE i.is_primary_key = 1
AND i.object_id= (SELECT object_id FROM sys.tables WHERE name = @NameTableView)

SELECT @IDFIELD =	tbf.id_field
FROM dbo.k_referential_tables_views_fields tbf
INNER JOIN dbo.k_referential_tables_views tb
	ON tbf.id_table_view = tb.id_table_view
WHERE
	tb.name_table_view = @NameTableView
	AND tbf.name_field = @PRIMARYKEYNAME

IF EXISTS(SELECT TOP 1 1 FROM dbo.k_referential_grids_fields WITH (NOLOCK) WHERE id_grid = @IdGrid AND id_field = @IDFIELD )
BEGIN
	SET @ISCONTAINPRIMARY = 1;
END

IF(@PRIMARYKEYNAME  IS NOT NULL AND @ISCONTAINPRIMARY = 0 )  
BEGIN    
    if CHARINDEX('['+@PRIMARYKEYNAME+']',@LocalizationFields) = 0
	   SET @LocalizationFields = '['+@PRIMARYKEYNAME+']' + ', '+ @LocalizationFields;    
    SET @RESULT = '['+@PRIMARYKEYNAME+']' + ', '+ @RESULT;     
	IF @GetAllTableColumns = 0 
		SET @RESULTWITHFOREIGN = '['+@PRIMARYKEYNAME+']' + ', '+ @RESULTWITHFOREIGN; 
END

IF @PageNum = -1  
	BEGIN  
	 SET @BetweenClause = ' ';  
	END  
ELSE IF @PageNum  = 0    
	BEGIN    
	  SET @BetweenClause = ' AND RowNum BETWEEN 1 AND ' + CONVERT(nvarchar,@PageSize);    
	END    
ELSE    
	BEGIN
		SET  @BetweenClause = ' AND RowNum BETWEEN ( '+ CONVERT(nvarchar,@PageNum) +' * '+ CONVERT(nvarchar,@PageSize) +'+1) AND (( '+ CONVERT(nvarchar,@PageNum) +' + 1) * '+ CONVERT(nvarchar,@PageSize)+') '    
	END

IF @SortBy IS NULL
BEGIN
	IF @groupCol IS NOT NULL
	BEGIN
		SET @SortBy = @groupCol;
	END
	ELSE
	BEGIN
		IF (@PRIMARYKEYNAME IS NULL OR @PRIMARYKEYNAME = '')
		BEGIN
			SET @SortBy = ' (SELECT NULL)'
		END
		ELSE
		BEGIN
				SET @SortBy = '['+ @PRIMARYKEYNAME + '] ASC '
				
				IF NOT EXISTS (SELECT * FROM k_referential_grids_fields WHERE id_grid = @IdGrid)
				BEGIN
					SET @SortBy = NULL
				END
		END
	END
END

IF @WhereClause IS NULL
BEGIN
	SET @WhereClause = ' WHERE 1=1 ';
END

DECLARE @TotalCountSQL nvarchar(MAX);
DECLARE @CommonSQL nvarchar(MAX);

DECLARE @CountChildrenSQL nvarchar(MAX) = N'';
DECLARE @CountChildrenSelectSQL nvarchar(MAX) = N'';

IF @ISTREE = 1
BEGIN
	DECLARE @parentFieldName nvarchar(MAX);
	DECLARE @childFieldName nvarchar(MAX);
	DECLARE @childWhereClause nvarchar(MAX);

	SELECT
		@parentFieldName = [F1].name_field,
		@childFieldName = [F2].name_field
	FROM k_referential_grids AS [G]
	INNER JOIN dbo.k_referential_tables_views_fields AS [F1]
		ON [G].parent_id_table_view_field = [F1].id_field
	INNER JOIN dbo.k_referential_tables_views_fields AS [F2]
		ON [G].child_id_table_view_field = [F2].id_field
	WHERE [G].id_grid = @IdGrid;

	SET @childWhereClause = REPLACE(@WhereClause, 'WHERE', '');

	IF(LEN(REPLACE(@HiddenWhereClause, 'WHERE', '')) > 0)
		SET @childWhereClause = @childWhereClause + ' AND ' + REPLACE(@HiddenWhereClause, 'WHERE', '');

	SET @CountChildrenSelectSQL = N', ISNULL([HC].leaf, ''''true'''') AS leaf';
	SET @CountChildrenSQL = N' OUTER APPLY (SELECT TOP 1 ''''false'''' AS [leaf] FROM [' + @NameTableView + '] AS [C] WHERE [C].[' + @parentFieldName + '] = MAINTABLE.[' + @childFieldName + '] AND ' + @childWhereClause + ') AS [HC] ';
END

IF @IdSim IS NOT NULL
BEGIN
	SET @CommonSQL =  ' (SELECT ' + @RESULTWITHFOREIGN +' FROM ' + @NameTableView + ' AS MAINTABLE '+ @LocalizationJoin + @OuterApplyJoins + ' ' + @HiddenWhereClause + @ParentWhereClause + ' AND typeModification != 2 AND idSim = ' + CAST (@IdSim AS nvarchar(20))
		+ ' UNION SELECT ' + @RESULTWITHFOREIGN +' FROM ' + @NameTableView + ' AS MAINTABLE '+ @LocalizationJoin + ' ' + @HiddenWhereClause
		+ ' AND idSim = 0 AND ' + @PRIMARYKEYNAME + ' NOT IN ( SELECT idOrg FROM ' + @NameTableView
		+ ' WHERE idSim = '+ CAST (@IdSim AS nvarchar(20))+' AND idOrg IS NOT NULL)'
		+ ' ) SUB ';
END
ELSE
BEGIN
	IF(@IDSIMCHECK <> 0)
		BEGIN
			IF CHARINDEX('[idSim]', @RESULTWITHFOREIGN) = 0
			BEGIN
				SET @RESULTWITHFOREIGN = @RESULTWITHFOREIGN + ', [idSim]';
			END
			IF CHARINDEX('[idSim]', @LocalizationFields) = 0
			BEGIN
				SET @LocalizationFields = @LocalizationFields + ', [idSim]';
			END
			SET @WhereClause = @WhereClause + ' AND idSim = 0 ';
		END
	IF (@isStaging = 1)
			BEGIN
			SET @LocalizationFields = @LocalizationFields + ',[stg_import_id_user]
			,[stg_validate_id_user],[stg_import_date],[stg_validate_date],
			[stg_validate_status],[stg_validate_reject_status],[stg_error_status],[stg_error_status_description],[stg_publish_reject_reason]';

			SET @CommonSQL = '
			(
			SELECT * FROM
			(
				SELECT ' + @RESULTWITHFOREIGN +'
				, U1.firstname_user_stg + '''' '''' + U1.lastname_user_stg as stg_import_id_user
				, U2.firstname_user_stg + '''' ''''+ U2.lastname_user_stg as stg_validate_id_user
				,MAINTABLE.stg_import_date
				,MAINTABLE.stg_validate_date
				,MAINTABLE.stg_validate_status
				,MAINTABLE.stg_validate_reject_status
				,ISNULL(L2.rps_loc_value, MAINTABLE.stg_publish_reject_reason) AS stg_publish_reject_reason
				,ISNULL(L.rps_loc_value, EC.error_detail) stg_error_status
				,MAINTABLE.stg_error_status_description ' +
				' FROM ' + @NameTableView + ' AS MAINTABLE '+ @LocalizationJoin + @OuterApplyJoins +
				'
				LEFT OUTER JOIN (SELECT id_user AS id_user_stg, firstname_user AS firstname_user_stg, lastname_user AS lastname_user_stg FROM dbo.k_users ) U1 ON U1.id_user_stg = MAINTABLE.stg_import_id_user
				LEFT OUTER JOIN (SELECT id_user AS id_user_stg, firstname_user AS firstname_user_stg, lastname_user AS lastname_user_stg FROM dbo.k_users ) U2 ON U2.id_user_stg = MAINTABLE.stg_validate_id_user
				LEFT OUTER JOIN
				(
					SELECT 1 AS id_error, ''''INF_Stg_Valid'''' AS error_detail
					UNION ALL
					SELECT 2 AS id_error, ''''INF_Stg_TypeError'''' AS error_detail
					UNION ALL
					SELECT 3 AS id_error, ''''INF_Stg_NullableError'''' AS error_detail
					UNION ALL
					SELECT 4 AS id_error, ''''INF_Stg_ForeignError'''' AS error_detail
					UNION ALL
					SELECT 5 AS id_error, ''''INF_Stg_PrimaryError'''' AS error_detail
					UNION ALL
					SELECT 6 AS id_error, ''''INF_Stg_LengthError'''' AS error_detail
				) EC ON MAINTABLE.stg_error_status = EC.id_error
				OUTER APPLY (SELECT TOP 1 value AS rps_loc_value FROM dbo.rps_Localization L WHERE L.name = EC.error_detail AND culture = ''''' + @Culture + ''''') L
				OUTER APPLY (SELECT TOP 1 value AS rps_loc_value FROM dbo.rps_Localization L2 WHERE L2.name = MAINTABLE.stg_publish_reject_reason AND L2.culture = ''''' + @Culture + ''''') L2
				WHERE 1=1
				AND (MAINTABLE.stg_error_status <> 2 OR CHARINDEX(''''['''' + MAINTABLE.stg_error_status_description + '''']'''', '''''+ @HIDDENWHERECLAUSEWITHOUTSINGLEQUOTES +''''' , 0) = 0)
			) AS MAINTABLE
			 '
			+ @HiddenWhereClause +') SUB
			 ';
			END
	ELSE
	BEGIN
		SET @CommonSQL = ' (SELECT ' + @RESULTWITHFOREIGN +' FROM ' + @NameTableView + ' AS MAINTABLE '+ @LocalizationJoin + @OuterApplyJoins + ' ' + @HiddenWhereClause + @ParentWhereClause +') SUB ';
	END
END

SET @TotalCountSQL = 'WITH GridRN AS ( SELECT 1 AS ColumnName FROM ' + @CommonSQL + @WhereClause + ' ) INSERT INTO #tmp1 SELECT COUNT(*) AS cnt FROM GridRN MAINTABLE';
SET @SQL =  'WITH GridRN AS ( SELECT *,ROW_NUMBER() OVER(ORDER BY '+ @SortBy +') AS RowNum FROM' + @CommonSQL + @WhereClause + ' ) SELECT ' +
			@LocalizationFields + @CountChildrenSelectSQL + ' FROM GridRN MAINTABLE ' + @CountChildrenSQL + 'WHERE 1=1 ' + @BetweenClause +' ORDER BY ' + @SortBy +' ; ' + @TotalCountSQL;


IF NULLIF(@FilterParameterValue, '') IS NULL
	SET @SQLDynamic =  N'exec sp_executesql N'''+@SQL+''' ,N'''+@FilterParameterType+''''
ELSE
	SET @SQLDynamic =  N'exec sp_executesql N'''+@SQL+''' ,N'''+@FilterParameterType +''','+@FilterParameterValue
execute sp_executesql @SQLdynamic

Print @SQLDynamic;
set @TableSize=( select * from  #tmp1 )

	 
IF @TableSize IS NULL
	SET @TableSize = 1
RETURN  @TableSize 
END