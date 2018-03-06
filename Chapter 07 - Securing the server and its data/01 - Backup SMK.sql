--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 7: SECURING THE SERVER AND ITS DATA
-- T-SQL SAMPLE 1
--

-- Backing up the SMK to the local hard drive
BACKUP SERVICE MASTER KEY TO FILE = 'C:\SecureLocation\service_master_key'   
   ENCRYPTION BY PASSWORD = '<UseAReallyStrongPassword>';  
GO
