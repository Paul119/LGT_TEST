CREATE TABLE [dbo].[k_monitor_event_alert_variable] (
    [id_monitor_event_alert_variable] INT            IDENTITY (1, 1) NOT NULL,
    [name_variable]                   NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_k_monitor_event_alert_variable] PRIMARY KEY CLUSTERED ([id_monitor_event_alert_variable] ASC)
);

