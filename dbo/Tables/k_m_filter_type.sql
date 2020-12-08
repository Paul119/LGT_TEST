CREATE TABLE [dbo].[k_m_filter_type] (
    [id_filter_type]   INT            IDENTITY (1, 1) NOT NULL,
    [name_filter_type] NVARCHAR (255) NOT NULL,
    [field_name]       NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_k_m_filter_type] PRIMARY KEY CLUSTERED ([id_filter_type] ASC)
);

