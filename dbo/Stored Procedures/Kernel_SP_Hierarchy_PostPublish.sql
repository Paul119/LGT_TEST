CREATE PROC dbo.Kernel_SP_Hierarchy_PostPublish 
		@idTree int, 
		@idTreePublished int, 
		@idUser int, 
		@idProfile int
AS
	Declare @Result bit = 1;
	Declare @Message nvarchar(max) = '';

	--Mandatory Call to fill hm_NodeLinkPublishedHierarchy
	EXEC Kernel_SP_Hierarchy_Populate @idTreePublished
	
	-- Call Custom stored procedure to manage project specific needs
	--EXEC Kernel_SP_People_Hierarchy_PostPublish @idTree, @idTreePublished, @idUser, @idProfile


	--select @Result as Continue_Flag , @Message as Message