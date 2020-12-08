CREATE VIEW [dbo].[Kernel_View_Setup_Cube_PayeeList]
AS
SELECT *,firstname + ' ' + lastname as fullname FROM py_payee;