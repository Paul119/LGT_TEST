CREATE TABLE [dbo].[nc_Receiver] (
    [id]           INT           IDENTITY (1, 1) NOT NULL,
    [ncType]       INT           NULL,
    [ncTrigger]    INT           NULL,
    [triggerEvent] INT           NULL,
    [receiverName] NVARCHAR (50) NULL,
    [receiverCode] NVARCHAR (50) NULL,
    CONSTRAINT [PK_nc_Receiver] PRIMARY KEY CLUSTERED ([id] ASC)
);

