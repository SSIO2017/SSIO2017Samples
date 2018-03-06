--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 7: SECURING THE SERVER AND ITS DATA
-- T-SQL SAMPLE 2
--

-- Backing up the DMK for the WideWorldImporters database
USE WideWorldImporters;
GO
BACKUP MASTER KEY TO FILE = 'C:\SecureLocation\wwi_database_master_key'
    ENCRYPTION BY PASSWORD = '<UseAReallyStrongPassword>';
GO  
