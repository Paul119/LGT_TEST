CREATE TABLE [dbo].[k_m_fields_format_type] (
    [id_format]   INT           IDENTITY (1, 1) NOT NULL,
    [name_format] NVARCHAR (50) NULL,
    CONSTRAINT [PK_k_m_fields_format_type] PRIMARY KEY CLUSTERED ([id_format] ASC)
);

