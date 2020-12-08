CREATE VIEW [dbo].[Kernel_View_Setup_CubeAggregationFunction]
AS
SELECT 'SUM' AS valueField ,'SUM' AS textField
UNION 
SELECT 'MIN' AS valueField ,'MIN' AS textField
UNION 
SELECT 'MAX' AS valueField ,'MAX' AS textField
UNION 
SELECT 'AVG' AS valueField ,'AVG' AS textField