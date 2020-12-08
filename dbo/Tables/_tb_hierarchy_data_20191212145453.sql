﻿CREATE TABLE [dbo].[_tb_hierarchy_data_20191212145453] (
    [hierarchydataId]       INT           IDENTITY (1, 1) NOT NULL,
    [Emp_IdPayee]           INT           NULL,
    [Emp_Id]                NVARCHAR (15) NULL,
    [Emp_FirstName]         NVARCHAR (50) NULL,
    [Emp_Lastname]          NVARCHAR (50) NULL,
    [Emp_ShortSign]         NVARCHAR (5)  NULL,
    [Mgr_IdPayee]           INT           NULL,
    [Mgr_ID]                NVARCHAR (15) NULL,
    [Mgr_FirstName]         NVARCHAR (50) NULL,
    [Mgr_LastName]          NVARCHAR (50) NULL,
    [FirstInput_Idpayee]    INT           NULL,
    [FirstInput_Id]         NVARCHAR (15) NULL,
    [FirstInput_ShortSign]  NVARCHAR (5)  NULL,
    [SecondInput_IdPayee]   INT           NULL,
    [SecondInput_Id]        NVARCHAR (15) NULL,
    [SecondInput_ShortSign] NVARCHAR (5)  NULL,
    [View_IdPayee]          INT           NULL,
    [View_Id]               NVARCHAR (15) NULL,
    [View_ShortSign]        NVARCHAR (5)  NULL,
    [FinalInput_IdPayee]    INT           NULL,
    [FinalInput_Id]         NVARCHAR (15) NULL,
    [FinalInput_ShortSign]  NVARCHAR (5)  NULL,
    [ParentId]              INT           NULL
);

