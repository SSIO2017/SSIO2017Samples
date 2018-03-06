--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 4: PROVISIONING DATABASES
-- T-SQL SAMPLE 1
--
SELECT servicename, instant_file_initialization_enabled 
FROM sys.dm_server_services
WHERE filename LIKE '%sqlservr.exe%'