CREATE VIEW [dbo].[Kernel_View_objectSecurity] AS
				 SELECT
					  u.[id_user]
					 ,u.[firstname_user]
					 ,u.[lastname_user]
					 ,u.[culture_user]
					 ,u.[active_user] 
					 ,null as id_payee
					 ,null as id_population
					 -- Additional columns and joins with other tables can be added here by consultants.
					 FROM k_users u