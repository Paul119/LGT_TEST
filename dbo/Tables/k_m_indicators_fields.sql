CREATE TABLE [dbo].[k_m_indicators_fields] (
    [id_indicator_field] INT IDENTITY (1, 1) NOT NULL,
    [id_ind]             INT NOT NULL,
    [id_field]           INT NOT NULL,
    [sort]               INT CONSTRAINT [DF_k_m_indicators_fields_sort] DEFAULT ((0)) NOT NULL,
    [id_source_tenant]   INT NULL,
    [id_source]          INT NULL,
    [id_change_set]      INT NULL,
    CONSTRAINT [PK_k_m_indicators_fields] PRIMARY KEY CLUSTERED ([id_indicator_field] ASC),
    CONSTRAINT [FK_k_m_indicators_fields_m_fields] FOREIGN KEY ([id_field]) REFERENCES [dbo].[k_m_fields] ([id_field]),
    CONSTRAINT [FK_k_m_indicators_fields_m_indicators] FOREIGN KEY ([id_ind]) REFERENCES [dbo].[k_m_indicators] ([id_ind]),
    CONSTRAINT [AK_k_m_indicators_fields] UNIQUE NONCLUSTERED ([id_ind] ASC, [id_field] ASC)
);

