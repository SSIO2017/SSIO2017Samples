--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 13: MANAGING AND MONITORING SQL SERVER
-- T-SQL SAMPLE 10
--

-- Aggregate wait stats
SELECT TOP (20) wait_type, wait_time_s =  wait_time_ms / 1000.  
	, Pct = 100. * wait_time_ms / SUM(wait_time_ms) OVER()
FROM sys.dm_os_wait_stats as wt 
ORDER BY Pct DESC;

--  Regularly capture and reset aggregate wait stats
CREATE TABLE dbo.sys_dm_os_wait_stats (
	id int NOT NULL IDENTITY(1, 1) 
	, datecapture datetimeoffset(0) NOT NULL
	, wait_type nvarchar(512) NOT NULL
	, wait_time_s decimal(19, 1) NOT NULL 
	, Pct decimal(9, 1) NOT NULL
	, CONSTRAINT PK_sys_dm_os_wait_stats PRIMARY KEY CLUSTERED (id)
);

-- This part of the script should be in a SQL Agent job, run regularly
INSERT INTO dbo.sys_dm_os_wait_stats  (datecapture, wait_type, wait_time_s, Pct)
SELECT TOP (100) datecapture = SYSDATETIMEOFFSET()
	, wait_type
	, wait_time_s = CONVERT(decimal(19, 1), ROUND( wait_time_ms / 1000.0, 1))
	, Pct = wait_time_ms / sum(wait_time_ms) OVER() 
FROM sys.dm_os_wait_stats wt
WHERE wait_time_ms > 0
ORDER BY wait_time_s;
GO

-- Reset the accumulated statistics in this DMV
DBCC SQLPERF ('sys.dm_os_wait_stats', CLEAR); 

-- Ignore harmless wait types
SELECT TOP (20) wait_type, wait_time_s =  wait_time_ms / 1000.
	, Pct = 100. * wait_time_ms / SUM(wait_time_ms) OVER()
FROM sys.dm_os_wait_stats as wt 
WHERE
	-- Can be safely ignored, sleeping
	wt.wait_type NOT LIKE '%SLEEP%' 
	-- Can be safely ignored, internal process
	AND wt.wait_type NOT LIKE 'BROKER%' 
	-- Can be safely ignored, internal processes for memory-optimized tables
	AND wt.wait_type NOT LIKE '%XTP_WAIT%' 
	-- Can be safely ignored, internal process
	AND wt.wait_type NOT LIKE '%SQLTRACE%' 
	-- Can be safely ignored, waits involved in the asynchronous collection of Query Store data
	AND wt.wait_type NOT LIKE 'QDS%' 
	-- Common benign wait types
	AND wt.wait_type NOT IN ('CHECKPOINT_QUEUE' 
		, 'CLR_AUTO_EVENT','CLR_MANUAL_EVENT' ,'CLR_SEMAPHORE'
		, 'DBMIRROR_DBM_MUTEX','DBMIRROR_EVENTS_QUEUE','DBMIRRORING_CMD' 
		, 'DIRTY_PAGE_POLL'
		, 'DISPATCHER_QUEUE_SEMAPHORE'
		, 'FT_IFTS_SCHEDULER_IDLE_WAIT','FT_IFTSHC_MUTEX' 
		, 'HADR_FILESTREAM_IOMGR_IOCOMPLETION'
		, 'KSOURCE_WAKEUP'
		, 'LOGMGR_QUEUE'
		, 'ONDEMAND_TASK_QUEUE'
		, 'REQUEST_FOR_DEADLOCK_SEARCH'
		, 'XE_DISPATCHER_WAIT','XE_TIMER_EVENT'
		--Ignorable HADR waits
		, 'HADR_WORK_QUEUE'
		, 'HADR_TIMER_TASK'
		, 'HADR_CLUSAPI_CALL'
	)
ORDER BY Pct DESC;



