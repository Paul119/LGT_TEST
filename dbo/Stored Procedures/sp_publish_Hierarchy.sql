-----END QC----
-----ACTIONS---

CREATE   PROCEDURE [dbo].[sp_publish_Hierarchy]  
(@qc_audit_key INT, @UserId INT = -1)  
AS  
BEGIN  
SET NOCOUNT ON;  
  
DECLARE @Category NVARCHAR(255) = 'Client';  
DECLARE @Process NVARCHAR(255) = 'Hiearchy';  
DECLARE @SubProcess NVARCHAR(255) = OBJECT_NAME(@@PROCID);  
DECLARE @StartDate DATETIME = GETDATE();  
--DECLARE @UserId INT = -1 --SuperAdmin  
DECLARE @Txt NVARCHAR(255);  
DECLARE @Anz INT;  
  
BEGIN TRY  
    BEGIN TRANSACTION @SubProcess;  

DROP TABLE IF EXISTS #hierachy

SELECT 
	    thd.Emp_IdPayee
	   ,thd.FirstInput_Idpayee
	   ,ISNULL(thd.SecondInput_IdPayee, thd.FirstInput_Idpayee) AS SecondInput_IdPayee
	   ,thd.View_IdPayee
	   ,thd.FinalInput_IdPayee
INTO #hierachy
FROM _tb_hierarchy_data thd 

--DELETE FROM k_user_plan
--DELETE FROM k_user_plan_field_filter
--DELETE FROM k_user_plan_field_setting
--
DELETE FROM k_m_plan_data_security
DELETE FROM k_tree_security_plan_level_exception
DELETE FROM k_tree_security_plan_level
DELETE FROM k_tree_security_filter 
DELETE FROM k_tree_security_exception
DELETE FROM k_tree_security
DELETE FROM hm_NodeLinkPublishedHierarchy
DELETE FROM hm_NodelinkPublished 
DELETE FROM hm_NodeTreePublished 
DELETE FROM hm_Nodelink 
DELETE FROM hm_NodeTree

----First INPUT
SET IDENTITY_INSERT hm_NodeTree ON

INSERT INTO hm_NodeTree (id, name, createDate, allowRepeatingItems)
SELECT DISTINCT CAST('100'+CAST(h.FirstInput_Idpayee AS NVARCHAR(10)) AS INT), '1st Input '+pp.lastname+' ' +pp.firstname , GETDATE(), 0 FROM #hierachy h
JOIN py_Payee pp ON h.FirstInput_Idpayee = pp.idPayee

SET IDENTITY_INSERT hm_NodeTree OFF

INSERT INTO hm_Nodelink (idTree, idChild, idType, idParent, idTypeParent, idRealParent, id_owner, date_creation, idUniqueParent)

----level 0
SELECT DISTINCT CAST('100'+CAST(FirstInput_Idpayee AS NVARCHAR(10)) AS INT), Emp_IdPayee, 14 AS idType, FirstInput_Idpayee AS parent, 14 AS idTypeParent, FirstInput_Idpayee AS idRealParent, -1, GETDATE(), 0 FROM #hierachy
--WHERE SecondInput_IdPayee <> FinalInput_IdPayee
UNION ALL

---- level 1
SELECT DISTINCT CAST('100'+CAST(FirstInput_Idpayee AS NVARCHAR(10)) AS INT), FirstInput_Idpayee, 14 AS idType, 0 AS parent, NULL AS idTypeParent, NULL AS idRealParent, -1, GETDATE(), 0 FROM #hierachy
--WHERE SecondInput_IdPayee <> FinalInput_IdPayee

---- Second INPUT
SET IDENTITY_INSERT hm_NodeTree ON

INSERT INTO hm_NodeTree (id, name, createDate, allowRepeatingItems)
SELECT DISTINCT CAST('200'+CAST(h.SecondInput_IdPayee AS NVARCHAR(10)) AS INT), '2nd Input '+pp.lastname+' ' +pp.firstname , GETDATE(), 0 FROM #hierachy h
JOIN py_Payee pp ON h.SecondInput_IdPayee = pp.idPayee
WHERE SecondInput_IdPayee <> h.FirstInput_Idpayee

SET IDENTITY_INSERT hm_NodeTree OFF

INSERT INTO hm_Nodelink (idTree, idChild, idType, idParent, idTypeParent, idRealParent, id_owner, date_creation, idUniqueParent)

