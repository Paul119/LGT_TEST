﻿CREATE TABLE [dbo].[_stg_xls_HierarchyData] (
    [stgHierarchydataId]    INT            IDENTITY (1, 1) NOT NULL,
    [Emp_Id]                NVARCHAR (255) NULL,
    [Emp_FirstName]         NVARCHAR (255) NULL,
    [Emp_Lastname]          NVARCHAR (255) NULL,
    [Emp_ShortSign]         NVARCHAR (255) NULL,
    [Mgr_ID]                NVARCHAR (255) NULL,
    [Mgr_FirstName]         NVARCHAR (255) NULL,
    [Mgr_LastName]          NVARCHAR (255) NULL,
    [FirstInput_Id]         NVARCHAR (255) NULL,
    [FirstInput_ShortSign]  NVARCHAR (255) NULL,
    [SecondInput_Id]        NVARCHAR (255) NULL,
    [SecondInput_ShortSign] NVARCHAR (255) NULL,
    [View_Id]               NVARCHAR (255) NULL,
    [View_ShortSign]        NVARCHAR (255) NULL,
    [FinalInput_Id]         NVARCHAR (255) NULL,
    [FinalInput_ShortSign]  NVARCHAR (255) NULL,
    [AuditId]               BIGINT         NULL,
    [DateLoading]           DATETIME       DEFAULT (getdate()) NULL,
    [FileName]              NVARCHAR (500) NULL,
    [QcStatusCode]          NVARCHAR (150) DEFAULT (replicate('0',(150))) NULL,
    [ParentId]              INT            DEFAULT ((1)) NULL,
    CONSTRAINT [pk_stg_xls_HierarchyData_stgHierarchydataId] PRIMARY KEY CLUSTERED ([stgHierarchydataId] ASC)
);

