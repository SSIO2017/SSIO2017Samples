--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 9: PERFORMANCE TUNING SQL SERVER
-- T-SQL SAMPLE 1
--
SELECT * 
FROM sys.dm_exec_sessions s 
	LEFT OUTER JOIN sys.dm_exec_requests r ON r.session_id = s.session_id;
