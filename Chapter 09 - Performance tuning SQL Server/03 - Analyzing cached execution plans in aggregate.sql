--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 9: PERFORMANCE TUNING SQL SERVER
-- T-SQL SAMPLE 3
--

-- Find long-running queries
SELECT 
	UseCount = p.usecounts
	, PlanSize_KB  = p.size_in_bytes / 1024
	, CPU_ms	   = qs.total_worker_time / 1000  
	, Duration_ms  = qs.total_elapsed_time / 1000
	, ObjectType   = p.cacheobjtype + ' (' + p.objtype + ')'
	, DatabaseName = db_name(CONVERT(int, pa.value))
	, txt.ObjectID
	, qs.total_physical_reads
	, qs.total_logical_writes
	, qs.total_logical_reads
	, qs.last_execution_time
	, StatementText = REPLACE(REPLACE 
                    (SUBSTRING (txt.[text], qs.statement_start_offset / 2 + 1, 
                    CASE WHEN qs.statement_end_offset = -1 THEN LEN (CONVERT(nvarchar(max), txt.[text])) 
                         ELSE qs.statement_end_offset / 2 - qs.statement_start_offset / 2 + 1 
                    END), 
                    CHAR(13), ' '), CHAR(10), ' ') 
	, QueryPlan  = qp.query_plan	
	, qs.plan_handle 
FROM sys.dm_exec_query_stats qs 		
	INNER JOIN sys.dm_exec_cached_plans p ON p.plan_handle = qs.plan_handle 
	OUTER APPLY sys.dm_exec_plan_attributes (p.plan_handle) pa 
	OUTER APPLY sys.dm_exec_sql_text (p.plan_handle) AS txt
	OUTER APPLY sys.dm_exec_query_plan (p.plan_handle) qp
WHERE pa.attribute = 'dbid' 
ORDER BY qs.total_worker_time + qs.total_elapsed_time DESC;
GO
