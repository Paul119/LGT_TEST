CREATE view [dbo].[Kernel_View_Admin_Synchronization]
as
           SELECT * FROM
            (

               SELECT	name table_name,V.id_table_view,
                        CASE WHEN  type ='U' THEN 'table' ELSE 'view' END type_table_view,
			            CASE WHEN type_data IS NOT NULL THEN type_data ELSE NULL END type_data,
                        CASE WHEN V.id_table_view IS NOT NULL
                        THEN 'True' ELSE 'False' END in_referential,
			            (SELECT SUM(nb) FROM (
				                select count(1) nb fROM  k_referential_grids G
					            WHERE G.id_table_view =V.id_table_view   UNION ALL
					            select count(1) nb fROM  k_referential_form F
					            WHERE F.table_view_id =V.id_table_view   UNION ALL
					            select count(1) nb fROM  k_program_cond_universes U
					            WHERE U.id_universe_table =V.id_table_view
				             ) as tbl0
			            ) nbLinkedObjects

			            FROM  sys.objects T
                        LEFT OUTER JOIN  dbo.k_referential_tables_views V
                        ON T.name = V.name_table_view
                        WHERE  type IN ('V','U') AND T.name NOT LIKE ''
                         AND T.name NOT LIKE  'sysdiagrams'
                         AND V.id_table_view IS NULL

                        GROUP BY name,V.id_table_view,type,type_data
            ) as tbl0