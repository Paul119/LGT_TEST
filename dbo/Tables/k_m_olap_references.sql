CREATE TABLE [dbo].[k_m_olap_references] (
    [id_reference]            INT            IDENTITY (1, 1) NOT NULL,
    [name_reference]          NVARCHAR (MAX) NULL,
    [olap_dimension_name]     NVARCHAR (MAX) NULL,
    [olap_attribute_name]     NVARCHAR (MAX) NULL,
    [id_source_tenant]        INT            NULL,
    [id_source]               INT            NULL,
    [id_change_set]           INT            NULL,
    [link_field]              NVARCHAR (200) NULL,
    [id_table_view]           INT            NULL,
    [is_perimeter]            BIT            CONSTRAINT [DF_k_m_olap_references_is_perimeter] DEFAULT ((0)) NOT NULL,
    [is_version_dimension]    BIT            CONSTRAINT [DF_k_m_olap_references_is_version_dimension] DEFAULT ((0)) NOT NULL,
    [is_visible_as_reference] BIT            CONSTRAINT [DF_k_m_olap_references_is_visible_as_reference] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_k_m_indicator_olap_reference] PRIMARY KEY CLUSTERED ([id_reference] ASC),
    CONSTRAINT [FK_k_m_olap_references_k_referential_tables_views] FOREIGN KEY ([id_table_view]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view])
);

