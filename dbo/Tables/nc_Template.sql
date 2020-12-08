CREATE TABLE [dbo].[nc_Template] (
    [id]        INT            IDENTITY (1, 1) NOT NULL,
    [idTrigger] INT            NULL,
    [name]      NVARCHAR (500) NULL,
    [content]   NVARCHAR (MAX) NULL,
    [idType]    INT            NULL,
    CONSTRAINT [PK_tbl_NotificationTemplate] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_nc_NotificationTemplate_nc_NotificationTemplate] FOREIGN KEY ([idType]) REFERENCES [dbo].[nc_Type] ([id]),
    CONSTRAINT [FK_nc_Template_nc_Trigger] FOREIGN KEY ([idTrigger]) REFERENCES [dbo].[nc_Trigger] ([id])
);

