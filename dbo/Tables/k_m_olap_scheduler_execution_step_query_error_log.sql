CREATE TABLE [dbo].[k_m_olap_scheduler_execution_step_query_error_log] (
    [id_olap_scheduler_execution_step_query_error_log] INT            IDENTITY (1, 1) NOT NULL,
    [id_olap_scheduler_execution_step]                 INT            NOT NULL,
    [start_date_generation]                            SMALLDATETIME  NULL,
    [end_date_generation]                              SMALLDATETIME  NULL,
    [failed_mdx_file_name]                             NVARCHAR (250) NOT NULL,
    [start_date_execution]                             SMALLDATETIME  NULL,
    [end_date_execution]                               SMALLDATETIME  NULL,
    [descripton]                                       NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_k_m_olap_scheduler_execution_step_query_error_log] PRIMARY KEY CLUSTERED ([id_olap_scheduler_execution_step_query_error_log] ASC),
    CONSTRAINT [FK_k_m_olap_scheduler_execution_step_query_error_log_k_m_olap_scheduler_execution_step] FOREIGN KEY ([id_olap_scheduler_execution_step]) REFERENCES [dbo].[k_m_olap_scheduler_execution_step] ([id_olap_scheduler_execution_step])
);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_olap_scheduler_execution_step_query_error_log_id_olap_scheduler_execution_step]
    ON [dbo].[k_m_olap_scheduler_execution_step_query_error_log]([id_olap_scheduler_execution_step] ASC);

