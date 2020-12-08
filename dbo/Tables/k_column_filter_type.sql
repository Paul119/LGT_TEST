CREATE TABLE [dbo].[k_column_filter_type] (
    [id_column_filter_type]   INT            IDENTITY (1, 1) NOT NULL,
    [name_column_filter_type] NVARCHAR (255) NULL,
    CONSTRAINT [PK_k_column_filter_type] PRIMARY KEY CLUSTERED ([id_column_filter_type] ASC)
);

