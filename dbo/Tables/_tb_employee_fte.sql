CREATE TABLE [dbo].[_tb_employee_fte] (
    [employeeFTEId]    INT            IDENTITY (1, 1) NOT NULL,
    [IdPayee]          INT            NULL,
    [PersonnelNumber]  INT            NULL,
    [EffectiveDate]    DATE           NULL,
    [EndDate]          DATE           NULL,
    [FTE]              DECIMAL (2, 1) NULL,
    [id_user]          INT            NULL,
    [CreatedDate]      DATETIME       NULL,
    [ModificationDate] DATETIME       NULL,
    [ParentId]         INT            NULL,
    CONSTRAINT [pk_tb_employee_fte_employeeFTEId] PRIMARY KEY CLUSTERED ([employeeFTEId] ASC)
);


GO

CREATE TRIGGER tr_tb_employee_fte_parentid
   ON  dbo._tb_employee_fte
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE t 
	set parentid = 1
	from _tb_employee_fte t 
	where ISNULL(parentid,0) <> 1

    -- Insert statements for trigger here

END