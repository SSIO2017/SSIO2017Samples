--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 12: IMPLEMENTING HIGH AVAILABILITY AND DISASTER RECOVERY
-- T-SQL SAMPLE 7
--

-- Monitor Availability Group Health
-- On a secondary replica, this query returns a row for every secondary database on the server instance. 
-- On the primary replica, this query returns a row for each primary database and an additional row for the corresponding secondary database. Recommended.

IF NOT EXISTS (
SELECT @@SERVERNAME
	FROM sys.dm_hadr_availability_replica_states
	WHERE is_local = 1
		AND role_desc = 'PRIMARY'
)
	SELECT 'Recommend: Run This Script on Primary Replica';

--Display current replicas
SELECT AG = ag.name
	, Instance = ar.replica_server_name + ' ' + CASE WHEN is_local = 1 THEN '(local)' ELSE '' END
	, DB = db_name(dm.database_id)
	, Replica_Role  = CASE WHEN last_received_time IS NULL THEN 'PRIMARY (Connections: '+ar.primary_role_allow_connections_desc+')' ELSE 'SECONDARY (Connections: '+ar.secondary_role_allow_connections_desc+')' END
	, dm.synchronization_state_desc 
	, dm.synchronization_health_desc
	, ar.availability_mode_desc
	, ar.failover_mode_desc
	, Suspended = CASE is_suspended WHEN 1 THEN suspend_reason_desc ELSE 'NO' END
	, last_received_time
	, last_commit_time
	, Redo_queue_size_MB = redo_queue_size / 1024.
	, dm.secondary_lag_seconds 
	, ar.backup_priority
	, ar.endpoint_url 
	, ar.read_only_routing_url
FROM sys.dm_hadr_database_replica_states dm
	INNER JOIN sys.availability_replicas ar on dm.replica_id = ar.replica_id and dm.group_id = ar.group_id
	INNER JOIN sys.availability_groups ag on ag.group_id = dm.group_id
ORDER BY AG, Instance, DB, Replica_Role;

GO
