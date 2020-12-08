CREATE VIEW [dbo].[Kernel_View_Admin_HomePage]
AS
SELECT 
	t.id_home_page, 
	t.id_home_page_type,
	t.display_name,
	Left(t.used_by_profile, Len(t.used_by_profile)-1) as used_by_profile,
	t.description 
FROM
(
	SELECT khp.id_home_page, khp.id_home_page_type, khp.display_name,
		(
			SELECT 
					kp.name_profile +',' AS [text()]
			FROM	k_profiles kp
			WHERE	kp.id_home_page = khp.id_home_page
			FOR XML PATH('')
		) AS used_by_profile,
		 khp.description
	FROM
		k_home_page khp
) t