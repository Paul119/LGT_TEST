CREATE VIEW Kernel_View_Alert_Events
AS
SELECT 
	KME.id_monitor_event,
	KMET.name_monitor_event_type,	
	CASE WHEN (KME.id_monitor_event_type = -1) THEN KPC.name_cond
		 WHEN (KME.id_monitor_event_type = -2) THEN KP.name_prog
		 WHEN (KME.id_monitor_event_type = -3) THEN KPEP.name_schedule 
		 END AS name_event,
    KME.is_active,
	KMEA.is_active as is_enabled
FROM  k_monitor_event KME
LEFT JOIN k_monitor_event_type KMET ON KME.id_monitor_event_type = KMET.id_monitor_event_type
LEFT JOIN k_monitor_event_alert KMEA ON KMEA.id_monitor_event = KME.id_monitor_event
LEFT JOIN k_program KP ON KP.id_prog = KME.id_rule
LEFT JOIN k_program_cond KPC ON KPC.id_cond = KME.id_cond
LEFT JOIN k_program_execution_plan KPEP ON KPEP.id_schedule = KME.id_execution_plan