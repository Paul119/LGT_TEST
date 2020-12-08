


CREATE   VIEW [dbo].[Dim_Department]
/**
# ===============================================================
Description: |
    Display users in process grid with type 49
Called by:
 - Process Grid
# ===============================================================
Changes:
 - Date: 2018-04-??
   Author: Sebastian Dziula
   Change: Creation
 - Date: 2019-05-24
   Author: Sebastian Dziula
   Change: Adjust view to new requirement
 - Date: 2019-07-01
   Author: Sebastian Dziula
   Change: Adjust view to add artifitial nodes for IPP
# ===============================================================
**/
AS
	SELECT pp.idPayee AS id_department
		,NULL AS id_parent_department
		,pp.codePayee AS code_department
		,'Input - '+ pp.lastname AS short_name_department
		,'Input - '+ pp.lastname + ' ' + pp.firstname AS long_name_department
		,NULL AS value1_department
		,NULL AS value2_department
		,NULL AS type_department
		,NULL AS sort_department
		,NULL AS id_version
	FROM py_Payee pp
	UNION ALL
	SELECT -100 AS id_department
		,NULL AS id_parent_department
		,'-100' AS code_department
		,'1st Input' AS short_name_department
		,'1st Input' AS long_name_department
		,NULL AS value1_department
		,NULL AS value2_department
		,NULL AS type_department
		,NULL AS sort_department
		,NULL AS id_version
   UNION ALL
   SELECT -200 AS id_department
		,NULL AS id_parent_department
		,'-200' AS code_department
		,'2nd Input' AS short_name_department
		,'2nd Input' AS long_name_department
		,NULL AS value1_department
		,NULL AS value2_department
		,NULL AS type_department
		,NULL AS sort_department
		,NULL AS id_version
	UNION ALL
   SELECT -300 AS id_department
		,NULL AS id_parent_department
		,'-300' AS code_department
		,'LGT Capital Partners' AS short_name_department
		,'LGT Capital Partners' AS long_name_department
		,NULL AS value1_department
		,NULL AS value2_department
		,NULL AS type_department
		,NULL AS sort_department
		,NULL AS id_version