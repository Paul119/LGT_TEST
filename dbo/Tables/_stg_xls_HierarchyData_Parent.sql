CREATE TABLE [dbo].[_stg_xls_HierarchyData_Parent] (
    [ParentId] INT           IDENTITY (1, 1) NOT NULL,
    [Label]    NVARCHAR (50) NULL,
    CONSTRAINT [PK_tbl_HierarchyData_Parent_ID] PRIMARY KEY CLUSTERED ([ParentId] ASC)
);

