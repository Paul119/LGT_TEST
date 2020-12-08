CREATE TABLE [dbo].[k_users_parameters_control] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [columnName]  NVARCHAR (50) NULL,
    [columnKey]   NVARCHAR (50) NULL,
    [groupHeader] NVARCHAR (50) NULL,
    [controlId]   INT           NULL,
    [sort]        INT           NULL,
    [isApplied]   BIT           NULL,
    [idParent]    INT           NULL,
    CONSTRAINT [PK_k_users_parameters_control] PRIMARY KEY CLUSTERED ([id] ASC)
);