---- level 0
SELECT DISTINCT CAST('200'+CAST(SecondInput_IdPayee AS NVARCHAR(10)) AS INT), Emp_IdPayee, 14 AS idType, MIN(FirstInput_Idpayee) AS parent, 49 idTypeParent, SecondInput_IdPayee AS idRealParent, -1, GETDATE(), 0 FROM #hierachy
WHERE SecondInput_IdPayee <> FirstInput_Idpayee
GROUP BY SecondInput_IdPayee,Emp_IdPayee
UNION ALL

---- level 1
SELECT DISTINCT CAST('200'+CAST(SecondInput_IdPayee AS NVARCHAR(10)) AS INT), MIN(FirstInput_Idpayee), 49 AS idType, SecondInput_IdPayee AS parent, 14 AS idTypeParent, SecondInput_IdPayee AS idRealParent, -1, GETDATE(), 0 FROM #hierachy 
WHERE FirstInput_Idpayee <> SecondInput_IdPayee 
GROUP BY SecondInput_IdPayee, Emp_IdPayee
UNION ALL
---- level 2

SELECT DISTINCT CAST('200'+CAST(SecondInput_IdPayee AS NVARCHAR(10)) AS INT), SecondInput_IdPayee, 14 AS idType, 0 AS parent, NULL AS idTypeParent, NULL AS idRealParent, -1, GETDATE(), 0 FROM #hierachy
WHERE FirstInput_Idpayee <> SecondInput_IdPayee

---- Final INPUT

SET IDENTITY_INSERT hm_NodeTree ON

INSERT INTO hm_NodeTree (id, name, createDate, allowRepeatingItems)
SELECT DISTINCT CAST('300'+CAST(h.FinalInput_IdPayee AS NVARCHAR(10)) AS INT), 'Final Input '+pp.lastname+' ' +pp.firstname , GETDATE(), 0 FROM #hierachy h
JOIN py_Payee pp ON h.FinalInput_IdPayee = pp.idPayee

SET IDENTITY_INSERT hm_NodeTree OFF

INSERT INTO hm_Nodelink (idTree, idChild, idType, idParent, idTypeParent, idRealParent, id_owner, date_creation, idUniqueParent)

---- level 0
SELECT DISTINCT CAST('300'+CAST(FinalInput_IdPayee AS NVARCHAR(10)) AS INT), Emp_IdPayee, 14 AS idType, -100 AS parent, 49 AS idTypeParent, FinalInput_IdPayee AS idRealParent, -1, GETDATE(), 0 FROM #hierachy
UNION ALL
---- level 1
SELECT DISTINCT CAST('300'+CAST(FinalInput_IdPayee AS NVARCHAR(10)) AS INT), -100, 49 AS idType, -200 AS parent, 49 AS idTypeParent, FinalInput_IdPayee AS idRealParent, -1, GETDATE(), 0 FROM #hierachy
UNION ALL
---- level 2
SELECT DISTINCT CAST('300'+CAST(FinalInput_IdPayee AS NVARCHAR(10)) AS INT), -200, 49 AS idType, FinalInput_IdPayee AS parent, 14 AS idTypeParent, FinalInput_IdPayee AS idRealParent, -1, GETDATE(), 0 FROM #hierachy
UNION ALL
---- level 3
SELECT DISTINCT CAST('300'+CAST(FinalInput_IdPayee AS NVARCHAR(10)) AS INT), FinalInput_IdPayee, 14 AS idType, 0 AS parent, NULL AS idTypeParent, NULL AS idRealParent, -1, GETDATE(), 0 FROM #hierachy

----View
SET IDENTITY_INSERT hm_NodeTree ON

INSERT INTO hm_NodeTree (id, name, createDate, allowRepeatingItems)
SELECT DISTINCT CAST('400'+CAST(h.View_IdPayee AS NVARCHAR(10)) AS INT), 'View '+pp.lastname+' ' +pp.firstname , GETDATE(), 0 FROM #hierachy h
JOIN py_Payee pp ON h.View_IdPayee = pp.idPayee

SET IDENTITY_INSERT hm_NodeTree OFF

INSERT INTO hm_Nodelink (idTree, idChild, idType, idParent, idTypeParent, idRealParent, id_owner, date_creation, idUniqueParent)

----level 0
SELECT DISTINCT CAST('400'+CAST(View_IdPayee AS NVARCHAR(10)) AS INT), Emp_IdPayee, 14 AS idType, View_IdPayee AS parent, 14 AS idTypeParent, View_IdPayee AS idRealParent, -1, GETDATE(), 0 FROM #hierachy
WHERE View_IdPayee IS NOT NULL
UNION ALL

