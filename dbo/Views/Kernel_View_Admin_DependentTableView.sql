--SYNCH VIEW TO SHOW RELATED ITEMS

CREATE VIEW [dbo].[Kernel_View_Admin_DependentTableView]       

AS

  SELECT 'Grid' AS objType,
	     id_grid AS itemId,
	     name_grid AS itemName,
	     krg.id_table_view AS id
  FROM dbo.k_referential_grids krg
  
  UNION ALL
  
  SELECT 'Universe View' AS objType,
	     id AS itemId,
	     (CASE WHEN kpcu.name_universe IS NULL THEN 'Obj_Universe_View' ELSE kpcu.name_universe END)  AS itemName,
	     krtv.id_table_view AS id
  FROM dbo.k_program_cond_universe_table krtv
  LEFT OUTER JOIN dbo.k_program_cond_universes kpcu ON kpcu.id_universe_table= krtv.id
  
  UNION ALL
  
  SELECT 'Universe Transaction' AS objType,
	     id AS itemId,
	     (CASE WHEN kpcu.name_universe IS NULL THEN 'Obj_Universe_Transaction' ELSE kpcu.name_universe END)  AS itemName,
	     krtv.id_table_view_transaction AS id
  FROM dbo.k_program_cond_universe_table krtv
  LEFT OUTER JOIN dbo.k_program_cond_universes kpcu ON kpcu.id_universe_table= krtv.id

  UNION ALL

  SELECT 'Universe Publication Transaction' AS objType,
	     id AS itemId,
	     (CASE WHEN kpcu.name_universe IS NULL THEN 'Obj_Universe_Transaction_Publication' ELSE kpcu.name_universe END)  AS itemName,
	     krtv.id_table_view_publication AS id
  FROM dbo.k_program_cond_universe_table krtv
  LEFT OUTER JOIN dbo.k_program_cond_universes kpcu ON kpcu.id_universe_table= krtv.id
  WHERE krtv.id_table_view_publication IS NOT NULL

  UNION ALL

  SELECT 'Business Object' AS objType,
		id_field AS itemId,
		name_field +'('+kpcu.name_universe+')' AS itemName,
		krtv.id_table_view AS id
  FROM dbo.k_program_cond_fields kpcf 
  INNER JOIN k_referential_tables_views krtv ON krtv.name_table_view= kpcf.table_field_preview
  INNER JOIN k_program_cond_folders kpcfo ON kpcfo.id_folder= kpcf.id_folder
  INNER JOIN dbo.k_program_cond_universes kpcu ON kpcu.id_universe= kpcfo.id_universe