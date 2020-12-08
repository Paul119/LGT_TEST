CREATE    VIEW dbo._vw_ETL_Passport_New_Users
 AS

SELECT ku.login_user AS PassportName,
	   ku.login_user AS Email,
	   ku.active_user,
	   ku.login_user AS ExternalID 
FROM k_users as ku
WHERE  (ku.id_user>0 
AND (  (((idExternalSSO IS NULL) OR idExternalSSO='') or len(idExternalSSO)<36)) -- idExternalSSO Needed
AND ku.id_user in (select id_user from k_users_profiles where id_profile <> 4))   -- ATM we exclude employee profile
OR (ku.id_user = 47 AND ku.idExternalSSO IS NULL) -- test
--ORDER BY ExternalID