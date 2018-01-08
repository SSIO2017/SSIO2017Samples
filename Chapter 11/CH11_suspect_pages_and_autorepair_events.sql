--Check for suspect pages (hopefully 0 rows returned)
SELECT * FROM msdb.dbo.suspect_pages
   WHERE (event_type <= 3);

--Check for autorepair events (hopefully 0 rows returned)
select db = db_name(database_id)
,	file_id
,	page_id
,	error_type 
,	page_status
,	modification_time
from sys.dm_hadr_auto_page_repair order by modification_time desc