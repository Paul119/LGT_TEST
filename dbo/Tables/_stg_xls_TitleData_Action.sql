CREATE TABLE [dbo].[_stg_xls_TitleData_Action] (
    [ID]       INT           IDENTITY (1, 1) NOT NULL,
    [ActionId] INT           NULL,
    [Label]    NVARCHAR (50) NULL,
    [ParentId] INT           NULL,
    CONSTRAINT [PK_tbl_TitleData_Action_ID] PRIMARY KEY CLUSTERED ([ID] ASC)
);

