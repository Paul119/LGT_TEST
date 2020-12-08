CREATE VIEW [dbo].[Kernel_View_Process_Field_Validations]
AS
	select
		fieldsUnion.id_plan,
		fieldsUnion.id_column,
		fieldsUnion.name_column,
		fieldsUnion.indicator_field,
		fieldsUnion.type_column,
		fieldsUnion.id_ind,
		fieldsUnion.id_item,
		CASE WHEN EXISTS( 
						  select * from k_m_plans_field_validation 
						  where k_m_plans_field_validation.id_plan = fieldsUnion.id_plan
								and 
								(
									(k_m_plans_field_validation.id_planInfo = fieldsUnion.id_item and fieldsUnion.id_ind = 0) 
									OR 
									(k_m_plans_field_validation.id_indicator_field = fieldsUnion.id_item and fieldsUnion.id_ind <> 0)
								)
						) THEN 'GV_Validation' 
				ELSE '' 
		END as validation_enabled,
		isnull(
				(
					select id_plans_field_validation from k_m_plans_field_validation 
					where k_m_plans_field_validation.id_plan = fieldsUnion.id_plan
		 			and 
		 			(
		 				(k_m_plans_field_validation.id_planInfo = fieldsUnion.id_item and fieldsUnion.id_ind = 0) 
		 				OR 
		 				(k_m_plans_field_validation.id_indicator_field = fieldsUnion.id_item and fieldsUnion.id_ind <> 0)
					)
				),0
			) as id_plans_field_validation,
			fieldsUnion.culture,
			formContent.form_content_exists
	from (
		select
			k_m_plans_informations.id_plan,
			'ic_' +CAST(k_referential_grids_fields.id_column as nvarchar(50)) as id_column,
			k_referential_grids_fields.name_column as name_column,
			'' as indicator_field,
			'GV_Column_Type_Information' as type_column,
			0 as id_ind,
			k_m_plans_informations.id_planInfo as id_item,
			c.culture culture
		from 
		k_cultures c cross join
		k_m_plans_informations
		inner join k_referential_grids_fields on k_referential_grids_fields.id_column = k_m_plans_informations.id_field_grid

		union

		select
			 k_m_plans_indicators.id_plan,
			/*CAST(k_m_plans_indicators.id_plan as nvarchar(50)) + '_' +*/ CAST(k_m_indicators.id_ind as nvarchar(50))+ '_' + CAST(k_m_fields.id_field as nvarchar(50)) as id_column,
		    coalesce(loc.value,k_m_indicators.name_ind) as name_column,
			coalesce(rps_loc.value,k_m_fields.label_field) as name_column,	
			'GV_Column_Type_Indicator' as type_column,
			k_m_indicators.id_ind,
			k_m_indicators_fields.id_indicator_field as id_item,
			c.culture culture
		from 
		k_cultures c cross join
		k_m_plans_indicators k_m_plans_indicators
		inner join k_m_indicators on k_m_indicators.id_ind = k_m_plans_indicators.id_ind
		inner join k_m_indicators_fields on k_m_indicators_fields.id_ind = k_m_plans_indicators.id_ind
		inner join k_m_fields on k_m_fields.id_field = k_m_indicators_fields.id_field
		left join rps_Localization loc on loc.name = k_m_indicators.name_ind and c.culture = loc.culture
		left join rps_Localization rps_loc on rps_loc.name = k_m_fields.label_field and c.culture = rps_loc.culture
	) as fieldsUnion
	outer apply 
	( 
		select 1 as form_content_exists from  k_m_plan_form_content fc
		left join k_m_indicators_fields inf on inf.id_ind = fc.indicator_id and inf.id_field = fc.field_id
		left join k_m_plans_informations pinf on fc.planInfo_id = pinf.id_planInfo
		where fieldsUnion.id_plan = fc.plan_id and
		( fieldsUnion.id_item = inf.id_indicator_field or fieldsUnion.id_item = pinf.id_planInfo)
	) formContent