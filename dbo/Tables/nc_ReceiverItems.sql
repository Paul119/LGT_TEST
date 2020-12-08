CREATE TABLE [dbo].[nc_ReceiverItems] (
    [id]              INT IDENTITY (1, 1) NOT NULL,
    [idReveiver]      INT NULL,
    [idITem]          INT NULL,
    [itemType]        INT NULL,
    [isReceiverPayee] BIT CONSTRAINT [DF_nc_ReceiverItems_isReceiverPayee] DEFAULT ((0)) NOT NULL,
    [receiverType]    INT NOT NULL,
    CONSTRAINT [PK_nc_ReceiverItems] PRIMARY KEY CLUSTERED ([id] ASC)
);

