CREATE view [dbo].[Kernel_View_Rule_Type]
as    
SELECT TOP 100 id_type,
UPPER(SUBSTRING(name_type,0,2))+ SUBSTRING(name_type,2,LEN(name_type)) AS name_type FROM k_program_type
WHERE id_type not in (-3,-8)
ORDER BY name_type