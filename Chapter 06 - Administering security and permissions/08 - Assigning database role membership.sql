--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 6: ADMINISTERING SECURITY AND PERMISSIONS
-- T-SQL SAMPLE 8
--

-- Add user to built-in database role
ALTER ROLE db_owner ADD MEMBER [domain\katie.sql];
GO

-- Add user to custom database role
ALTER ROLE SalesReadOnly ADD MEMBER [domain\James];
ALTER ROLE SalesReadOnly ADD MEMBER [domain\Alex];
ALTER ROLE SalesReadOnly ADD MEMBER [domain\Naomi];
ALTER ROLE SalesReadOnly ADD MEMBER [domain\Amos];
ALTER ROLE SalesReadOnly ADD MEMBER [domain\Shed];
GO

-- Remove User from database role
ALTER ROLE SalesReadOnly DROP MEMBER [domain\Shed];
GO