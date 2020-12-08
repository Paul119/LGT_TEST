CREATE TABLE [dbo].[_stg_xls_CompensationData] (
    [stgCompensationDataId] INT            IDENTITY (1, 1) NOT NULL,
    [PersonnelNumber]       NVARCHAR (255) NULL,
    [CompensationType]      NVARCHAR (255) NULL,
    [AwardDate]             NVARCHAR (255) NULL,
    [TargetValue]           NVARCHAR (255) NULL,
    [TargetValueMin]        NVARCHAR (255) NULL,
    [TargetValueMax]        NVARCHAR (255) NULL,
    [PaidDate]              NVARCHAR (255) NULL,
    [PaidValue]             NVARCHAR (255) NULL,
    [Currency]              NVARCHAR (255) NULL,
    [AuditId]               BIGINT         NULL,
    [DateLoading]           DATETIME       DEFAULT (getdate()) NULL,
    [FileName]              NVARCHAR (500) NULL,
    [QcStatusCode]          NVARCHAR (150) DEFAULT (replicate('0',(150))) NULL,
    [ParentId]              INT            DEFAULT ((1)) NULL,
    CONSTRAINT [pk_stg_xls_CompensationData_stgCompensationDataId] PRIMARY KEY CLUSTERED ([stgCompensationDataId] ASC)
);

