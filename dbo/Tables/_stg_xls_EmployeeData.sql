﻿CREATE TABLE [dbo].[_stg_xls_EmployeeData] (
    [stgEmployeeDataId] INT            IDENTITY (1, 1) NOT NULL,
    [PersonnelNumber]   NVARCHAR (255) NULL,
    [Name]              NVARCHAR (255) NULL,
    [FirstName]         NVARCHAR (255) NULL,
    [BirthDate]         NVARCHAR (255) NULL,
    [Gender]            NVARCHAR (255) NULL,
    [EntryDate]         NVARCHAR (255) NULL,
    [LeavingDate]       NVARCHAR (255) NULL,
    [Adress]            NVARCHAR (255) NULL,
    [PostalCode]        NVARCHAR (255) NULL,
    [City]              NVARCHAR (255) NULL,
    [Canton]            NVARCHAR (255) NULL,
    [Country]           NVARCHAR (255) NULL,
    [EmployeeClass]     NVARCHAR (255) NULL,
    [EMailAddress]      NVARCHAR (255) NULL,
    [Infotext]          NVARCHAR (255) NULL,
    [AuditId]           BIGINT         NULL,
    [DateLoading]       DATETIME       DEFAULT (getdate()) NULL,
    [FileName]          NVARCHAR (500) NULL,
    [QcStatusCode]      NVARCHAR (150) DEFAULT (replicate('0',(150))) NULL,
    [ParentId]          INT            DEFAULT ((1)) NULL,
    CONSTRAINT [pk_stg_xls_EmployeeData_stgEmployeeDataId] PRIMARY KEY CLUSTERED ([stgEmployeeDataId] ASC)
);

