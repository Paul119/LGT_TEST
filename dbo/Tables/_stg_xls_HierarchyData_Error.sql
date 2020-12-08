CREATE TABLE [dbo].[_stg_xls_HierarchyData_Error] (
    [ErrorId]               INT            IDENTITY (1, 1) NOT NULL,
    [Error]                 NVARCHAR (255) NULL,
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
    [ParentId]              INT            DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tbl_HierarchyData_Error_ID] PRIMARY KEY CLUSTERED ([ErrorId] ASC)
);

