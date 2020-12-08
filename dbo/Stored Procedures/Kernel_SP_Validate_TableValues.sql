CREATE PROCEDURE [dbo].[Kernel_SP_Validate_TableValues]
(
@sourceTableName NVARCHAR(MAX),
@stagingTableName NVARCHAR(MAX),
@stagingPK NVARCHAR(MAX)
)
AS
BEGIN
--STAGING TABLE PRIMARY KEY
IF @stagingPK = '' -- For Temp tables it should not be empty
BEGIN
	SELECT @stagingPK=col.COLUMN_NAME 
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC 
	INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE COL 
		ON COL.CONSTRAINT_NAME = TC.CONSTRAINT_NAME 
		AND COL.CONSTRAINT_SCHEMA = TC.CONSTRAINT_SCHEMA 
	WHERE TC.CONSTRAINT_TYPE = 'PRIMARY KEY' 
	AND COL.Table_name = @stagingTableName
END

-----------------
-- Source PK
DECLARE @sourcePK NVARCHAR(MAX) = N'';
SELECT @sourcePK=COL.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC 
	INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE COL 
	ON COL.CONSTRAINT_NAME = TC.CONSTRAINT_NAME 
	AND COL.CONSTRAINT_SCHEMA = TC.CONSTRAINT_SCHEMA 
WHERE TC.CONSTRAINT_TYPE = 'PRIMARY KEY' 
AND COL.Table_name = @sourceTableName 

------------------
--NULLABLE CHECK
DECLARE @nullable_check NVARCHAR(MAX)  = N'';

SELECT @nullable_check = @nullable_check +'
WHEN [' +COLUMN_NAME+'] IS NULL THEN ''' + COLUMN_NAME+'''
'
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @sourceTableName 
AND IS_NULLABLE='NO'
AND COLUMN_NAME <> @sourcePK 


------------------
-- PRIMARY KEY DUPLICATE CHECK
DECLARE @primary_key_control_where_cond NVARCHAR(MAX) = N'';
DECLARE @primary_key_control NVARCHAR(MAX) = N'';

SET @primary_key_control_where_cond =
'SELECT ['+@sourcePK+']
FROM '+@stagingTableName+'  
GROUP BY ['+@sourcePK+']
HAVING ( COUNT(['+@sourcePK+']) > 1 )'
SET @primary_key_control=' (['+@sourcePK+'] 
IN( '+@primary_key_control_where_cond+'))';
--------------------------------
-- FOREIGN KEY CONTROL
DECLARE @foreign_key_control NVARCHAR(MAX) = N'';

SELECT
@foreign_key_control = @foreign_key_control + 'WHEN ( ' + CU.COLUMN_NAME+' 
NOT IN'+'(
SELECT ['+ PT.COLUMN_NAME+'] 
FROM '+PK.TABLE_NAME+')
) 
THEN ''' +CU.COLUMN_NAME+''''
FROM
    INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
	INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK
		ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
	INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK
		ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
	INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU
		ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
	INNER JOIN (
				select 
					ro.name as TABLE_NAME
					,rc.name as COLUMN_NAME
				from sys.foreign_key_columns col
					join  sys.objects po
						on col.parent_object_id = po.object_id
					join  sys.objects ro
						on col.referenced_object_id = ro.object_id
					join  sys.columns pc
						on pc.object_id = col.parent_object_id and pc.column_id = col.parent_column_id
					join  sys.columns rc
						on rc.object_id = col.referenced_object_id and rc.column_id = col.referenced_column_id
				) PT
		ON PT.TABLE_NAME = PK.TABLE_NAME 
		WHERE FK.TABLE_NAME= @sourceTableName

--------------------------------------
-- TYPE CONVENIENT CONTROL

DECLARE @type_control NVARCHAR(MAX) = N'';
SELECT @type_control=@type_control+'
WHEN ['+COLUMN_NAME+'] IS NULL AND [' + COLUMN_NAME + '_nvarchar] IS NOT NULL THEN ''' + COLUMN_NAME + '''
' 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME=@sourceTableName

---------------------------------------
-- NVARCHAR VARCHAR LENGTH CONTROL
DECLARE @length_control NVARCHAR(MAX) = N''
SELECT @length_control=@length_control+'
WHEN LEN(['+CAST(COLUMN_NAME AS NVARCHAR(MAX))+'])>' + 
CAST(CHARACTER_MAXIMUM_LENGTH  AS NVARCHAR(MAX) ) + ' 
AND '+ CAST(CHARACTER_MAXIMUM_LENGTH  AS NVARCHAR(MAX) ) +'<> -1
THEN '''  + COLUMN_NAME + '''
'
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME=@sourceTableName 
AND (DATA_TYPE='NVARCHAR' or DATA_TYPE='VARCHAR')



 DECLARE @source_staging_control NVARCHAR(MAX)='

;
UPDATE '+@stagingTableName+' SET stg_error_status = 1, stg_error_status_description = NULL;

;WITH TableStatus
AS
(

	SELECT ['+@stagingPK+'], 
	CASE
	WHEN typeCheckInner is not null then 2
	WHEN nullableCheck is not null then 3
	WHEN foreignCheck  is not null then 4
	WHEN primaryCheck is not null then 5
	WHEN lengthCheck  is not null then 6
	END AS ErrorType,
	CASE
	WHEN typeCheckInner is not null then typeCheckInner
	WHEN nullableCheck is not null then nullableCheck
	WHEN foreignCheck  is not null then foreignCheck
	WHEN primaryCheck is not null then primaryCheck
	WHEN lengthCheck  is not null then lengthCheck
	END AS ErrorColumn
	FROM
	(
			SELECT ['+@stagingPK+'], 
			typeCheckInner,
			CASE WHEN 1=2 THEN ''''
				 WHEN typeCheckInner IS NOT NULL THEN ''''
				'+@nullable_check+'
				ELSE NULL
			END AS  nullableCheck
			,
			CASE WHEN 1=2 THEN ''''
				 WHEN typeCheckInner IS NOT NULL THEN ''''
				'+@foreign_key_control+'
				ELSE NULL
			END  AS foreignCheck
			,
			CASE WHEN 
				(
					'+@primary_key_control+'
				) THEN '''+@stagingPK+'''
				ELSE NULL
			END  AS primaryCheck
			,
			CASE WHEN 1=2 THEN ''''
				 WHEN typeCheckInner IS NOT NULL THEN ''''
				'+@length_control+'
				ELSE NULL
			END  AS lengthCheck
			FROM 
			( 
				SELECT
				*,
				CASE WHEN 1=2 THEN ''''
					'+@type_control+'
					ELSE NULL
				END  AS typeCheckInner
				FROM
				'+@stagingTableName+'
			) st
	) T
	WHERE typeCheckInner is not null
	OR nullableCheck is not null
	OR  foreignCheck is not null
	OR primaryCheck is not null
	OR lengthCheck is not null
)
UPDATE stg SET stg_error_status = s.ErrorType, stg.stg_error_status_description = s.ErrorColumn
FROM ' + @stagingTableName +' stg
JOIN TableStatus s
	ON stg.['+@stagingPK+'] = s.['+@stagingPK +']'
EXEC(@source_staging_control)

------------------------------------------
END