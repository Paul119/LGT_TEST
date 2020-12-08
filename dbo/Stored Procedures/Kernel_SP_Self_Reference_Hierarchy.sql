CREATE procedure [dbo].[Kernel_SP_Self_Reference_Hierarchy]
(	@idTree INT,
	@maxLevel INT )
AS
Begin
IF OBJECT_ID('tempdb.dbo.#tempInfLoopCheck') IS NOT NULL
	DROP TABLE #tempInfLoopCheck

CREATE TABLE #tempInfLoopCheck
(
       id       INT PRIMARY KEY
)

INSERT INTO #tempInfLoopCheck
select id from hm_nodelink HMN
          where  idTree=@idTree and 
		         idChild in(
                            select idChild from hm_nodelink HMNG
							               where idTree=@idTree and
										         HMNG.idChild=HMN.idChild and
												 HMNG.idType=HMN.idType
										   group by idChild,idType 
										   having count (idChild)>1) 
IF EXISTS (select 1 from #tempInfLoopCheck)
begin	
;WITH FindRoot AS
(
	SELECT 
		  [idChild]
		, [idType]
		, [idParent]
		, [idTypeParent]
		, CAST([idChild] AS NVARCHAR(MAX)) + N',' + CAST([idType] AS NVARCHAR(MAX)) AS [Path]
		, 1 AS [Distance]
		, [id]
		, [idUniqueParent]
	FROM [dbo].[hm_nodelink] AS [hm] WHERE [hm].[idTree] = @idTree
	UNION ALL
	SELECT 
		  C.[idChild]
		, C.[idType]		
		, [Parent].[idParent]
		, [Parent].[idTypeParent]		
		, C.[Path] + ';' + CAST([Parent].[idChild] AS NVARCHAR(MAX)) + N',' + CAST([Parent].[idType] AS NVARCHAR(MAX)) AS [Path]
		, C.[Distance] + 1
		, C.[id]
		, [Parent].[idUniqueParent]
	FROM [dbo].[hm_nodelink] [Parent]
		INNER JOIN FindRoot C ON 
		    C.[idParent] = [Parent].[idChild] AND
			C.[idTypeParent] = [Parent].[idType] AND 
			[Parent].[idParent] <> [Parent].[idChild] AND 
			C.[idParent] <> C.[idChild] AND 
			C.[Distance] < @maxLevel AND 
			[Parent].[idTree] = @idTree 
		INNER JOIN #tempInfLoopCheck [Temp] on [Temp].id=C.[id]	
)
SELECT top 1 R.[Path] FROM FindRoot R
WHERE 
	R.idChild = R.idParent 
	AND R.idType = R.idTypeParent
end
END