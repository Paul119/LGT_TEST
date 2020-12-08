CREATE TABLE [dbo].[k_program_statement] (
    [id]            INT            IDENTITY (1, 1) NOT NULL,
    [name]          NVARCHAR (100) NOT NULL,
    [statementType] TINYINT        NOT NULL,
    [definition]    NVARCHAR (MAX) NULL,
    [isShared]      BIT            NULL,
    CONSTRAINT [PK_k_program_statement] PRIMARY KEY CLUSTERED ([id] ASC)
);

