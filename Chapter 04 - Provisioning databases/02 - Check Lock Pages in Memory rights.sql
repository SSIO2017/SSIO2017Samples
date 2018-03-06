--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 4: PROVISIONING DATABASES
-- T-SQL SAMPLE 2
--
SELECT sql_memory_model_Desc 
FROM sys.dm_os_sys_info 

-- Output interpretation:
-- Conventional = Lock Pages in Memory privilege is not granted
-- LOCK_PAGES = Lock Pages in Memory privilege is granted
-- LARGE_PAGES = Lock Pages in Memory privilege is granted in Enterprise mode with Trace Flag 834 ON
