CREATE TABLE [dbo].[k_program_status] (
    [id_status]   SMALLINT       IDENTITY (1, 1) NOT NULL,
    [name_status] NVARCHAR (100) NULL,
    [comments]    NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_k_program_status] PRIMARY KEY CLUSTERED ([id_status] ASC)
);

