CREATE VIEW [dbo].[Kernel_View_Custom_Localization]
	AS
	SELECT localization_id, tab_id, module_type, item_id, name, value, culture, type_source, ref_localization_id 
	  FROM (
	SELECT localization_id, tab_id, module_type, item_id, name, value, culture, type_source, ref_localization_id 
		   ,ROW_NUMBER() OVER(PARTITION BY culture, module_type, item_id, name ORDER BY localization_id DESC) rowNum
	  FROM [dbo].[rps_Localization]
	) SUB
	 WHERE SUB.rowNum = 1