--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 8: UNDERSTANDING AND DESIGNING TABLES
-- EXTRA T-SQL SAMPLE 7
--

-- Add filtered unique index to Sales.CustomerTransactions
CREATE UNIQUE INDEX UX_CustomerTransactions_InvoiceID ON Sales.CustomerTransactions (InvoiceID) WHERE (InvoiceID IS NOT NULL);