CREATE VIEW [dbo].[Kernel_View_Profile_Users] AS 
SELECT 
up.idUserProfile,us.id_user, id_profile, firstname_user, lastname_user, us.mail_user 
FROM k_Users_profiles up
INNER JOIN k_users us on us.id_user = up.id_user