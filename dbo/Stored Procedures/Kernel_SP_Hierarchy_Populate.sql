CREATE PROCEDURE [dbo].[Kernel_SP_Hierarchy_Populate] 
	 @idTree INT
AS
BEGIN
    SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#children') IS NOT NULL
		DROP TABLE #children

	CREATE TABLE #children (id INT, idUniqueParent INT, row_num INT, idChild INT, idType INT, idParent INT, idTypeParent INT);  

	INSERT INTO #children (id, idUniqueParent, row_num, idChild, idType, idParent, idTypeParent)  
	SELECT 
		id,
		idUniqueParent, 
		ROW_NUMBER() OVER (PARTITION BY idUniqueParent ORDER BY idUniqueParent) AS row_num,
		idChild,
		idType,
		idParent,
		idTypeParent
	FROM hm_nodelinkPublished 
	WHERE idTree = @idTree
	ORDER BY idParent, idChild

	CREATE CLUSTERED INDEX tmpind ON #children (idParent, idChild);  

	DELETE from hm_NodeLinkPublishedHierarchy where idtree = @idTree

	;WITH Hierarchy(path, id, idChild, idType, idParent, idTypeParent, payee_path) AS
	(
		SELECT 
			hierarchyid::GetRoot() AS path, 
			id, 
			idChild,
			idType,
			idParent,
			idTypeParent,		
			CASE WHEN idType = 14 
				THEN hierarchyid::GetRoot()
				ELSE NULL
			END AS payee_path
		FROM #children c
		WHERE ISNULL(idParent, 0) = 0

		UNION ALL

		SELECT 
			CAST(p.path.ToString() + CAST(c.id AS varchar) + '/' AS hierarchyid) AS path, 
			c.id, 
			c.idChild,
			c.idType,
			c.idParent,
			c.idTypeParent,
			CASE WHEN c.idType = 14 
				THEN
					CASE WHEN p.payee_path IS NULL
						THEN hierarchyid::GetRoot()
						ELSE CAST(p.payee_path.ToString() + CAST(c.id as nvarchar) + '/' AS hierarchyid)
					END
				ELSE p.payee_path			
			END AS payee_path
		FROM #children AS c   
		JOIN Hierarchy AS p 
			ON c.idParent = p.idChild and c.idTypeParent = p.idType 
	)
	
	INSERT INTO hm_NodeLinkPublishedHierarchy (idtree,hid, hid_payee, id_NodelinkPublished, idChild, idType)  
	SELECT @idtree, h.path, h.payee_path as payee_path, h.id, h.idChild, h.idType
	FROM Hierarchy AS h 
		
END