--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 10: UNDERSTANDING AND DESIGNING INDEXES
-- T-SQL SAMPLE 2
--

SELECT TableName = sc.name + '.' + o.name
	, IndexName = i.name
	, s.user_seeks
	, s.user_scans
	, s.user_lookups
	, s.user_updates
	, ps.row_count
	, SizeMb = (ps.in_row_reserved_page_count * 8.)/ 1024.
	, s.last_user_lookup
	, s.last_user_scan
	, s.last_user_seek
	, s.last_user_update
FROM sys.dm_db_index_usage_stats s 
	INNER JOIN sys.indexes as i ON i.object_id = s.object_id AND i.index_id = s.index_id
	INNER JOIN sys.objects as o ON o.object_id=i.object_id
	INNER JOIN sys.schemas as sc ON sc.schema_id = o.schema_id
	INNER JOIN sys.partitions as pr ON pr.object_id = i.object_id AND pr.index_id = i.index_id
	INNER JOIN sys.dm_db_partition_stats as ps ON ps.object_id = i.object_id AND ps.partition_id = pr.partition_id
WHERE o.is_ms_shipped = 0
ORDER BY user_seeks + user_scans + user_lookups ASC,  s.user_updates DESC;
