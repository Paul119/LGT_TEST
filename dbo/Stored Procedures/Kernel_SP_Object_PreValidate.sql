
CREATE PROC [dbo].[Kernel_SP_Object_PreValidate]
        @uidObject UNIQUEIDENTIFIER,
		@uidProfile UNIQUEIDENTIFIER,
		@uidUser UNIQUEIDENTIFIER,
		@idStep int,
		@idTree int,
		@idTreeSecurity int,
		@isValidation bit
	AS

	Declare @SuccessFlag bit = 1;
	Declare @ErrorMessage nvarchar(max) = '';

	--Custom Logic

	select @SuccessFlag as SuccessFlag, @ErrorMessage as ErrorMessage