CREATE TABLE [dbo].[k_m_field_perspective] (
    [id_field_perspective] INT IDENTITY (1, 1) NOT NULL,
    [id_field]             INT NOT NULL,
    [id_perspective]       INT NOT NULL,
    CONSTRAINT [PK_k_m_field_perspective] PRIMARY KEY CLUSTERED ([id_field_perspective] ASC),
    CONSTRAINT [FK_k_m_field_perspective_k_m_field] FOREIGN KEY ([id_field]) REFERENCES [dbo].[k_m_fields] ([id_field]),
    CONSTRAINT [FK_k_m_field_perspective_k_m_perspective] FOREIGN KEY ([id_perspective]) REFERENCES [dbo].[k_m_perspective] ([id_perspective]),
    CONSTRAINT [AK_k_m_field_perspective] UNIQUE NONCLUSTERED ([id_field] ASC, [id_perspective] ASC)
);

