CREATE TABLE [dbo].[_tb_employee_Job_20191205154525] (
    [employeeJobId]    INT          IDENTITY (1, 1) NOT NULL,
    [IdPayee]          INT          NULL,
    [PersonnelNumber]  INT          NULL,
    [EffectiveDate]    DATE         NULL,
    [EndDate]          DATE         NULL,
    [JobCode]          NVARCHAR (6) NULL,
    [id_user]          INT          NULL,
    [CreatedDate]      DATETIME     NULL,
    [ModificationDate] DATETIME     NULL,
    [ParentId]         INT          NULL
);

