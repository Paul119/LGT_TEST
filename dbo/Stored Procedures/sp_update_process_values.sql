CREATE PROCEDURE [dbo].[sp_update_process_values]
@field_values
[dbo].[Kernel_Type_Update_Values]  readonly,
@IsSimulated bit,
@IdUser int
as
create table #Temp
(
    id int identity(1,1),
    step_id int not null,
    process_id int not null,
    indicator_id int not null,
    field_id int not null,
	field_format_type int not null,
    value nvarchar(max) null,
	input_date datetime not null,
	id_user int not null,
	idSim int null
)

insert into #Temp (step_id,process_id,indicator_id,field_id,field_format_type,value,input_date,id_user,idSim)
select
    step_id,
    SUBSTRING(pif,0,Charindex('_',pif)) as process_id,
    Reverse(SUBSTRING(SUBSTRING(Reverse(pif),Charindex('_',Reverse(pif))+1,len(pif)),0,Charindex('_',SUBSTRING(Reverse(pif),Charindex('_',Reverse(pif))+1,len(pif))))) as indicator_id,
    RIGHT(pif, CHARINDEX('_', REVERSE('_' + pif)) - 1) AS field_id,
	type_value,
    value as value,
	GETUTCDATE(),
	@IdUser,
	idSim
from @field_values fv
inner join k_m_fields field  
	on field.id_field = RIGHT(pif, CHARINDEX('_', REVERSE('_' + pif)) - 1)


update vali 
	set vali.input_value=t.value,
	vali.input_value_numeric =
								(
									cast((
									case
										when field_format_type=2 or field_format_type=4 
										then t.value
										else null        
									end
									) as decimal(18,4))
								),
	vali.input_value_int =
								(
									cast((
									case
										when field_format_type=4 
										then t.value
										else null        
									end
									) as int)
								),
	vali.input_value_date=(
				case
					when field_format_type=3
					then CONVERT(datetime, value, 120)
					else null        
				end
				  ) ,
   vali.input_date= t.input_date,
   vali.id_user= t.id_user
   output inserted.id_value,
	   inserted.id_ind,
	   inserted.id_field,
	   inserted.id_step,
	   inserted.input_value,
	   inserted.input_value_int,
	   inserted.input_value_numeric,
	   inserted.input_value_date,
	   inserted.input_date,
	   inserted.id_user,
	   inserted.comment_value,
	   inserted.source_value,
	   inserted.input_date,
	   inserted.id_user 
into k_m_values_histo(
					  id_value,
					  id_ind,
					  id_field,
					  id_step,
					  input_value,
					  input_value_int,
					  input_value_numeric,
					  input_value_date,
					  input_date,id_user,
					  comment_value,
					  source_value,
					  date_histo,user_histo
					 )
from k_m_values vali 
	inner join #Temp t 
		on vali.id_ind=t.indicator_id 
		and vali.id_field=t.field_id 
		and vali.id_step=t.step_id
		and vali.idSim=t.idSim

insert into k_m_values (
						 id_ind,
						 id_field,
						 id_step,
						 input_value,
						 input_value_numeric,
						 input_value_int,
						 input_value_date,
						 input_date,
						 id_user,
						 idSim
					   )
output inserted.id_value,
	   inserted.id_ind,
	   inserted.id_field,
	   inserted.id_step,
	   inserted.input_value,
	   inserted.input_value_int,
	   inserted.input_value_numeric,
	   inserted.input_value_date,
	   inserted.input_date,
	   inserted.id_user,
	   inserted.comment_value,
	   inserted.source_value,
	   inserted.input_date,
	   inserted.id_user 
into k_m_values_histo(
					  id_value,
					  id_ind,
					  id_field,
					  id_step,
					  input_value,
					  input_value_int,
					  input_value_numeric,
					  input_value_date,
					  input_date,
					  id_user,
					  comment_value,
					  source_value,
					  date_histo,
					  user_histo
					 )
select indicator_id,
	   field_id,
	   step_id,value,
	   (
			cast((
					case
						when field_format_type=2 or field_format_type=4 
						then value
						else null        
					end
				  ) as decimal(18,4))      
	   ) as input_value_numeric,
	   (
			cast((
					case
						when field_format_type=4
						then value
						else null        
					end
				  ) as int)      
	   ) as input_value_int,
	   (
		case
			when field_format_type=3
			then CONVERT(datetime, value, 120)
			else null        
		end
			)  as input_value_date,
	   input_date,
	   id_user,
	   idSim 
from #Temp 
where id not in
				(
						select t.id 
						  from #Temp t 
							inner join k_m_values val 
								on t.step_id=val.id_step 
								and t.indicator_id=val.id_ind 
								and t.field_id=val.id_field 
								and val.idSim=t.idSim
				)