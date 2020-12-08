CREATE TABLE [dbo].[_ref_EmployeeClass] (
    [EmployeeClassId]          INT           IDENTITY (1, 1) NOT NULL,
    [EmployeeClassCode]        NVARCHAR (3)  NOT NULL,
    [EmployeeClassDescription] NVARCHAR (50) NULL,
    CONSTRAINT [pk_ref_EmployeeClass_EmployeeClassId] PRIMARY KEY CLUSTERED ([EmployeeClassId] ASC)
);

