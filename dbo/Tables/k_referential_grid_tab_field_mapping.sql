CREATE TABLE [dbo].[k_referential_grid_tab_field_mapping] (
    [id_grid_tab_field_mapping]  INT IDENTITY (1, 1) NOT NULL,
    [id_grid_tab]                INT NOT NULL,
    [id_parent_table_view_field] INT NOT NULL,
    [id_table_view_field]        INT NOT NULL,
    CONSTRAINT [PK_k_referential_grid_tab_field_mapping] PRIMARY KEY CLUSTERED ([id_grid_tab_field_mapping] ASC),
    CONSTRAINT [FK_k_referential_grid_tab_field_mapping_k_referential_grid_tab] FOREIGN KEY ([id_grid_tab]) REFERENCES [dbo].[k_referential_grid_tab] ([id_grid_tab]),
    CONSTRAINT [FK_k_referential_grid_tab_field_mapping_k_referential_tables_views_fields] FOREIGN KEY ([id_parent_table_view_field]) REFERENCES [dbo].[k_referential_tables_views_fields] ([id_field]),
    CONSTRAINT [FK_k_referential_grid_tab_field_mapping_k_referential_tables_views_fields_1] FOREIGN KEY ([id_table_view_field]) REFERENCES [dbo].[k_referential_tables_views_fields] ([id_field])
);

