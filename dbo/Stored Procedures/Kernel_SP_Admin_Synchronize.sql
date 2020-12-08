CREATE PROCEDURE [dbo].[Kernel_SP_Admin_Synchronize]
(
	@IdTableView INT,
	@NameTableView Nvarchar(250)
)
AS
BEGIN

DECLARE @SynchronizationTable AS TABLE
(
	name_field sysname NULL,
	type_field nvarchar(128) NULL,
	length_field float NULL,
	contraint_null_field int NOT NULL,
	constraint_field sysname NULL,
	is_computed bit NULL,
	has_default_value int NULL,
	default_value nvarchar(max) NULL,
	numeric_precision int NULL,
	scale int NULL
)

INSERT INTO @SynchronizationTable
(name_field, type_field, length_field, contraint_null_field, constraint_field, is_computed, has_default_value, default_value,numeric_precision,scale)
SELECT ISC.COLUMN_NAME as name_field,
	   ISC.DATA_TYPE AS type_field,
	   (CASE
			WHEN (DATA_TYPE='decimal' OR DATA_TYPE='numeric')
				THEN CAST((CAST(NUMERIC_PRECISION AS NVARCHAR(MAX))+'.'+ CAST(NUMERIC_SCALE AS NVARCHAR(MAX))) AS FLOAT)
			WHEN (DATA_TYPE='float' OR DATA_TYPE='bigint' OR DATA_TYPE='tinyint' OR DATA_TYPE='smallint' OR DATA_TYPE='int')
				THEN CAST(CAST(NUMERIC_PRECISION AS NVARCHAR(MAX)) AS FLOAT)
			WHEN (DATA_TYPE='nvarchar' OR DATA_TYPE='varchar' OR DATA_TYPE='char' OR DATA_TYPE='nchar' OR DATA_TYPE='ntext' OR DATA_TYPE='binary' )
				THEN CAST(CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(MAX)) AS FLOAT)
				
				ELSE  NULL END) AS length_field,
		(CASE WHEN ISC.IS_NULLABLE='YES' THEN 1 ELSE 0 END) AS contraint_null_field,
		ISC.COLLATION_NAME AS constraint_field,
		C.is_computed is_computed,
		X.has_default_value AS has_default_value,
		X.default_value,
		(CASE WHEN (DATA_TYPE='decimal' OR DATA_TYPE='numeric')THEN NUMERIC_PRECISION ELSE  NULL END) AS numeric_precision,
	    (CASE WHEN (DATA_TYPE='decimal' OR DATA_TYPE='numeric')THEN NUMERIC_SCALE ELSE  NULL END) AS scale
  FROM INFORMATION_SCHEMA.COLUMNS ISC
	LEFT JOIN sys.columns as C on c.name=ISC.COLUMN_NAME AND ISC.TABLE_NAME = OBJECT_NAME(c.object_id)
	OUTER APPLY (
					SELECT	1 AS has_default_value
							,SC.name  name
							,SD.definition default_value
					  FROM sys.columns SC
						LEFT JOIN sys.tables ST ON ST.[object_id] = SC.object_id
						LEFT JOIN sys.views v on  v.object_id = SC.object_id
						INNER JOIN sys.default_constraints SD ON SC.[object_id] = SD.[parent_object_id] AND SC.column_id = SD.parent_column_id
					 WHERE (st.name = @NameTableView or v.name = @NameTableView) and SC.name = C.name
				) AS X
 WHERE TABLE_NAME= @NameTableView


DECLARE @IdGrid AS INT
DECLARE @NameColumn AS NVARCHAR(MAX)
DECLARE @TypeColumn AS NVARCHAR(MAX)
DECLARE @LengthColumn AS NVARCHAR(MAX)
DECLARE @ConstraintNullColumn AS BIT
DECLARE @ContraintColumn AS NVARCHAR(MAX)
DECLARE @IsComputed AS BIT
DECLARE @HasDefault AS BIT
DECLARE @DefaultValueDefinition AS NVARCHAR(MAX)
DECLARE @NumericPrecision AS INT
DECLARE @Scale AS INT
DECLARE field_cursor CURSOR FOR
SELECT name_field, type_field, length_field, contraint_null_field, constraint_field, is_computed, has_default_value, default_value,numeric_precision,scale
  FROM @SynchronizationTable
OPEN field_cursor

FETCH NEXT FROM field_cursor
INTO @NameColumn,@TypeColumn,@LengthColumn ,@ConstraintNullColumn,@ContraintColumn,@IsComputed,@HasDefault,@DefaultValueDefinition,@NumericPrecision,@Scale

