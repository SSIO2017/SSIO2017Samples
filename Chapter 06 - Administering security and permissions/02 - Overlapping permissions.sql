--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 6: ADMINISTERING SECURITY AND PERMISSIONS
-- T-SQL SAMPLE 2
--
USE WideWorldImporters;
GO
GRANT SELECT ON SCHEMA::Sales TO [domain\katie.sql];
DENY SELECT ON OBJECT::Sales.InvoiceLines TO [domain\katie.sql];

USE WideWorldImporters;
GO
SELECT TOP 100 * FROM Sales.Invoices;
SELECT TOP 100 * FROM Sales.InvoiceLines;

-- Output:
-- Msg 229, Level 14, State 5, Line 4
-- The SELECT permission was denied on the object 'InvoiceLines', database 'WideWorldImporters', schema 'sales'.

REVOKE SELECT ON SCHEMA::Sales TO [domain\katie.sql];
REVOKE SELECT ON OBJECT::Sales.Invoices TO [domain\katie.sql];

SELECT TOP 100 * FROM Sales.Invoices;
SELECT TOP 100 * FROM Sales.InvoiceLines;

-- Output:
-- Msg 229, Level 14, State 5, Line 4
-- The SELECT permission was denied on the object 'Invoices', database 'WideWorldImporters', schema 'sales'.
-- Msg 229, Level 14, State 5, Line 5
-- The SELECT permission was denied on the object 'InvoiceLines', database 'WideWorldImporters', schema 'sales'.

DENY SELECT ON SCHEMA::Sales TO [domain\katie.sql];
GRANT SELECT ON OBJECT::Sales.InvoiceLines TO [domain\katie.sql];

SELECT TOP 100 * FROM Sales.Invoices;
SELECT TOP 100 * FROM Sales.InvoiceLines;

--Msg 229, Level 14, State 5, Line 4
--The SELECT permission was denied on the object 'Invoices', database 'WideWorldImporters', schema 'sales'.
--Msg 229, Level 14, State 5, Line 5
--The SELECT permission was denied on the object 'InvoiceLines', database 'WideWorldImporters', schema 'sales'.
