CREATE TABLE [dbo].[k_program_phrase] (
    [id]         INT            IDENTITY (1, 1) NOT NULL,
    [name]       NVARCHAR (100) NOT NULL,
    [satisfyAll] BIT            NULL,
    [isShared]   BIT            NULL,
    CONSTRAINT [PK_k_program_phrase] PRIMARY KEY CLUSTERED ([id] ASC)
);