---- level 1
SELECT DISTINCT CAST('400'+CAST(View_IdPayee AS NVARCHAR(10)) AS INT), View_IdPayee, 14 AS idType, 0 AS parent, NULL AS idTypeParent, NULL AS idRealParent, -1, GETDATE(), 0 FROM #hierachy
WHERE View_IdPayee IS NOT NULL

---- LGT Capital Partners -- ALL EMPLOYEES including CEO
SET IDENTITY_INSERT hm_NodeTree ON

INSERT INTO hm_NodeTree (id, name, createDate, allowRepeatingItems)
SELECT DISTINCT CAST('500300' AS INT), 'LGT Capital Partners' , GETDATE(), 0 

SET IDENTITY_INSERT hm_NodeTree OFF

INSERT INTO hm_Nodelink (idTree, idChild, idType, idParent, idTypeParent, idRealParent, id_owner, date_creation, idUniqueParent)

----level 0
SELECT DISTINCT CAST('500300' AS INT), Emp_IdPayee, 14 AS idType, -300 AS parent, 49 AS idTypeParent, NULL AS idRealParent, -1, GETDATE(), 0 FROM #hierachy
UNION ALL

---- level 1
SELECT DISTINCT CAST('500300' AS INT), -300, 49 AS idType, 0 AS parent, NULL AS idTypeParent, NULL AS idRealParent, -1, GETDATE(), 0 FROM #hierachy



-- Publish
SET IDENTITY_INSERT hm_NodeTreePublished ON

INSERT INTO hm_NodeTreePublished (id, name, createDate, id_hm_NodeTree, allowRepeatingItems)
	SELECT hnt.id, hnt.name,  GETDATE(), hnt.id, hnt.allowRepeatingItems FROM hm_NodeTree hnt 

SET IDENTITY_INSERT hm_NodeTreePublished OFF

INSERT hm_NodelinkPublished (  
			 idTree  
			 ,idChild  
			 ,idType  
			 ,idParent  
			 ,idTypeParent  
			 ,idRealParent  
			 ,date_begin  
			 ,date_end  
			 ,id_owner  
			 ,date_creation  
			 ,date_modification  
			 --,idTenant  
			 )  
			SELECT hn.idTree AS idTree  
			 ,hn.idChild  
			 ,hn.idType  
			 ,hn.idParent  
			 ,hn.idTypeParent  
			 ,hn.idRealParent  
			 ,NULL AS date_begin  
			 ,NULL AS date_end  
			 ,-1 AS id_owner  
			 ,getdate() AS date_creation  
			 ,NULL AS date_modification  
			-- ,@idTenant AS idTenant  
			 FROM dbo.hm_Nodelink hn

-- Give Manager profile
--DELETE FROM k_users_profiles WHERE id_profile in (SELECT id_profile FROM k_profiles kp WHERE kp.name_profile = 'Compensation Review Manager')

INSERT INTO k_users_profiles (id_user, id_profile)
SELECT DISTINCT ku.id_user, kp.id_profile
FROM hm_NodelinkPublished hnp 
JOIN k_users ku ON ku.id_external_user = hnp.idChild
JOIN k_profiles kp ON kp.name_profile = 'Compensation Review Manager'
LEFT JOIN k_users_profiles kup ON kp.id_profile = kup.id_profile AND ku.id_user = kup.id_user
WHERE hnp.idParent = 0 AND hnp.idType = 14
AND LEFT(hnp.idTree,1) in (1,2,3)
AND kup.idUserProfile IS NULL

-- Give View profile
--DELETE FROM k_users_profiles WHERE id_profile in (SELECT id_profile FROM k_profiles kp WHERE kp.name_profile = 'View Profile')

INSERT INTO k_users_profiles (id_user, id_profile)
SELECT DISTINCT ku.id_user, kp.id_profile
FROM hm_NodelinkPublished hnp 
JOIN k_users ku ON ku.id_external_user = hnp.idChild
JOIN k_profiles kp ON kp.name_profile = 'View Profile'
LEFT JOIN k_users_profiles kup ON kp.id_profile = kup.id_profile AND ku.id_user = kup.id_user
WHERE hnp.idParent = 0 AND hnp.idType = 14
AND LEFT(hnp.idTree,1) in (4)
AND kup.idUserProfile IS NULL


