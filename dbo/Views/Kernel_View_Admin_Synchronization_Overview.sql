CREATE VIEW [dbo].[Kernel_View_Admin_Synchronization_Overview] AS
SELECT 
id_table_view AS id_table_view ,
name_table_view AS name_table_view,
type_table_view AS type_table_view,
CASE WHEN id_object_security_table_view <>'' AND id_object_security_table_view IS NOT NULL  THEN 1 ELSE 0 END AS has_security ,
type_data AS type_data,
id_object_security_table_view AS id_object_security_table_view
from k_referential_tables_views