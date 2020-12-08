CREATE VIEW [dbo].[Kernel_View_Rule_Execution_Plan_Details]
AS
	WITH 
			Folders As
			(
				select id_parent_folder,id_folder, ISNULL(l.value,f.name_folder) as name_folder, kc.culture 
					from k_program_folders f
					cross join k_cultures kc
					OUTER APPLY (SELECT * FROM rps_Localization l WHERE f.name_folder = l.name and kc.culture = l.culture ) L
			)
			,Hierarchy(id_folder, Parents, culture)
			AS
			(
				SELECT 
			  id_folder, 
			  CAST('' AS NVARCHAR(MAX)),
			  kc.culture
			 FROM k_program_folders pf
				cross join k_cultures kc
				WHERE id_parent_folder IS NULL  

				UNION ALL

				SELECT 
			  children.id_folder,
			  CAST(
				CASE 
				 WHEN Parent.Parents = '' THEN(CAST(children.name_folder AS NVARCHAR(MAX)))
				 ELSE(Parent.Parents + ' / ' + CAST(children.name_folder AS NVARCHAR(MAX)))
				END AS NVARCHAR(MAX)
			   ),
			   children.culture
				FROM Folders AS children
				INNER JOIN Hierarchy AS Parent ON children.id_parent_folder = Parent.id_folder and children.culture = Parent.culture
				
			)
			SELECT
				epd.id_detail, 
				epd.id_schedule, 
				epd.order_schedule, 
				epd.id_prog, 
				epd.id_cond, 
				epd.id_version, 
				epd.id_source_tenant, 
				epd.id_source, 
				epd.id_change_set,
				pf.Parents as [path],
				culture
			FROM k_program_execution_plan_details epd
			inner join k_program p on epd.id_prog=p.id_prog
			inner join Hierarchy pf on pf.id_folder = p.id_parent