CREATE TABLE [dbo].[_tb_employee_compensation] (
    [employeecompensationId] INT             IDENTITY (1, 1) NOT NULL,
    [IdPayee]                INT             NULL,
    [PersonnelNumber]        NVARCHAR (15)   NULL,
    [PayrollType]            NVARCHAR (10)   NULL,
    [AwardDate]              DATE            NULL,
    [EndDate]                DATE            NULL,
    [TargetValueMin]         DECIMAL (32, 2) NULL,
    [TargetValueMax]         DECIMAL (32, 2) NULL,
    [TargetValue]            DECIMAL (32, 2) NULL,
    [PaidDate]               DATE            NULL,
    [PaidValue]              DECIMAL (32, 2) NULL,
    [Currency]               NVARCHAR (3)    NULL,
    [id_user]                INT             NULL,
    [CreatedDate]            DATETIME        NULL,
    [ModificationDate]       DATETIME        NULL,
    [ParentId]               INT             NULL,
    CONSTRAINT [pk_tb_employee_compensation_employeecompensationId] PRIMARY KEY CLUSTERED ([employeecompensationId] ASC)
);


GO

CREATE TRIGGER tr_tb_employee_compensation_parentid
   ON  dbo._tb_employee_compensation
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE t 
	set parentid = 1
	from _tb_employee_compensation t 
	where ISNULL(parentid,0) <> 1

    -- Insert statements for trigger here

END