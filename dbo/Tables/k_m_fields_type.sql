CREATE TABLE [dbo].[k_m_fields_type] (
    [id_field_type]   INT           IDENTITY (1, 1) NOT NULL,
    [name_field_type] NVARCHAR (50) NOT NULL,
    [sort_field_type] INT           NOT NULL,
    CONSTRAINT [PK_k_m_fields_type] PRIMARY KEY CLUSTERED ([id_field_type] ASC)
);

