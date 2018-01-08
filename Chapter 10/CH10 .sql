Use WideworldImporters

go



--fill haystack
insert into sales.invoicelines (InvoiceLineID, InvoiceID, StockItemID, Description, PackageTypeID, Quantity, UnitPrice, TaxRate, TaxAmount, LineProfit, ExtendedPrice, LastEditedBy, LastEditedWhen)
select InvoiceLineID= NEXT VALUE FOR [Sequences].[InvoiceLineID], InvoiceID, StockItemID, Description, PackageTypeID, Quantity, UnitPrice, TaxRate, TaxAmount, LineProfit, ExtendedPrice, LastEditedBy, LastEditedWhen
 from sales.invoicelines
GO 2 --run previous two batches to fill table with lots of rows

--half the table has records for InvoiceID 69776
insert into sales.invoicelines (InvoiceLineID, InvoiceID, StockItemID, Description, PackageTypeID, Quantity, UnitPrice, TaxRate, TaxAmount, LineProfit, ExtendedPrice, LastEditedBy, LastEditedWhen)
select InvoiceLineID= NEXT VALUE FOR [Sequences].[InvoiceLineID], 69776, StockItemID, Description, PackageTypeID, Quantity, UnitPrice, TaxRate, TaxAmount, LineProfit, ExtendedPrice, LastEditedBy, LastEditedWhen
  from sales.invoicelines
 go 
 
select count(1) from sales.InvoiceLines (NOLOCK) --should be millions
select count(1) from sales.InvoiceLines where InvoiceID = 69776 --should be half the table
 select count(1) from sales.InvoiceLines where InvoiceID = 1 --should be only a few

 
 dbcc freeproccache
go
DROP INDEX IF EXISTS [NCCX_Sales_InvoiceLines]  ON [Sales].[InvoiceLines]
GO
DROP INDEX IF EXISTS IDX_NC_InvoiceLines_InvoiceID_StockItemID_Quantity ON [Sales].[InvoiceLines] 
GO
DROP INDEX IF EXISTS IDX_CS_InvoiceLines_InvoiceID_StockItemID_quantity ON [Sales].[InvoiceLines] 
GO

CREATE INDEX IDX_NC_InvoiceLines_InvoiceID_StockItemID_Quantity
ON [Sales].[InvoiceLines] (InvoiceID, StockItemID, Quantity)
GO
set statistics time on 
SELECT il.StockItemID, AvgQuantity = avg(il.quantity)
FROM [Sales].[InvoiceLines] as il
WHERE il.InvoiceID = 1 --4 rows
group by il.StockItemID
set statistics time off
GO
set statistics time on 
SELECT il.StockItemID, AvgQuantity = avg(il.quantity)
FROM [Sales].[InvoiceLines] as il
WHERE il.InvoiceID = 69776
group by il.StockItemID

set statistics time off
GO
DROP INDEX IDX_NC_InvoiceLines_InvoiceID_StockItemID_Quantity ON [Sales].[InvoiceLines] 
GO
CREATE COLUMNSTORE INDEX IDX_CS_InvoiceLines_InvoiceID_StockItemID_quantity
ON [Sales].[InvoiceLines] (InvoiceID, StockItemID, Quantity)
GO
set statistics time on 
SELECT il.StockItemID, AvgQuantity = avg(il.quantity)
FROM [Sales].[InvoiceLines] as il
WHERE il.InvoiceID = 1 --4 rows
group by il.StockItemID
set statistics time off
GO
set statistics time on 
SELECT il.StockItemID, AvgQuantity = avg(il.quantity)
FROM [Sales].[InvoiceLines] as il
WHERE il.InvoiceID = 69776
group by il.StockItemID
set statistics time off
GO
DROP INDEX IF EXISTS IDX_CS_InvoiceLines_InvoiceID_StockItemID_quantity ON [Sales].[InvoiceLines] 
GO
