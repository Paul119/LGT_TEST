
CREATE view [dbo].[Kernel_View_Admin_Universe]
as
        SELECT DISTINCT 
			U.id_universe
			,U.name_universe
			,TV.name_table_view AS universe_view_name
			,TV2.name_table_view AS transaction_name
			,( (SELECT COUNT(*) FROM dbo.pop_Population PP WHERE PP.idUniverse=U.id_universe) + (SELECT COUNT(*) FROM k_program_cond KPC WHERE KPC.id_universe = U.id_universe)) AS total_linked_objects
			,(SELECT name_type FROM k_program_type KPT WHERE  KPT.id_type = UT.id_type) AS universe_type
        FROM k_program_cond_universes U
			INNER JOIN dbo.k_program_cond_universe_table UT ON UT.id = U.id_universe_table
			INNER JOIN dbo.k_referential_tables_views TV ON TV.id_table_view = UT.id_table_view
			LEFT JOIN dbo.k_referential_tables_views TV2 ON TV2.id_table_view = UT.id_table_view_transaction