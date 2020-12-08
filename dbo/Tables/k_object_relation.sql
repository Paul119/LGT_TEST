﻿CREATE TABLE [dbo].[k_object_relation] (
    [id]                          INT            IDENTITY (1, 1) NOT NULL,
    [name]                        NVARCHAR (100) NULL,
    [relation_type]               INT            NULL,
    [parent]                      INT            NULL,
    [id_base]                     INT            NULL,
    [id_related]                  INT            NULL,
    [base_key]                    NVARCHAR (100) NULL,
    [related_key]                 NVARCHAR (100) NULL,
    [related_where_condition]     NVARCHAR (500) NULL,
    [association]                 INT            NULL,
    [id_custom_map_table_view]    INT            NULL,
    [id_custom_map_related_field] INT            NULL,
    [id_custom_map_base_field]    INT            NULL,
    [id_source_tenant]            INT            NULL,
    [id_source]                   INT            NULL,
    [id_change_set]               INT            NULL,
    CONSTRAINT [PK_k_object_relation] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_object_relation_k_object_relation_type] FOREIGN KEY ([relation_type]) REFERENCES [dbo].[k_object_relation_type] ([id]),
    CONSTRAINT [FK_k_object_relation_k_object_relation1] FOREIGN KEY ([parent]) REFERENCES [dbo].[k_object_relation] ([id]),
    CONSTRAINT [FK_k_object_relation_k_referential_tables_views] FOREIGN KEY ([id_custom_map_table_view]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view]),
    CONSTRAINT [FK_k_object_relation_k_referential_tables_views_fields] FOREIGN KEY ([id_custom_map_base_field]) REFERENCES [dbo].[k_referential_tables_views_fields] ([id_field]),
    CONSTRAINT [FK_k_object_relation_k_referential_tables_views_fields1] FOREIGN KEY ([id_custom_map_related_field]) REFERENCES [dbo].[k_referential_tables_views_fields] ([id_field])
);

