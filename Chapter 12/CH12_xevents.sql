--Find deadlocks in built-in system_health XEvents session
WITH cteDeadlocks ([Deadlock_XML]) AS (
  --Query RingBufferTarget
  SELECT [Deadlock_XML] = CAST(target_data AS XML) 
  FROM sys.dm_xe_sessions AS xs
  INNER JOIN sys.dm_xe_session_targets AS xst 
  ON xs.address = xst.event_session_address
  WHERE xs.NAME = 'system_health'
  AND xst.target_name = 'ring_buffer'
 )
SELECT 
  Deadlock_XML = x.Graph.query('(event/data/value/deadlock)[1]')  --View as XML for detail, save this output as .xdl and re-open in SSMS for visual graph
, Deadlock_When = x.Graph.value('(event/data/value/deadlock/process-list/process/@lastbatchstarted)[1]', 'datetime2(3)') --date the last batch in the first process started, only an approximation of time of deadlock
, DB = DB_Name(x.Graph.value('(event/data/value/deadlock/process-list/process/@currentdb)[1]', 'int')) --Current database of the first listed process 
FROM (
 SELECT Graph.query('.') AS Graph 
 FROM cteDeadLocks c
 CROSS APPLY c.[Deadlock_XML].nodes('RingBufferTarget/event[@name="xml_deadlock_report"]') AS Deadlock_Report(Graph)
) AS x
ORDER BY Deadlock_When desc;

--Create session to detect autogrwoth events
CREATE   EVENT SESSION [autogrowths] ON SERVER
ADD EVENT sqlserver.database_file_size_change(
    ACTION(package0.collect_system_time,sqlserver.database_id
,sqlserver.database_name,sqlserver.sql_text)),
ADD EVENT sqlserver.databases_log_file_size_changed(
    ACTION(package0.collect_system_time,sqlserver.database_id
,sqlserver.database_name,sqlserver.sql_text))
ADD TARGET package0.event_file(
--.xel file target
SET filename=N'F:\DATA\autogrowths.xel'), 
ADD   TARGET package0.histogram(
--Histogram target, counting events per database_name
SET filtering_event_name=N'sqlserver.database_file_size_change'
,source=N'database_name',source_type=(0))
--Start session at server startup
WITH (STARTUP_STATE=ON); 
GO
--Start the session now
ALTER EVENT SESSION [autogrowths]  
ON SERVER  STATE = START;


--Create session to detect page splits
CREATE EVENT SESSION [page_splits] ON SERVER 
ADD EVENT sqlserver.page_split(
    ACTION(sqlserver.database_name,sqlserver.sql_text))
ADD TARGET package0.event_file(SET filename=N'page_splits',max_file_size=(100)),
ADD TARGET package0.histogram(SET filtering_event_name=N'sqlserver.page_split',source=N'database_id',source_type=(0))
--Start session at server startup
WITH (STARTUP_STATE=ON);


