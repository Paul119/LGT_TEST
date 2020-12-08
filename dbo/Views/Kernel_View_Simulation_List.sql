CREATE view [dbo].[Kernel_View_Simulation_List]
as
   SELECT CSD.*,CS.id_user,CS.id_process,CS.simulation_name FROM dbo.cm_simulation_detail CSD
	INNER JOIN dbo.cm_simulation CS
	ON CS.simulation_id= CSD.id_simulation