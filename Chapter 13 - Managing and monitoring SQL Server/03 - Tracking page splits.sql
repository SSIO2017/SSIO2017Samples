--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 13: MANAGING AND MONITORING SQL SERVER
-- T-SQL SAMPLE 3
--

--Detect page splits
SELECT * 
FROM sys.dm_os_performance_counters 
WHERE counter_name ='Page Splits/sec'
	AND object_name LIKE '%Access Methods%';
