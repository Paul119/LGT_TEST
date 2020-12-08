CREATE TABLE [dbo].[k_monitor_event_alert] (
    [id_monitor_event_alert]      INT            IDENTITY (1, 1) NOT NULL,
    [id_monitor_event]            INT            NOT NULL,
    [id_monitor_event_alert_type] INT            NOT NULL,
    [email_to]                    NVARCHAR (255) NULL,
    [email_subject]               NVARCHAR (255) NULL,
    [email_content]               NVARCHAR (MAX) NULL,
    [is_active]                   BIT            NULL,
    [threshold_in_minute]         INT            NULL,
    [use_translate]               BIT            CONSTRAINT [DF_k_monitor_event_alert_use_translate] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_k_monitor_event_alert] PRIMARY KEY CLUSTERED ([id_monitor_event_alert] ASC),
    CONSTRAINT [FK_k_monitor_event_alert_k_monitor_event] FOREIGN KEY ([id_monitor_event]) REFERENCES [dbo].[k_monitor_event] ([id_monitor_event]),
    CONSTRAINT [FK_k_monitor_event_alert_k_monitor_event_alert_type] FOREIGN KEY ([id_monitor_event_alert_type]) REFERENCES [dbo].[k_monitor_event_alert_type] ([id_monitor_event_alert_type])
);

