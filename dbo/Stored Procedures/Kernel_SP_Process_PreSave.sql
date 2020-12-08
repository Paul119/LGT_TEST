CREATE PROC [dbo].[Kernel_SP_Process_PreSave]
		@idProfile int,
		@idUser int,
		@idTree int,
		@kMValuesData AS [dbo].[Kernel_Type_k_m_values] READONLY,
		@selectedIdPayee int,
		@idProcess int
	AS

	Declare @Result bit = 1;
	Declare @Message nvarchar(max) = NULL;
	Declare @argumentsForError nvarchar(max)=NULL

	-- Validation check Logic 
	-- Set @Result and @Message. If desired, set @argumentsForError

	select @Result as Continue_Flag , @Message as Message, @argumentsForError as ArgumentsForError