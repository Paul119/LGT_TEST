CREATE FUNCTION [dbo].[udf_Split](@STRING nvarchar(MAX), @Delimiter char(1))
RETURNS @Results TABLE (Item nvarchar(MAX), Position INT)
AS
    BEGIN
    DECLARE @INDEX INT
    DECLARE @SLICE nvarchar(4000)
    DECLARE @POSITION INT
    SET @INDEX = 1
    SET @POSITION = 1
    IF @STRING IS NULL RETURN
    WHILE @INDEX !=0
        BEGIN 
         SELECT @INDEX = CHARINDEX(@Delimiter,@STRING)
         IF @INDEX !=0
          SELECT @SLICE = RTRIM(LTRIM(LEFT(@STRING,@INDEX - 1)))
         ELSE
          SELECT @SLICE = RTRIM(LTRIM(@STRING))
         INSERT INTO @Results(Item, Position) VALUES(@SLICE, @POSITION)
         SELECT @STRING = RIGHT(@STRING,LEN(@STRING) - @INDEX)
         SET @POSITION = @POSITION + 1
         IF LEN(@STRING) = 0 BREAK
    END
    RETURN
END