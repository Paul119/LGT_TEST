CREATE    PROCEDURE [dbo].[sp_load_process_data_to_tables]
(@id_plan INT = 6)
AS 

BEGIN 

BEGIN TRY
	BEGIN TRANSACTION trans_insert_values;

	-- variables
	DECLARE @current_year INT = (SELECT YEAR(FreezeDate) FROM _tb_ProcessDefinition WHERE id_plan = @id_plan)
	DECLARE @current_award_date DATE = CAST(@current_year AS NVARCHAR(4))+'-04-01'
	DECLARE @next_year INT = @current_year+1
	DECLARE @next_award_date DATE = CAST(@next_year AS NVARCHAR(4))+'-04-01'
	DECLARE @id_user INT = -2



	-- title table bkp
	DECLARE @sql NVARCHAR(MAX) = 'SELECT * INTO _tb_employee_Title'+'_'+convert(varchar, getdate(), 112)	 + replace(convert(varchar, getdate(),108),':','')+' FROM _tb_employee_Title'

	EXEC sys.sp_executesql @sql

	-- insert title
	
	
   INSERT INTO _tb_employee_Title (IdPayee, PersonnelNumber, EffectiveDate, EndDate, TitleCode, id_user, CreatedDate, ModificationDate, ParentId)
   SELECT  vcpt.IdPayee, vcpt.PersonnelNumber, @next_award_date, '2999-01-01' AS EndDate, kmv.input_value AS TitleCode, @id_user, GETDATE() AS CreatedDate, NULL AS ModificationDate, 1 AS ParentId
	  FROM _vw_CRP_Process_Template vcpt
	  JOIN k_m_plans_payees_steps kmpps ON vcpt.id_plan = kmpps.id_plan AND vcpt.idPayee = kmpps.id_payee
	  JOIN k_m_values kmv ON kmpps.id_step = kmv.id_step
	  JOIN k_m_fields kmf ON kmv.id_field = kmf.id_field
	  LEFT JOIN _tb_employee_Title t on T.EffectiveDate = @next_award_date AND t.IdPayee = vcpt.IdPayee
	  WHERE kmf.code_field IN (
	  'CRP-LGT-NewTitle'
		 )
   AND NULLIF(kmv.input_value,'') IS NOT NULL
   AND kmpps.id_plan = @id_plan
   AND t.employeeTitleId IS NULL
   --ORDER BY kmpps.id_step


   -- update title enddates
   	;WITH cte AS (
	SELECT PersonnelNumber, EffectiveDate, Lead(DATEADD("day",-1,EffectiveDate),1,'01-01-2999') over (PARTITION BY PersonnelNumber order by EffectiveDate) AS EndDate
	FROM _tb_employee_Title
	)


	UPDATE f
	SET f.EndDate = c.EndDate
	FROM _tb_employee_Title f
	JOIN  cte c ON f.PersonnelNumber = c.PersonnelNumber AND f.EffectiveDate = c.EffectiveDate



   -- backup compensation table
  SET @sql  = 'SELECT * INTO _tb_employee_compensation'+'_'+convert(varchar, getdate(), 112)	 + replace(convert(varchar, getdate(),108),':','')+' FROM _tb_employee_compensation'

  EXEC sys.sp_executesql @sql

	-- insert compensation paid



	;MERGE _tb_employee_compensation AS tgt USING(

	 SELECT  vcpt.IdPayee, vcpt.PersonnelNumber,				
			CASE kmf.code_field	WHEN 'CRP-LGT-BonusAdminStaff' THEN '0000000060'
					WHEN 'CRP-LGT-DiscrBonus' THEN '0000000020'
					WHEN 'CRP-LGT-HFP' THEN '000008'
					WHEN 'CRP-LGT-PEP' THEN '000009'
					WHEN 'CRP-LGT-SalesComm' THEN '0000000050'
					WHEN 'CRP-LGT-TBProfStaff' THEN '000006' END AS PayrollType
		, @current_award_date AS AwardDate
		, '2999-01-01' AS EndDate
		, @next_award_date AS PaidDate
		, CASE WHEN kmf.code_field in ('CRP-LGT-HFP', 'CRP-LGT-PEP') THEN kmv.input_value_numeric ELSE NULL end as TargetValue
		,CASE kmf.code_field WHEN  'CRP-LGT-HFP' THEN  ROUND((kmv.input_value_numeric*p.HFValue)/r.Rate,0)
							 WHEN  'CRP-LGT-PEP' THEN  ROUND((kmv.input_value_numeric*p.PEValue)/r.Rate,0)
							ELSE kmv.input_value_numeric end as PaidValue
		,vcpt.Target_Bonus_Currency
		, @id_user AS id_user
		, GETDATE() AS CreatedDate
		, NULL AS ModificationDate
		, 1 AS ParentId
		  FROM _vw_CRP_Process_Template vcpt
		  JOIN k_m_plans_payees_steps kmpps ON vcpt.id_plan = kmpps.id_plan AND vcpt.idPayee = kmpps.id_payee
		  JOIN k_m_values kmv ON kmpps.id_step = kmv.id_step
		  JOIN k_m_fields kmf ON kmv.id_field = kmf.id_field
		  LEFT JOIN _tb_Point_Values p on @current_year = p.year and kmf.code_field IN ('CRP-LGT-HFP', 'CRP-LGT-PEP')
		  LEFT JOIN _tb_fx_rates_to_chf r on @current_year = r.year and r.CurrencyCode = vcpt.Target_Bonus_Currency
		  WHERE kmf.code_field IN (
	  				 'CRP-LGT-BonusAdminStaff',
					 'CRP-LGT-DiscrBonus',
					 'CRP-LGT-HFP',
					 'CRP-LGT-PEP',
					 'CRP-LGT-SalesComm',
					 'CRP-LGT-TBProfStaff'
	   )
	   AND kmv.input_value_numeric IS NOT NULL
	   AND kmpps.id_plan = @id_plan
	   --AND vcpt.IdPayee = 476
	  -- ORDER BY kmpps.id_step
	) AS src
	ON (src.IdPayee = tgt.IdPayee AND src.PayrollType = tgt.PayrollType AND src.AwardDate = tgt.AwardDate)
	WHEN MATCHED 
	THEN
		UPDATE 
		SET  tgt.TargetValue = ISNULL(tgt.TargetValue,src.TargetValue), tgt.PaidDate = ISNULL(tgt.PaidDate,src.PaidDate), tgt.PaidValue = ISNULL(tgt.PaidValue,src.PaidValue), tgt.id_user = src.id_user, ModificationDate = getdate()
	WHEN NOT MATCHED
	THEN 
		INSERT	(idPayee, PersonnelNumber, PayrollType, AwardDate, EndDate, TargetValueMin, TargetValueMax, TargetValue, PaidDate, PaidValue, Currency, id_user, CreatedDate, ModificationDate, ParentId)
		VALUES(src.idPayee, src.PersonnelNumber, src.PayrollType, src.AwardDate, src.EndDate,NULL, NULL, src.TargetValue, src.PaidDate, src.PaidValue, src.Target_Bonus_Currency, src.id_user, GETDATE(), NULL, 1);



	-- insert new compensation
	INSERT INTO _tb_employee_compensation (idPayee, PersonnelNumber, PayrollType, AwardDate, EndDate, TargetValueMin, TargetValueMax, TargetValue, PaidDate, PaidValue, Currency, id_user, CreatedDate, ModificationDate, ParentId)
	SELECT  vcpt.IdPayee, vcpt.PersonnelNumber,				
			CASE kmf.code_field	WHEN 'CRP-LGT-LTISY+1' THEN '000010'
					WHEN 'CRP-LGT-Base_JLY+1' THEN '000001' --000002
					WHEN 'CRP-LGT-Target_BonusAdminStaff' THEN '0000000060'
					WHEN 'CRP-LGT-Target_DiscrBonus' THEN '0000000020'
					WHEN 'CRP-LGT-Target_TBProfStaff' THEN '000006' END AS PayrollType
		, @next_award_date AS AwardDate
		, '2999-01-01' AS EndDate
		,NULL as TargetValueMin
		, NULL as TargetValueMax
		,CASE WHEN kmf.code_field in ('CRP-LGT-Target_BonusAdminStaff', 'CRP-LGT-Target_DiscrBonus','CRP-LGT-Target_TBProfStaff') THEN kmv.input_value_numeric ELSE NULL end as TargetValue
		, NULL AS PaidDate
		, CASE WHEN kmf.code_field in ('CRP-LGT-LTISY+1', 'CRP-LGT-Base_JLY+1') THEN kmv.input_value_numeric ELSE NULL END as PaidValue 
		,vcpt.Target_Bonus_Currency
		, @id_user AS id_user
		, GETDATE() AS CreatedDate
		, NULL AS ModificationDate
		, 1 AS ParentId
		  FROM _vw_CRP_Process_Template vcpt
		  JOIN k_m_plans_payees_steps kmpps ON vcpt.id_plan = kmpps.id_plan AND vcpt.idPayee = kmpps.id_payee
		  JOIN k_m_values kmv ON kmpps.id_step = kmv.id_step
		  JOIN k_m_fields kmf ON kmv.id_field = kmf.id_field
		  LEFT JOIN _tb_employee_compensation t on t.IdPayee= vcpt.idPayee and CASE kmf.code_field	WHEN 'CRP-LGT-LTISY+1' THEN '000010'
					WHEN 'CRP-LGT-Base_JLY+1' THEN '000001' --000002
					WHEN 'CRP-LGT-Target_BonusAdminStaff' THEN '0000000060'
					WHEN 'CRP-LGT-Target_DiscrBonus' THEN '0000000020'
					WHEN 'CRP-LGT-Target_TBProfStaff' THEN '000006' END = t.PayrollType and @next_award_date = t.AwardDate
		  --JOIN k_m_fields_values kmfv ON kmf.id_field = kmfv.id_field AND kmfv.id_payee = vcpt.idPayee
		  WHERE kmf.code_field IN (
	  				'CRP-LGT-LTISY+1',
					'CRP-LGT-Base_JLY+1',
					'CRP-LGT-Target_BonusAdminStaff',
					'CRP-LGT-Target_DiscrBonus',
					'CRP-LGT-Target_TBProfStaff'
	   )
	   AND kmv.input_value_numeric IS NOT NULL
	   AND kmpps.id_plan = @id_plan
	   and t.employeecompensationId IS NULL
	   --AND vcpt.IdPayee = 476
	  -- ORDER BY kmpps.id_step


   
	-- insert hf/pe min/max
	INSERT INTO _tb_employee_compensation (idPayee, PersonnelNumber, PayrollType, AwardDate, EndDate, TargetValueMin, TargetValueMax, TargetValue, PaidDate, PaidValue, Currency, id_user, CreatedDate, ModificationDate, ParentId)
	SELECT  vcpt.IdPayee, vcpt.PersonnelNumber,				
			pt.PayrollTypeCode AS PayrollType
		, @next_award_date AS AwardDate
		, '2999-01-01' AS EndDate
		,CASE pt.PayrollTypeCode WHEN '000008' THEN p.TargetHFmin
								 WHEN '000009' THEN p.TargetPEmin
		 END as TargetValueMin
		,CASE pt.PayrollTypeCode WHEN '000008' THEN p.TargetHFmax
								 WHEN '000009' THEN p.TargetPEmax
		 END as TargetValuemax
		,NULL as TargetValue
		, NULL AS PaidDate
		,NULL as PaidValue 
		,vcpt.Target_Bonus_Currency
		, @id_user AS id_user
		, GETDATE() AS CreatedDate
		, NULL AS ModificationDate
		, 1 AS ParentId
		  FROM _vw_CRP_Process_Template vcpt
		  JOIN k_m_plans_payees_steps kmpps ON vcpt.id_plan = kmpps.id_plan AND vcpt.idPayee = kmpps.id_payee
		  JOIN _vw_CRP_Process_Pivot p on kmpps.id_step = p.id_step
		  CROSS JOIN _ref_PayrollType pt 
		  LEFT JOIN _tb_employee_compensation t on t.IdPayee= vcpt.idPayee and pt.PayrollTypeCode = t.PayrollType and @next_award_date = t.AwardDate
		  WHERE (p.TargetHFmin IS NOT NULL OR p.TargetHFmax IS NOT NULL or p.TargetPEmin IS NOT NULL or p.TargetPEmax IS NOT NULL)
		   AND (pt.PayrollTypeCode in ( '000008','000009'))
		   AND kmpps.id_plan = @id_plan
		   and t.employeecompensationId IS NULL
		--AND vcpt.IdPayee = 476
		--ORDER BY kmpps.id_step

	-- update compensation dates
	;WITH cte AS (
	SELECT PersonnelNumber, PayrollType, AwardDate, Lead(DATEADD("day",-1,AwardDate),1,'01-01-2999') over (PARTITION BY PersonnelNumber, PayrollType order by AwardDate) AS EndDate
	FROM _tb_employee_compensation
	)

	UPDATE f
	SET f.EndDate = c.EndDate
	FROM _tb_employee_compensation f
	JOIN  cte c ON f.PersonnelNumber = c.PersonnelNumber AND f.PayrollType = c.PayrollType AND f.AwardDate = c.AwardDate




COMMIT TRANSACTION trans_insert_values;
	END TRY

	BEGIN CATCH
		DECLARE @ErrorFlag BIT = 1;
		DECLARE @EventText NVARCHAR(MAX) = 'End';
		DECLARE @ErrorText NVARCHAR(MAX) = ERROR_MESSAGE();
		DECLARE @ErrorLine INT = ERROR_LINE();
		DECLARE @xstate INT = XACT_STATE()

		SELECT @ErrorText

		IF @xstate != 0
			ROLLBACK TRANSACTION trans_insert_values;

		
	END CATCH
END