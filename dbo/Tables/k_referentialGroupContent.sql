CREATE TABLE [dbo].[k_referentialGroupContent] (
    [id]        INT IDENTITY (1, 1) NOT NULL,
    [groupId]   INT NOT NULL,
    [itemId]    INT NOT NULL,
    [typeId]    INT NOT NULL,
    [itemOrder] INT NULL,
    CONSTRAINT [PK_k_referentialGroupContent] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_referentialGroupContent_k_referentialGroup] FOREIGN KEY ([groupId]) REFERENCES [dbo].[k_referentialGroup] ([id])
);

