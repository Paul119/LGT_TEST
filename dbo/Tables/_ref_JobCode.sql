CREATE TABLE [dbo].[_ref_JobCode] (
    [JobCodeId]           INT           IDENTITY (1, 1) NOT NULL,
    [JobCode]             NVARCHAR (6)  NOT NULL,
    [JobCodeDescription]  NVARCHAR (50) NULL,
    [Function]            NVARCHAR (2)  NULL,
    [FunctionDescription] NVARCHAR (50) NULL,
    [SubFunction]         NVARCHAR (50) NULL,
    CONSTRAINT [pk_ref_JobCode_JobCodeId] PRIMARY KEY CLUSTERED ([JobCodeId] ASC)
);

