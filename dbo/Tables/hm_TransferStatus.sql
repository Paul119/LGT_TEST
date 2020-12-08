CREATE TABLE [dbo].[hm_TransferStatus] (
    [id]   INT           IDENTITY (1, 1) NOT NULL,
    [name] NVARCHAR (50) NULL,
    CONSTRAINT [PK_hm_TransferStatus] PRIMARY KEY CLUSTERED ([id] ASC)
);

