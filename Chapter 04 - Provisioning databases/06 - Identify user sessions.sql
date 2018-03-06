--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 4: PROVISIONING DATABASES
-- T-SQL SAMPLE 6
--
SELECT *
FROM sys.dm_exec_sessions
WHERE db_name(database_id) = 'w';