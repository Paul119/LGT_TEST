
--

/****** Object:  View [dbo].[_vw_employee_information_import_action_list]    Script Date: 8/7/2019 3:29:54 PM ******/

CREATE   VIEW [dbo].[_vw_employee_information_import_action_list] 
AS
/*   
==========================================================================
  
Called by:	  Master grid import collab data
Returns:     
Description:  
  
==========================================================================
Date       Author      	Change
-------------------------------------------------------------------------- 
04.12.2018 D. RUIZ		Creation
==========================================================================
*/  
		SELECT 0 AS Id,'Select an action:' AS Label
		UNION ALL		
		SELECT 1 AS Id,'0 - Empty Source' AS Label
		UNION ALL
		SELECT 2 AS Id,'1 - Load Source (control and load final table)' AS Label