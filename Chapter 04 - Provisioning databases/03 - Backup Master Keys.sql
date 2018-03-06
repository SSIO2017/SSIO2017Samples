--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 4: PROVISIONING DATABASES
-- T-SQL SAMPLE 3
--
-- Backup Service master keys:
BACKUP SERVICE MASTER KEY TO FILE = 'localfilepath_or_UNC' ENCRYPTION BY PASSWORD = 'complexpassword';	

-- Backup individual database master keys:
BACKUP MASTER KEY TO FILE = 'localfilepath_or_UNC' ENCRYPTION BY PASSWORD = 'complexpassword';