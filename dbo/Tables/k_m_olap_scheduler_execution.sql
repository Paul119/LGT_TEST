CREATE TABLE [dbo].[k_m_olap_scheduler_execution] (
    [id_olap_scheduler_execution]      INT            IDENTITY (1, 1) NOT NULL,
    [id_olap_scheduler]                INT            NOT NULL,
    [start_date]                       DATETIME       NOT NULL,
    [end_date]                         DATETIME       NULL,
    [id_user_created]                  INT            NOT NULL,
    [id_olap_scheduler_status]         TINYINT        NOT NULL,
    [description]                      NVARCHAR (MAX) NULL,
    [is_cancelled]                     BIT            CONSTRAINT [DF_k_m_olap_scheduler_execution_is_cancelled] DEFAULT ((0)) NOT NULL,
    [id_olap_scheduler_execution_main] INT            NULL,
    [execution_type]                   TINYINT        CONSTRAINT [DF_k_m_olap_scheduler_execution_execution_type] DEFAULT ((0)) NOT NULL,
    [id_crediting_run]                 VARCHAR (40)   NULL,
    CONSTRAINT [PK_k_m_olap_scheduler_execution] PRIMARY KEY CLUSTERED ([id_olap_scheduler_execution] ASC),
    CONSTRAINT [FK_k_m_olap_scheduler_execution_k_m_olap_scheduler] FOREIGN KEY ([id_olap_scheduler]) REFERENCES [dbo].[k_m_olap_scheduler] ([id]),
    CONSTRAINT [FK_k_m_olap_scheduler_execution_k_m_olap_scheduler_execution] FOREIGN KEY ([id_olap_scheduler_execution_main]) REFERENCES [dbo].[k_m_olap_scheduler_execution] ([id_olap_scheduler_execution]),
    CONSTRAINT [FK_k_m_olap_scheduler_execution_k_m_olap_scheduler_status] FOREIGN KEY ([id_olap_scheduler_status]) REFERENCES [dbo].[k_m_olap_scheduler_status] ([id_olap_scheduler_status]),
    CONSTRAINT [FK_k_m_olap_scheduler_execution_k_users] FOREIGN KEY ([id_user_created]) REFERENCES [dbo].[k_users] ([id_user])
);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_olap_scheduler_execution_id_olap_scheduler]
    ON [dbo].[k_m_olap_scheduler_execution]([id_olap_scheduler] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_olap_scheduler_execution_id_olap_scheduler_status]
    ON [dbo].[k_m_olap_scheduler_execution]([id_olap_scheduler_status] ASC);

