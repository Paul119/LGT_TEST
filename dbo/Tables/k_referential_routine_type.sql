CREATE TABLE [dbo].[k_referential_routine_type] (
    [id_routine_type]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [name_routine_type] NVARCHAR (20) NOT NULL,
    CONSTRAINT [PK_k_referential_routine_type] PRIMARY KEY CLUSTERED ([id_routine_type] ASC)
);

