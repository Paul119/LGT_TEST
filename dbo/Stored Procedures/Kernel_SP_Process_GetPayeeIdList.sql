CREATE PROCEDURE [dbo].[Kernel_SP_Process_GetPayeeIdList]
        @idPlan INT
       ,@idTree INT
       ,@idManager INT
       ,@idTreeType INT
       ,@Level NVARCHAR(250)
	   ,@isfilterUsed BIT
       ,@filterCTE nvarchar(max)
WITH RECOMPILE
AS
 
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
'

DECLARE @ParmDefinition nvarchar(500) = N'@p_idPlan int, @p_idTree int,@p_idTreeType int  ';
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

EXEC sp_executesql @FilterInsertQuery, @ParmDefinition, @p_idPlan  = @idPlan, @p_idTree = @idTree, @p_idTreeType = @idTreeType

 
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

SELECT pc.idPayee
  FROM #ParentChild pc
  INNER JOIN #BasePeople bp ON bp.idpayee= pc.idPayee
WHERE [Level] IN (SELECT LevelID FROM #LevelList)
   AND EXISTS (SELECT NULL FROM #BasePeople bp WHERE pc.idPayee = bp.idPayee)
   AND NOT EXISTS (SELECT NULL FROM hm_NodeTransfer nt WHERE pc.idParent = nt.idParent AND pc.idPayee = nt.idEmployee AND nt.idStatus = 2)
   order by bp.lastname, bp.firstname,  bp.idPayee