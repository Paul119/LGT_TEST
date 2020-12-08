--ALTER KERNEL VIEW AND SPS RELATED WITH MOBILITY
CREATE view [dbo].[Kernel_View_Setup_FieldDefaultValue]
AS
SELECT TOP 100 PERCENT pl.id_plan,
	   ind.name_ind,
	   field.name_field,
	   field.default_type,
	   field.default_value,
	   ind.id_ind,
	   field.id_field

FROM k_m_plans pl
JOIN dbo.k_m_plans_indicators plInd ON plInd.id_plan= pl.id_plan
JOIN dbo.k_m_indicators ind ON ind.id_ind= plInd.id_ind 
JOIN dbo.k_m_indicators_fields IndFi ON IndFi.id_ind= plInd.id_ind
JOIN dbo.k_m_fields field ON field.id_field= IndFi.id_field
WHERE (field.default_type='static' OR field.default_type='prog' OR field.default_type='sql')
AND field.default_value IS NOT NULL
ORDER BY pl.id_plan,ind.name_ind,field.name_field,field.default_type,field.default_value