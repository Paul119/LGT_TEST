CREATE TABLE [dbo].[k_referential_grids_fields_relation] (
    [id_grid_field_relation] INT IDENTITY (1, 1) NOT NULL,
    [id_field_grid_parent]   INT NULL,
    [id_field_table_view]    INT NULL,
    [id_field_grid]          INT NULL,
    [id_source_tenant]       INT NULL,
    [id_source]              INT NULL,
    [id_change_set]          INT NULL,
    CONSTRAINT [PK_k_referential_grids_fields_relation] PRIMARY KEY CLUSTERED ([id_grid_field_relation] ASC),
    CONSTRAINT [FK_k_referential_grids_fields_relation_k_referential_grids_fields] FOREIGN KEY ([id_field_grid]) REFERENCES [dbo].[k_referential_grids_fields] ([id_column]),
    CONSTRAINT [FK_k_referential_grids_fields_relation_k_referential_grids_fields_relation] FOREIGN KEY ([id_field_grid_parent]) REFERENCES [dbo].[k_referential_grids_fields] ([id_column]),
    CONSTRAINT [FK_k_referential_grids_fields_relation_k_referential_tables_views_fields] FOREIGN KEY ([id_field_table_view]) REFERENCES [dbo].[k_referential_tables_views_fields] ([id_field])
);

