--Detect page splits
SELECT * FROM sys.dm_os_performance_counters 
WHERE counter_name ='Page Splits/sec'
and object_name like '%Access Methods%'

--Sample: find the fragmentation level of all indexes on the Sales.Orders table in the WideWorldImporters sample database
SELECT
  DB = db_name(s.database_id)
, [schema_name] = sc.name
, [table_name] = o.name
, index_name = i.name
, s.index_type_desc
, s.partition_number
, avg_fragmentation_pct = s.avg_fragmentation_in_percent
, s.page_count
FROM  sys.indexes AS i 
CROSS APPLY sys.dm_db_index_physical_stats (DB_ID(),i.object_id,i.index_id, NULL, NULL) AS s
INNER JOIN sys.objects AS o ON o.object_id = s.object_id
INNER JOIN sys.schemas AS sc ON o.schema_id = sc.schema_id
WHERE i.is_disabled = 0;

--Sample: rebuild the FK_Sales_Orders_CustomerID nonclustered index on the Sales.Orders table with the ONLINE functionality 
ALTER INDEX FK_Sales_Orders_CustomerID 
ON Sales.Orders
REBUILD WITH (ONLINE=ON);

--Sample: to rebuild all indexes on the Sales.Orders table
ALTER INDEX ALL ON Sales.Orders REBUILD;

--Sample: use Managed Lock Priority to prevent blocking
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders
REBUILD WITH (ONLINE=ON (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = SELF)));


--Resumable Index Maint sample
--In Connection 1
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders
REBUILD WITH (ONLINE=ON, RESUMABLE=ON);

--In Connection 2
--Show that the index rebuild is RUNNING
SELECT object_name = object_name (object_id), * FROM sys.index_resumable_operations;
GO
--Pause the Index Rebuild
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders PAUSE;
--Connection 1 shows messages indicating the session has been disconnected because of a high priority DDL operation.
GO
--Show that the index rebulild is PAUSED
SELECT object_name = object_name (object_id), * FROM sys.index_resumable_operations;
GO
--Allow the index rebuild to complete
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders RESUME;

--Execute resumable index rebuild operation that runs for at most 60 minutes and then pauses.
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders
REBUILD WITH (ONLINE=ON, RESUMABLE=ON, MAX_DURATION = 60 MINUTES);

--Sample: reorganize the FK_Sales_Orders_CustomerID index on the Sales.Orders table
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders 
REORGANIZE;

--Sample: reorganize all indexes on the Sales.Orders table
ALTER INDEX ALL ON Sales.Orders REORGANIZE;

--Basic update statistics operation on an individual table
UPDATE STATISTICS [Sales].[Invoices];

--Update Statistics options for sampling
UPDATE STATISTICS [Sales].[Invoices] 
WITH SAMPLE 50 PERCENT;
UPDATE STATISTICS [Sales].[Invoices] 
WITH SAMPLE 100000 ROWS;



