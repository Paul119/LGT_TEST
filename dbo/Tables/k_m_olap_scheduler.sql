CREATE TABLE [dbo].[k_m_olap_scheduler] (
    [id]                       INT      IDENTITY (1, 1) NOT NULL,
    [idProcess]                INT      NULL,
    [deleteBeforeStart]        BIT      NULL,
    [formattedValue]           BIT      NULL,
    [lastCalulcationTime]      DATETIME NULL,
    [isCalculated]             BIT      NULL,
    [Status]                   AS       (case [isCalculated] when (1) then 'Calculated' else 'Not Calculated' end),
    [startDate]                DATETIME NULL,
    [endDate]                  DATETIME NULL,
    [idPop]                    INT      NULL,
    [idPayee]                  INT      NULL,
    [id_olap_scheduler_status] TINYINT  CONSTRAINT [DF_k_m_olap_scheduler_id_olap_scheduler_status] DEFAULT ((0)) NOT NULL,
    [is_deleted]               BIT      CONSTRAINT [DF_k_m_olap_scheduler_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_k_m_olap_scheduler] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_m_olap_scheduler_k_m_olap_scheduler_status] FOREIGN KEY ([id_olap_scheduler_status]) REFERENCES [dbo].[k_m_olap_scheduler_status] ([id_olap_scheduler_status])
);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_olap_scheduler_id_olap_scheduler_status]
    ON [dbo].[k_m_olap_scheduler]([id_olap_scheduler_status] ASC);