WHILE @@FETCH_STATUS = 0
BEGIN
	IF EXISTS(SELECT * FROM dbo.k_referential_tables_views_fields WHERE id_table_view = @IdTableView AND name_field = @NameColumn)
	BEGIN
		UPDATE k_referential_tables_views_fields
		   SET	type_field = @TypeColumn
				,length_field = @LengthColumn
				,constraint_null_field = @ConstraintNullColumn
				,constraint_field = @ContraintColumn
				,order_field = 0
				,is_computed = @IsComputed
				,has_default_value = @HasDefault
				,default_value_definition = @DefaultValueDefinition
				,[precision] =@NumericPrecision
				,scale =@Scale
		 WHERE id_table_view = @IdTableView
		   AND name_field = @NameColumn
	END
	ELSE
	BEGIN
		INSERT INTO dbo.k_referential_tables_views_fields
		( 
			id_table_view
			, name_field, type_field
			, length_field
			, constraint_null_field
			, constraint_field
			, order_field
			, is_computed
			, has_default_value
			, default_value_definition 
			,[precision]
			,scale
		)
		VALUES 
		(
			@IdTableView
			, @NameColumn
			, @TypeColumn
			, @LengthColumn
			, @ConstraintNullColumn
			, @ContraintColumn
			, 0
			, @IsComputed
			, @HasDefault
			, @DefaultValueDefinition
			,@NumericPrecision
			,@Scale
		)
	END
	
	FETCH NEXT FROM field_cursor
	INTO @NameColumn,@TypeColumn,@LengthColumn,@ConstraintNullColumn,@ContraintColumn, @IsComputed,@HasDefault,@DefaultValueDefinition,@NumericPrecision,@Scale
END   
CLOSE field_cursor;  
DEALLOCATE field_cursor;  

-- USER GRID FIELDS
DELETE FROM k_user_grid_field 
WHERE id_grid_field IN(
	SELECT id_column FROM dbo.k_referential_grids_fields
	WHERE id_field IN (  
					SELECT id_field
					  FROM k_referential_tables_views_fields
					 WHERE id_table_view = @IdTableView
					   AND name_field NOT IN ( SELECT name_field FROM @SynchronizationTable)
				   )
)

-- GRID RELATIONS (CASCADED FIELDS)
DELETE FROM k_referential_grids_fields_relation
WHERE id_field_grid IN(
	SELECT id_column FROM dbo.k_referential_grids_fields
	WHERE id_field IN (  
					SELECT id_field
					  FROM k_referential_tables_views_fields
					 WHERE id_table_view = @IdTableView
					   AND name_field NOT IN ( SELECT name_field FROM @SynchronizationTable)
				   )
)

--GRID FIELDS
DELETE FROM dbo.k_referential_grids_fields
 WHERE id_field IN (  
					SELECT id_field
					  FROM k_referential_tables_views_fields
					 WHERE id_table_view = @IdTableView
					   AND name_field NOT IN ( SELECT name_field FROM @SynchronizationTable)
				   )
--CONSIDER BUSINESS OBJECTS
DELETE FROM k_program_cond_fields WHERE value_field_view = NULL

DELETE FROM dbo.k_program_cond_fields
 WHERE value_field_view IN (
							SELECT CAST(id_field AS nvarchar(50))
							  FROM k_referential_tables_views_fields
							 WHERE id_table_view = @IdTableView
							   AND name_field NOT IN ( SELECT name_field FROM @SynchronizationTable )
						   )   

--VALIDATION FIELDS

--Creating temp tables 
IF object_id(N'tempdb..#TempValidation') is not null
	DROP TABLE #TempValidation

CREATE TABLE #TempValidation  
( 
  IdFieldValidation INT 
);

INSERT INTO #TempValidation 
  SELECT id_grid_field_validation FROM k_referential_grid_field_validation_formula_items WHERE id_field IN (              
     SELECT id_field FROM dbo.k_referential_tables_views_fields
      WHERE id_table_view = @IdTableView
        AND name_field NOT IN ( SELECT name_field FROM @SynchronizationTable )
  ) 


--validation formula items
DELETE FROM k_referential_grid_field_validation_formula_items WHERE id_field IN (              
   SELECT id_field FROM dbo.k_referential_tables_views_fields
    WHERE id_table_view = @IdTableView
      AND name_field NOT IN ( SELECT name_field FROM @SynchronizationTable )
) 

DELETE FROM k_referential_grid_field_validation_formula_items WHERE id_grid_field_validation IN (
SELECT id_grid_field_validation FROM  k_referential_grid_field_validation WHERE id_field IN (       
   SELECT id_field FROM dbo.k_referential_tables_views_fields
    WHERE id_table_view = @IdTableView
      AND name_field NOT IN ( SELECT name_field FROM @SynchronizationTable )
	  )
) 

DELETE FROM k_referential_grid_field_validation_formula_items WHERE id_grid_field_validation IN (
	SELECT IdFieldValidation FROM #TempValidation
) 

--validation relations (cascaded fields)
DELETE FROM k_referential_grid_field_validation WHERE id_grid_field_validation IN (
 SELECT IdFieldValidation FROM #TempValidation
)

--validations
DELETE FROM k_referential_grid_field_validation WHERE id_field IN (              
   SELECT id_field FROM dbo.k_referential_tables_views_fields
    WHERE id_table_view = @IdTableView
      AND name_field NOT IN ( SELECT name_field FROM @SynchronizationTable )
) 

--LASTLY CLEAR TABLEVIEW FIELDS               
DELETE FROM dbo.k_referential_tables_views_fields
 WHERE id_table_view = @IdTableView
   AND name_field NOT IN ( SELECT name_field FROM @SynchronizationTable )  
END