-- fill hm_NodeLinkPublishedHierarchy
	DECLARE @idTree INT, @idTreePublished INT

	DECLARE tree_cursor CURSOR FOR   
	SELECT hntp.id_hm_NodeTree AS idTree, hntp.id AS idTreePublished
	FROM hm_NodeTreePublished hntp  

	OPEN tree_cursor  
  
	FETCH NEXT FROM tree_cursor   
	INTO @idTree, @idTreePublished  
  
	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		 
		 	EXEC Kernel_SP_Hierarchy_PostPublish @idTree 
										,@idTreePublished 
										,@idUser = @UserId
										,@idProfile = -1
		
			-- Get the next vendor.  
		FETCH NEXT FROM tree_cursor   
		INTO @idTree, @idTreePublished   
	END   
	CLOSE tree_cursor;  
	DEALLOCATE tree_cursor;  
	

		INSERT INTO cm_ProcessHierarchy (idProcess, idTree, nameTree)
	(
		SELECT DISTINCT kmp.id_plan
			,hnt.id
			,LEFT(hnt.name, 50)
		FROM hm_NodeTree hnt
		INNER JOIN k_m_plans kmp ON 1=1
	)



 DROP TABLE #hierachy

 -- Hierarchy Secutiry
 
 UPDATE k_parameters SET value_parameter = 'True' WHERE key_parameter = 'PRM_DisableStandardHierarchyAccess'

 -- HR Admin 
DECLARE @id_profile_hr_admin INT = (SELECT id_profile FROM k_profiles WHERE name_profile = 'HR Administrator')

DELETE FROM k_tree_security WHERE id_user_profile IN (SELECT idUserProfile FROM k_users_profiles kup WHERE kup.id_profile = @id_profile_hr_admin)

INSERT INTO k_tree_security (description_security, comment_security, begin_date, end_date, id_user_profile, id_tree_node_published, is_manage_access, is_self, is_apply_filter, is_included, id_tree_security_type, id_owner, id_parent_tree_security, create_date, modified_date, modified_id_user)
SELECT '', NULL, GETDATE(), '2099-12-31', kup.idUserProfile, hnp.id, 0, CASE WHEN LEFT(hnp.idTree,1) = 5 /*All Employees*/ THEN 1 ELSE 0  END , 0, 1, -1, 2, NULL, GETDATE(), NULL, NULL FROM 
k_users_profiles kup
CROSS JOIN  hm_NodelinkPublished  hnp
WHERE kup.id_profile = @id_profile_hr_admin
AND idParent = 0


--###### Limit view for some HR Admin ###########
-- THIS IS MANUAL AT THE MOMENT --
--DECLARE @limited AS TABLE (id_user_profile INT, is_limited BIT)
--INSERT INTO @limited
--SELECT kup.idUserProfile, 1
--FROM k_users_profiles kup
--JOIN k_users ku ON kup.id_user = ku.id_user
--JOIN py_Payee pp1 ON pp1.idPayee = ku.id_external_user
--WHERE 1=1
--AND (pp1.codePayee = '10966') -- Florian Fischer
--AND kup.id_profile = @id_profile_hr_admin

UPDATE k_tree_security
SET is_apply_filter =1, is_included = 0, is_self = 0
WHERE id_user_profile IN (SELECT idUserProfile FROM _tb_profile_hr_administrator_limited)

INSERT INTO k_tree_security_filter (id_tree_security, id_pop)
SELECT kts.id_tree_security, pp.idPop
FROM k_tree_security kts
CROSS JOIN pop_Population pp
WHERE kts.id_user_profile IN (SELECT idUserProfile FROM _tb_profile_hr_administrator_limited)
AND pp.Name LIKE '%HR Limited%'
--###### END Limit view for some HR Admin ###########

-- End HR Admin

-- View Profile
DECLARE @id_profile_view INT = (SELECT id_profile FROM k_profiles WHERE name_profile = 'View Profile')

DELETE FROM k_tree_security WHERE id_user_profile IN (SELECT idUserProfile FROM k_users_profiles kup WHERE kup.id_profile = @id_profile_view)

