CREATE TABLE [dbo].[_stg_xls_FTEData] (
    [stgFTEDataId]    INT            IDENTITY (1, 1) NOT NULL,
    [PersonnelNumber] NVARCHAR (255) NULL,
    [EffectiveDate]   NVARCHAR (255) NULL,
    [FTE]             NVARCHAR (255) NULL,
    [AuditId]         BIGINT         NULL,
    [DateLoading]     DATETIME       DEFAULT (getdate()) NULL,
    [FileName]        NVARCHAR (500) NULL,
    [QcStatusCode]    NVARCHAR (150) DEFAULT (replicate('0',(150))) NULL,
    [ParentId]        INT            DEFAULT ((1)) NULL,
    CONSTRAINT [pk__stg_xls_FTEData_stgFTEDataId] PRIMARY KEY CLUSTERED ([stgFTEDataId] ASC)
);

