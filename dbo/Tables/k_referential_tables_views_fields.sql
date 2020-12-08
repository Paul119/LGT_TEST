CREATE TABLE [dbo].[k_referential_tables_views_fields] (
    [id_field]                 INT              IDENTITY (1, 1) NOT NULL,
    [id_table_view]            INT              NOT NULL,
    [name_field]               NVARCHAR (255)   NOT NULL,
    [type_field]               NVARCHAR (255)   NOT NULL,
    [length_field]             FLOAT (53)       NULL,
    [constraint_null_field]    BIT              NOT NULL,
    [constraint_field]         NVARCHAR (255)   NULL,
    [order_field]              SMALLINT         NOT NULL,
    [encrypt_field]            BIT              NULL,
    [is_localizable]           BIT              NULL,
    [is_unique]                BIT              NULL,
    [id_source_tenant]         INT              NULL,
    [id_source]                INT              NULL,
    [id_change_set]            INT              NULL,
    [is_computed]              BIT              NULL,
    [has_default_value]        BIT              NULL,
    [default_value_definition] NVARCHAR (MAX)   NULL,
    [is_key_field]             BIT              NULL,
    [is_display_field]         BIT              NULL,
    [sort_order]               INT              NULL,
    [sort_direction]           INT              CONSTRAINT [DF_k_referential_tables_views_fields_sort_direction] DEFAULT ((0)) NOT NULL,
    [precision]                INT              NULL,
    [scale]                    INT              NULL,
    [uid_datasource_attribute] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_k_referential_tables_views_fields] PRIMARY KEY CLUSTERED ([id_field] ASC),
    CONSTRAINT [FK_k_referential_tables_views_fields_k_referential_tables_views] FOREIGN KEY ([id_table_view]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view])
);


GO
CREATE NONCLUSTERED INDEX [IX_k_referential_tables_views_fieldsid_table_view_name_field]
    ON [dbo].[k_referential_tables_views_fields]([id_table_view] ASC, [name_field] ASC);

