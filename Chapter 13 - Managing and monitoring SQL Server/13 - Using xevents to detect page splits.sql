--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 13: MANAGING AND MONITORING SQL SERVER
-- T-SQL SAMPLE 13
--

-- Create session to detect page splits
CREATE EVENT SESSION [page_splits] ON SERVER 
	ADD EVENT sqlserver.page_split(
		ACTION(sqlserver.database_name, sqlserver.sql_text))
	ADD TARGET package0.event_file(SET filename = N'page_splits', max_file_size = (100)),
	ADD TARGET package0.histogram(SET filtering_event_name = N'sqlserver.page_split'
		, source=N'database_id', source_type=(0))
--Start session at server startup
WITH (STARTUP_STATE=ON);
