--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 8: UNDERSTANDING AND DESIGNING TABLES
-- T-SQL SAMPLE 4
--
CREATE TYPE CustomerNameType FROM NVARCHAR(100) NOT NULL;
GO

-- Create a database-wide default
CREATE DEFAULT CustomerNameDefault
AS 'NA';
GO

-- Create a database-wide validation rule
CREATE RULE CustomerNameRule
AS
-- Allow the value 'NA' (the default)
@value = 'NA' OR
-- Or require at least 3 characters
LEN(@value) >= 3;
GO

-- Bind the default and the rule to the CustomerNameType UDT
EXEC sp_bindefault 'CustomerNameDefault', 'CustomerNameType';
EXEC sp_bindrule 'CustomerNameRule', 'CustomerNameType';