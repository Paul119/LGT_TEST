CREATE TABLE [dbo].[k_m_filter_perspective] (
    [id_filter_perspective] INT IDENTITY (1, 1) NOT NULL,
    [id_filter]             INT NOT NULL,
    [id_perspective]        INT NOT NULL,
    CONSTRAINT [PK_k_m_filter_perspective] PRIMARY KEY CLUSTERED ([id_filter_perspective] ASC),
    CONSTRAINT [FK_k_m_filter_perspective_k_m_filter] FOREIGN KEY ([id_filter]) REFERENCES [dbo].[k_m_filter] ([id_filter]),
    CONSTRAINT [FK_k_m_filter_perspective_k_m_perspective] FOREIGN KEY ([id_perspective]) REFERENCES [dbo].[k_m_perspective] ([id_perspective])
);

