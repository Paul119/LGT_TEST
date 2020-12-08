CREATE view [dbo].[Kernel_View_Process_PayeeHistory]
as
select 
             kmi.name_ind,
             kmf.name_field,
             kvh.input_value,
             kvh.comment_value,
             kvh.date_histo,
             ku.lastname_user +' ' + ku.firstname_user as firstname,
             kmps.id_plan,
             kmps.id_payee AS idPayee,
             kmps.id_step             
  from k_m_values_histo kvh
  left join k_m_indicators kmi on kmi.id_ind=kvh.id_ind
  left join k_m_fields kmf on kmf.id_field=kvh.id_field
  left join k_users ku on  kvh.id_user=ku.id_user
  left join k_m_plans_payees_steps kmps on kvh.id_step=kmps.id_step