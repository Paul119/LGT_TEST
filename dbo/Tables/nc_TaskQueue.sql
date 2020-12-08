CREATE TABLE [dbo].[nc_TaskQueue] (
    [id]                   INT            IDENTITY (1, 1) NOT NULL,
    [idTask]               INT            NULL,
    [title]                NVARCHAR (100) NULL,
    [definition]           NVARCHAR (MAX) NULL,
    [idOwner]              INT            NULL,
    [createTime]           DATETIME       NULL,
    [dueTime]              DATETIME       NULL,
    [isCompleted]          BIT            NULL,
    [warnTime]             DATETIME       NULL,
    [criticTime]           DATETIME       NULL,
    [idTransferredPerson]  INT            NULL,
    [treeId]               INT            NULL,
    [additionalParameters] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_nc_TaskNotificationQueue] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_nc_TaskQueue_nc_Task] FOREIGN KEY ([idTask]) REFERENCES [dbo].[nc_Task] ([id])
);

