--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 13: MANAGING AND MONITORING SQL SERVER
-- T-SQL SAMPLE 5
--

-- Rebuild the FK_Sales_Orders_CustomerID non-clustered index on the Sales.Orders table with the ONLINE functionality 
ALTER INDEX FK_Sales_Orders_CustomerID 
ON Sales.Orders
REBUILD WITH (ONLINE=ON);

-- To rebuild all indexes on the Sales.Orders table
ALTER INDEX ALL ON Sales.Orders REBUILD;

-- Use Managed Lock Priority to prevent blocking
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders
REBUILD WITH (ONLINE=ON (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = SELF)));

-- Resumable Index Maintenance
-- In Connection 1
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders
REBUILD WITH (ONLINE=ON, RESUMABLE=ON);

-- In Connection 2
-- Show that the index rebuild is RUNNING
SELECT object_name = object_name (object_id), * FROM sys.index_resumable_operations;
GO
-- Pause the Index Rebuild
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders PAUSE;
-- Connection 1 shows messages indicating the session has been disconnected because of a high priority DDL operation.
GO

-- Show that the index rebuild is PAUSED
SELECT object_name = object_name (object_id), * FROM sys.index_resumable_operations;
GO

-- Allow the index rebuild to complete
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders RESUME;

-- Execute resumable index rebuild operation that runs for at most 60 minutes and then pauses.
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders
REBUILD WITH (ONLINE=ON, RESUMABLE=ON, MAX_DURATION = 60 MINUTES);