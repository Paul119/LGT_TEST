CREATE PROCEDURE [dbo].[Kernel_SP_Process_GetPayeeIdListGeneric]
 @PayeeBasedLevel INT
,@IdTreeSecurity INT
,@IdNodeManager INT
,@Level NVARCHAR(250)
,@FilterCTE nvarchar(max)
AS

DECLARE @idTree INT = 0;
DECLARE @isApplyFilter BIT;
DECLARE @isIncluded BIT;
DECLARE @CurrentEmployee hierarchyid  
DECLARE @CurrentLevel int 
DECLARE @NonPayeeLevel int 
DECLARE @RootIsNonPayee bit = 0

IF OBJECT_ID('tempdb.dbo.#ParentChild') IS NOT NULL
	DROP TABLE #ParentChild
 
CREATE TABLE #ParentChild
(
	idChild INT,
	idType INT,
	id_NodelinkPublished INT,
	hidLevel smallint,
	PRIMARY KEY CLUSTERED (idChild,idType) 
)

IF OBJECT_ID('tempdb.dbo.#LevelList') IS NOT NULL
	DROP TABLE #LevelList

CREATE TABLE #LevelList
(
       LevelID       INT PRIMARY KEY
)

INSERT INTO #LevelList
SELECT * FROM dbo.udf_Split2(@Level,',')

