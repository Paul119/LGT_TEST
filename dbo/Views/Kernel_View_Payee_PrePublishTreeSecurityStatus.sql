CREATE VIEW [dbo].[Kernel_View_Payee_PrePublishTreeSecurityStatus]
 AS
 select 
 'GV_Hierarchy_Security_Node' as is_exception,
 (case when hmnlp.idType= 14 then (select firstname+' '+lastname from py_payee where idPayee=hmnlp.idChild )
   when hmnlp.idType= 48 then (select long_name_structure from Dim_Structure where id_structure= hmnlp.idChild)
   when hmnlp.idType= 47 then (select long_name_territory from Dim_Territory where id_territory= hmnlp.idChild)
   when hmnlp.idType= 49 then (select long_name_department from Dim_Department where id_department= hmnlp.idChild)
   else 'GV_Unknown' end) as [tree_security_node_label] ,
   (case when (hnl.idChild is null) then 'GV_Delete' else 'GV_Check'  end) as [tree_security_status],
   hmnlp.idTree as tree_id
   from k_tree_security kts
 inner join hm_NodelinkPublished hmnlp on kts.id_tree_node_published= hmnlp.id
 inner join hm_NodeTreePublished hmntp on hmntp.id= hmnlp.idTree
 left join hm_Nodelink hnl on hnl.idChild= hmnlp.idChild and hnl.idType= hmnlp.idType
 and hnl.idTree= hmntp.id_hm_NodeTree

 UNION ALL 

 select 
 'GV_Hierarchy_Security_Exclusion' as is_exception,
 (case when hmnlp.idType= 14 then (select firstname+' '+lastname from py_payee where idPayee=hmnlp.idChild )
   when hmnlp.idType= 48 then (select long_name_structure from Dim_Structure where id_structure= hmnlp.idChild)
   when hmnlp.idType= 47 then (select long_name_territory from Dim_Territory where id_territory= hmnlp.idChild)
   when hmnlp.idType= 49 then (select long_name_department from Dim_Department where id_department= hmnlp.idChild)
   else 'GV_Unknown' end) as [tree_security_node_label] ,
   (case when (hnl.idChild is null) then 'GV_Delete' else 'GV_Check'  end) as [tree_security_status],
    hmnlp.idTree as tree_id
   from k_tree_security_exception ktse
 inner join hm_NodelinkPublished hmnlp on ktse.id_tree_node_published= hmnlp.id
 inner join hm_NodeTreePublished hmntp on hmntp.id= hmnlp.idTree
 left join hm_Nodelink hnl on hnl.idChild= hmnlp.idChild and hnl.idType= hmnlp.idType
 and hnl.idTree= hmntp.id_hm_NodeTree


 UNION ALL 

 select 
 'GV_Process_Security_Exception' as is_exception,
 (case when hmnlp.idType= 14 then (select firstname+' '+lastname from py_payee where idPayee=hmnlp.idChild )
   when hmnlp.idType= 48 then (select long_name_structure from Dim_Structure where id_structure= hmnlp.idChild)
   when hmnlp.idType= 47 then (select long_name_territory from Dim_Territory where id_territory= hmnlp.idChild)
   when hmnlp.idType= 49 then (select long_name_department from Dim_Department where id_department= hmnlp.idChild)
   else 'GV_Unknown' end) as [tree_security_node_label] ,
   (case when (hnl.idChild is null) then 'GV_Delete' else 'GV_Check'  end) as [tree_security_status],
    hmnlp.idTree as tree_id
   from k_tree_security_plan_level_exception ktse
 inner join hm_NodelinkPublished hmnlp on ktse.id_tree_node_published= hmnlp.id
 inner join hm_NodeTreePublished hmntp on hmntp.id= hmnlp.idTree
 left join hm_Nodelink hnl on hnl.idChild= hmnlp.idChild and hnl.idType= hmnlp.idType
 and hnl.idTree= hmntp.id_hm_NodeTree