CREATE TABLE [dbo].[_stg_xls_FTEData_Parent] (
    [ParentId] INT           IDENTITY (1, 1) NOT NULL,
    [Label]    NVARCHAR (50) NULL,
    CONSTRAINT [PK_tbl_FTEData_Parent_ID] PRIMARY KEY CLUSTERED ([ParentId] ASC)
);

