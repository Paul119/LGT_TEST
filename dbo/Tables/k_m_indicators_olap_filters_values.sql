CREATE TABLE [dbo].[k_m_indicators_olap_filters_values] (
    [id_olap_filter_value]  INT            IDENTITY (1, 1) NOT NULL,
    [id_olap_filter]        INT            NULL,
    [id_object_reference]   NVARCHAR (255) NOT NULL,
    [name_object_reference] NVARCHAR (255) NOT NULL,
    [id_source_tenant]      INT            NULL,
    [id_source]             INT            NULL,
    [id_change_set]         INT            NULL,
    CONSTRAINT [PK_k_m_indicators_olap_filters_values] PRIMARY KEY CLUSTERED ([id_olap_filter_value] ASC),
    CONSTRAINT [FK_k_m_indicators_olap_filters_values_k_m_indicators_olap_filters] FOREIGN KEY ([id_olap_filter]) REFERENCES [dbo].[k_m_indicators_olap_filters] ([id_olap_filter])
);


GO
CREATE NONCLUSTERED INDEX [Nc_IX_k_m_indicators_olap_filters_values_id_olap_filter]
    ON [dbo].[k_m_indicators_olap_filters_values]([id_olap_filter] ASC);

