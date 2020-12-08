Create VIEW [dbo].[Kernel_View_Payee_Ext]  
		AS  
		SELECT     
			h.id_histo, 
			h.start_date_histo, 
			h.end_date_histo, 
			h.idPayee, 
			h.codePayee, 
			h.firstname, 
			h.lastname, 
			h.email, 
			h.birth_date, 
			h.age, 
			h.start_date_company, 
			h.end_date_company, 
			h.start_date_group, 
			h.end_date_group, 
			h.start_date_job, 
			h.end_date_job, 
			h.base_salary, 
			h.base_salary_period, 
			h.variable_period, 
			h.nb_year_experience, 
			h.months_per_year, 
			h.hours_per_month, 
			h.weight_structure_1, 
			h.variable, 
			h.company_car, 
			h.id_category, 
			h.id_grade, 
			h.id_contract, 
			h.id_agreement, 
			h.id_cost_center, 
			h.id_gender, 
			h.id_activity_status, 
			h.id_job, 
			h.id_department, 
			h.id_organization, 
			h.id_structure_1, 
			h.id_structure_2, 
			h.id_nationality, 
			h.id_pool, 
			h.id_job_country, 
			h.id_benefit, 
			h.id_salary_currency,
			h.id_performance_rating,
			j.short_name_job, 
			s.short_name_structure, 
			h.id_title,
			h.id_payment_currency ,
			b.code_band, 
			b.short_name_band
		,d.code_division, 
		d.short_name_division
		,bu.code_BusinessUnit
		,bu.short_name_BusinessUnit 
		,e.code_host_country
		,e.code_home_country
		,e.code_Jobfamily
		,jf.short_name_Jobfamily
		,dc.code_contract
		,dc.short_name_contract
		,dg.code_gender
		,dg.short_name_gender
		,g.code_grade
		,g.short_name_grade
		,j.risk_profile

		FROM  py_PayeeHisto h
		LEFT JOIN Dim_Job j ON h.id_job = j.id_job
		LEFT JOIN Dim_Structure s ON h.id_structure_1 = s.id_structure
		LEFT JOIN Dim_Grade g on g.id_grade=h.id_grade
		LEFT JOIN Dim_Gender ge on ge.id_gender= h.id_gender
		LEFT JOIN Dim_Contract co on co.id_contract= h.id_contract
		LEFT OUTER JOIN  py_PayeeExt e ON h.id_histo = e.id_histo
		LEFT JOIN Dim_Band as b on b.code_band = e.code_band
		LEFT JOIN Dim_division as d on d.code_division = e.code_division
		LEFT JOIN Dim_BusinessUnit as bu on bu.code_BusinessUnit = e.code_businessunit	
		LEFT JOIN Dim_Jobfamily as jf on jf.code_Jobfamily = e.code_jobfamily	
		LEFT join Dim_Contract as dc ON dc.id_contract = h.id_contract
		LEFT join Dim_Gender as dg ON dg.id_gender = h.id_gender
		LEFT JOIN dbo.Dim_Performance_Rating ON dbo.Dim_Performance_Rating.id_perf_rating = h.id_performance_rating