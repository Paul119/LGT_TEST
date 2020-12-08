CREATE view [dbo].[Kernel_View_Comm_PayeeReports]  as
select distinct  R.*,VC.idColl
from pop_VersionContent VC
                join pop_VersionItems VI on VC.idPopVersion = VI.activeVersion
                join nc_Report R on VI.idItem = R.id
                left join k_users KU on VC.idColl = KU.id_external_user
                           left join k_users_parameters UP on KU.id_user_parameter = UP.id
where VI.itemType=4
AND UP.numberOfDaysBoxItems>= DATEDIFF(day,R.beginDate,getdate())
AND R.beginDate<getdate()
AND (R.endDate>getdate() OR R.endDate is NULL)