CREATE TABLE [dbo].[nc_NotificationQueue] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [idNotification] INT            NULL,
    [title]          NVARCHAR (100) NULL,
    [definition]     NVARCHAR (MAX) NULL,
    [idOwner]        INT            NULL,
    [createTime]     DATETIME       NULL,
    [dueTime]        DATETIME       NULL,
    [isRead]         BIT            NULL,
    [treeId]         INT            NULL,
    [isDeleted]      BIT            CONSTRAINT [DF_nc_NotificationQueue_isDeleted] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_nc_CommunicationNotificationQueue] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_nc_CommunicationNotificationQueue_nc_CommunicationNotification] FOREIGN KEY ([idNotification]) REFERENCES [dbo].[nc_Notification] ([id])
);


GO
CREATE NONCLUSTERED INDEX [IX_nc_NotificationQueue_Owner]
    ON [dbo].[nc_NotificationQueue]([idOwner] ASC);

