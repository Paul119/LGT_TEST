CREATE TABLE [dbo].[ads_gridRelation] (
    [id]                      INT            IDENTITY (1, 1) NOT NULL,
    [idBase]                  INT            NOT NULL,
    [idRelated]               INT            NOT NULL,
    [baseKey]                 NVARCHAR (255) NOT NULL,
    [relatedKey]              NVARCHAR (255) NOT NULL,
    [foreignKey]              NVARCHAR (255) NULL,
    [name]                    NVARCHAR (100) NOT NULL,
    [idCustomMapTableView]    INT            NULL,
    [idCustomMapBaseField]    INT            NULL,
    [idCustomMapRelatedField] INT            NULL,
    CONSTRAINT [PK__ads_grid__3213E83F2097C3F2] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_ads_gridRelation_k_referential_grids] FOREIGN KEY ([idBase]) REFERENCES [dbo].[k_referential_grids] ([id_grid]),
    CONSTRAINT [FK_ads_gridRelation_k_referential_grids1] FOREIGN KEY ([idRelated]) REFERENCES [dbo].[k_referential_grids] ([id_grid]),
    CONSTRAINT [FK_ads_gridRelation_k_referential_tables_views] FOREIGN KEY ([idCustomMapTableView]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view]),
    CONSTRAINT [FK_ads_gridRelation_k_referential_tables_views_fields] FOREIGN KEY ([idCustomMapBaseField]) REFERENCES [dbo].[k_referential_tables_views_fields] ([id_field]),
    CONSTRAINT [FK_ads_gridRelation_k_referential_tables_views_fields1] FOREIGN KEY ([idCustomMapRelatedField]) REFERENCES [dbo].[k_referential_tables_views_fields] ([id_field])
);

