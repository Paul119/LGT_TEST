CREATE TABLE [dbo].[k_program_type] (
    [id_type]   INT            IDENTITY (1, 1) NOT NULL,
    [name_type] NVARCHAR (50)  NULL,
    [comments]  NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_k_program_type] PRIMARY KEY CLUSTERED ([id_type] ASC)
);

