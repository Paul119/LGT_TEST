CREATE TABLE [dbo].[k_cultures] (
    [id]      INT           IDENTITY (1, 1) NOT NULL,
    [label]   NVARCHAR (50) NULL,
    [value]   CHAR (5)      NOT NULL,
    [culture] CHAR (5)      NOT NULL,
    [sort]    INT           NULL,
    CONSTRAINT [PK_k_cultures] PRIMARY KEY CLUSTERED ([id] ASC)
);

