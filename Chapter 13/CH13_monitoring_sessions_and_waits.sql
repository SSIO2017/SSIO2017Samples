--Sample: Sessions and Requests
SELECT		
  when_observed = sysdatetime()
, r.session_id, r.request_id
, session_status = s.[status] -- running, sleeping, dormant, preconnect
, request_status = r.[status] -- running, runnable, suspended, sleeping, background
, blocked_by = r.blocking_session_id 
, [database_name] = db_name(r.database_id)
, s.login_time, r.start_time
, query_text = CASE	WHEN r.statement_start_offset = 0 and r.statement_end_offset= 0 THEN left(est.text, 4000)
        ELSE SUBSTRING (est.[text],	r.statement_start_offset/2 + 1,
        CASE WHEN r.statement_end_offset = -1 THEN LEN (CONVERT(nvarchar(max), est.[text])) 
             ELSE r.statement_end_offset/2 - r.statement_start_offset/2 + 1
        END	) END --the actual query text being executed is stored as nvarchar, so we must divide by 2 for the offsets
, qp.query_plan	
, cacheobjtype = LEFT (p.cacheobjtype + ' (' + p.objtype + ')', 35)
, est.objectid
, s.login_name, s.client_interface_name, endpoint_name = e.name, protocol = e.protocol_desc
, s.host_name, s.program_name
, cpu_time_s = r.cpu_time, tot_time_s = r.total_elapsed_time
, wait_time_s = r.wait_time, r.wait_type, r.wait_resource, r.last_wait_type
, r.reads, r.writes, r.logical_reads  --accumulated request statistics
FROM sys.dm_exec_sessions as s 
LEFT OUTER JOIN sys.dm_exec_requests as r on r.session_id = s.session_id
LEFT OUTER JOIN sys.endpoints as e ON e.endpoint_id = s.endpoint_id 
LEFT OUTER JOIN sys.dm_exec_cached_plans as p ON p.plan_handle = r.plan_handle 
OUTER APPLY sys.dm_exec_query_plan (r.plan_handle) as qp
OUTER APPLY sys.dm_exec_sql_text (r.sql_handle) as est
LEFT OUTER JOIN sys.dm_exec_query_stats as stat on stat.plan_handle = r.plan_handle
AND r.statement_start_offset = stat.statement_start_offset  
AND r.statement_end_offset = stat.statement_end_offset
WHERE 1=1
AND s.session_id >= 50 --retrieve only user spids
AND s.session_id <> @@SPID --ignore myself
ORDER BY r.blocking_session_id desc, s.session_id asc;


--Aggregate wait stats
SELECT TOP (20)
 wait_type, wait_time_s =  wait_time_ms / 1000.  
, Pct = 100. * wait_time_ms/sum(wait_time_ms) OVER()
FROM sys.dm_os_wait_stats as wt ORDER BY Pct desc;

--Sample Regularly capture and reset aggregate wait stats
CREATE TABLE dbo.sys_dm_os_wait_stats 
(	id int NOT NULL IDENTITY(1,1) 
,	datecapture datetimeoffset(0) NOT NULL
,	wait_type nvarchar(512) NOT NULL
,	wait_time_s  decimal(19,1) NOT NULL 
,	Pct decimal(9,1)  NOT NULL
,	CONSTRAINT PK_sys_dm_os_wait_stats PRIMARY KEY CLUSTERED (id)
);
--This part of the script should be in a SQL Agent job, run regularly
INSERT INTO dbo.sys_dm_os_wait_stats  (datecapture, wait_type, wait_time_s, Pct)
SELECT TOP (100)
  datecapture = SYSDATETIMEOFFSET()
, wait_type
, wait_time_s = convert(decimal(19,1), round( wait_time_ms / 1000.0,1))
, Pct = wait_time_ms/sum(wait_time_ms) OVER() 
FROM sys.dm_os_wait_stats wt
WHERE wait_time_ms > 0
ORDER BY wait_time_s;
GO
DBCC SQLPERF ('sys.dm_os_wait_stats', CLEAR); --Reset the accumulated statistics in this DMV


--Ignore harmless wait types

SELECT TOP (20)
 wait_type, wait_time_s =  wait_time_ms / 1000.  
, Pct = 100. * wait_time_ms/sum(wait_time_ms) OVER()
FROM sys.dm_os_wait_stats as wt 
WHERE 
    wt.wait_type NOT LIKE '%SLEEP%' --can be safely ignored, sleeping
AND wt.wait_type NOT LIKE 'BROKER%' --can be safely ignored, internal process
AND wt.wait_type NOT LIKE '%XTP_WAIT%' --can be safely ignored, internal processes for memory-optimized tables
AND wt.wait_type NOT LIKE '%SQLTRACE%' --can be safely ignored, internal process
AND wt.wait_type NOT LIKE 'QDS%' --can be safely ignored, waits involved in the asynchronous collection of Query Store data
AND wt.wait_type NOT IN ( -- common benign wait types
 'CHECKPOINT_QUEUE' 
,'CLR_AUTO_EVENT','CLR_MANUAL_EVENT' ,'CLR_SEMAPHORE'
,'DBMIRROR_DBM_MUTEX','DBMIRROR_EVENTS_QUEUE','DBMIRRORING_CMD' 
,'DIRTY_PAGE_POLL'
,'DISPATCHER_QUEUE_SEMAPHORE'
,'FT_IFTS_SCHEDULER_IDLE_WAIT','FT_IFTSHC_MUTEX' 
,'HADR_FILESTREAM_IOMGR_IOCOMPLETION'
,'KSOURCE_WAKEUP'
,'LOGMGR_QUEUE'
,'ONDEMAND_TASK_QUEUE'
,'REQUEST_FOR_DEADLOCK_SEARCH'
,'XE_DISPATCHER_WAIT','XE_TIMER_EVENT'
--Ignorable HADR waits
,'HADR_WORK_QUEUE'
,'HADR_TIMER_TASK'
,'HADR_CLUSAPI_CALL'
)
ORDER BY Pct desc;



