CREATE TABLE [dbo].[k_program_frequency] (
    [id_frequency]       INT            IDENTITY (1, 1) NOT NULL,
    [name_frequency]     NVARCHAR (50)  NOT NULL,
    [comments_frequency] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_k_program_frequency] PRIMARY KEY CLUSTERED ([id_frequency] ASC)
);

