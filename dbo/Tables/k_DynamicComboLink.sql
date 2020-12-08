CREATE TABLE [dbo].[k_DynamicComboLink] (
    [id]             INT IDENTITY (1, 1) NOT NULL,
    [idDynamicCombo] INT NULL,
    [idLinkedTo]     INT NULL,
    CONSTRAINT [PK_k_DynamicComboMap] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_DynamicComboMap_k_DynamicCombo] FOREIGN KEY ([idDynamicCombo]) REFERENCES [dbo].[k_DynamicCombo] ([id]) ON DELETE CASCADE
);

