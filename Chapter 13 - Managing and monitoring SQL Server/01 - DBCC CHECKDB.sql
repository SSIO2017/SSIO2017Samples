--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 13: MANAGING AND MONITORING SQL SERVER
-- T-SQL SAMPLE 1
--

DBCC CHECKDB 

/* --Not recommended!!!
ALTER DATABASE WorldWideImporters SET EMERGENCY, SINGLE_USER;
DBCC CHECKDB('WideWorldImporters', REPAIR_ALLOW_DATA_LOSS);
ALTER DATABASE WorldWideImporters SET MULTI_USER;
*/

/* --Rebuild transaction log
ALTER DATABASE WorldWideImporters SET EMERGENCY, SINGLE_USER;
ALTER DATABASE WorldWideImporters REBUILD LOG ON (NAME=WWI_Log, FILENAME='F:\DATA\WideWorldImporters_new.ldf');
ALTER DATABASE WorldWideImporters SET MULTI_USER;
*/