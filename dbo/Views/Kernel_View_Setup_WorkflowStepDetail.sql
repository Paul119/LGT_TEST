CREATE VIEW [dbo].[Kernel_View_Setup_WorkflowStepDetail]
AS
SELECT [ws1].[id_wflstep], [ws1].[id_workflow], [ws1].name_step, [ws1].sort_step, c.[value] as [culture]
, STUFF ( (
   SELECT ', ' + ISNULL(RPSLOC.[value], p.name_profile) AS [text()]
   FROM k_m_workflow_step AS [ws]
		JOIN k_m_workflow_step_group AS [wsg]
			ON ws.id_wflstep = wsg.id_wflstep
		JOIN k_m_workflow_step_group_profile AS [wsgp]
			ON wsgp.id_wflstepgroup = wsg.id_wflstepgroup
		JOIN k_profiles AS [p]
			ON wsgp.id_profile = p.id_profile
		LEFT JOIN ( select distinct name,culture,value from rps_localization) [RPSLOC]
		        	ON p.name_profile = RPSLOC.[name] AND RPSLOC.culture = c.[culture]
   WHERE [ws].[id_wflstep] = [ws1].[id_wflstep]
   ORDER BY p.id_profile
   FOR XML PATH('')
  )
 ,1,1,''
 ) 
 AS [profiles]
from [k_m_workflow_step] AS [ws1], [k_cultures] AS [c]