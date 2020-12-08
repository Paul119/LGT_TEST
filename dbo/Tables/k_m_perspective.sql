CREATE TABLE [dbo].[k_m_perspective] (
    [id_perspective]                INT            IDENTITY (1, 1) NOT NULL,
    [name_perspective]              NVARCHAR (100) NOT NULL,
    [id_cube]                       INT            NOT NULL,
    [is_available_for_import_field] BIT            NOT NULL,
    [default_filter_mdx]            NVARCHAR (MAX) NULL,
    [default_filter_sql]            NVARCHAR (MAX) NULL,
    [id_source_tenant]              INT            NULL,
    [id_source]                     INT            NULL,
    [id_change_set]                 INT            NULL,
    CONSTRAINT [PK_k_m_perspective] PRIMARY KEY CLUSTERED ([id_perspective] ASC),
    CONSTRAINT [FK_k_m_perspective_k_m_cube] FOREIGN KEY ([id_cube]) REFERENCES [dbo].[k_m_cube] ([id_cube])
);

