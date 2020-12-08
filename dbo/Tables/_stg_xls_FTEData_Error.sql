CREATE TABLE [dbo].[_stg_xls_FTEData_Error] (
    [ErrorId]         INT            IDENTITY (1, 1) NOT NULL,
    [Error]           NVARCHAR (255) NULL,
    [PersonnelNumber] NVARCHAR (255) NULL,
    [EffectiveDate]   NVARCHAR (255) NULL,
    [FTE]             NVARCHAR (255) NULL,
    [ParentId]        INT            DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tbl_FTEData_Error_ID] PRIMARY KEY CLUSTERED ([ErrorId] ASC)
);

