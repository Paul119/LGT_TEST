CREATE VIEW [dbo].[Kernel_View_Process_CreditingList]
AS
SELECT os.id,
	   os.idProcess,
	   os.startDate,
	   os.endDate,
	   os.formattedValue,
	   os.deleteBeforeStart,
	   os.idPop,
	   os.idPayee,
	   execution.executionStartDate as last_execution_start_date
	   ,CASE WHEN os.id_olap_scheduler_status = 1 /*Pending*/ AND (execution.last_execution_status IS NULL OR execution.last_execution_status_id IN (4,8,16))
			THEN moss.name
			ELSE execution.last_execution_status 
		END AS last_execution_olap_scheduler_status
  FROM k_m_olap_scheduler os
	LEFT OUTER JOIN k_m_olap_scheduler_status AS moss
		ON os.id_olap_scheduler_status = moss.id_olap_scheduler_status
	OUTER APPLY (
				SELECT TOP 1 oss.name as last_execution_status,oss.id_olap_scheduler_status as last_execution_status_id,ose.[start_date] AS executionStartDate
				  FROM k_m_olap_scheduler_execution ose
					LEFT OUTER JOIN k_m_olap_scheduler_status oss
						ON ose.id_olap_scheduler_status = oss.id_olap_scheduler_status
				 WHERE os.id = ose.id_olap_scheduler
				 ORDER BY ose.id_olap_scheduler_execution DESC
				) execution
 WHERE os.is_deleted = 0;