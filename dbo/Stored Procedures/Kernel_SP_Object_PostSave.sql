
CREATE PROC [dbo].[Kernel_SP_Object_PostSave]
                       @uidDataSource UNIQUEIDENTIFIER,
		@uidProfile UNIQUEIDENTIFIER,
		@uidUser UNIQUEIDENTIFIER,
		@idStep int,
		@idTree int,
		@idTreeSecurity int,
		@dataSourceResult [Kernel_Type_Object_Result] READONLY
	AS

	--Custom Logic