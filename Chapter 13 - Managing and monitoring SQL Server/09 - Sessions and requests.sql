--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 13: MANAGING AND MONITORING SQL SERVER
-- T-SQL SAMPLE 1
--

-- Sessions and Requests
SELECT when_observed = sysdatetime()
	, r.session_id, r.request_id
	-- Running, sleeping, dormant, preconnect
	, session_status = s.[status] 
	-- Running, runnable, suspended, sleeping, background
	, request_status = r.[status] 
	, blocked_by = r.blocking_session_id 
	, [database_name] = db_name(r.database_id)
	, s.login_time, r.start_time
	, query_text = CASE	WHEN r.statement_start_offset = 0 AND r.statement_end_offset= 0 THEN LEFT(est.text, 4000)
        ELSE SUBSTRING (est.[text],	r.statement_start_offset/2 + 1,
        CASE WHEN r.statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), est.[text])) 
             ELSE r.statement_end_offset/2 - r.statement_start_offset/2 + 1
        END) END --the actual query text being executed is stored as nvarchar, so we must divide by 2 for the offsets
	, qp.query_plan	
	, cacheobjtype = LEFT (p.cacheobjtype + ' (' + p.objtype + ')', 35)
	, est.objectid
	, s.login_name, s.client_interface_name, endpoint_name = e.name, protocol = e.protocol_desc
	, s.host_name, s.program_name
	, cpu_time_s = r.cpu_time, tot_time_s = r.total_elapsed_time
	, wait_time_s = r.wait_time, r.wait_type, r.wait_resource, r.last_wait_type
	-- Accumulated request statistics
	, r.reads, r.writes, r.logical_reads  
FROM sys.dm_exec_sessions AS s 
	LEFT OUTER JOIN sys.dm_exec_requests as r ON r.session_id = s.session_id
	LEFT OUTER JOIN sys.endpoints as e ON e.endpoint_id = s.endpoint_id 
	LEFT OUTER JOIN sys.dm_exec_cached_plans as p ON p.plan_handle = r.plan_handle 
	OUTER APPLY sys.dm_exec_query_plan (r.plan_handle) as qp
	OUTER APPLY sys.dm_exec_sql_text (r.sql_handle) as est
	LEFT OUTER JOIN sys.dm_exec_query_stats as stat on stat.plan_handle = r.plan_handle
		AND r.statement_start_offset = stat.statement_start_offset  
		AND r.statement_end_offset = stat.statement_end_offset
WHERE 1 = 1
	-- Retrieve only user spids
	AND s.session_id >= 50 
	-- Ignore myself
	AND s.session_id <> @@SPID 
ORDER BY r.blocking_session_id DESC, s.session_id ASC;