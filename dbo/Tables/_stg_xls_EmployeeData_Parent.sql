CREATE TABLE [dbo].[_stg_xls_EmployeeData_Parent] (
    [ParentId] INT           IDENTITY (1, 1) NOT NULL,
    [Label]    NVARCHAR (50) NULL,
    CONSTRAINT [PK_tbl_EmployeeData_Parent_ID] PRIMARY KEY CLUSTERED ([ParentId] ASC)
);

