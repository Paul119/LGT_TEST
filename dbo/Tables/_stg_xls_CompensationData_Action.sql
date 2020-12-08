CREATE TABLE [dbo].[_stg_xls_CompensationData_Action] (
    [ID]       INT           IDENTITY (1, 1) NOT NULL,
    [ActionId] INT           NULL,
    [Label]    NVARCHAR (50) NULL,
    [ParentId] INT           NULL,
    CONSTRAINT [PK_tbl_CompensationData_Action_ID] PRIMARY KEY CLUSTERED ([ID] ASC)
);

