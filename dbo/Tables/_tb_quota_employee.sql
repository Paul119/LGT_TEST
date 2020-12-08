CREATE TABLE [dbo].[_tb_quota_employee] (
    [quotaID] INT           IDENTITY (1, 1) NOT NULL,
    [PersID]  NVARCHAR (15) NOT NULL,
    [SEG]     NVARCHAR (3)  NULL,
    PRIMARY KEY CLUSTERED ([quotaID] ASC)
);

