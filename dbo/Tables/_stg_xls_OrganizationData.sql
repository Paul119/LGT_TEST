CREATE TABLE [dbo].[_stg_xls_OrganizationData] (
    [stgOrganizationDataId] INT            IDENTITY (1, 1) NOT NULL,
    [PersonnelNumber]       NVARCHAR (255) NULL,
    [EffectiveDate]         NVARCHAR (255) NULL,
    [ReportManager]         NVARCHAR (255) NULL,
    [CostCenter]            NVARCHAR (255) NULL,
    [BusinessUnit]          NVARCHAR (255) NULL,
    [BusinessArea]          NVARCHAR (255) NULL,
    [Department]            NVARCHAR (255) NULL,
    [LegalEntity]           NVARCHAR (255) NULL,
    [AuditId]               BIGINT         NULL,
    [DateLoading]           DATETIME       DEFAULT (getdate()) NULL,
    [FileName]              NVARCHAR (500) NULL,
    [QcStatusCode]          NVARCHAR (150) DEFAULT (replicate('0',(150))) NULL,
    [ParentId]              INT            DEFAULT ((1)) NULL,
    CONSTRAINT [pk_stg_xls_OrganizationData_stgOrganizationDataId] PRIMARY KEY CLUSTERED ([stgOrganizationDataId] ASC)
);

