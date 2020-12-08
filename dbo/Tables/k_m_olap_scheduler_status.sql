CREATE TABLE [dbo].[k_m_olap_scheduler_status] (
    [id_olap_scheduler_status] TINYINT        NOT NULL,
    [name]                     NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_k_m_olap_scheduler_status] PRIMARY KEY CLUSTERED ([id_olap_scheduler_status] ASC)
);

