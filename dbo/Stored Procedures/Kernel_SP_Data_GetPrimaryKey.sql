CREATE PROCEDURE [dbo].[Kernel_SP_Data_GetPrimaryKey] (@TableName NVARCHAR(100))
AS
BEGIN

SELECT id_field AS 'fieldId' 
  FROM dbo.k_referential_tables_views_fields wf
  JOIN dbo.k_referential_tables_views tb ON wf.id_table_view = tb.id_table_view
 WHERE tb.name_table_view = @TableName
   AND name_field IN(

SELECT COL_NAME(ic.OBJECT_ID,ic.column_id)          
                                       FROM sys.indexes AS i          
                                       INNER JOIN sys.index_columns AS ic
                                       
                                       ON i.OBJECT_ID = ic.OBJECT_ID          
                                       AND i.index_id = ic.index_id          
                                       WHERE i.is_primary_key = 1          
                                       AND i.object_id= (select object_id from sys.tables where name = @TableName) )


END