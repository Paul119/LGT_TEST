CREATE TABLE [dbo].[k_m_perspective_measure] (
    [id_perspective_detail] INT IDENTITY (1, 1) NOT NULL,
    [id_perspective]        INT NOT NULL,
    [id_reference]          INT NOT NULL,
    [id_source_tenant]      INT NULL,
    [id_source]             INT NULL,
    [id_change_set]         INT NULL,
    CONSTRAINT [PK_k_m_perspective_measure] PRIMARY KEY CLUSTERED ([id_perspective_detail] ASC),
    CONSTRAINT [FK_k_m_perspective_measure_k_m_olap_reference] FOREIGN KEY ([id_reference]) REFERENCES [dbo].[k_m_olap_references] ([id_reference]),
    CONSTRAINT [FK_k_m_perspective_measure_k_m_perspective] FOREIGN KEY ([id_perspective]) REFERENCES [dbo].[k_m_perspective] ([id_perspective]),
    CONSTRAINT [IX_UQ_k_perspective_measure_id_perspective_olap_measure_name] UNIQUE NONCLUSTERED ([id_perspective] ASC, [id_reference] ASC)
);

