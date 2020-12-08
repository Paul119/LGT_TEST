CREATE TABLE [dbo].[k_referential_grid_field_validation_formula_items] (
    [id_grid_field_validation_formula_item] INT IDENTITY (1, 1) NOT NULL,
    [id_grid_field_validation]              INT NOT NULL,
    [id_field]                              INT NOT NULL,
    CONSTRAINT [PK_k_referential_grid_field_validation_formula_items] PRIMARY KEY CLUSTERED ([id_grid_field_validation_formula_item] ASC),
    CONSTRAINT [FK_k_referential_grid_field_validation_formula_items_k_referential_grid_field_validation] FOREIGN KEY ([id_grid_field_validation]) REFERENCES [dbo].[k_referential_grid_field_validation] ([id_grid_field_validation]),
    CONSTRAINT [FK_k_referential_grid_field_validation_formula_items_k_referential_tables_views_fields] FOREIGN KEY ([id_field]) REFERENCES [dbo].[k_referential_tables_views_fields] ([id_field])
);

