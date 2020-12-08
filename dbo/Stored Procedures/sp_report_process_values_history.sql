
CREATE PROCEDURE [dbo].[sp_report_process_values_history]
@idStep INT, @idUser INT, @idProfile INT
AS
SET NOCOUNT ON;

DECLARE @default_cult NVARCHAR(5) = (SELECT value_parameter FROM k_parameters WHERE key_parameter = 'PRM_GlobalCulture')
DECLARE @user_cult NVARCHAR(5) = (SELECT culture_user FROM k_users WHERE id_user = @idUser)

select v.input_value,v.input_value_int,v.input_value_numeric,v.input_value_date, v.comment_value, v.input_date, v.date_histo, i.id_ind, ISNULL(rl_ind.value,i.name_ind) AS name_ind, f.id_field, ISNULL(rl_field.value, f.label_field) AS label_field, f.type_value, ISNULL(lastname_user,'') + ' ' + ISNULL(firstname_user,'') as fullname, sort_plan_ind AS ind_sort,mif.sort AS field_sort
--from
--(
--select v.input_value,v.input_value_int,v.input_value_numeric,v.input_value_date, v.comment_value, v.input_date, GetDate() as date_histo, v.id_step, v.id_ind, v.id_field, v.id_user
--from k_m_values v

--union all
---- histo values
--select v.input_value,v.input_value_int,v.input_value_numeric,v.input_value_date, v.comment_value, v.input_date, v.date_histo, v.id_step, v.id_ind, v.id_field, v.id_user
--from k_m_values_histo v
--) v
from k_m_values_histo v
inner join k_m_plans_payees_steps ps on ps.id_step = v.id_step
inner join k_m_plans_indicators mpi on mpi.id_plan  = ps.id_plan and mpi.id_ind = v.id_ind
inner join k_m_indicators i on i.id_ind = mpi.id_ind
inner join k_m_indicators_fields mif on i.id_ind = mif.id_ind and v.id_field = mif.id_field
inner join k_m_fields f on f.id_field = v.id_field
inner join k_users u on u.id_user = v.id_user
INNER JOIN k_m_plan_display kmpd ON ps.id_plan = kmpd.id_plan AND kmpd.id_profile = @idProfile
INNER JOIN k_m_plan_display_field kmpdf ON kmpd.id_plan_display = kmpdf.id_plan_display AND mif.id_indicator_field = kmpdf.id_indicator_field AND kmpdf.available_plan_display_field = 1
LEFT JOIN rps_Localization rl_ind ON i.name_ind = rl_ind.name AND rl_ind.culture = ISNULL(@user_cult, @default_cult)
LEFT JOIN rps_Localization rl_field ON f.label_field = rl_field.name AND rl_field.culture = ISNULL(@user_cult, @default_cult)
where v.id_step = @idStep
AND u.isadmin_user <> 1 AND u.id_user > 0
AND v.input_value IS NOT NULL
order by
sort_plan_ind,
mif.sort ASC,
date_histo DESC