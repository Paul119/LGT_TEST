CREATE view [dbo].[Kernel_View_Comm_PayeeDocuments] as
select distinct  D.*,VC.idColl
from pop_VersionContent VC
       join pop_VersionItems VI on VC.idPopVersion = VI.activeVersion
       join nc_Document D on VI.idItem = D.id
          left join k_users KU on VC.idColl = KU.id_external_user
       left join k_users_parameters UP on KU.id_user_parameter = UP.id
where VI.itemType=1 
AND
VC.idColl =1
AND
(
D.isFavorite = 1 
OR
       (
             ISNULL(UP.numberOfDaysBoxItems,30)> DATEDIFF(day,D.beginDate,getdate())
             AND (D.endDate>getdate() OR D.endDate is NULL)
       )
)
AND
D.id in
(
       select distinct id_document from rps_file
)