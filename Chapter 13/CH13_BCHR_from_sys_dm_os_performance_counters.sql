SELECT [BufferCacheHitRatio] = (bchr * 1.0 / bchrb) * 100.0
FROM
(SELECT bchr = cntr_value FROM
sys.dm_os_performance_counters
WHERE counter_name = 'Buffer cache hit ratio'
AND object_name = 'MSSQL$sql2017:Buffer Manager') AS r
CROSS APPLY
(SELECT bchrb= cntr_value FROM
sys.dm_os_performance_counters
WHERE counter_name = 'Buffer cache hit ratio base'
and object_name = 'MSSQL$sql2017:Buffer Manager') AS rb
