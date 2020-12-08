CREATE TABLE [dbo].[k_m_field_value_filter] (
    [id_field_value_filter]   INT           IDENTITY (1, 1) NOT NULL,
    [name_field_value_filter] NVARCHAR (20) NULL,
    CONSTRAINT [PK_k_m_field_value_filter] PRIMARY KEY CLUSTERED ([id_field_value_filter] ASC)
);

