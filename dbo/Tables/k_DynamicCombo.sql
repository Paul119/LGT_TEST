CREATE TABLE [dbo].[k_DynamicCombo] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [name]           NVARCHAR (100) NULL,
    [idSourceGrid]   INT            NULL,
    [linkType]       VARCHAR (15)   NULL,
    [idDisplayField] INT            NULL,
    [idValueField]   INT            NULL,
    CONSTRAINT [PK_k_DynamicCombo] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_DynamicCombo_k_referential_grids] FOREIGN KEY ([idSourceGrid]) REFERENCES [dbo].[k_referential_grids] ([id_grid]) ON DELETE CASCADE,
    CONSTRAINT [FK_k_DynamicCombo_k_referential_tables_views_fields] FOREIGN KEY ([idDisplayField]) REFERENCES [dbo].[k_referential_tables_views_fields] ([id_field]),
    CONSTRAINT [FK_k_DynamicCombo_k_referential_tables_views_fields1] FOREIGN KEY ([idValueField]) REFERENCES [dbo].[k_referential_tables_views_fields] ([id_field])
);

