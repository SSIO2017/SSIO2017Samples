-- Creating a database audit specification and setting it active.

USE WideWorldImporters;
GO

-- Create the database audit specification.
CREATE DATABASE AUDIT SPECIFICATION Sales_Tables
    FOR SERVER AUDIT Sales_Security_Audit
    ADD (SELECT, INSERT ON Sales.CustomerTransactions BY dbo)   
    WITH (STATE = ON);
GO
