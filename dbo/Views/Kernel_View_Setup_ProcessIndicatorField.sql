 CREATE VIEW [dbo].[Kernel_View_Setup_ProcessIndicatorField]
  AS
  SELECT processIndicators.id_plan,(CASE WHEN kmpi.id_plan is NULL THEN 0 ELSE 1 END ) as is_selected, processIndicators.id_ind,
  kmi.name_ind AS nameIndicators,kc1.name_category AS category1 ,kc2.name_category AS category2
  FROM
  (SELECT id_plan,id_ind FROM k_m_plans kmp, k_m_indicators kmi) processIndicators
  INNER JOIN k_m_indicators kmi ON kmi.id_ind = processIndicators.id_ind
  LEFT JOIN k_m_category kc1 ON kc1.id_category= kmi.categorie1_ind
  LEFT JOIN k_m_category kc2 ON kc2.id_category= kmi.categorie2_ind
  LEFT OUTER JOIN k_m_plans_indicators kmpi ON processIndicators.id_ind= kmpi.id_ind AND processIndicators.id_plan= kmpi.id_plan