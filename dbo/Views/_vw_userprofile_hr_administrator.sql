

CREATE VIEW [dbo].[_vw_userprofile_hr_administrator]
AS


	SELECT kup.idUserProfile, pp1.firstname + ' ' + pp1.lastname + ' - ' + pp1.codePayee AS user_fullname
	FROM k_users_profiles kup
	JOIN k_users ku ON kup.id_user = ku.id_user
	JOIN py_Payee pp1 ON pp1.idPayee = ku.id_external_user
	JOIN k_profiles kp ON kup.id_profile = kp.id_profile
	WHERE 1=1
	--AND (pp1.codePayee = '10966') -- Florian Fischer
	AND kp.name_profile = 'HR Administrator'