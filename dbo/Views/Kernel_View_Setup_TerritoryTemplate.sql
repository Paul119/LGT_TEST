CREATE View [dbo].[Kernel_View_Setup_TerritoryTemplate]
AS
select t.id_template, t.name_template
    ,(select count(*) from k_tqm_template_step ts where t.id_template = ts.id_template)  as number_of_steps 
from k_tqm_template t