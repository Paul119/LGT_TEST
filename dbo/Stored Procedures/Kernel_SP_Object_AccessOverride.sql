
CREATE PROC [dbo].[Kernel_SP_Object_AccessOverride]
        @uidObject UNIQUEIDENTIFIER,
		@uidProfile UNIQUEIDENTIFIER,
		@uidUser UNIQUEIDENTIFIER,
		@idStep int,
		@idTree int,
		@idTreeSecurity int
	AS

	Declare @DenyRead bit = 0;
	Declare @DenyEdit bit = 0;
	Declare @DenyValidate bit = 1;
	Declare @DenyInvalidate bit = 1;

	--Custom Logic

	select @DenyRead as DenyRead , @DenyEdit as DenyEdit, @DenyValidate as DenyValidate, @DenyInvalidate AS DenyInvalidate