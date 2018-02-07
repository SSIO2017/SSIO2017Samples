/*
	Add check contraint on WideWorldImporters.Sales.Invoices
*/

USE [WideWorldImporters];
GO

ALTER TABLE Sales.Invoices WITH CHECK
	ADD CONSTRAINT CH_Comments CHECK (LastEditedWhen < '2018-02-01' OR Comments IS NOT NULL);