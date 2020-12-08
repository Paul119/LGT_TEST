CREATE TABLE [dbo].[k_program_cond_phrase] (
    [id]       INT IDENTITY (1, 1) NOT NULL,
    [condId]   INT NULL,
    [phraseId] INT NULL,
    CONSTRAINT [PK_k_program_cond_phrase] PRIMARY KEY CLUSTERED ([id] ASC)
);

