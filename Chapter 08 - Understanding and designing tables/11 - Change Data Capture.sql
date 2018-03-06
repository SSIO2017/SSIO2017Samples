--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 8: UNDERSTANDING AND DESIGNING TABLES
-- T-SQL SAMPLE 11
--
CREATE DATABASE MyDb;
GO
USE MyDb;
GO

EXEC sys.sp_cdc_enable_db;

CREATE TABLE Orders (OrderId BIGINT PRIMARY KEY IDENTITY(1,1));

CREATE ROLE cdc_reader;

EXEC sys.sp_cdc_enable_table  
    @source_schema = 'dbo',  
    @source_name = 'Orders',
	@role_name = 'cdc_reader';