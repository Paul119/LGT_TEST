CREATE TABLE [dbo].[_ref_JobTitle] (
    [JobTitleId]          INT            IDENTITY (1, 1) NOT NULL,
    [Ranking]             INT            NULL,
    [JobTitleCode]        NVARCHAR (6)   NOT NULL,
    [JobTitleDescription] NVARCHAR (50)  NULL,
    [IdentifiedStaff]     NVARCHAR (3)   NULL,
    [DeferallQuotaPct]    INT            NULL,
    [Co-InvestQuotaPct]   INT            NULL,
    [Remarks]             NVARCHAR (255) NULL,
    CONSTRAINT [pk_ref_JobTitle_JobTitleId] PRIMARY KEY CLUSTERED ([JobTitleId] ASC)
);

