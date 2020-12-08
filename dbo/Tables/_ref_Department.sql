CREATE TABLE [dbo].[_ref_Department] (
    [DepartmentId]               INT           IDENTITY (1, 1) NOT NULL,
    [DepartmentCode]             NVARCHAR (10) NOT NULL,
    [DepartmentShortCode]        NVARCHAR (10) NULL,
    [DepartmentShortDescription] NVARCHAR (50) NULL,
    CONSTRAINT [pk_ref_Department_DepartmentId] PRIMARY KEY CLUSTERED ([DepartmentId] ASC)
);

