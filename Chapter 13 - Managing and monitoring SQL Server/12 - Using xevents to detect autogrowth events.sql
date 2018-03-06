--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 13: MANAGING AND MONITORING SQL SERVER
-- T-SQL SAMPLE 1
--

-- Create session to detect autogrowth events
CREATE EVENT SESSION [autogrowths] ON SERVER
	ADD EVENT sqlserver.database_file_size_change(
		ACTION(package0.collect_system_time, sqlserver.database_id
			, sqlserver.database_name,sqlserver.sql_text)),
	ADD EVENT sqlserver.databases_log_file_size_changed(
		ACTION(package0.collect_system_time, sqlserver.database_id
			, sqlserver.database_name, sqlserver.sql_text))
	ADD TARGET package0.event_file(
		-- .xel file target
		SET filename=N'F:\DATA\autogrowths.xel'), 
	ADD TARGET package0.histogram(
		-- Histogram target, counting events per database_name
		SET filtering_event_name=N'sqlserver.database_file_size_change'
		, source = N'database_name', source_type = (0))
--Start session at server startup
WITH (STARTUP_STATE=ON); 
GO

-- Start the session now
ALTER EVENT SESSION [autogrowths]  
	ON SERVER STATE = START;
