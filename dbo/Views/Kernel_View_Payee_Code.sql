CREATE view [dbo].[Kernel_View_Payee_Code]  
as  
select NULL as idPayee, '' as codePayee  
UNION  
select idPayee, codePayee from dbo.py_Payee