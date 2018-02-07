USE master;
GO
-- Enable snapshot isolation for the database
ALTER DATABASE [WideWorldImporters]
     SET ALLOW_SNAPSHOT_ISOLATION ON;
-- Enable change tracking for the database
ALTER DATABASE [WideWorldImporters]
    SET CHANGE_TRACKING = ON  
    (CHANGE_RETENTION = 5 DAYS, AUTO_CLEANUP = ON);
USE [WideWorldImporters];
GO 
 -- Enable change tracking for Orders
ALTER TABLE Sales.Orders 
    ENABLE CHANGE_TRACKING  
    -- and track which columns changed
    WITH (TRACK_COLUMNS_UPDATED = ON);
-- Enable change tracking for OrderLines
ALTER TABLE Sales.OrderLines
    ENABLE CHANGE_TRACKING;
-- Disable change tracking for OrderLines
ALTER TABLE Sales.OrderLines
    DISABLE CHANGE_TRACKING;
-- Query the current state of change tracking in the database
SELECT *
FROM sys.change_tracking_tables;  


select * from sales.Orders
update sales.Orders set comments = 'by sven' where orderid=73595

select * from changetable (CHANGES sales.Orders, 0) AS e