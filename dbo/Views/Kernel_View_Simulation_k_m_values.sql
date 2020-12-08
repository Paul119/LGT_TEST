CREATE VIEW [dbo].[Kernel_View_Simulation_k_m_values]
AS
select 
	sim1.id_value
	,sim1.id_ind
	,sim1.id_field
	,sim1.id_step
	,sim1.input_value
	,sim1.input_value_int
	,sim1.input_value_numeric
	,sim1.input_value_date
	,sim1.input_date
	,sim1.id_user
	,sim1.comment_value
	,sim1.source_value
	,sim1.value_type
	,sim1.idSim
	,sim1.typeModification
	,sim1.idOrg
	,cs.simulation_id from k_m_values sim1, cm_simulation cs
WHERE 1=1
AND (sim1.typeModification <> 2 OR sim1.typeModification is NULL)
AND (NOT EXISTS (SELECT idOrg FROM k_m_values sim2 WHERE sim2.idSim=cs.simulation_id AND sim1.id_value = sim2.idOrg))
AND ( (sim1.idSim <> 0 AND cs.simulation_id=sim1.idSim) OR (sim1.idSim = 0 ))