IF EXISTS (SELECT TOP 1 1 FROM #LevelList WHERE LevelID = -1)
BEGIN
	DELETE FROM #LevelList WHERE LevelID = -1
	
	INSERT INTO #LevelList
	SELECT TOP 50 ROW_NUMBER() OVER(ORDER BY so1.id) + 4 AS RN
	FROM sysobjects so1, sysobjects so2
END

SELECT @idTree = idTree FROM hm_NodeLinkPublishedHierarchy where id_NodelinkPublished = @IdNodeManager

IF @IdTreeSecurity <> 0
BEGIN
	SELECT 
		@isApplyFilter = ts.is_apply_filter
		,@isIncluded = ts.is_included
	FROM k_tree_security ts
	JOIN hm_NodeLinkPublishedHierarchy np
		ON ts.id_tree_node_published=np.id_NodelinkPublished
		LEFT join hm_NodeLinkPublished h 
		on np.id_NodelinkPublished = h.id
	WHERE 1=1
	AND ts.id_tree_security = @IdTreeSecurity
	AND h.transferRequestStatus <> 2
	AND np.idTree = @idTree 
END


IF((SELECT idType FROM hm_NodeLinkPublishedHierarchy WHERE id_NodelinkPublished =@IdNodeManager and hid_payee is null and idTree = @idTree) !=14)
BEGIN
	SET @RootIsNonPayee = 1
	SELECT @NonPayeeLevel=hidLevel FROM hm_NodeLinkPublishedHierarchy WHERE id_NodelinkPublished =@IdNodeManager and hid_payee is null and idTree = @idTree
END

SELECT 
@CurrentEmployee = hid, 
@CurrentLevel = CASE 
					WHEN @PayeeBasedLevel=1 
					THEN 
						CASE 
							WHEN @RootIsNonPayee=1 
							THEN hidLevel 
							ELSE hid_payee.GetLevel() 
						END  
					ELSE  hidLevel 
				END
FROM hm_NodeLinkPublishedHierarchy nh
LEFT join hm_NodeLinkPublished h 
			ON id_NodelinkPublished = h.id
WHERE id_NodelinkPublished =@IdNodeManager 
AND h.transferRequestStatus <> 2
AND nh.idTree = @idTree
AND NOT EXISTS
(
	SELECT 1
	FROM k_tree_security ts
	JOIN k_tree_security_exception tse
		ON ts.id_tree_security = tse.id_tree_security
	WHERE 1 = 1
	AND ts.id_tree_security = @IdTreeSecurity
	AND id_NodelinkPublished = tse.id_tree_node_published
) 

IF @PayeeBasedLevel = 1
BEGIN
	INSERT INTO #ParentChild  
	SELECT  DISTINCT h.idChild,h.idType,h.id_NodelinkPublished,
	CASE 
		WHEN @RootIsNonPayee=1 
		THEN 
			CASE 
				WHEN @NonPayeeLevel !=0  
				THEN hid_payee.GetLevel()+@CurrentLevel 
				ELSE hid_payee.GetLevel()-@CurrentLevel +1 
			END
		ELSE hid_payee.GetLevel()-@CurrentLevel 
	END AS hidLevel
	FROM hm_NodeLinkPublishedHierarchy h
	WHERE  h.idTree = @idTree AND hid.IsDescendantOf(@CurrentEmployee ) = 1			
END
ELSE
BEGIN		
	INSERT INTO #ParentChild  SELECT DISTINCT idChild,idType,id_NodelinkPublished,hidLevel-@CurrentLevel as hidLevel
	FROM hm_NodeLinkPublishedHierarchy t
	WHERE t.idTree = @idTree AND hidParent.IsDescendantOf(@CurrentEmployee ) = 1 
END


DECLARE @SQL NVARCHAR(MAX) =
';

WITH PopFilter
AS (
	SELECT vc.idColl
	FROM dbo.pop_VersionContent vc
	WHERE EXISTS (
		SELECT *
		FROM dbo.pop_Population pp
		WHERE pp.lastVersion = vc.idPopVersion
		AND EXISTS (
			SELECT *
			FROM dbo.k_tree_security_filter tsf
			WHERE tsf.id_pop = pp.idPop
			AND tsf.id_tree_security = @p_idTreeSecurity
			AND EXISTS (
				SELECT *
				FROM k_tree_security ts
				WHERE tsf.id_tree_security = ts.id_tree_security
			)
		)
	)
)
,
###FILTERCTE###

SELECT pc.idChild AS idPayee
	,pc.hidLevel AS LEVEL
FROM #ParentChild pc
INNER JOIN (SELECT distinct idPayee, fullname From FilteredCTE) f ON f.idPayee = pc.idChild
WHERE 1 = 1
	AND pc.idType = 14
	AND EXISTS (
		SELECT *
		FROM #LevelList
		WHERE pc.[hidLevel] = LevelID
		)
	AND NOT EXISTS (
		SELECT *
		FROM hm_NodeLinkPublished h
		INNER JOIN hm_NodeTransfer nt ON h.idParent = nt.idParent
		WHERE 1 = 1
			AND pc.id_NodelinkPublished = h.id
			AND pc.idChild = nt.idEmployee
			AND pc.idType = 14
			AND nt.idStatus = 2
		)

###FILTERSTATEMENT###
ORDER BY f.fullname,  f.idPayee
OPTION (FORCE ORDER,LOOP JOIN,HASH JOIN)' 

DECLARE @FilterStatement NVARCHAR(MAX)

IF (@isApplyFilter = 1)
BEGIN
	IF (@isIncluded = 1)
	BEGIN
		SET @FilterStatement = N'AND
				EXISTS 
				(
					SELECT * 
					FROM PopFilter pf
					WHERE	1=1
							AND pf.idColl = pc.idChild
							AND pc.idType = 14
				)'
	END
	ELSE
	BEGIN
		SET @FilterStatement = N'AND
				NOT EXISTS 
				(
					SELECT * 
					FROM PopFilter pf
					WHERE	1=1
							AND pf.idColl = pc.idChild
							AND pc.idType = 14
				)'
	END
		
END
ELSE
BEGIN
	SET @FilterStatement = N''
END

SET @SQL = REPLACE(@SQL,'###FILTERCTE###', @FilterCTE);
SET @SQL = REPLACE(@SQL,'###FILTERSTATEMENT###',@FilterStatement)

DECLARE @ParamDefinition NVARCHAR(500) = '@p_idTreeSecurity INT'
EXEC sp_executesql @SQL,@ParamDefinition,@p_idTreeSecurity = @IdTreeSecurity