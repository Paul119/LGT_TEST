CREATE VIEW [dbo].[Kernel_View_Admin_User]
AS
SELECT TOP (100) PERCENT lastname_user, 
firstname_user, login_user, password_user, date_created_user, date_modified_user,
 (CASE WHEN active_user = 1 THEN (select top 1 value from rps_localization l where l.culture = k.culture and name = 'GV_Yes') 
ELSE
(select top 1 value from rps_localization l where l.culture = k.culture and name = 'GV_No') 
 END)  AS active, id_user, 
id_external_user, isadmin_user, nb_attempt_user, culture_user, stylesheet_user, comments_user, mail_user, active_user, id_owner,codePayee as code_payee
, k.culture
FROM            
k_cultures k,
dbo.k_users ku
LEFT JOIN py_Payee pp on ku.id_external_user = pp.idPayee 
ORDER BY date_created_user