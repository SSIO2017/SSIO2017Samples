--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 8: UNDERSTANDING AND DESIGNING TABLES
-- EXTRA T-SQL SAMPLE 6
--

-- Create a new table with a VARBINARY(MAX) field
CREATE TABLE FILESTREAM_mig_test (
	Id INT NOT NULL IDENTITY (1, 1) PRIMARY KEY CLUSTERED,
	Val VARCHAR(20) NOT NULL,
	FileData VARBINARY(MAX));

-- Insert a single row
INSERT INTO FILESTREAM_mig_test VALUES ('My value', 0x0065);

-- Retrieve the row
SELECT * FROM FILESTREAM_mig_test;

-- Create a new FILESTREAM column
ALTER TABLE FILESTREAM_mig_test
	ALTER COLUMN FileData VARBINARY(MAX) FILESTREAM;

-- TODO: Copy data