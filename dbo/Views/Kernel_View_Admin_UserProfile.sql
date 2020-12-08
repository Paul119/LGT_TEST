CREATE VIEW [dbo].[Kernel_View_Admin_UserProfile] AS
SELECT DISTINCT UP.id_profile,P.name_profile,U.id_user FROM k_users U 
		,dbo.k_users_profiles UP 
		,dbo.k_profiles P 
		WHERE UP.id_user=U.id_user
		AND UP.id_profile=P.id_profile