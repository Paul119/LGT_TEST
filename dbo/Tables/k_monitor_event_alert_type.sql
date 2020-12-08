CREATE TABLE [dbo].[k_monitor_event_alert_type] (
    [id_monitor_event_alert_type]   INT            IDENTITY (1, 1) NOT NULL,
    [name_monitor_event_alert_type] NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_k_monitor_event_alert_type] PRIMARY KEY CLUSTERED ([id_monitor_event_alert_type] ASC)
);

