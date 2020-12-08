CREATE TABLE [dbo].[_tb_employee_information] (
    [employeeInfoId]   INT            IDENTITY (1, 1) NOT NULL,
    [IdPayee]          INT            NOT NULL,
    [PersonnelNumber]  NVARCHAR (15)  NULL,
    [Name]             NVARCHAR (50)  NULL,
    [FirstName]        NVARCHAR (50)  NULL,
    [BirthDate]        DATETIME       NULL,
    [Gender]           NVARCHAR (5)   NULL,
    [EntryDate]        DATETIME       NULL,
    [LeavingDate]      DATETIME       NULL,
    [Adress]           NVARCHAR (255) NULL,
    [PostalCode]       NVARCHAR (15)  NULL,
    [City]             NVARCHAR (50)  NULL,
    [Canton]           NVARCHAR (5)   NULL,
    [Country]          NVARCHAR (50)  NULL,
    [EmployeeClass]    NVARCHAR (3)   NULL,
    [EMailAddress]     NVARCHAR (100) NULL,
    [Infotext]         NVARCHAR (255) NULL,
    [id_user]          INT            NULL,
    [CreatedDate]      DATETIME       NULL,
    [ModificationDate] DATETIME       NULL,
    [ParentId]         INT            NULL,
    CONSTRAINT [pk_tb_employee_information_employeeInfoId] PRIMARY KEY CLUSTERED ([employeeInfoId] ASC)
);


GO

CREATE TRIGGER tr_tb_employee_information_parentid
   ON  dbo._tb_employee_information
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE t 
	set parentid = 1
	from _tb_employee_information t 
	where ISNULL(parentid,0) <> 1

    -- Insert statements for trigger here

END