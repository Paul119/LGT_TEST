CREATE TABLE [dbo].[_tb_employee_Organization_20191205153122] (
    [employeeOrganizationId] INT           IDENTITY (1, 1) NOT NULL,
    [IdPayee]                INT           NULL,
    [PersonnelNumber]        INT           NULL,
    [EffectiveDate]          DATE          NULL,
    [EndDate]                DATE          NULL,
    [ReportManager]          NVARCHAR (15) NULL,
    [CostCenter]             NVARCHAR (5)  NULL,
    [BusinessUnit]           NVARCHAR (15) NULL,
    [BusinessArea]           NVARCHAR (10) NULL,
    [Department]             NVARCHAR (10) NULL,
    [LegalEntity]            NVARCHAR (4)  NULL,
    [id_user]                INT           NULL,
    [CreatedDate]            DATETIME      NULL,
    [ModificationDate]       DATETIME      NULL,
    [ParentId]               INT           NULL
);

