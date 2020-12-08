CREATE PROCEDURE [dbo].[sp_global_refresh_population]  
( @id_pop INT = 0)  
AS  
BEGIN  
SET NOCOUNT ON;  
 
/*    
==========================================================================  
Called by:  sp_global_refresh_population_masterprocedure  
Parameter:      NA  
Returns:        NA  
Description:    refresh population based on conditions  
==========================================================================  
 Date       Author      Change  
---------------------------------------------  
03/10/2017   D. RUIZ    Creation  
==========================================================================  
*/  
 DECLARE @latest_version INT  
 DECLARE @table_name nvarchar(255)  
 DECLARE @sqlCond nvarchar(max)  
DECLARE @sql nvarchar(max)  
 
 SELECT @sqlCond = dbo.fn_global_decrypt_bo_coding(p.sqlCond), @latest_version = p.lastVersion, @table_name = rtv.name_table_view    
 --SELECT *  
 FROM pop_Population p  
 INNER JOIN k_program_cond_universes pud  
  ON pud.id_universe = p.idUniverse  
 INNER JOIN k_program_cond_universe_table pudt  
  ON pudt.id = pud.id_universe_table  
 INNER JOIN k_referential_tables_views rtv  
  ON rtv.id_table_view = pudt.id_table_view  
 --INNER JOIN k_program_cond_fields pcf  
 -- ON pcf.id_field = 1225--@id_bo  
 --INNER JOIN k_referential_tables_views_fields rtvf  
 -- ON rtvf.id_field = pcf.value_field_view  
 
 WHERE p.idPop = @id_pop    
 
 --SELECT @latest_version, @table_name, @sqlCond  
 DELETE FROM pop_VersionContent WHERE idPopVersion = @latest_version  -- we delete the population of the version  
 
 SELECT @sql =  
 'INSERT INTO pop_VersionContent (idColl, idPopVersion)  
 SELECT DISTINCT idPayee, ' + CAST(@latest_version AS nvarchar(20)) + ' FROM ' + @table_name +  
 ' WHERE ' + @sqlCond  
EXECUTE sp_executesql @sql  
 --SELECT @sql  
 
END