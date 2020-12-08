CREATE view [dbo].[Kernel_View_Simulation_VersionContent]
AS
SELECT CSD.*,CS.id_process,CS.id_user, 
  CASE  
   WHEN CSD.id_type= 4 THEN --GRID
    (SELECT name_grid 
    FROM dbo.k_referential_grids 
    WHERE id_grid=  CSD.id_original) 
   WHEN CSD.id_type=2 THEN --POPULATION
    (SELECT name 
    FROM dbo.pop_Population 
    WHERE idPop= CSD.id_original)
   WHEN CSD.id_type=7 THEN --RULE
    (SELECT KPC.name_cond +' ('+KP.name_prog + ')' 
    FROM k_program_cond KPC 
    INNER JOIN  dbo.k_program KP ON  KP.id_prog=KPC.id_prog 
    WHERE id_cond= CSD.id_original)
  END AS simulation_item_name,
  (SELECT name_itemtype FROM cgTreeItemType where id_itemtype = CSD.id_type) as name_type
FROM dbo.cm_simulation CS 
INNER JOIN dbo.cm_simulation_detail CSD
ON CS.simulation_id = CSD.id_simulation
UNION ALL
SELECT CSD.*,CS.id_process,TU.id_user, 
  CASE  
   WHEN CSD.id_type= 4 THEN --GRID
    (SELECT name_grid 
    FROM dbo.k_referential_grids 
    WHERE id_grid=  CSD.id_original) 
   WHEN CSD.id_type=2 THEN --POPULATION
    (SELECT name 
    FROM dbo.pop_Population 
    WHERE idPop= CSD.id_original)
   WHEN CSD.id_type=7 THEN --RULE
    (SELECT KPC.name_cond +' ('+KP.name_prog + ')' 
    FROM k_program_cond KPC 
    INNER JOIN  dbo.k_program KP ON  KP.id_prog=KPC.id_prog 
    WHERE id_cond= CSD.id_original)
  END AS simulation_item_name,
  (SELECT name_itemtype FROM cgTreeItemType where id_itemtype = CSD.id_type) as name_type
FROM dbo.cm_simulation CS 
INNER JOIN dbo.cm_simulation_detail CSD
ON CS.simulation_id = CSD.id_simulation
LEFT JOIN (select *  from k_teams_shares where id_share = -24) TS ON  TS.id_object = CS.simulation_id
LEFT JOIN k_teams_users TU ON TS.id_team = TU.id_team
WHERE TU.id_user is not NULL and TU.id_user <> CS.id_user