CREATE TABLE [dbo].[k_m_indicators_olap_filters] (
    [id_olap_filter]   INT            IDENTITY (1, 1) NOT NULL,
    [id_ind]           INT            NULL,
    [id_reference]     INT            NOT NULL,
    [name_reference]   NVARCHAR (255) NOT NULL,
    [type_reference]   NVARCHAR (255) NOT NULL,
    [id_source_tenant] INT            NULL,
    [id_source]        INT            NULL,
    [id_change_set]    INT            NULL,
    [id_filter]        INT            NULL,
    CONSTRAINT [PK_k_m_indicators_olap_filters] PRIMARY KEY CLUSTERED ([id_olap_filter] ASC),
    CONSTRAINT [FK_k_m_indicators_olap_filters_k_m_filter] FOREIGN KEY ([id_filter]) REFERENCES [dbo].[k_m_filter] ([id_filter]),
    CONSTRAINT [FK_k_m_indicators_olap_filters_m_indicators] FOREIGN KEY ([id_ind]) REFERENCES [dbo].[k_m_indicators] ([id_ind]),
    CONSTRAINT [FK_k_m_indicators_olap_filters_m_olap_references] FOREIGN KEY ([id_reference]) REFERENCES [dbo].[k_m_olap_references] ([id_reference]),
    CONSTRAINT [IX_k_m_indicators_olap_filters] UNIQUE NONCLUSTERED ([id_ind] ASC, [id_reference] ASC, [id_filter] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Nc_IX_k_m_indicators_olap_filters_id_filter]
    ON [dbo].[k_m_indicators_olap_filters]([id_filter] ASC);


GO
CREATE NONCLUSTERED INDEX [Nc_IX_k_m_indicators_olap_filters_id_ind]
    ON [dbo].[k_m_indicators_olap_filters]([id_ind] ASC);

