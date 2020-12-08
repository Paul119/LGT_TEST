CREATE TABLE [dbo].[k_tqm_dimension] (
    [id_dimension]   INT            IDENTITY (1, 1) NOT NULL,
    [name_dimension] NVARCHAR (200) NULL,
    [olap_dimension] NVARCHAR (256) NULL,
    [id_table_view]  INT            NULL,
    CONSTRAINT [PK_k_tqm_dimension] PRIMARY KEY CLUSTERED ([id_dimension] ASC),
    CONSTRAINT [FK_k_tqm_dimension_k_referential_tables_views] FOREIGN KEY ([id_table_view]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view])
);

