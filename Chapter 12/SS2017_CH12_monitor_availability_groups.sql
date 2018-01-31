--Monitor Availability Group Health
--On a secondary replica, this query returns a row for every secondary database on the server instance. 
--On the primary replica, this query returns a row for each primary database and an additional row for the corresponding secondary database. Recommended.

IF NOT EXISTS (
SELECT @@SERVERNAME
   FROM sys.dm_hadr_availability_replica_states
   WHERE is_local = 1
   and role_desc = 'PRIMARY'
)
  SELECT 'Recommend: Run This Script on Primary Replica';

--Display current replicas
SELECT 
  AG = ag.name
, Instance = ar.replica_server_name + ' ' + case when is_local = 1 then '(local)' else '' end
, DB = db_name(dm.database_id)
, Replica_Role  = CASE WHEN last_received_time IS NULL THEN 'PRIMARY (Connections: '+ar.primary_role_allow_connections_desc+')' ELSE 'SECONDARY (Connections: '+ar.secondary_role_allow_connections_desc+')' END
, dm.synchronization_state_desc 
, dm.synchronization_health_desc
, ar.availability_mode_desc
, ar.failover_mode_desc
, Suspended = CASE is_suspended WHEN 1 THEN suspend_reason_desc ELSE 'NO' END
, last_received_time
, last_commit_time
, Redo_queue_size_MB = redo_queue_size/1024.
, dm.secondary_lag_seconds 
, ar.backup_priority
, ar.endpoint_url 
, ar.read_only_routing_url
FROM sys.dm_hadr_database_replica_states dm
INNER JOIN sys.availability_replicas ar on dm.replica_id = ar.replica_id and dm.group_id = ar.group_id
INNER JOIN sys.availability_groups ag on ag.group_id = dm.group_id
ORDER BY AG, Instance, DB, Replica_Role;

GO
--Monitor Availability Group performance
--On a secondary replica, this view returns a row for every secondary database on the server instance. 
--On the primary replica, this view returns a row for each primary database and an additional row for the corresponding secondary database. Recommended.

IF NOT EXISTS (
SELECT @@SERVERNAME
   FROM sys.dm_hadr_availability_replica_states
   WHERE is_local = 1
   and role_desc = 'PRIMARY'
)
  SELECT 'Recommend: Run This Script on Primary Replica';

DECLARE @BytesFlushed_Start_ms bigint, @BytesFlushed_Start bigint, @BytesFlushed_End_ms bigint, @BytesFlushed_End bigint;

--Compare counter samples
DECLARE @TransactionDelay TABLE
(	DB sysname not null
,	TransactionDelay_Start_ms decimal(19,2) null
,	TransactionDelay_end_ms decimal(19,2) null
,	TransactionDelay_Start decimal(19,2) null
,	TransactionDelay_end decimal(19,2) null
,	MirroredWriteTranspersec_Start_ms decimal(19,2) null
,	MirroredWriteTranspersec_end_ms decimal(19,2) null
,	MirroredWriteTranspersec_Start decimal(19,2) null
,	MirroredWriteTranspersec_end decimal(19,2) null
,	UNIQUE CLUSTERED (DB)
);

INSERT INTO @TransactionDelay (DB, TransactionDelay_Start_ms, TransactionDelay_Start)
SELECT DB = pc.instance_name
,	TransactionDelay_Start_ms = MAX(ms_ticks)
,	TransactionDelay_Start = MAX(convert(decimal(19,2), pc.cntr_value))
FROM sys.dm_os_sys_info as si
CROSS APPLY sys.dm_os_performance_counters as pc
 WHERE object_name like '%database replica%'
 AND counter_name = 'transaction delay' --cumulative transaction delay in ms
 GROUP BY pc.instance_name;
  
