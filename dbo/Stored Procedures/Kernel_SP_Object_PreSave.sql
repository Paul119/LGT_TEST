
CREATE PROC [dbo].[Kernel_SP_Object_PreSave]
	    @uidDataSource UNIQUEIDENTIFIER,
		@uidProfile UNIQUEIDENTIFIER,
		@uidUser UNIQUEIDENTIFIER,
		@idStep int,
		@idTree int,
		@idTreeSecurity int,
		@dataSourceResult [Kernel_Type_Object_Result] READONLY
	AS

Declare @ContinueFlag bit = 1;
	Declare @ErrorMessage nvarchar(max) = '';

	--Custom Logic

	select @ContinueFlag as ContinueFlag, @ErrorMessage as ErrorMessage