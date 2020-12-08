CREATE PROC [dbo].[Kernel_SP_People_Hierarchy_PostPublish] 
		@idTree int, 
		@idTreePublished int, 
		@idUser int, 
		@idProfile int
AS
	Declare @Result bit = 1;
	Declare @Message nvarchar(max) = '';

	-- Logic here
	-- Set @Result and @Message


	select @Result as Continue_Flag , @Message as Message