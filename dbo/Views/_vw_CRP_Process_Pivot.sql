
CREATE   VIEW [dbo].[_vw_CRP_Process_Pivot]   
AS   
      
    SELECT 
	p.id_step,
	p.id_payee,
	p.id_plan,
	rjt.JobTitleDescription /*p.[CRP-LGT-NewTitle]*/ AS NewTitle,
	CAST(p.[CRP-LGT-Base_JLY+1]AS DECIMAL(32,2)) AS NewBaseSalary,
	CAST(p.[CRP-LGT-TBProfStaff]AS DECIMAL(32,2)) AS TBProfStaff,
	CAST(p.[CRP-LGT-BonusAdminStaff]AS DECIMAL(32,2)) AS BonusAdminStaff,
	CAST(p.[CRP-LGT-SalesComm]AS DECIMAL(32,2)) AS SalesComm,
	CAST(p.[CRP-LGT-DiscrBonus]AS DECIMAL(32,2)) AS DiscrBonus,
	CAST(p.[CRP-LGT-HFP]AS DECIMAL(32,2)) AS HFP,
	CAST(p.[CRP-LGT-PEP]AS DECIMAL(32,2)) AS PEP,
	CAST(p.[CRP-LGT-Target_TBProfStaff]AS DECIMAL(32,2)) AS TargetTBProfStaff,
	CAST(p.[CRP-LGT-Target_BonusAdminStaff]AS DECIMAL(32,2)) AS TargetBonusAdminStaff,
	CAST(p.[CRP-LGT-Target_Sign-onBonus]AS DECIMAL(32,2)) AS TargetSignOnBonus,
	CAST(p.[CRP-LGT-Target_ExitBonus]AS DECIMAL(32,2)) AS TargetExiBonus,
	CAST(p.[CRP-LGT-Target_HFmin]AS DECIMAL(32,1)) AS TargetHFmin,
	CAST(p.[CRP-LGT-Target_HFmax]AS DECIMAL(32,1)) AS TargetHFmax,
	CAST(p.[CRP-LGT-Target_PEmin]AS DECIMAL(32,0)) AS TargetPEmin,
	CAST(p.[CRP-LGT-Target_PEmax]AS DECIMAL(32,0)) AS TargetPEmax,
	CAST(p.[CRP-LGT-LTISY+1]AS DECIMAL(32,0)) AS LTISY1,
	p.[CRP-LGT-Bemerkungen] AS Bemerkungen,
	ra.Academy_Name /*P.[CRP-LGT-Academy]*/ AS Academy
    FROM (  
    SELECT kmv.input_value  AS input_value
     ,kmpps.id_payee  
     ,kmf.code_field
	 ,kmpps.id_plan 
	 ,kmpps.id_step
    FROM k_m_values kmv  
    INNER JOIN k_m_plans_payees_steps kmpps  
     ON kmv.id_step = kmpps.id_step  
    INNER JOIN k_m_fields kmf  
     ON kmv.id_field = kmf.id_field
	 ) st  
    PIVOT (  
     MAX(st.input_value)  
    FOR st.code_field   
     IN ([CRP-LGT-NewTitle],[CRP-LGT-Base_JLY+1],[CRP-LGT-TBProfStaff],[CRP-LGT-BonusAdminStaff],[CRP-LGT-DiscrBonus],[CRP-LGT-SalesComm],[CRP-LGT-HFP],[CRP-LGT-PEP],[CRP-LGT-Target_TBProfStaff],
   [CRP-LGT-Target_BonusAdminStaff],[CRP-LGT-Target_Sign-onBonus],[CRP-LGT-Target_ExitBonus],[CRP-LGT-Target_HFmin],[CRP-LGT-Target_HFmax],
   [CRP-LGT-Target_PEmin],[CRP-LGT-Target_PEmax],[CRP-LGT-LTISY+1],[CRP-LGT-Bemerkungen],[CRP-LGT-Academy]
     )  
    ) AS p  
	LEFT JOIN _ref_JobTitle rjt ON p.[CRP-LGT-NewTitle] = rjt.JobTitleCode
	LEFT JOIN _ref_Academy ra ON p.[CRP-LGT-Academy] = ra.AcademyId