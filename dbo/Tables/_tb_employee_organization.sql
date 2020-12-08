CREATE TABLE [dbo].[_tb_employee_organization] (
    [employeeOrganizationId] INT           IDENTITY (1, 1) NOT NULL,
    [IdPayee]                INT           NULL,
    [PersonnelNumber]        INT           NULL,
    [EffectiveDate]          DATE          NULL,
    [EndDate]                DATE          NULL,
    [ReportManager]          NVARCHAR (15) NULL,
    [CostCenter]             NVARCHAR (5)  NULL,
    [BusinessUnit]           NVARCHAR (15) NULL,
    [BusinessArea]           NVARCHAR (10) NULL,
    [Department]             NVARCHAR (10) NULL,
    [LegalEntity]            NVARCHAR (4)  NULL,
    [id_user]                INT           NULL,
    [CreatedDate]            DATETIME      NULL,
    [ModificationDate]       DATETIME      NULL,
    [ParentId]               INT           NULL,
    CONSTRAINT [pk_tb_employee_organization_employeeOrganizationId] PRIMARY KEY CLUSTERED ([employeeOrganizationId] ASC)
);


GO

CREATE TRIGGER tr_tb_employee_organization_parentid
   ON  dbo._tb_employee_organization
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE t 
	set parentid = 1
	from _tb_employee_organization t 
	where ISNULL(parentid,0) <> 1

    -- Insert statements for trigger here

END