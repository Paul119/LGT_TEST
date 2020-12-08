CREATE TABLE [dbo].[k_program_cond_statement] (
    [id]          INT IDENTITY (1, 1) NOT NULL,
    [condId]      INT NULL,
    [statementId] INT NULL,
    CONSTRAINT [PK_k_program_cond_statement] PRIMARY KEY CLUSTERED ([id] ASC)
);

