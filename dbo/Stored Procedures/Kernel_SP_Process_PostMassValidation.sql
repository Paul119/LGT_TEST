CREATE PROC [dbo].[Kernel_SP_Process_PostMassValidation]
		@idProfile int,
		@idUser int,
		@idTree int,
		@idPayeeSteps AS [dbo].[Kernel_ValueList_INT] READONLY,
		@selectedIdPayee int,
		@idProcess int,
		@idAction INT -- 1 Validate, 2 Invalidate, 3 Show Data
	AS

	Declare @Result bit = 1;
	Declare @Message nvarchar(max) = NULL;
	Declare @argumentsForError nvarchar(max)=NULL

	-- Validation check Logic 
	-- Set @Result and @Message. If desired, set @argumentsForError

	select @Result as Continue_Flag , @Message as Message, @argumentsForError as ArgumentsForError