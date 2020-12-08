CREATE TABLE [dbo].[k_monitor_event] (
    [id_monitor_event]      INT IDENTITY (1, 1) NOT NULL,
    [id_monitor_event_type] INT NOT NULL,
    [id_rule]               INT NULL,
    [id_cond]               INT NULL,
    [id_execution_plan]     INT NULL,
    [is_active]             BIT NOT NULL,
    CONSTRAINT [PK_k_monitor_event] PRIMARY KEY CLUSTERED ([id_monitor_event] ASC),
    CONSTRAINT [FK_k_monitor_event_k_monitor_event_type] FOREIGN KEY ([id_monitor_event_type]) REFERENCES [dbo].[k_monitor_event_type] ([id_monitor_event_type])
);

