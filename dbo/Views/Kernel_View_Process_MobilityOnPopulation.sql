-- Performance increase on [Kernel_View_Process_MobilityOnPopulation]
CREATE VIEW [dbo].[Kernel_View_Process_MobilityOnPopulation]
AS
WITH StepPlanEmployee
AS
(
	SELECT DISTINCT ps.id_plan,ps.id_payee,pm.id_status
	  FROM k_m_plans_payees_steps AS ps
		INNER JOIN k_m_plans_payees_mobility pm
			ON ps.id_step = pm.id_step
			
)
,Mobility
AS
(
SELECT p.id_plan, p.name_plan, SUB.idPayee, SUB.IdStatus, SUB.Status
  FROM k_m_plans p
  CROSS APPLY (
				
				SELECT pa.id_plan, vc.idColl as idPayee, 2 as IdStatus, 'GV_Leaver'  AS Status
					FROM k_m_plans_affectations pa
					JOIN pop_VersionContent vc
						ON pa.idPopVersion = vc.idPopVersion
				WHERE type_affectation = 'P'
					AND pa.id_plan = p.id_plan
					AND NOT EXISTS (
									SELECT 1 
										FROM StepPlanEmployee sp
										WHERE sp.id_status = 2
										AND sp.id_payee = vc.idColl
										AND p.id_plan = sp.id_plan
									)
				EXCEPT
					(
						SELECT pa.id_plan, vc.idColl, 2 as IdStatus, 'GV_Leaver' AS Status
							FROM k_m_plans_affectations pa
								JOIN pop_Population po
									ON pa.id_assignee = po.idPop
								JOIN pop_VersionContent vc
									ON vc.idPopVersion = po.lastVersion
							WHERE type_affectation = 'P'
							  AND pa.id_plan = p.id_plan
					)

			UNION ALL

			SELECT pa.id_plan, vc.idColl AS idPayee, 1 as IdStatus,  'GV_NewComer' AS Status
				FROM k_cultures k,k_m_plans_affectations pa
					JOIN pop_Population po
						ON pa.id_assignee = po.idPop
					JOIN pop_VersionContent vc
						ON vc.idPopVersion = po.lastVersion
				WHERE type_affectation = 'P'
					AND pa.id_plan = p.id_plan
					AND NOT EXISTS 
					(
									SELECT 1 
									  FROM StepPlanEmployee sp
									 WHERE sp.id_status = 1
									   AND sp.id_payee = vc.idColl
									   AND p.id_plan = sp.id_plan
					)
				EXCEPT
					(
						SELECT pa.id_plan, vc.idColl AS idPayee, 1 as IdStatus, 'GV_NewComer' AS Status
							FROM k_m_plans_affectations pa

								JOIN pop_VersionContent vc
									ON pa.idPopVersion = vc.idPopVersion
							WHERE type_affectation = 'P'
								AND pa.id_plan = p.id_plan
					)
			  ) SUB
)
SELECT m.id_plan, m.name_plan, m.idPayee, sub.firstname + ' ' + sub.lastname as Fullname, m.IdStatus, ISNULL(l.value,m.Status) as Status,kc.culture
  FROM Mobility m
  cross join k_cultures kc
					OUTER APPLY (SELECT top 1 * FROM rps_Localization l WHERE m.Status = l.name and kc.culture = l.culture ) L
	OUTER APPLY (
					SELECT p.firstname,p.lastname
					  FROM py_Payee p
					 WHERE m.idPayee = p.idPayee
				) as sub