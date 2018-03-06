--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 6: ADMINISTERING SECURITY AND PERMISSIONS
-- T-SQL SAMPLE 7
--

-- Create a new custom database role
USE [WideWorldImporters];
GO

-- Create the database role
CREATE ROLE SalesReadOnly AUTHORIZATION [dbo];
GO

-- Grant access rights to a specific schema in the database
GRANT EXECUTE ON [Website].[SearchForSuppliers] TO SalesReadOnly;
GO