UPDATE t 
SET MirroredWriteTranspersec_Start_ms = t2.MirroredWriteTranspersec_Start_ms
,	MirroredWriteTranspersec_Start = t2.MirroredWriteTranspersec_Start
FROM @TransactionDelay t
INNER JOIN 
(SELECT DB = pc.instance_name
,	MirroredWriteTranspersec_Start_ms = MAX(ms_ticks)
,	MirroredWriteTranspersec_Start = MAX(convert(decimal(19,2), pc.cntr_value))
FROM sys.dm_os_sys_info as si
CROSS APPLY sys.dm_os_performance_counters as pc
 WHERE object_name like '%database replica%'
 AND counter_name = 'mirrored write transactions/sec' --actually a cumulative transactions count, not per sec
 GROUP BY pc.instance_name
 ) t2 on t.DB = t2.DB;

SELECT @BytesFlushed_Start_ms = MAX(ms_ticks), @BytesFlushed_Start = MAX(cntr_value) 
FROM sys.dm_os_sys_info
CROSS APPLY sys.dm_os_performance_counters where counter_name like 'Log Bytes Flushed/sec%';

WAITFOR DELAY '00:00:05'; --Adjust sample duration between measurements

UPDATE t 
SET TransactionDelay_end_ms = t2.TransactionDelay_end_ms
,	TransactionDelay_end = t2.TransactionDelay_end
FROM @TransactionDelay t
INNER JOIN 
(SELECT DB = pc.instance_name
,	TransactionDelay_end_ms = MAX(ms_ticks)
,	TransactionDelay_end = MAX(convert(decimal(19,2), pc.cntr_value))
FROM sys.dm_os_sys_info as si
CROSS APPLY sys.dm_os_performance_counters as pc
 WHERE object_name like '%database replica%'
 AND counter_name = 'transaction delay' --cumulative transaction delay in ms
 GROUP BY pc.instance_name
 ) t2 on t.DB = t2.DB;
 
UPDATE t 
SET MirroredWriteTranspersec_end_ms = t2.MirroredWriteTranspersec_end_ms
,	MirroredWriteTranspersec_end = t2.MirroredWriteTranspersec_end
FROM @TransactionDelay t
inner join 
(SELECT DB = pc.instance_name
,	MirroredWriteTranspersec_end_ms = MAX(ms_ticks)
,	MirroredWriteTranspersec_end = MAX(convert(decimal(19,2), pc.cntr_value))
FROM sys.dm_os_sys_info as si
CROSS APPLY sys.dm_os_performance_counters as pc
 WHERE object_name like '%database replica%'
 AND counter_name = 'mirrored write transactions/sec'  --actually a cumulative transactions count, not per sec
 GROUP BY pc.instance_name
 ) t2 on t.DB = t2.DB;

SELECT @BytesFlushed_End_ms =  MAX(ms_ticks), @BytesFlushed_End = MAX(cntr_value) 
FROM sys.dm_os_sys_info
CROSS APPLY sys.dm_os_performance_counters where counter_name like 'Log Bytes Flushed/sec%';

DECLARE @LogBytesFushed decimal(19,2) 
SET @LogBytesFushed = (@BytesFlushed_End - @BytesFlushed_Start) / NULLIF(@BytesFlushed_End_ms - @BytesFlushed_Start_ms,0);

--Current replica metrics
SELECT 
	AG					= ag.name
