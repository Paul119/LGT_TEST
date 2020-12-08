CREATE TABLE [dbo].[_tb_employee_fte_20200911150341] (
    [employeeFTEId]    INT            IDENTITY (1, 1) NOT NULL,
    [IdPayee]          INT            NULL,
    [PersonnelNumber]  INT            NULL,
    [EffectiveDate]    DATE           NULL,
    [EndDate]          DATE           NULL,
    [FTE]              DECIMAL (2, 1) NULL,
    [id_user]          INT            NULL,
    [CreatedDate]      DATETIME       NULL,
    [ModificationDate] DATETIME       NULL,
    [ParentId]         INT            NULL
);

