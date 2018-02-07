/*
	Create a computed column ExtendedPrice by multiplying Quantity * UnitPrice
*/

ALTER TABLE Sales.OrderLines
	ADD ExtendedPrice AS (Quantity * UnitPrice) PERSISTED;

	select * from sys.syslanguages