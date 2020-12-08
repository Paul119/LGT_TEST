CREATE PROCEDURE [dbo].[Kernel_SP_Admin_CheckColumn]
@EssentialFields nvarchar(max),@TableName nvarchar(100)
AS
BEGIN
      DECLARE @ColumnName nvarchar(50),@Result int
      DECLARE ColumnNameCursor CURSOR FOR
            select Item 
            from udf_Split
            ((select @EssentialFields) , ',')
      OPEN ColumnNameCursor
      FETCH NEXT FROM ColumnNameCursor INTO @ColumnName
      WHILE @@FETCH_STATUS = 0
            BEGIN
                  SET @Result =     (select COUNT(0) 
                                            from
                                         (select COLUMN_NAME 
                                            from INFORMATION_SCHEMA.COLUMNS 
                                           where table_name = @TableName) as K
                                           where @ColumnName in (select K.COLUMN_NAME))                         
                  IF @Result = 0
                        Begin
                             CLOSE ColumnNameCursor
                             DEALLOCATE ColumnNameCursor        
                             RETURN 0
                        End         
                  FETCH NEXT FROM ColumnNameCursor INTO @ColumnName
            END
      CLOSE ColumnNameCursor
      DEALLOCATE ColumnNameCursor 
      RETURN 1  
END