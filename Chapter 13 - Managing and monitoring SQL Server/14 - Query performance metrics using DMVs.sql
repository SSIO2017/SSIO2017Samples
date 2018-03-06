--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 13: MANAGING AND MONITORING SQL SERVER
-- T-SQL SAMPLE 14
--

-- Use sys.dm_os_performance_counters to return the instance’s current target server memory, total server memory, and page life expectancy.
SELECT InstanceName = @@SERVERNAME 
	, Target_Server_Mem_GB = max(CASE counter_name WHEN 'Target Server Memory (KB)' THEN CONVERT(decimal(19, 3), cntr_value / 1024. / 1024.) END)
	, Total_Server_Mem_GB = max(CASE counter_name WHEN  'Total Server Memory (KB)' THEN CONVERT(decimal(19, 3), cntr_value / 1024. / 1024.) END) 
	, PLE_s = MAX(CASE counter_name WHEN 'Page life expectancy'  THEN cntr_value END) 
FROM sys.dm_os_performance_counters;

-- Calculate Buffer Cache Hit Ratio using sys.dm_os_performance_counters
SELECT Buffer_Cache_Hit_Ratio = 100 *
	(SELECT cntr_value = CONVERT(decimal(9, 1), cntr_value) 
		FROM sys.dm_os_performance_counters as pc
		WHERE pc.COUNTER_NAME = 'Buffer cache hit ratio'
		AND pc.OBJECT_NAME like '%:Buffer Manager%')
	/
	(SELECT cntr_value = CONVERT(decimal(9, 1), cntr_value) 
		FROM sys.dm_os_performance_counters as pc
		WHERE pc.COUNTER_NAME = 'Buffer cache hit ratio base'
		AND pc.OBJECT_NAME like '%:Buffer Manager%');

-- Calculate incrementing performance counter
DECLARE @page_splits_Start_ms bigint, @page_splits_Start bigint, @page_splits_End_ms bigint, @page_splits_End bigint

SELECT @page_splits_Start_ms = ms_ticks, @page_splits_Start = cntr_value
FROM sys.dm_os_sys_info
	CROSS APPLY sys.dm_os_performance_counters 
WHERE counter_name ='Page Splits/sec'
	AND object_name LIKE '%SQL%Access Methods%'

WAITFOR DELAY '00:00:10' --Adjust sample duration between measurements, 10s sample

SELECT @page_splits_End_ms =  MAX(ms_ticks), @page_splits_End = MAX(cntr_value) 
FROM sys.dm_os_sys_info
CROSS APPLY sys.dm_os_performance_counters
WHERE counter_name ='Page Splits/sec'
AND object_name LIKE '%SQL%Access Methods%'

SELECT Page_Splits_per_s = (@page_splits_End - @page_splits_Start)*1. / NULLIF(@page_splits_End_ms - @page_splits_Start_ms,0)*1.;

-- Use sys.dm_os_ring_buffers to gather CPU 
SELECT [Time] = DATEADD(ms, -1 * (si.cpu_ticks /  (si.cpu_ticks/si.ms_ticks) - x.[timestamp]) , SYSDATETIMEOFFSET ()) 
	, CPU_SQL_pct = bufferxml.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') 
	, CPU_Idle_pct = bufferxml.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') 
FROM (SELECT timestamp, CONVERT(xml, record) AS bufferxml
       FROM sys.dm_os_ring_buffers
       WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR') AS x
CROSS APPLY sys.dm_os_sys_info AS si
ORDER BY [Time] DESC;

-- Use sys.dm_os_ring_buffers to gather Memory utilization
SELECT [Time] =  DATEADD(ms, -1 * (si.cpu_ticks / (si.cpu_ticks/si.ms_ticks) - x.[timestamp]), SYSDATETIMEOFFSET ())
	, MemoryEvent = bufferxml.value('(./Record/ResourceMonitor/Notification)[1]', 'varchar(64)')
	, Target_Server_Mem_GB = CONVERT(decimal(19, 3), bufferxml.value('(./Record/MemoryNode/TargetMemory)[1]', 'bigint') / 1024. / 1024.)
	, Physical_Server_Mem_GB = CONVERT(decimal(19, 3), bufferxml.value('(./Record/MemoryRecord/TotalPhysicalMemory)[1]', 'bigint') / 1024. / 1024.)
	, Committed_Mem_GB = CONVERT(decimal(19, 3), bufferxml.value('(./Record/MemoryNode/CommittedMemory)[1]', 'bigint') / 1024. / 1024.)
	, Shared_Mem_GB = CONVERT(decimal(19, 3), bufferxml.value('(./Record/MemoryNode/SharedMemory)[1]', 'bigint') / 1024. / 1024.)
	, MemoryUtilization = bufferxml.value('(./Record/MemoryRecord/MemoryUtilization)[1]', 'bigint')
	, Available_Server_Mem_GB = CONVERT(decimal(19, 3), bufferxml.value('(./Record/MemoryRecord/AvailablePhysicalMemory)[1]', 'bigint') / 1024. / 1024.)
FROM (SELECT timestamp, CONVERT(xml, record) AS bufferxml
         FROM sys.dm_os_ring_buffers
         WHERE ring_buffer_type = N'RING_BUFFER_RESOURCE_MONITOR') AS x
CROSS APPLY sys.dm_os_sys_info AS si
ORDER BY [Time] DESC;

