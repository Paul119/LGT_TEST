-----END QC----
-----ACTIONS---

CREATE   PROCEDURE [dbo].[sp_publish_Hierarchy_old]  
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

DECLARE @id_owner INT = -3 --id_owner for k_tree_security etc.

DROP TABLE IF EXISTS #hierachy

SELECT 
	    thd.Emp_IdPayee
	   ,thd.FirstInput_Idpayee
	   ,ISNULL(thd.SecondInput_IdPayee, thd.FirstInput_Idpayee) AS SecondInput_IdPayee
	   ,thd.View_IdPayee
	   ,thd.FinalInput_IdPayee
INTO #hierachy
FROM _tb_hierarchy_data thd 

DELETE FROM hm_NodeLinkPublishedHierarchy
DELETE FROM hm_NodelinkPublished 
DELETE FROM hm_NodeTreePublished 
DELETE FROM hm_Nodelink 
DELETE FROM hm_NodeTree


-- Comp Review Manager
SET IDENTITY_INSERT hm_NodeTree ON

INSERT INTO hm_NodeTree (id, name, createDate, allowRepeatingItems)
SELECT distinct h.SecondInput_IdPayee, 'Tree '+pp.lastname+' ' +pp.firstname , GETDATE(), 0 FROM #hierachy h
JOIN py_Payee pp ON h.SecondInput_IdPayee = pp.idPayee
WHERE SecondInput_IdPayee <> FinalInput_IdPayee

SET IDENTITY_INSERT hm_NodeTree OFF

INSERT INTO hm_Nodelink (idTree, idChild, idType, idParent, idTypeParent, idRealParent, id_owner, date_creation, idUniqueParent)

--level 0
SELECT DISTINCT SecondInput_IdPayee, Emp_IdPayee, 14 AS idType, FirstInput_Idpayee AS parent, CASE WHEN FirstInput_Idpayee = SecondInput_IdPayee THEN 14 ELSE 49 END AS idTypeParent, SecondInput_IdPayee AS idRealParent, -1, GETDATE(), 0 FROM #hierachy
WHERE SecondInput_IdPayee <> FinalInput_IdPayee
UNION ALL

-- level 1
SELECT DISTINCT SecondInput_IdPayee, FirstInput_Idpayee, 49 AS idType, SecondInput_IdPayee AS parent, 14 AS idTypeParent, SecondInput_IdPayee AS idRealParent, -1, GETDATE(), 0 FROM #hierachy 
WHERE FirstInput_Idpayee <> SecondInput_IdPayee and SecondInput_IdPayee <> FinalInput_IdPayee
UNION ALL
-- level 2

SELECT DISTINCT SecondInput_IdPayee, SecondInput_IdPayee, 14 AS idType, 0 AS parent, NULL AS idTypeParent, NULL AS idRealParent, -1, GETDATE(), 0 FROM #hierachy
WHERE SecondInput_IdPayee <> FinalInput_IdPayee


-- CEO 
SET IDENTITY_INSERT hm_NodeTree ON

INSERT INTO hm_NodeTree (id, name, createDate, allowRepeatingItems)
SELECT distinct h.FinalInput_IdPayee, 'Tree '+pp.lastname+' ' +pp.firstname , GETDATE(), 0 FROM #hierachy h
JOIN py_Payee pp ON h.FinalInput_IdPayee = pp.idPayee

SET IDENTITY_INSERT hm_NodeTree OFF

INSERT INTO hm_Nodelink (idTree, idChild, idType, idParent, idTypeParent, idRealParent, id_owner, date_creation, idUniqueParent)

--level 0
SELECT DISTINCT FinalInput_IdPayee, Emp_IdPayee, 14 AS idType, FirstInput_Idpayee AS parent, CASE WHEN FirstInput_Idpayee = FinalInput_IdPayee THEN 14 ELSE 49 END AS idTypeParent, FinalInput_IdPayee AS idRealParent, -1, GETDATE(), 0 FROM #hierachy
UNION ALL

-- level 1
SELECT DISTINCT FinalInput_IdPayee, FirstInput_Idpayee, 49 AS idType, SecondInput_IdPayee AS parent, 49 AS idTypeParent, FinalInput_IdPayee AS idRealParent, -1, GETDATE(), 0 FROM #hierachy 
WHERE FirstInput_Idpayee <> SecondInput_IdPayee and FirstInput_Idpayee <> FinalInput_IdPayee 
UNION ALL
-- level 2
SELECT DISTINCT FinalInput_IdPayee, SecondInput_IdPayee, 49 AS idType, FinalInput_IdPayee AS parent, 14 AS idTypeParent, FinalInput_IdPayee AS idRealParent, -1, GETDATE(), 0 FROM #hierachy 
WHERE SecondInput_IdPayee <> FinalInput_IdPayee 
UNION ALL
--level 3
SELECT DISTINCT FinalInput_IdPayee, FinalInput_IdPayee, 14 AS idType, 0 AS parent, NULL AS idTypeParent, NULL AS idRealParent, -1, GETDATE(), 0 FROM #hierachy





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