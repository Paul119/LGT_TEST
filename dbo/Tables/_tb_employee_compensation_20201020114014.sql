CREATE TABLE [dbo].[_tb_employee_compensation_20201020114014] (
    [employeecompensationId] INT             IDENTITY (1, 1) NOT NULL,
    [IdPayee]                INT             NULL,
    [PersonnelNumber]        NVARCHAR (15)   NULL,
    [PayrollType]            NVARCHAR (10)   NULL,
    [AwardDate]              DATE            NULL,
    [EndDate]                DATE            NULL,
    [TargetValueMin]         DECIMAL (32, 2) NULL,
    [TargetValueMax]         DECIMAL (32, 2) NULL,
    [TargetValue]            DECIMAL (32, 2) NULL,
    [PaidDate]               DATE            NULL,
    [PaidValue]              DECIMAL (32, 2) NULL,
    [Currency]               NVARCHAR (3)    NULL,
    [id_user]                INT             NULL,
    [CreatedDate]            DATETIME        NULL,
    [ModificationDate]       DATETIME        NULL,
    [ParentId]               INT             NULL
);

