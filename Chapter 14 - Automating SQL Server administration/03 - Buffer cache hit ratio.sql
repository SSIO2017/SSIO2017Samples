--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 14: AUTOMATING SQL SERVER ADMINISTRATION
-- T-SQL SAMPLE 3
--
SELECT [BufferCacheHitRatio] = (bchr * 1.0 / bchrb) * 100.0
FROM (SELECT bchr = cntr_value
		FROM sys.dm_os_performance_counters
		WHERE counter_name = 'Buffer cache hit ratio'
			AND object_name = 'MSSQL$sql2017:Buffer Manager') AS r
CROSS APPLY (SELECT bchrb= cntr_value
	FROM sys.dm_os_performance_counters
	WHERE counter_name = 'Buffer cache hit ratio base'
	AND object_name = 'MSSQL$sql2017:Buffer Manager') AS rb
