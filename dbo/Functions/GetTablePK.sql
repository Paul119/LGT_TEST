CREATE FUNCTION GetTablePK
(
	@Table_Name NVARCHAR(MAX)
)
RETURNS 
@Result TABLE 
(
	[PKColumn] NVARCHAR(MAX),
	[PKColumnAndType] NVARCHAR(MAX)
)
AS
BEGIN
	DECLARE @PK_Column NVARCHAR(max)
	DECLARE @PK_ColumnAndTypes NVARCHAR(MAX)

	SELECT 
		  @PK_Column = col_name(ic.object_id,ic.column_id)
		, @PK_ColumnAndTypes = col_name(ic.object_id,ic.column_id) + ' ' +  krtvf.type_field  + ',' 
	FROM sys.indexes AS i
	INNER JOIN sys.index_columns as ic
		ON i.object_id = ic.object_id
		and i.index_id = ic.index_id
	INNER JOIN k_referential_tables_views krtv
		ON object_id(krtv.name_table_view ) =  i.object_id
	INNER JOIN k_referential_tables_views_fields krtvf
		ON krtvf.id_table_view = krtv.id_table_view AND krtvf.name_field = col_name(ic.object_id,ic.column_id)
	 WHERE i.is_primary_key = 1 and i.object_id = object_id(@Table_Name)

	-- If table has not primary key , getting is_unique column name
	IF (@PK_Column IS NULL OR @PK_Column = '')
	BEGIN
		SELECT  @PK_Column = f.name_field, @PK_ColumnAndTypes = f.name_field + ' ' + f.type_field  + ',' 
		FROM k_referential_tables_views_fields f
		INNER JOIN k_referential_tables_views t ON t.id_table_view = f.id_table_view
		WHERE f.is_unique = 1 AND t.name_table_view =  @Table_Name
	END
	
	INSERT INTO @Result ([PKColumn], [PKColumnAndType]) VALUES (@PK_Column, @PK_ColumnAndTypes);

	RETURN 
END