CREATE PROCEDURE [dbo].[Kernel_SP_Hierarchy_SearchTreeContent]
(
	@idTree int,
	@idUser int,
	@idProfile int,
	@searchString nvarchar(200),
	@payeeNameTemplate nvarchar(100)
)
AS 

BEGIN
    DECLARE @SQL nvarchar(max); 
    DECLARE @SQL2 nvarchar(max);
	set @searchString = CONCAT('%',LOWER(@searchString),'%')

	--0_0 FIND SUBORDINATES OF A NODE  
	declare @idUserProfile int
	SELECT @idUserProfile = up.idUserProfile from k_users_profiles up where up.id_user = @idUser and up.id_profile = @idProfile

	IF(@idTree is null or @idUser is null or @idProfile is null)
	BEGIN
		print 'RETURN: @idTree is null or @idUser is null or @idProfile is null or @idUserProfile is null'
		RETURN
	END

if object_id(N'tempdb..#matchnodes') is not null
		drop table #matchnodes
			create table #matchnodes
	(
		idNode int,
		idType int
	)
	--FIND Payees
	set @SQL2='
	select idPayee as idNode, 14 as idType
	from py_Payee p 
		left join hm_NodelinkPublished n 
			on p.idPayee = n.idChild and n.idType = 14
	where 
	    n.idTree = ' + CAST(@idTree AS NVARCHAR(MAX)) + '  AND 
		(LOWER (' +@payeeNameTemplate+ ') LIKE ''' +@searchString + '''
		OR LOWER(p.codePayee) LIKE ''' +@searchString + ''')
		'
		insert into #matchnodes EXECUTE sp_sqlexec @SQL2

	--FIND Territory
	insert into #matchnodes
	select id_territory, 47 from Dim_Territory t
		left join hm_NodelinkPublished n 
			on t.id_territory = n.idChild and n.idType = 47
	where
		n.idTree = @idTree AND 
		(LOWER(t.long_name_territory) LIKE @searchString 
		OR LOWER(t.code_territory) LIKE @searchString)

	--FIND Structures
	insert into #matchnodes
	select id_structure, 48 from Dim_Structure s
		left join hm_NodelinkPublished n 
			on s.id_structure = n.idChild and n.idType = 48
	where
		n.idTree = @idTree AND 
		(LOWER(s.long_name_structure) LIKE @searchString 
		OR LOWER(s.code_structure) LIKE @searchString)

	--FIND Departments
	insert into #matchnodes
	select id_department, 49 from Dim_Department d
		left join hm_NodelinkPublished n 
			on d.id_department= n.idChild and n.idType = 49
	where
		n.idTree = @idTree AND 
		(LOWER(d.long_name_department) LIKE @searchString 
		OR LOWER(d.code_department) LIKE @searchString)


	IF NOT EXISTS (select * from #matchnodes)
	BEGIN
		print 'not found'
		RETURN
	END

	declare @idPayee int = null
	declare @isAdmin bit = 0

	select @idPayee = u.id_external_user, @isAdmin = u.isadmin_user from k_users u where id_user = @idUser and u.active_user = 1
	
	declare @hidUserNode hierarchyid		--might be null (user is not in the tree, either admin or accessing via k_tree_security assignment)
	declare @hidUserNodeLevel smallint		--might be null (user is not in the tree, either admin or accessing via k_tree_security assignment)

	IF(@isAdmin = 1)	-- load from the root of the hierarchy							-- Q: What if  MULTIPLE HIERARCHY in hm_NodeLinkPublishedHierarchy table? (So there will be multiple hierarchyid::GetRoot()) 
		select @hidUserNode = hierarchyid::GetRoot(), @hidUserNodeLevel = 0		-- A: Its ok if we also include idTree in where clause whenever we filter hm_NodeLinkPublishedHierarchy table with @hidSelectedNode 
	ELSE				-- load from the current node
		select top (1) @hidUserNode = h.hid, @hidUserNodeLevel = h.hidLevel 
		from hm_NodeLinkPublishedHierarchy h 
		where h.idTree = @idTree and h.idChild = @idPayee and h.idType = 14


	if(object_id('tempdb.dbo.#resultSet') is not null)
		drop table #resultSet
	create table #resultSet
	(
		id_NodelinkPublished int, 
		hid hierarchyid,
		idTree int, 
		idChild int, 
		idType int,
		idTreeSecurity int
	)

	if(object_id('tempdb.dbo.#match') is not null)
		drop table #match

	select top 100 h.id_NodelinkPublished, h.hid, h.idTree, h.idChild, h.idType, 1 as included, hn.sort_order 
	into #match
	from 
		hm_NodeLinkPublishedHierarchy h
		left join hm_NodelinkPublished hn
			on h.id_NodelinkPublished = hn.id
		left join #matchnodes m 
			on h.idChild = m.idNode and h.idType = m.idType
	where h.idTree = @idTree and m.idNode is not null
		
	declare @disableStdHierAccess bit
	select @disableStdHierAccess = p.value_parameter from k_parameters p where id_parameter = -33 --PRM_DisableStandardHierarchyAccess

	--IF STANDARD IS AVAILABLE
	IF(@disableStdHierAccess = 0 AND @hidUserNode is not null) OR @isAdmin = 1
	BEGIN
		update #match set included = hid.IsDescendantOf(@hidUserNode)

		--- we have the list, find the complete path
		;WITH matchAndParents 
		AS  
		(
			select 
				id_NodelinkPublished, hid, idTree, idChild, idType
				from #match m--initialization 
				where m.included = 1
			UNION ALL 
			select 
				n.id, h2.hid, n.idTree, n.idChild, n.idType
				from 
					matchAndParents m --recursive execution 
						inner join hm_NodeLinkPublishedHierarchy h1 
							on m.id_NodelinkPublished = h1.id_NodelinkPublished
						inner join hm_NodeLinkPublishedHierarchy h2
							on h1.hidParent = h2.hid and h2.idTree = @idTree
						inner join hm_NodelinkPublished n
							on h2.id_NodelinkPublished = n.id 
				where h2.hid.IsDescendantOf(@hidUserNode) = 1
		)
		Insert into #resultSet 
		SELECT distinct *, NULL as idTreeSecurity FROM matchAndParents order by hid
	END

	if object_id(N'tempdb..#security') is not null
		drop table #security

	create table #security
	(
		id_tree_security int,
		id_tree_node_published int,
		is_self int,
		is_apply_filter bit,
		id_user_profile int,
		is_included bit,
		id_tree int
	)

	insert into #security 
	select id_tree_security, id_tree_node_published, is_self, is_apply_filter, id_user_profile, is_included, idTree  
	from k_tree_security sec left join hm_NodelinkPublished n on sec.id_tree_node_published = n.id 
	where id_user_profile = @idUserProfile and idTree = @idTree and sec.begin_date < GETUTCDATE() and (sec.end_date is null or sec.end_date > getdate())


	if object_id(N'tempdb..#nodesExcluded') is not null
		drop table #nodesExcluded
	SELECT ex.*, h.hid INTO #nodesExcluded 
		from k_tree_security_exception ex
		left join hm_NodeLinkPublishedHierarchy h
			on ex.id_tree_node_published = h.id_NodelinkPublished
	WHERE id_tree_security in (select id_tree_security from #security)

	if object_id(N'tempdb..#popsFiltered') is not null
		drop table #popsFiltered
	select f.id_tree_security, s.is_included, f.id_pop, p.lastVersion as idVersion 
	INTO #popsFiltered
		from #security s
		left join k_tree_security_filter f on s.id_tree_security = f.id_tree_security
		left join pop_Population p on f.id_pop = p.idPop
		WHERE s.is_apply_filter = 1

	declare @idType int
	declare @id_tree_security int, @id_tree_node_published int, @is_self bit, @is_apply_filter bit, @id_user_profile int, @is_included bit
	declare secCursor cursor for 
		select id_tree_security, id_tree_node_published, is_self, is_apply_filter, id_user_profile, is_included from #security 

	open secCursor
	fetch next from secCursor
		into @id_tree_security, @id_tree_node_published, @is_self, @is_apply_filter, @id_user_profile, @is_included 
	while @@FETCH_STATUS = 0
	BEGIN
		select @hidUserNode = null, @hidUserNodeLevel = null, @idType = null
		select top (1) @hidUserNode = h.hid, @hidUserNodeLevel = h.hidLevel, @idType = h.idType 
			from hm_NodeLinkPublishedHierarchy h 
			where h.idTree = @idTree and h.id_NodelinkPublished= @id_tree_node_published --h.idChild = @id_tree_node_published and h.idType = 14
		if(@hidUserNode is null)
		BEGIN
			fetch next from secCursor
				into @id_tree_security, @id_tree_node_published, @is_self, @is_apply_filter, @id_user_profile, @is_included 
			continue
		END
		--- here clear the filtered out or chopped ones
		update #match set included = hid.IsDescendantOf(@hidUserNode)
		
		if(@is_apply_filter = 1) --population filter
		begin
			if (@is_included = 1)
			begin
				update #match set included = included -1 where idType=14
				update m 
				set included = 1
				from #match m
					left join #popsFiltered pf on pf.id_tree_security = @id_tree_security
					left join pop_VersionContent pvc on pf.idVersion = pvc.idPopVersion and pvc.idColl=m.idChild
					left join hm_NodeLinkPublishedHierarchy h on m.idTree = h.idTree and h.idType = 14 and (m.hid = h.hid or h.hid.IsDescendantOf(m.hid) = 1)
				where m.included = 0 and pf.id_pop is not null and pvc.idColl is not null
			end
			else
			begin
				update m 
				set included = 0
				from #match m
					left join #popsFiltered pf on pf.id_tree_security = @id_tree_security
					left join pop_VersionContent pvc on pf.idVersion = pvc.idPopVersion and pvc.idColl=m.idChild
					left join hm_NodeLinkPublishedHierarchy h on m.idTree = h.idTree and h.idType = 14 and (m.hid = h.hid or h.hid.IsDescendantOf(m.hid) = 1)
				where m.included = 1 and pf.id_pop is not null and pvc.idColl is not null
			end
		end

		update #match set included = 0 where 
			hid in
			(
				select m.hid 
					from #match m 
					left join #nodesExcluded ex 
						on m.hid.IsDescendantOf(ex.hid) = 1 
				where ex.hid is not null and ex.id_tree_security = @id_tree_security
			) 

		;WITH matchAndParents 
		AS  
		(
			select 
				id_NodelinkPublished, hid, idTree, idChild, idType
				from #match m--initialization 
				where m.included = 1
			UNION ALL 
			select n.id, h2.hid, n.idTree, n.idChild, n.idType
				from 
					matchAndParents m --recursive execution 
						inner join hm_NodeLinkPublishedHierarchy h1 
							on m.id_NodelinkPublished = h1.id_NodelinkPublished
						inner join hm_NodeLinkPublishedHierarchy h2
							on h1.hidParent = h2.hid and h2.idTree = @idTree
						inner join hm_NodelinkPublished n
							on h2.id_NodelinkPublished = n.id 
				where h2.hid.IsDescendantOf(@hidUserNode) = 1
		)  

		INSERT INTO #resultSet
		SELECT distinct *, @id_tree_security as idTreeSecurity FROM matchAndParents order by hid

		fetch next from secCursor
			into @id_tree_security, @id_tree_node_published, @is_self, @is_apply_filter, @id_user_profile, @is_included 
	END
	close secCursor
	deallocate secCursor

	SET @SQL ='
	select 
		n.id, rs.idChild, rs.idType, rs.idTreeSecurity,  
		case rs.idType	when 14 then ' +@payeeNameTemplate +'
						when 47 then t.long_name_territory
						when 48 then s.long_name_structure
						when 49 then d.long_name_department
		END AS nodeName, 
		CAST((select COUNT(*) from hm_NodeLinkPublishedHierarchy child where child.idTree = rs.idTree and child.hidParent = rs.hid) as bit) as hasChild,
		idParent, idTypeParent, 
		p.codePayee as childCodePayee, s.code_structure as childCodeStructure, 
		t.code_territory as childCodeTerritory, d.code_department as childCodeDepartment,
		n.sort_order as sortOrder, h.hidLevel
	from #resultSet rs
	left join hm_NodeLinkPublished n on rs.idTree = n.idTree and rs.idChild = n.idChild and rs.idType = n.idType
	left join hm_NodeLinkPublishedHierarchy h on n.id = h.id_NodelinkPublished 
	left join py_Payee p 
		on rs.idType = 14 and rs.idChild = p.idPayee
	left join Dim_Structure s
		on s.id_structure = n.idChild and n.idType = 48
	left join Dim_Territory t
		on t.id_territory = n.idChild and n.idType = 47
	left join Dim_Department d
		on d.id_department= n.idChild and n.idType = 49

	select
		rs.idTreeSecurity, Min(h.hidLevel) as rootLevel
	from #resultSet rs
	left join hm_NodeLinkPublished n on rs.idTree = n.idTree and rs.idChild = n.idChild and rs.idType = n.idType
	left join hm_NodeLinkPublishedHierarchy h on n.id = h.id_NodelinkPublished 
	group by rs.idTreeSecurity'
	EXECUTE sp_sqlexec @SQL; 

END