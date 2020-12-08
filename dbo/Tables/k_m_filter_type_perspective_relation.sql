CREATE TABLE [dbo].[k_m_filter_type_perspective_relation] (
    [id_filter_type_perpective_relation] INT IDENTITY (1, 1) NOT NULL,
    [id_filter_type]                     INT NOT NULL,
    [id_perspective]                     INT NOT NULL,
    CONSTRAINT [PK_k_m_filter_type_perspective_relation] PRIMARY KEY CLUSTERED ([id_filter_type_perpective_relation] ASC),
    CONSTRAINT [FK_k_m_filter_type_perspective_relation_k_m_filter_type] FOREIGN KEY ([id_filter_type]) REFERENCES [dbo].[k_m_filter_type] ([id_filter_type]),
    CONSTRAINT [FK_k_m_filter_type_perspective_relation_k_perspective] FOREIGN KEY ([id_perspective]) REFERENCES [dbo].[k_m_perspective] ([id_perspective])
);

