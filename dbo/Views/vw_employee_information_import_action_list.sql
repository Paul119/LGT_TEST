
CREATE   VIEW [dbo].[vw_employee_information_import_action_list] 
AS
		SELECT 0 AS Id,'Select an action:' AS Label
		UNION ALL		
		SELECT 1 AS Id,'1 - Empty source' AS Label
		UNION ALL
		SELECT 2 AS Id,'2 - Load source (control and load final table)' AS Label