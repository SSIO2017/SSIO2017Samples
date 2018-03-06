--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 13: MANAGING AND MONITORING SQL SERVER
-- T-SQL SAMPLE 11
--

-- Find deadlocks in built-in system_health XEvents session
WITH cteDeadlocks ([Deadlock_XML]) AS (
	--Query RingBufferTarget
	SELECT [Deadlock_XML] = CAST(target_data AS XML) 
	FROM sys.dm_xe_sessions AS xs
		INNER JOIN sys.dm_xe_session_targets AS xst ON xs.address = xst.event_session_address
	WHERE xs.NAME = 'system_health'
		AND xst.target_name = 'ring_buffer'
 )
--View as XML for detail, save this output as .xdl and re-open in SSMS for visual graph
SELECT Deadlock_XML = x.Graph.query('(event/data/value/deadlock)[1]')
	-- Date the last batch in the first process started, only an approximation of time of deadlock
	, Deadlock_When = x.Graph.value('(event/data/value/deadlock/process-list/process/@lastbatchstarted)[1]', 'datetime2(3)') 
	-- Current database of the first listed process 
	, DB = DB_Name(x.Graph.value('(event/data/value/deadlock/process-list/process/@currentdb)[1]', 'int')) 
FROM (
	SELECT Graph.query('.') AS Graph 
	FROM cteDeadLocks c
		CROSS APPLY c.[Deadlock_XML].nodes('RingBufferTarget/event[@name="xml_deadlock_report"]') AS Deadlock_Report(Graph)
) AS x
ORDER BY Deadlock_When desc;