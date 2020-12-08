CREATE TABLE [dbo].[_stg_xls_CompensationData_Error] (
    [ErrorId]          INT            IDENTITY (1, 1) NOT NULL,
    [Error]            NVARCHAR (500) NULL,
    [PersonnelNumber]  NVARCHAR (255) NULL,
    [CompensationType] NVARCHAR (255) NULL,
    [AwardDate]        NVARCHAR (255) NULL,
    [TargetValue]      NVARCHAR (255) NULL,
    [TargetValueMin]   NVARCHAR (255) NULL,
    [TargetValueMax]   NVARCHAR (255) NULL,
    [PaidDate]         NVARCHAR (255) NULL,
    [PaidValue]        NVARCHAR (255) NULL,
    [Currency]         NVARCHAR (255) NULL,
    [ParentId]         INT            DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tbl_CompensationData_Error_ID] PRIMARY KEY CLUSTERED ([ErrorId] ASC)
);

