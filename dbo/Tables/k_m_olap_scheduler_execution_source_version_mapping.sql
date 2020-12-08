CREATE TABLE [dbo].[k_m_olap_scheduler_execution_source_version_mapping] (
    [id_olap_scheduler_execution_source_version_mapping] INT           IDENTITY (1, 1) NOT NULL,
    [id_olap_scheduler_execution]                        INT           NOT NULL,
    [id_ind]                                             INT           NOT NULL,
    [id_version]                                         NVARCHAR (10) NOT NULL,
    CONSTRAINT [PK_k_m_olap_scheduler_execution_source_version_mapping] PRIMARY KEY CLUSTERED ([id_olap_scheduler_execution_source_version_mapping] ASC),
    CONSTRAINT [FK_k_m_olap_scheduler_execution_source_version_mapping_k_m_indicators] FOREIGN KEY ([id_ind]) REFERENCES [dbo].[k_m_indicators] ([id_ind]),
    CONSTRAINT [FK_k_m_olap_scheduler_execution_source_version_mapping_k_m_olap_scheduler_execution] FOREIGN KEY ([id_olap_scheduler_execution]) REFERENCES [dbo].[k_m_olap_scheduler_execution] ([id_olap_scheduler_execution])
);


GO
CREATE NONCLUSTERED INDEX [Nc_Ix_id_olap_scheduler_execution]
    ON [dbo].[k_m_olap_scheduler_execution_source_version_mapping]([id_olap_scheduler_execution] ASC);


GO
CREATE NONCLUSTERED INDEX [Nc_Ix_id_ind]
    ON [dbo].[k_m_olap_scheduler_execution_source_version_mapping]([id_ind] ASC);

