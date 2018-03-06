--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 12: IMPLEMENTING HIGH AVAILABILITY AND DISASTER RECOVERY
-- T-SQL SAMPLE 8
--

--Check for suspect pages (hopefully 0 rows returned)
SELECT * FROM msdb.dbo.suspect_pages
   WHERE (event_type <= 3);

--Check for autorepair events (hopefully 0 rows returned)
SELECT db = db_name(database_id)
	, file_id
	, page_id
	, error_type 
	, page_status
	, modification_time
FROM sys.dm_hadr_auto_page_repair 
ORDER BY modification_time DESC;