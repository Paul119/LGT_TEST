CREATE TABLE [dbo].[k_m_filter] (
    [id_filter]      INT            IDENTITY (1, 1) NOT NULL,
    [name_filter]    NVARCHAR (255) NOT NULL,
    [id_filter_type] INT            NOT NULL,
    CONSTRAINT [PK_k_m_filter] PRIMARY KEY CLUSTERED ([id_filter] ASC),
    CONSTRAINT [FK_k_m_filter_k_m_filter_type] FOREIGN KEY ([id_filter_type]) REFERENCES [dbo].[k_m_filter_type] ([id_filter_type])
);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_filter_id_filter_type]
    ON [dbo].[k_m_filter]([id_filter_type] ASC)
    INCLUDE([name_filter]);

