CREATE TABLE [dbo].[k_m_olap_scheduler_indicators_field] (
    [ID]               INT IDENTITY (1, 1) NOT NULL,
    [OlapSchedulerID]  INT NOT NULL,
    [IndicatorFieldID] INT NOT NULL,
    CONSTRAINT [PK_k_m_olap_scheduler_indicators_field] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_k_m_olap_scheduler_indicators_field_m_indicators_fields] FOREIGN KEY ([IndicatorFieldID]) REFERENCES [dbo].[k_m_indicators_fields] ([id_indicator_field]) ON DELETE CASCADE,
    CONSTRAINT [FK_k_m_olap_scheduler_indicators_field_m_olap_scheduler] FOREIGN KEY ([OlapSchedulerID]) REFERENCES [dbo].[k_m_olap_scheduler] ([id])
);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_olap_scheduler_indicators_field_OlapSchedulerID]
    ON [dbo].[k_m_olap_scheduler_indicators_field]([OlapSchedulerID] ASC);

