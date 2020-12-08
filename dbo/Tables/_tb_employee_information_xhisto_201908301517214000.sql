﻿CREATE TABLE [dbo].[_tb_employee_information_xhisto_201908301517214000] (
    [id_xhisto]        INT            IDENTITY (1, 1) NOT NULL,
    [id_user_xhisto]   INT            NOT NULL,
    [dt_xhisto]        DATETIME       NOT NULL,
    [type_xhisto]      CHAR (3)       NOT NULL,
    [Adress]           NVARCHAR (255) NULL,
    [BirthDate]        DATETIME       NULL,
    [Canton]           NVARCHAR (5)   NULL,
    [City]             NVARCHAR (50)  NULL,
    [Country]          NVARCHAR (50)  NULL,
    [CreatedDate]      DATETIME       NULL,
    [EMailAddress]     NVARCHAR (100) NULL,
    [EmployeeClass]    NVARCHAR (3)   NULL,
    [employeeInfoId]   INT            NULL,
    [EntryDate]        DATETIME       NULL,
    [FirstName]        NVARCHAR (50)  NULL,
    [Gender]           NVARCHAR (5)   NULL,
    [id_user]          INT            NULL,
    [IdPayee]          INT            NULL,
    [Infotext]         NVARCHAR (255) NULL,
    [LeavingDate]      DATETIME       NULL,
    [ModificationDate] DATETIME       NULL,
    [Name]             NVARCHAR (50)  NULL,
    [ParentId]         INT            NULL,
    [PersonnelNumber]  NVARCHAR (15)  NULL,
    [PostalCode]       NVARCHAR (15)  NULL,
    PRIMARY KEY CLUSTERED ([id_xhisto] ASC)
);
