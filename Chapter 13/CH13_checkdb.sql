DBCC CHECKDB 


/* --Not recommended!!!
ALTER DATABASE WorldWideImporters SET EMERGENCY, SINGLE_USER;
DBCC CHECKDB('WideWorldImporters', REPAIR_ALLOW_DATA_LOSS);
ALTER DATABASE WorldWideImporters SET MULTI_USER;
*/

/* --Rebuild trasnaction log
ALTER DATABASE WorldWideImporters SET EMERGENCY, SINGLE_USER;
ALTER DATABASE WorldWideImporters REBUILD LOG ON (NAME=WWI_Log, FILENAME='F:\DATA\WideWorldImporters_new.ldf');
ALTER DATABASE WorldWideImporters SET MULTI_USER;
*/