CREATE TABLE [dbo].[_stg_xls_OrganizationData_Error] (
    [ErrorId]         INT            IDENTITY (1, 1) NOT NULL,
    [Error]           NVARCHAR (255) NULL,
    [PersonnelNumber] NVARCHAR (255) NULL,
    [EffectiveDate]   NVARCHAR (255) NULL,
    [ReportManager]   NVARCHAR (255) NULL,
    [CostCenter]      NVARCHAR (255) NULL,
    [BusinessUnit]    NVARCHAR (255) NULL,
    [BusinessArea]    NVARCHAR (255) NULL,
    [Department]      NVARCHAR (255) NULL,
    [LegalEntity]     NVARCHAR (255) NULL,
    [ParentId]        INT            DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tbl_OrganizationData_Error_ID] PRIMARY KEY CLUSTERED ([ErrorId] ASC)
);

