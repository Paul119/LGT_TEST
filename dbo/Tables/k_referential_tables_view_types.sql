CREATE TABLE [dbo].[k_referential_tables_view_types] (
    [id_type]      INT           NOT NULL,
    [type_table]   NVARCHAR (50) NOT NULL,
    [order_column] INT           NULL,
    CONSTRAINT [PK_k_referential_tables_types] PRIMARY KEY CLUSTERED ([id_type] ASC)
);

