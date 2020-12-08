CREATE TABLE [dbo].[_tb_employee_Title] (
    [employeeTitleId]  INT          IDENTITY (1, 1) NOT NULL,
    [IdPayee]          INT          NULL,
    [PersonnelNumber]  INT          NULL,
    [EffectiveDate]    DATE         NULL,
    [EndDate]          DATE         NULL,
    [TitleCode]        NVARCHAR (6) NULL,
    [id_user]          INT          NULL,
    [CreatedDate]      DATETIME     NULL,
    [ModificationDate] DATETIME     NULL,
    [ParentId]         INT          NULL,
    CONSTRAINT [pk_tb_employee_Title_employeeTitleId] PRIMARY KEY CLUSTERED ([employeeTitleId] ASC)
);


GO

CREATE TRIGGER tr_tb_employee_Title_parentid
   ON  dbo._tb_employee_Title
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE t 
	set parentid = 1
	from _tb_employee_Title t 
	where ISNULL(parentid,0) <> 1

    -- Insert statements for trigger here

END