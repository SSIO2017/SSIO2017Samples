--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 9: PERFORMANCE TUNING SQL SERVER
-- T-SQL SAMPLE 2
--

-- Measure ad hoc query plans
SELECT 
	PlanUse = CASE WHEN p.usecounts > 1 THEN '>1' ELSE '1' END
	, PlanCount = COUNT(1) 
	, SizeInMB = SUM(p.size_in_bytes / 1024. / 1024.)
FROM sys.dm_exec_cached_plans p
GROUP BY CASE WHEN p.usecounts > 1 THEN '>1' ELSE '1' END;