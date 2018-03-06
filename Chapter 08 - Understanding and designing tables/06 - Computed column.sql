--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 8: UNDERSTANDING AND DESIGNING TABLES
-- T-SQL SAMPLE 6
--
-- Create a computed column ExtendedPrice by multiplying Quantity * UnitPrice
ALTER TABLE Sales.OrderLines
	ADD ExtendedPrice AS (Quantity * UnitPrice) PERSISTED;

	select * from sys.syslanguages