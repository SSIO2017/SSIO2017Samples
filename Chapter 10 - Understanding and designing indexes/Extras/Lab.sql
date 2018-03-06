--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 10: UNDERSTANDING AND DESIGNING INDEXES
-- EXTRA T-SQL SAMPLE 1
--

USE WideworldImporters;
GO

-- Fill haystack
INSERT INTO Sales.InvoiceLines (InvoiceLineID, InvoiceID, StockItemID, Description, PackageTypeID, Quantity, UnitPrice, TaxRate, TaxAmount, LineProfit, ExtendedPrice, LAStEditedBy, LAStEditedWhen)
SELECT InvoiceLineID = NEXT VALUE FOR [Sequences].[InvoiceLineID], InvoiceID, StockItemID, Description, PackageTypeID, Quantity, UnitPrice, TaxRate, TaxAmount, LineProfit, ExtendedPrice, LAStEditedBy, LAStEditedWhen
FROM Sales.InvoiceLines;
-- Run previous two batches to fill table with lots of rows
GO 2 

-- Half the table hAS records for InvoiceID 69776
INSERT INTO Sales.InvoiceLines (InvoiceLineID, InvoiceID, StockItemID, Description, PackageTypeID, Quantity, UnitPrice, TaxRate, TaxAmount, LineProfit, ExtendedPrice, LAStEditedBy, LAStEditedWhen)
SELECT InvoiceLineID = NEXT VALUE FOR [Sequences].[InvoiceLineID], 69776, StockItemID, Description, PackageTypeID, Quantity, UnitPrice, TaxRate, TaxAmount, LineProfit, ExtendedPrice, LAStEditedBy, LAStEditedWhen
FROM sales.invoicelines;
GO 
 
SELECT COUNT(1) FROM sales.InvoiceLines (NOLOCK); -- Should be millions
SELECT COUNT(1) FROM sales.InvoiceLines where InvoiceID = 69776; -- Should be half the table
SELECT COUNT(1) FROM sales.InvoiceLines where InvoiceID = 1; -- Should be only a few

DBCC FREEPROCCACHE
GO
DROP INDEX IF EXISTS [NCCX_Sales_InvoiceLines]  ON [Sales].[InvoiceLines];
GO
DROP INDEX IF EXISTS IDX_NC_InvoiceLines_InvoiceID_StockItemID_Quantity ON [Sales].[InvoiceLines];
GO
DROP INDEX IF EXISTS IDX_CS_InvoiceLines_InvoiceID_StockItemID_quantity ON [Sales].[InvoiceLines];
GO

CREATE INDEX IDX_NC_InvoiceLines_InvoiceID_StockItemID_Quantity
	ON [Sales].[InvoiceLines] (InvoiceID, StockItemID, Quantity);
GO

SET STATISTICS TIME ON;

SELECT il.StockItemID, AvgQuantity = AVG(il.quantity)
FROM [Sales].[InvoiceLines] AS il
WHERE il.InvoiceID = 1 -- 4 rows
GROUP BY il.StockItemID;

SET STATISTICS TIME OFF;
GO

SET STATISTICS TIME ON;

SELECT il.StockItemID, AvgQuantity = AVG(il.quantity)
FROM [Sales].[InvoiceLines] AS il
WHERE il.InvoiceID = 69776
GROUP BY il.StockItemID;

SET STATISTICS TIME OFF;
GO

DROP INDEX IDX_NC_InvoiceLines_InvoiceID_StockItemID_Quantity ON [Sales].[InvoiceLines];
GO

CREATE COLUMNSTORE INDEX IDX_CS_InvoiceLines_InvoiceID_StockItemID_quantity
	ON [Sales].[InvoiceLines] (InvoiceID, StockItemID, Quantity);
GO

SET STATISTICS TIME ON;

SELECT il.StockItemID, AvgQuantity = AVG(il.quantity)
FROM [Sales].[InvoiceLines] AS il
WHERE il.InvoiceID = 1 -- 4 rows
GROUP BY il.StockItemID;

SET STATISTICS TIME OFF;
GO

SET STATISTICS TIME ON;

SELECT il.StockItemID, AvgQuantity = AVG(il.quantity)
FROM [Sales].[InvoiceLines] AS il
WHERE il.InvoiceID = 69776
GROUP BY il.StockItemID;

SET STATISTICS TIME OFF;
GO

DROP INDEX IF EXISTS IDX_CS_InvoiceLines_InvoiceID_StockItemID_quantity ON [Sales].[InvoiceLines];
GO
