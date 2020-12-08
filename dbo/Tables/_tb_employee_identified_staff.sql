CREATE TABLE [dbo].[_tb_employee_identified_staff] (
    [EmpIdStaffId]        INT             IDENTITY (1, 1) NOT NULL,
    [PersonnelNumber]     NVARCHAR (15)   NOT NULL,
    [Deferall_3Y_pct]     DECIMAL (5, 2)  NULL,
    [Coinv_Overall_pct]   DECIMAL (5, 2)  NULL,
    [SS_pct]              DECIMAL (5, 2)  NULL,
    [Taxes_pct]           DECIMAL (5, 2)  NULL,
    [Deffered_Amount_Ym2] DECIMAL (18, 2) NULL,
    [Deffered_Amount_Ym1] DECIMAL (18, 2) NULL,
    CONSTRAINT [pk_tb_employee_identified_staff] PRIMARY KEY CLUSTERED ([EmpIdStaffId] ASC)
);

