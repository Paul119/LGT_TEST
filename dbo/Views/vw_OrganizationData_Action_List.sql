CREATE   VIEW dbo.vw_OrganizationData_Action_List
AS
		SELECT 0 AS ActionId,'Select an action:' AS Label
		UNION ALL		
		SELECT 1 AS ActionId,'1 - Empty source' AS Label
		UNION ALL
		SELECT 2 AS ActionId,'2 - Load source (control and load final table)' AS Label