INSERT INTO k_tree_security (description_security, comment_security, begin_date, end_date, id_user_profile, id_tree_node_published, is_manage_access, is_self, is_apply_filter, is_included, id_tree_security_type, id_owner, id_parent_tree_security, create_date, modified_date, modified_id_user)
SELECT '', NULL, GETDATE(), '2099-12-31', kup.idUserProfile, hnp.id, 0, 0, 0, 1, -1, 2, NULL, GETDATE(), NULL, NULL FROM 
k_users_profiles kup
JOIN k_users ku ON kup.id_user = ku.id_user
JOIN hm_NodelinkPublished  hnp ON hnp.idChild = ku.id_external_user
WHERE kup.id_profile = @id_profile_view
AND hnp.idParent = 0 AND hnp.idType = 14
AND LEFT(hnp.idTree,1) in (4)

-- End View Profile

-- Compensation Review Manager
DECLARE @id_profile_comp_manager INT = (SELECT id_profile FROM k_profiles WHERE name_profile = 'Compensation Review Manager')

DELETE FROM k_tree_security WHERE id_user_profile IN (SELECT idUserProfile FROM k_users_profiles kup WHERE kup.id_profile = @id_profile_comp_manager)

INSERT INTO k_tree_security (description_security, comment_security, begin_date, end_date, id_user_profile, id_tree_node_published, is_manage_access, is_self, is_apply_filter, is_included, id_tree_security_type, id_owner, id_parent_tree_security, create_date, modified_date, modified_id_user)
SELECT '', NULL, GETDATE(), '2099-12-31', kup.idUserProfile, hnp.id, 0, 0, 0, 1, -1, 2, NULL, GETDATE(), NULL, NULL FROM 
k_users_profiles kup
JOIN k_users ku ON kup.id_user = ku.id_user
JOIN hm_NodelinkPublished  hnp ON hnp.idChild = ku.id_external_user
WHERE kup.id_profile = @id_profile_comp_manager
AND hnp.idParent = 0 AND hnp.idType = 14
AND LEFT(hnp.idTree,1) in (1,2,3)

--  End Compensation Review Manager


INSERT INTO k_tree_security_plan_level (id_tree_security, is_override_workflow_permission, is_read, is_edit, is_validate, is_invalidate, is_mass_validate, is_mass_invalidate, begin_date, end_date, id_owner, create_date, modified_date, modified_id_user, comment_security_plan_level)
SELECT DISTINCT kts.id_tree_security,0, 0, 0, 0, 0, 0, 0,GETDATE(), '2099-12-31',-1, GETDATE(),NULL, NULL, ''  
FROM k_tree_security kts

INSERT INTO k_m_plan_data_security (id_tree_security_plan_level, id_process)
select id_tree_security_plan_level, kmp.id_plan
FROM k_tree_security_plan_level
CROSS JOIN k_m_plans kmp

-- END Hierarchy Security



-- default profile 
UPDATE kup SET kup.defaultProfileId = T.id_profile FROM k_users_parameters kup JOIN 
(SELECT ku.id_user, kup.id, MIN(kup1.id_profile) AS id_profile FROM k_users_parameters kup
JOIN k_users ku ON kup.id = ku.id_user_parameter
JOIN k_users_profiles kup1 ON ku.id_user = kup1.id_user
JOIN k_profiles kp ON kp.id_profile = kup1.id_profile
WHERE kp.name_profile <> 'Employee'
GROUP BY ku.id_user, kup.id) t ON kup.id = t.id

   
 COMMIT TRANSACTION @SubProcess  
END TRY  
BEGIN CATCH   

  
 DECLARE @ErrorFlag BIT = 1;  
 DECLARE @EventText NVARCHAR(MAX) = 'Error';  
 DECLARE @ErrorText NVARCHAR(MAX) = error_message();  
 DECLARE @ErrorLine INT = error_line();  
 DECLARE @xstate INT = XACT_STATE()  
   
  
 IF @xstate != 0   
  ROLLBACK TRANSACTION @SubProcess;  
  
   EXEC [sp_audit_log]  
   @Category  = @Category  --Events Hierarchy level 1  
  ,@Process  = @Process   --Events Hierarchy level 2  
  ,@SubProcess = @SubProcess  --Events (Names of the stored procedures)  
  ,@StartDate  = @StartDate --Start date to be used as a key (to know which records belong to each other)  
  ,@EventText  = @EventText  
  ,@AuditId  = @qc_audit_key  
  ,@UserId  = @UserId  --For application only  
  ,@ErrorFlag  = @ErrorFlag  
  ,@ErrorText  = @ErrorText  
  ,@ErrorLine  = @ErrorLine  

END CATCH  
END 
----END LOAD
----QC