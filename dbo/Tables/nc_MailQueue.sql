CREATE TABLE [dbo].[nc_MailQueue] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [mailSubject]  NVARCHAR (250) NULL,
    [mailContent]  NVARCHAR (MAX) NULL,
    [sentTo]       NVARCHAR (MAX) NULL,
    [mailCC]       NVARCHAR (MAX) NULL,
    [mailBCC]      NVARCHAR (MAX) NULL,
    [mailAttach]   NVARCHAR (250) NULL,
    [createDate]   DATETIME       NULL,
    [sentDate]     DATETIME       NULL,
    [isSent]       BIT            NULL,
    [sendTryCount] INT            NULL,
    [priority]     SMALLINT       NULL,
    [sourceId]     INT            NULL,
    [typeSource]   INT            NULL,
    [scheduleDate] DATETIME       NULL,
    [isDeleted]    BIT            CONSTRAINT [DF_nc_MailQueue_isDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_nc_MailQueue] PRIMARY KEY CLUSTERED ([id] ASC)
);

