CREATE TABLE [dbo].[k_monitor_log] (
    [id]               INT              IDENTITY (1, 1) NOT NULL,
    [id_event]         UNIQUEIDENTIFIER NOT NULL,
    [id_monitor_event] INT              NOT NULL,
    [start_date]       DATETIME2 (7)    NOT NULL,
    [end_date]         DATETIME2 (7)    NULL,
    [id_user]          INT              NOT NULL,
    [is_error]         BIT              CONSTRAINT [DF_k_monitor_log_is_error] DEFAULT ((0)) NOT NULL,
    [is_alerted]       BIT              NOT NULL,
    CONSTRAINT [PK_k_monitor_log] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_monitor_log_k_users] FOREIGN KEY ([id_user]) REFERENCES [dbo].[k_users] ([id_user])
);

