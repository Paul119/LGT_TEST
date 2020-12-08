CREATE TABLE [dbo].[k_m_values_detail] (
    [id_value_detail]                  INT             IDENTITY (1, 1) NOT NULL,
    [id_plan]                          INT             NOT NULL,
    [id_ind]                           INT             NOT NULL,
    [idPayee]                          INT             NOT NULL,
    [id_field]                         INT             NOT NULL,
    [start_step]                       DATETIME        NOT NULL,
    [end_step]                         DATETIME        NOT NULL,
    [input_value]                      NUMERIC (18, 4) NULL,
    [id_Territory]                     INT             NULL,
    [id_olap_scheduler_execution]      INT             NULL,
    [id_olap_scheduler_execution_step] INT             NULL,
    CONSTRAINT [PK_k_m_values_detail] PRIMARY KEY CLUSTERED ([id_value_detail] ASC),
    CONSTRAINT [FK_k_m_values_detail_k_m_olap_scheduler_execution] FOREIGN KEY ([id_olap_scheduler_execution]) REFERENCES [dbo].[k_m_olap_scheduler_execution] ([id_olap_scheduler_execution]),
    CONSTRAINT [FK_k_m_values_detail_k_m_olap_scheduler_execution_step] FOREIGN KEY ([id_olap_scheduler_execution_step]) REFERENCES [dbo].[k_m_olap_scheduler_execution_step] ([id_olap_scheduler_execution_step])
);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_values_detail_id_olap_scheduler_execution]
    ON [dbo].[k_m_values_detail]([id_olap_scheduler_execution] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_values_detail_id_olap_scheduler_execution_step]
    ON [dbo].[k_m_values_detail]([id_olap_scheduler_execution_step] ASC);