,	Instance			= ar.replica_server_name + ' ' + case when is_local = 1 then '(local)' else '' end
,	DB					= db_name(dm.database_id)	
,	Replica_Role		= CASE WHEN last_received_time IS NULL THEN 'PRIMARY (Connections: '+ar.primary_role_allow_connections_desc+')' ELSE 'SECONDARY (Connections: '+ar.secondary_role_allow_connections_desc+')' END
,	Last_received_time
,	Last_commit_time
,	Redo_queue_size_MB		= convert(decimal(19,2),dm.redo_queue_size/1024.)--KB
,	Redo_rate_MB_per_s		= convert(decimal(19,2),dm.redo_rate/1024.) --KB/s
,	Redo_Time_Left_s_RTO	= convert(decimal(19,2),dm.redo_queue_size*1./NULLIF(dm.redo_rate*1.,0)) --only part of RTO. NULL value on secondary replica indicates no sampled activity.
,	Log_Send_Queue_RPO		= convert(decimal(19,2),dm.log_send_queue_size*1./NULLIF(@LogBytesFushed ,0)) --Rate. NULL value on secondary replica indicates no sampled activity.
,	Sampled_Transactions_count		= (td.MirroredWriteTranspersec_end - td.MirroredWriteTranspersec_start)  
,	Sampled_Transaction_Delay_ms	= (td.TransactionDelay_end - td.TransactionDelay_start)  
--Transaction Delay numbers will be 0 if there is no synchronous replica for the DB
,	Avg_Sampled_Transaction_Delay_ms_per_s	= convert(decimal(19,2), (td.TransactionDelay_end - td.TransactionDelay_Start) / ((td.TransactionDelay_end_ms - td.TransactionDelay_Start_ms)/1000.))
,	Transactions_per_s	= convert(decimal(19,2), ((td.MirroredWriteTranspersec_end - td.MirroredWriteTranspersec_start) / ((td.MirroredWriteTranspersec_End_ms - td.MirroredWriteTranspersec_Start_ms)/1000.)))
,	dm.secondary_lag_seconds 
,	dm.synchronization_state_desc 
,	dm.synchronization_health_desc
,	ar.availability_mode_desc
,	ar.failover_mode_desc
,	Suspended = case is_suspended when 1 then suspend_reason_desc else 'NO' end
,	ar.backup_priority--Backup preference priorities for reference
,	ar.modify_date--Replica modified date
,	ar.endpoint_url --EndPoint URL for reference
,	ar.read_only_routing_url --Routing URL for reference
FROM sys.dm_hadr_database_replica_states dm
INNER JOIN sys.availability_replicas ar on dm.replica_id = ar.replica_id and dm.group_id = ar.group_id
INNER JOIN @TransactionDelay td on td.DB = db_name(dm.database_id)
INNER JOIN sys.availability_groups ag on ag.group_id = dm.group_id
ORDER BY
	AG			
,	Instance		
,	DB			
,	Replica_Role;
GO

--Create Extended Events sessions to monitor synchronization
IF EXISTS (SELECT * FROM sys.server_event_sessions 
	WHERE name = N'AG_Synchronization_Events_Secondary')
		DROP EVENT SESSION [AG_Synchronization_Events_Secondary] ON SERVER ;
GO
IF EXISTS (SELECT * FROM sys.server_event_sessions 
	WHERE name = N'AG_Synchronization_Events_Primary')
		DROP EVENT SESSION [AG_Synchronization_Events_Primary] ON SERVER ;
GO
--Create extended events session to monitor Availability Group synchronization
--Recommended for diagnostic purposes only
--For monitoring events on Primary Replica 
CREATE EVENT SESSION [AG_Synchronization_Events_Primary] ON SERVER 
ADD EVENT sqlserver.hadr_log_block_group_commit,
ADD EVENT sqlserver.log_flush_start,
ADD EVENT sqlserver.hadr_log_block_send_complete,
ADD EVENT sqlserver.log_flush_complete,
ADD EVENT ucs.ucs_connection_send_msg,
ADD EVENT sqlserver.hadr_receive_harden_lsn_message,
ADD EVENT sqlserver.hadr_db_commit_mgr_harden
ADD TARGET package0.event_file(SET filename=N'Synchronization_Events_Primary.xel',max_file_size=(5),max_rollover_files=(2))
WITH (STARTUP_STATE=ON);
GO

--Recommended for diagnostic purposes only
--For monitoring events on a Secondary Replica 
CREATE EVENT SESSION [AG_Synchronization_Events_Secondary] ON SERVER 
ADD EVENT sqlserver.hadr_transport_receive_log_block_message,
ADD EVENT sqlserver.log_flush_start,
ADD EVENT sqlserver.log_flush_complete,
ADD EVENT sqlserver.hadr_send_harden_lsn_message,
ADD EVENT ucs.ucs_connection_send_msg
ADD TARGET package0.event_file(SET filename=N'Synchronization_Events_Secondary.xel',max_file_size=(5),max_rollover_files=(2))
WITH (STARTUP_STATE=ON);
GO
ALTER EVENT SESSION [AG_Synchronization_Events_Secondary] ON SERVER STATE = START;
ALTER EVENT SESSION [AG_Synchronization_Events_Primary] ON SERVER STATE = START;