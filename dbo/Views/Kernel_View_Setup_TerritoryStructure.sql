CREATE VIEW [dbo].[Kernel_View_Setup_TerritoryStructure]
AS
SELECT  st.id_structure, 
tree.id as tree_id, 
tree.name as tree_name,
ptree.id as published_tree_id, 
ptree.name as published_tree_name, 
ptree.createDate published_tree_date, 
tmp.id_template, 
tmp.name_template,
CASE 
WHEN ptree.id IS NOT NULL
THEN 1
ELSE 0
END
as is_published
FROM k_tqm_structure st
JOIN k_tqm_template tmp
ON st.id_template = tmp.id_template
JOIN hm_NodeTree tree
ON st.id_tree = tree.id
LEFT JOIN hm_NodeTreePublished ptree
ON tree.id = ptree.id_hm_NodeTree