CREATE TABLE [dbo].[k_program_phrase_statement] (
    [id]          INT IDENTITY (1, 1) NOT NULL,
    [statementId] INT NULL,
    [phraseId]    INT NULL,
    CONSTRAINT [PK_k_program_phrase_statement] PRIMARY KEY CLUSTERED ([id] ASC)
);

