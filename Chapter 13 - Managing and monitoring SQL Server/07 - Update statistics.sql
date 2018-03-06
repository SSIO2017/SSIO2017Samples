--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 13: MANAGING AND MONITORING SQL SERVER
-- T-SQL SAMPLE 7
--

-- Basic update statistics operation on an individual table
UPDATE STATISTICS [Sales].[Invoices];

-- Update Statistics options for sampling
UPDATE STATISTICS [Sales].[Invoices] 
	WITH SAMPLE 50 PERCENT;
UPDATE STATISTICS [Sales].[Invoices] 
	WITH SAMPLE 100000 ROWS;