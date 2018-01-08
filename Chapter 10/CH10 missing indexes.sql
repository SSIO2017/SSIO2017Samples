use WideWorldImporters
go
SELECT 
  mid.[statement]
, create_index_statement = 'CREATE NONCLUSTERED INDEX IDX_NC_' + replace(t.[name], ' ' ,'')
	+ TRANSLATE(ISNULL(replace(mid.equality_columns, ' ' ,''),'') , '],[' ,' _ ') --Translate is supported for SQL 2017+
	+ TRANSLATE(ISNULL(replace(mid.inequality_columns, ' ' ,''),''), '],[' ,' _ ') 
	/*
	The following lines work prior to SQL 2017
	+ replace(replace(replace(ISNULL(replace(mid.equality_columns, ' ' ,''),'') , '],[' ,'_'),'[','_'),']','') 
	+ replace(replace(replace(ISNULL(replace(mid.inequality_columns, ' ' ,''),''), '],[' ,'_'),'[','_'),']','') 
	*/
     + ' ON ' + [statement]
     + ' (' + ISNULL (mid.equality_columns,'') 
     + CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END 
     + ISNULL (mid.inequality_columns, '')  + ')' 
     + ISNULL (' INCLUDE (' + mid.included_columns + ')', '')  COLLATE SQL_Latin1_General_CP1_CI_AS
, unique_compiles, migs.user_seeks, migs.user_scans, last_user_seek, migs.avg_total_user_cost
, avg_user_impact
, mid.equality_columns,  mid.inequality_columns, mid.included_columns
FROM sys.dm_db_missing_index_groups mig
INNER JOIN sys.dm_db_missing_index_group_stats migs 
ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details mid 
ON mig.index_handle = mid.index_handle
INNER JOIN sys.tables t 
ON t.object_id = mid.object_id
INNER JOIN sys.schemas s
ON s.schema_id = t.schema_id
WHERE mid.database_id = db_id()
--AND	 	migs.unique_compiles > 10 -- count of query compilations that needed this proposed index
--AND	 	migs.user_seeks > 10 -- count of query seeks that needed this proposed index
--AND	 	migs.avg_user_impact > 75 -- average percentage of cost that could be alleviated with this proposed index
ORDER BY avg_user_impact * avg_total_user_cost desc;-- Sort by indexes that will have the most impact to the costliest queries 
