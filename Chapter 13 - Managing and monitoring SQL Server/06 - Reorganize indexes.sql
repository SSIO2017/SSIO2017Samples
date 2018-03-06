--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 13: MANAGING AND MONITORING SQL SERVER
-- T-SQL SAMPLE 6
--

-- Reorganize the FK_Sales_Orders_CustomerID index on the Sales.Orders table
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders 
REORGANIZE;

-- Reorganize all indexes on the Sales.Orders table
ALTER INDEX ALL ON Sales.Orders REORGANIZE;