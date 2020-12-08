CREATE TABLE [dbo].[k_m_olap_scheduler_execution_step] (
    [id_olap_scheduler_execution_step]    INT           IDENTITY (1, 1) NOT NULL,
    [id_olap_scheduler_execution]         INT           NOT NULL,
    [payee_list]                          XML           NOT NULL,
    [create_date]                         DATETIME      CONSTRAINT [DF_k_m_olap_scheduler_execution_step_create_date] DEFAULT (getutcdate()) NOT NULL,
    [id_olap_scheduler_status_generation] TINYINT       NOT NULL,
    [start_date_generation]               SMALLDATETIME NULL,
    [end_date_generation]                 SMALLDATETIME NULL,
    [try_count_generation]                TINYINT       CONSTRAINT [DF_k_m_olap_scheduler_execution_step_try_count_generation] DEFAULT ((0)) NOT NULL,
    [mdx_file_count_generated]            INT           NULL,
    [id_olap_scheduler_status_execution]  TINYINT       NOT NULL,
    [start_date_execution]                SMALLDATETIME NULL,
    [end_date_execution]                  SMALLDATETIME NULL,
    [try_count_execution]                 TINYINT       CONSTRAINT [DF_k_m_olap_scheduler_execution_step_try_count_execution] DEFAULT ((0)) NOT NULL,
    [mdx_file_count_executed]             INT           NULL,
    CONSTRAINT [PK_k_m_olap_scheduler_execution_step] PRIMARY KEY CLUSTERED ([id_olap_scheduler_execution_step] ASC),
    CONSTRAINT [FK_k_m_olap_scheduler_execution_step_k_m_olap_scheduler_execution] FOREIGN KEY ([id_olap_scheduler_execution]) REFERENCES [dbo].[k_m_olap_scheduler_execution] ([id_olap_scheduler_execution]),
    CONSTRAINT [FK_k_m_olap_scheduler_execution_step_k_m_olap_scheduler_status_id_olap_scheduler_status_execution] FOREIGN KEY ([id_olap_scheduler_status_execution]) REFERENCES [dbo].[k_m_olap_scheduler_status] ([id_olap_scheduler_status]),
    CONSTRAINT [FK_k_m_olap_scheduler_execution_step_k_m_olap_scheduler_status_id_olap_scheduler_status_generation] FOREIGN KEY ([id_olap_scheduler_status_generation]) REFERENCES [dbo].[k_m_olap_scheduler_status] ([id_olap_scheduler_status])
);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_olap_scheduler_execution_step_id_olap_scheduler_execution]
    ON [dbo].[k_m_olap_scheduler_execution_step]([id_olap_scheduler_execution] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_olap_scheduler_execution_step_id_olap_scheduler_status_generation]
    ON [dbo].[k_m_olap_scheduler_execution_step]([id_olap_scheduler_status_generation] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_olap_scheduler_execution_step_id_olap_scheduler_status_execution]
    ON [dbo].[k_m_olap_scheduler_execution_step]([id_olap_scheduler_status_execution] ASC);

