-- OLAP Kernel_View_Setup_CubeReferenceDate cuve v6 update
CREATE VIEW [dbo].[Kernel_View_Setup_CubeReferenceDate]
AS  
SELECT '[Time Billing]' AS valueField ,'Time Billing' AS textField  
UNION   
SELECT '[Time Event]' AS valueField ,'Time Event' AS textField