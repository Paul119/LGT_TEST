CREATE TABLE [dbo].[nc_TriggerEvent] (
    [id]        INT            IDENTITY (1, 1) NOT NULL,
    [idTrigger] INT            NULL,
    [name]      NVARCHAR (500) NULL,
    CONSTRAINT [PK_k_m_NotificationAction] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_m_NotificationAction_k_m_Module] FOREIGN KEY ([idTrigger]) REFERENCES [dbo].[nc_Trigger] ([id])
);

