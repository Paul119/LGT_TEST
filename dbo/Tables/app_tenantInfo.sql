CREATE TABLE [dbo].[app_tenantInfo] (
    [id]              INT              IDENTITY (1, 1) NOT NULL,
    [uidTenant]       UNIQUEIDENTIFIER NOT NULL,
    [keyTenant]       NVARCHAR (200)   NOT NULL,
    [idProduct]       INT              NOT NULL,
    [createDate]      DATETIME         NULL,
    [lastUpdatedDate] DATETIME         NULL,
    CONSTRAINT [PK_app_tenantInfo] PRIMARY KEY CLUSTERED ([id] ASC)
);

