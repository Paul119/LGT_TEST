CREATE TABLE [dbo].[_stg_xls_TitleData] (
    [stgTitleDataId]  INT            IDENTITY (1, 1) NOT NULL,
    [PersonnelNumber] NVARCHAR (255) NULL,
    [EffectiveDate]   DATE           NULL,
    [TitleCode]       NVARCHAR (255) NULL,
    [AuditId]         BIGINT         NULL,
    [DateLoading]     DATETIME       DEFAULT (getdate()) NULL,
    [FileName]        NVARCHAR (500) NULL,
    [QcStatusCode]    NVARCHAR (150) DEFAULT (replicate('0',(150))) NULL,
    [ParentId]        INT            DEFAULT ((1)) NULL,
    CONSTRAINT [pk_stg_xls_TitleData_stgTitleDataId] PRIMARY KEY CLUSTERED ([stgTitleDataId] ASC)
);

