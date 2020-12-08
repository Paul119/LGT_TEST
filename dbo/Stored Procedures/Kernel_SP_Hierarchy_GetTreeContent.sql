CREATE PROCEDURE [dbo].[Kernel_SP_Hierarchy_GetTreeContent]
(
	@idTree int,
	@idTreeSecurity int, --idTreeSecurity might be null. Then all the different available roots for that userprofile needs to be reurned
	@idSelectedNode int, 
	@idUser int,
	@idProfile int,
	@payeeNameTemplate nvarchar(100)
)
AS 
BEGIN

	DECLARE @idTreeLocal int
	DECLARE @idTreeSecurityLocal int 
	DECLARE @idSelectedNodeLocal int 
	DECLARE @idUserLocal int 
	DECLARE @idProfileLocal int
	DECLARE @payeeNameTemplateLocal nvarchar(100) 
	
	SET @idTreeLocal = @idTree
	SET @idTreeSecurityLocal = @idTreeSecurity
	SET @idSelectedNodeLocal = @idSelectedNode
	SET @idUserLocal = @idUser
	SET @idProfileLocal = @idProfile
	SET @payeeNameTemplateLocal = @payeeNameTemplate

    DECLARE @SQL nvarchar(max);
	IF(@idTreeSecurityLocal = 0)
		SET @idTreeSecurityLocal = null
	IF(@idSelectedNodeLocal = 0)
		SET @idSelectedNodeLocal = null

	--0_0 FIND SUBORDINATES OF A NODE  
	declare @idUserProfile int
	SELECT @idUserProfile = up.idUserProfile from k_users_profiles up where up.id_user = @idUserLocal and up.id_profile = @idProfileLocal

	IF(@idTreeLocal is null or @idUserLocal is null or @idProfileLocal is null or @idUserProfile is null)
	BEGIN
		print 'RETURN: @@idTreeLocal is null or @idUserLocal is null or @idProfileLocal is null or @idUserProfile is null'
		RETURN
	END
	------
	declare @hidSelectedNode hierarchyid	--might be null
	declare @hidSelectedNodeLevel smallint	--might be null

	declare @idPayee int = null
	declare @isAdmin bit = 0

	select @idPayee = u.id_external_user, @isAdmin = u.isadmin_user from k_users u where id_user = @idUserLocal and u.active_user = 1
	
	declare @hidUserNode hierarchyid		--might be null (user is not in the tree, either admin or accessing via k_tree_security assignment)
	declare @hidUserNodeLevel smallint		--might be null (user is not in the tree, either admin or accessing via k_tree_security assignment)
	select top (1) @hidUserNode = h.hid, @hidUserNodeLevel = h.hidLevel from hm_NodeLinkPublishedHierarchy h where h.idTree = @idTreeLocal and h.idChild = @idPayee and h.idType = 14

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
		id_parent_tree_security int
	)


	if object_id(N'tempdb..#allNP1') is not null
		drop table #allNP1
	create table #allNP1
	(
		id_NodelinkPublished int, 
		idChild int, 
		included int, 
		hid hierarchyid, 
		idType int, 
		hasChild bit, 
		hidLevel int,
		idTreeSecurity int
	)

	--1_0. Find the security rules
	-------------------------
	IF(@idTreeSecurityLocal is null)			--A.(AllL1FirstLoad_OR_SelectedNodeOfAStdHierarchy) IdSecurity is null so return all possible L1 roots of the tree available for this user and profile
	BEGIN
		declare @disableStdHierAccess bit
		select @disableStdHierAccess = p.value_parameter from k_parameters p where id_parameter = -33 --PRM_DisableStandardHierarchyAccess
		IF(@disableStdHierAccess = 0 OR @isAdmin = 1)--A.(AllL1FirstLoad_OR_SelectedNodeOfAStdHierarchy.IncStd) L1 roots, including standard if possible to access
		BEGIN
			IF(@idSelectedNodeLocal is null)			--AllL1FirstLoad.Part1Standard: (AllL1FirstLoad_OR_SelectedNodeOfAStdHierarchy.IncStd.AllL1FirstLoad_NOTSelectedNodeOfAStdHierarchy)
			BEGIN
				IF(@isAdmin = 1)	-- load from the root of the hierarchy							-- Q: What if  MULTIPLE HIERARCHY in hm_NodeLinkPublishedHierarchy table? (So there will be multiple hierarchyid::GetRoot()) 
					select @hidSelectedNode = hierarchyid::GetRoot(), @hidSelectedNodeLevel = 0		-- A: It's ok if we also include idTree in where clause whenever we filter hm_NodeLinkPublishedHierarchy table with @hidSelectedNode 
				ELSE				-- load from the current node
					select top (1) @hidSelectedNode = h.hid, @hidSelectedNodeLevel = h.hidLevel from hm_NodeLinkPublishedHierarchy h where h.idTree = @idTreeLocal and h.idChild = @idPayee and h.idType = 14

				IF(@hidSelectedNode is null) --Not admin and not in hierarchy
					print 'User does not have access to standard tree, he is neither an admin nor in the hierarchy. Lets check any nodes accessible via hierarchy security'
				ELSE
					INSERT INTO #allNP1
					Select 
						id_NodelinkPublished, idChild, 1 as included, hid, idType, 0 as hasChild, hidLevel, null  
					From hm_NodeLinkPublishedHierarchy h
					WHERE h.hid = @hidSelectedNode and h.idTree = @idTreeLocal
			END
			ELSE								--SelectedNodeOfAStdHierarchy: (AllL1FirstLoad_OR_SelectedNodeOfAStdHierarchy.IncStd.SelectedNodeOfAStdHierarchy_NOTAllL1FirstLoad)
			BEGIN
				select top (1) @hidSelectedNode = h.hid, @hidSelectedNodeLevel = h.hidLevel from hm_NodeLinkPublishedHierarchy h where h.id_NodelinkPublished = @idSelectedNodeLocal

				IF(@isAdmin = 0 and @hidSelectedNode.IsDescendantOf(@hidUserNode) = 0) -- cool, check this also on hierarchy security access
				BEGIN
					print 'RETURN: User does not have access to the selected node'
					RETURN
				END
				INSERT INTO #allNP1
				Select 
					id_NodelinkPublished, idChild, 1 as included, hid, idType, 0 as hasChild, hidLevel, null  
				From hm_NodeLinkPublishedHierarchy h
				WHERE h.hidParent = @hidSelectedNode and h.hidLevel = @hidSelectedNodeLevel + 1 and h.idTree = @idTreeLocal
			END
		END		
		IF(@idSelectedNodeLocal is null)				--AllL1FirstLoad.Part2HierSec: (AllL1FirstLoad_OR_SelectedNodeOfAStdHierarchy.IncStd.AllL1FirstLoad_NOTSelectedNodeOfAStdHierarchy)
		BEGIN
			INSERT INTO #security
			select 
				id_tree_security, id_tree_node_published, is_self, is_apply_filter, id_user_profile, is_included, id_parent_tree_security
			from 
				k_tree_security sec 
				left join hm_NodeLinkPublishedHierarchy h 
					ON sec.id_tree_node_published = h.id_NodelinkPublished
			where sec.id_user_profile = @idUserProfile and h.idTree = @idTreeLocal and sec.begin_date < GETUTCDATE() and (sec.end_date is null or sec.end_date > GETUTCDATE())
		
			INSERT INTO #allNP1
			Select 
				id_NodelinkPublished, idChild, 1 as included, hid, idType, 0 as hasChild, hidLevel, sec.id_tree_security  
			From #security sec 
				left join hm_NodeLinkPublishedHierarchy h
					on sec.id_tree_node_published = h.id_NodelinkPublished
		END
		
		Update np1
		SET 
			np1.hasChild = 1
		FROM #allNP1 np1 left join hm_NodeLinkPublishedHierarchy h 
			on np1.hid = h.hidParent
		where h.hid is not null
	END
	ELSE								--B.(L2AndBlw.HierSecOnly) IdSecurity is given
	BEGIN
		INSERT INTO #security
		select 
			id_tree_security, id_tree_node_published, is_self, is_apply_filter, id_user_profile, is_included, id_parent_tree_security
		from 
			k_tree_security sec 
		where sec.id_tree_security = @idTreeSecurityLocal and sec.id_user_profile = @idUserProfile and sec.begin_date < GETUTCDATE() and (sec.end_date is null or sec.end_date > GETUTCDATE()) 

		IF(NOT EXISTS (SELECT * FROM #security))
		BEGIN
			print 'RETURN: No such record in k_tree_security'
			RETURN
		END

		--2_0. FIND THE ROOT NODE
		IF(@idSelectedNodeLocal = 0)	--ROOT NODE is not given, find from security assignment
			SELECT top (1) @idSelectedNodeLocal = sec.id_tree_node_published FROM #security sec
		--ELSE ROOT NODE is already selected node

		declare @isIncluded int = 2 -- 2:NoFilter, 0:Excluded, 1:Included
		SELECT top (1) @isIncluded = sec.is_included FROM #security sec WHERE sec.is_apply_filter = 1
		-------------------------
		select top (1) @hidSelectedNode = h.hid, @hidSelectedNodeLevel = h.hidLevel from hm_NodeLinkPublishedHierarchy h where id_NodelinkPublished = @idSelectedNodeLocal
		
		--3_0. Find Level N+1 and check if any of them disappears
		-----------------------------
		--2ND MOST EXPENSIVE 400ms --
		-----------------------------
		-- INCLUDE all children of the node
		INSERT INTO #allNP1
		Select 
			id_NodelinkPublished, idChild, 
			CASE @isIncluded WHEN 2 THEN 1 --if no filter assigned then all included
			ELSE -1 END as included, 
			hid, idType, 0 as hasChild, hidLevel, @idTreeSecurityLocal  
		From hm_NodeLinkPublishedHierarchy h
		Where h.hidParent = @hidSelectedNode and h.hidLevel = @hidSelectedNodeLevel + 1 and h.idTree = @idTreeLocal

		-----------------------------------


		--2_1. Node exclusions
		-------------------------
		if object_id(N'tempdb..#nodesExcluded') is not null
			drop table #nodesExcluded

		SELECT * INTO #nodesExcluded from k_tree_security_exception 
		WHERE id_tree_security = @idTreeSecurityLocal --in this else block idTreeSecurity is given and single -- IN (select s.id_tree_security from #security s)

		--2_2. Population inclusions and exclusions
		-------------------------
		if object_id(N'tempdb..#popFilters') is not null
			drop table #popFilters
		select * INTO #popFilters from k_tree_security_filter where id_tree_security  = @idTreeSecurityLocal --in this else block idTreeSecurity is given and single --IN (select s.id_tree_security from #security s)
		--Update the ones belongs to populations declared in popfilter.
		IF(@isIncluded <> 2)
		BEGIN
			Update 
				res
			SET 
				res.included = @isIncluded -- Smart! Update all individuals to 1 if pop filter is defined as included or to 0 if pop filter is defined as excluded or to 2 if no filter assigned.
			FROM 
				#allNP1 as res 
				left join (select distinct idColl 
							from pop_Population p left join pop_VersionContent pvc 
								on p.lastVersion = pvc.idPopVersion 
							where p.idPop IN (select pf.id_pop from #popFilters pf)) pc
					on res.idChild = pc.idColl and res.idType = 14
			WHERE pc.idColl is not null
				 
			Update							-- Smart approach completes itself here..
				#allNP1
			SET 
				included = 1-@isIncluded 
			WHERE
				included = -1 -- and idType = 14 (Any Level N+1 should be set not only payee nodes. And idType = 14 ) 
		END
		--Mark the nodes excluded
		Update 	#allNP1 set included = -2
			WHERE id_NodelinkPublished IN (Select ne.id_tree_node_published from #nodesExcluded ne)

		--Find out if the node has a child
		UPDATE res
		SET
			res.hasChild = 1
		FROM
			#allNP1 res
		WHERE EXISTS (SELECT * FROM hm_NodeLinkPublishedHierarchy h WHERE h.hidLevel = (@hidSelectedNodeLevel+2) AND h.hidParent = res.hid) 

		--3_2. Identify if any of #filteredOutNP1s need to join back
		---------------------------------------
		--THE MOST EXPENSIVE 1.5s > x < 2.7s --
		---------------------------------------

		IF(@isIncluded = 1)
		BEGIN
			UPDATE rs
			SET 
				included = 2
			FROM	
				#allNP1 rs 
			left join
				(	
					select TOP 1000000  Lvl1Manager from
					(
								SELECT hier.Lvl1Manager FROM
											(
												select distinct TOP 1000000 idChild from hm_NodeLinkPublishedHierarchy h2 
													where h2.idType = 14 AND h2.idChild IN(
													select distinct idColl 
													from	pop_Population p 
															left join pop_VersionContent pvc 
															on p.lastVersion = pvc.idPopVersion 
													where p.idPop IN (select pf.id_pop from #popFilters pf))
													AND h2.hidLevel> @hidSelectedNodeLevel and h2.idType = 14 and h2.idTree = @idTreeLocal
											) popCont
								left join	(	
												SELECT h.hid.GetAncestor(h.hidLevel-(@hidSelectedNodeLevel + 1)) as Lvl1Manager, h.idChild, h.idType 
												FROM	hm_NodeLinkPublishedHierarchy h
												WHERE h.hidLevel> @hidSelectedNodeLevel												
											)hier
								on popCont.idChild is not null and hier.idChild = popCont.idChild and hier.idType = 14
						) t
					group by Lvl1Manager
				) allNP1 on rs.hid = allNP1.Lvl1Manager
			WHERE rs.hasChild = 1 AND 
					(rs.included = 0 OR (rs.included = -1 AND rs.idType <> 14 )) AND Lvl1Manager is not null
		END
		ELSE IF(@isIncluded = 0)
		BEGIN
			UPDATE rs
			SET 
				included = 2
			FROM	
				#allNP1 rs 
			left join
				(	
					select TOP 1000000  Lvl1Manager from
					(
								SELECT hier.Lvl1Manager FROM
											(
												select distinct TOP 1000000 idChild from hm_NodeLinkPublishedHierarchy h2 
													where h2.idType = 14 AND h2.idChild NOT IN(
													select distinct idColl 
													from	pop_Population p 
															left join pop_VersionContent pvc 
															on p.lastVersion = pvc.idPopVersion 
													where p.idPop IN (select pf.id_pop from #popFilters pf))
													AND h2.hidLevel> @hidSelectedNodeLevel and h2.idType = 14 and h2.idTree = @idTreeLocal
											) popCont
								left join	(	
												SELECT h.hid.GetAncestor(h.hidLevel-(@hidSelectedNodeLevel + 1)) as Lvl1Manager, h.idChild, h.idType 
												FROM	hm_NodeLinkPublishedHierarchy h
												WHERE h.hidLevel> @hidSelectedNodeLevel												
											)hier
								on popCont.idChild is not null and hier.idChild = popCont.idChild and hier.idType = 14
						) t
					group by Lvl1Manager
				) allNP1 on rs.hid = allNP1.Lvl1Manager
			WHERE rs.hasChild = 1 AND 
					rs.included = 0  AND Lvl1Manager is not null
		END
	END

	  SET @SQL ='SELECT	
		n.included as Included, n.hasChild as HasChild, n.hidLevel as [Level], n.idTreeSecurity,
		h.id as Id,h.idChild as IdChild, h.idType as TypeId, h.idParent as IdParent, h.idTypeParent as IdTypeParent, h.sort_order,
		p.codePayee as ChildCodePayee, 
		CASE (n.idType) 
			WHEN 14 THEN ' +@payeeNameTemplateLocal +'
			WHEN 47 THEN t.long_name_territory
			WHEN 48 THEN s.long_name_structure
			WHEN 49 THEN d.long_name_department
		END AS NodeName
	FROM 
		#allNP1 n 
		left join hm_NodeLinkPublished h 
			on n.id_NodelinkPublished = h.id
		left join py_Payee p 
			on n.idType = 14 and n.idChild = p.idPayee 
		left join Dim_Territory t 
			on n.idType = 47 and n.idChild = t.id_territory
		left join Dim_Structure s 
			on n.idType = 48 and n.idChild = s.id_structure
		left join Dim_Department d 
			on n.idType = 49 and n.idChild = d.id_department
	where n.included > 0'

    EXECUTE sp_sqlexec @SQL;
END