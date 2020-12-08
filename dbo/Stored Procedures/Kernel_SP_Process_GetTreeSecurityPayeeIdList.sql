
CREATE PROCEDURE [dbo].[Kernel_SP_Process_GetTreeSecurityPayeeIdList]
     @idPlan INT
	,@idTreeSecurity INT
    ,@idManager INT
	,@idTreeType INT
    ,@Level NVARCHAR(250)
	,@isfilterUsed BIT
    ,@filterCTE nvarchar(max)
AS

DECLARE @idTree INT;
DECLARE @isApplyFilter BIT;
DECLARE @isIncluded BIT;

SELECT 
	 @idTree = np.idTree
	,@isApplyFilter = ts.is_apply_filter
	,@isIncluded = ts.is_included
FROM k_tree_security ts
JOIN hm_NodelinkPublished np 
	ON ts.id_tree_node_published=np.id
WHERE 1=1
AND ts.id_tree_security = @idTreeSecurity
					


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
 
DECLARE @maxLevel INT;
 
SELECT @maxLevel = MAX(LevelID) FROM #LevelList
 

CREATE TABLE #BasePeople
(
 idPayee INT,
 idParent INT,
 lastname NVARCHAR(250),
 firstname NVARCHAR(250)
)

CREATE UNIQUE CLUSTERED INDEX Cl_Ix_id_step_idPayee ON #BasePeople
(idPayee,idParent)

DECLARE @FilterInsertQuery nvarchar(max) = 
'
;WITH 
###CTE###
FilteredEmployeeList
AS
(
	SELECT DISTINCT p.idPayee,p.lastname,p.firstname
		FROM dbo.py_Payee p
	WHERE 1=1
		AND EXISTS (SELECT NULL FROM dbo.k_m_plans_payees_steps ps WHERE p.idPayee = ps.id_payee AND ps.id_plan = @p_idPlan)
		###FILTER###
)
INSERT INTO #BasePeople
(idPayee,idParent,lastname,firstname)
SELECT DISTINCT fel.idPayee, np.idRealParent,fel.lastname,fel.firstname
	FROM FilteredEmployeeList fel
	INNER JOIN dbo.hm_nodelinkpublished np
	ON fel.idPayee = np.idChild
	AND np.idTree = @p_idTree
	AND np.idType = @p_idTreeType
	AND NOT EXISTS
		(
			SELECT 1
			FROM k_tree_security ts
			JOIN k_tree_security_exception tse
				ON ts.id_tree_security = tse.id_tree_security
			JOIN hm_NodelinkPublished np2
				ON np2.id = tse.id_tree_node_published
			WHERE	1=1
					AND ts.id_tree_security = @p_idTreeSecurity
					AND fel.idPayee = np2.idChild
					AND np2.idType = @p_idTreeType
		)'

DECLARE @ParmDefinition nvarchar(500) = N'@p_idPlan int, @p_idTree int,@p_idTreeType int, @p_idTreeSecurity int ';
IF (@isfilterUsed = 1)
BEGIN
	SET @FilterInsertQuery = REPLACE(@FilterInsertQuery,'###CTE###', @filterCTE +',');
	SET @FilterInsertQuery = REPLACE(@FilterInsertQuery,'###FILTER###','AND EXISTS (SELECT NULL FROM FilteredCTE f WHERE f.idPayee = p.idPayee)');
END
ELSE 
BEGIN
	SET @FilterInsertQuery = REPLACE(@FilterInsertQuery,'###CTE###','');
	SET @FilterInsertQuery = REPLACE(@FilterInsertQuery,'###FILTER###','');
END
PRINT @FilterInsertQuery

EXEC sp_executesql @FilterInsertQuery, @ParmDefinition, @p_idPlan  = @idPlan, @p_idTree = @idTree, @p_idTreeType = @idTreeType, @p_idTreeSecurity = @idTreeSecurity



IF OBJECT_ID('tempdb.dbo.#ParentChild') IS NOT NULL
 DROP TABLE #ParentChild

CREATE TABLE #ParentChild
(
 idPayee INT,
 idParent INT,
 Level TINYINT
)

CREATE UNIQUE CLUSTERED INDEX Cl_Ix_idPayee_idParent ON #ParentChild
(idPayee,idParent)

CREATE INDEX [Level] ON #ParentChild 
([Level])

DECLARE @LevelNode TINYINT = 0
DECLARE @RowCount INT = 0
DECLARE @LoopVar TINYINT = 1

WHILE @LoopVar = 1
BEGIN
	SET @RowCount = 0
 
	IF @LevelNode = 0
	BEGIN
		INSERT INTO #ParentChild
		SELECT np.idChild,np.idRealParent,@LevelNode AS Level
		FROM dbo.hm_NodelinkPublished as np
		WHERE 1=1
			AND np.idChild = @idManager
			AND np.idTree = @idTree
			AND np.idType = @idTreeType
		SET @RowCount = @@ROWCOUNT
	END
 
	IF (@LevelNode > 0 AND @LevelNode <= @maxLevel)
	BEGIN
		INSERT INTO #ParentChild
		SELECT DISTINCT np.idChild,np.idRealParent,@LevelNode AS Level
		FROM dbo.hm_NodelinkPublished as np
		WHERE 1=1
			AND np.idRealParent IN (SELECT idPayee FROM #ParentChild WHERE Level = @LevelNode - 1)
			AND np.idTree = @idTree
			AND np.idType = @idTreeType

		SET @RowCount = @@ROWCOUNT
	END
	IF @RowCount = 0
		SET @LoopVar = 2
	SET @LevelNode = @LevelNode + 1
END
DECLARE @SQL NVARCHAR(MAX) = N''

SET @SQL = ';WITH PopFilter
AS
(
	SELECT  ts.is_apply_filter,ts.is_included,vc.idColl
				FROM k_tree_security ts
				JOIN k_tree_security_filter tsf
					ON ts.id_tree_security = tsf.id_tree_security
				JOIN pop_Population pp
					ON tsf.id_pop = pp.idPop
				JOIN pop_VersionContent vc
					ON pp.lastVersion = vc.idPopVersion
			WHERE	1=1
					AND ts.id_tree_security = @p_idTreeSecurity
)
SELECT bp.idPayee AS [idPayee]
	FROM #ParentChild pc
	INNER JOIN #BasePeople bp ON bp.idpayee= pc.idPayee
WHERE [Level] IN (SELECT LevelID FROM #LevelList)
	AND EXISTS (SELECT NULL FROM #BasePeople bp WHERE pc.idPayee = bp.idPayee)
	AND NOT EXISTS (SELECT NULL FROM hm_NodeTransfer nt WHERE pc.idParent = nt.idParent AND pc.idPayee = nt.idEmployee AND nt.idStatus = 2)
	###FILTERSTATEMENT###
	ORDER BY bp.firstname, bp.lastname, bp.idPayee'
	
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
								AND pf.idColl = pc.idPayee
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
								AND pf.idColl = pc.idPayee
					)'
		END
	END
	ELSE
	BEGIN
		SET @FilterStatement = N''
	END
	
	SET @SQL = REPLACE(@SQL,'###FILTERSTATEMENT###',@FilterStatement)

	DECLARE @ParamDefinition NVARCHAR(500) = '@p_idTreeSecurity INT'
	EXEC sp_executesql @SQL,@ParamDefinition,@p_idTreeSecurity = @idTreeSecurity