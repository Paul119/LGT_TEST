CREATE TABLE [dbo].[k_m_fields_source_type] (
    [id_sourcetype]          INT           IDENTITY (1, 1) NOT NULL,
    [source_name]            NVARCHAR (50) NULL,
    [format_name]            NVARCHAR (50) NULL,
    [id_fields_control_type] INT           NULL,
    CONSTRAINT [PK_k_m_fields_source_type] PRIMARY KEY CLUSTERED ([id_sourcetype] ASC),
    CONSTRAINT [FK_k_m_fields_source_type_k_m_fields_control_type] FOREIGN KEY ([id_fields_control_type]) REFERENCES [dbo].[k_m_fields_control_type] ([id_control_type])
);

