CREATE TABLE [dbo].[k_DynamicComboDetail] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [idDynamicCombo] INT            NULL,
    [name]           NVARCHAR (150) NULL,
    [idFilterField]  INT            NULL,
    [isAutoFilled]   BIT            NULL,
    [autoField]      VARCHAR (15)   NULL,
    [filterOrder]    INT            NULL,
    CONSTRAINT [PK_k_DynamicComboDetail] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_DynamicComboDetail_k_DynamicCombo] FOREIGN KEY ([idDynamicCombo]) REFERENCES [dbo].[k_DynamicCombo] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_k_DynamicComboDetail_k_referential_tables_views_fields] FOREIGN KEY ([idFilterField]) REFERENCES [dbo].[k_referential_tables_views_fields] ([id_field])
);

