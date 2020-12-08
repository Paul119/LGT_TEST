CREATE VIEW Kernel_View_Alert_EventsLog
AS
SELECT top 100
	KML.id,
	KMET.name_monitor_event_type,
	KML.start_date,
	KML.end_date,
	CASE WHEN (KME.id_monitor_event_type = -1) THEN KPC.name_cond
		 WHEN (KME.id_monitor_event_type = -2) THEN KP.name_prog
		 WHEN (KME.id_monitor_event_type = -3) THEN KPEP.name_schedule 
		 END AS name_event,
	KU.firstname_user + '' + KU.lastname_user AS executed_user_name,
	DATEDIFF(s,KML.start_date,KML.end_date) AS execution_time,
	KMEA.is_active AS is_alert_sent
FROM k_monitor_log KML
LEFT JOIN k_monitor_event KME ON KME.id_monitor_event = kml.id_monitor_event
LEFT JOIN k_monitor_event_type KMET ON KMET.id_monitor_event_type = KME.id_monitor_event_type
LEFT JOIN k_program KP ON kp.id_prog = KME.id_rule
LEFT JOIN k_program_cond KPC ON KPC.id_cond = KME.id_cond
LEFT JOIN k_program_execution_plan KPEP ON KPEP.id_schedule = KME.id_execution_plan
LEFT JOIN k_users KU ON KU.id_user = kml.id_user
LEFT JOIN k_monitor_event_alert KMEA ON KMEA.id_monitor_event = KMl.id_monitor_event
ORDER BY KML.start_date DESC