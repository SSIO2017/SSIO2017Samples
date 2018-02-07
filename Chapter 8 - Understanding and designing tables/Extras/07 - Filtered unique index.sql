/*
	Add filtered unique index to Sales.CustomerTransactions
*/

CREATE UNIQUE INDEX UX_CustomerTransactions_InvoiceID ON Sales.CustomerTransactions (InvoiceID) WHERE (InvoiceID IS NOT NULL);