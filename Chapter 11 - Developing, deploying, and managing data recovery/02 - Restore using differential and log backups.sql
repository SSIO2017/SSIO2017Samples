--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 11: DEVELOPING, DEPLOYING, AND MANAGING DATA RECOVERY
-- T-SQL SAMPLE 2
--

-- First, restore the full backup
RESTORE DATABASE [WideWorldImporters]
FROM
	DISK = N'C:\SQLData\Backup\SERVER_WideWorldImporters_FULL_20170918_210912.BAK'
WITH
	MOVE N'WideWorldImporters' TO N'C:\SQLData\WWI.mdf',
	MOVE N'WideWorldImporters_log' TO N'C:\SQLData\WWI.ldf',
	STATS = 5,
	NORECOVERY;
GO

-- Second, restore the most recent differential backup
RESTORE DATABASE [WideWorldImporters]
FROM
	DISK = N'C:\SQLData\Backup\SERVER_WideWorldImporters_DIFF_20170926_120100.BAK'
WITH
	STATS = 5,
	NORECOVERY;
GO

-- Finally, restore all transaction log backups after the differential
RESTORE LOG [WideWorldImporters]
FROM
	DISK = N'C:\SQLData\Backup\SERVER_WideWorldImporters_LOG_20170926_121500.BAK'
WITH
	STATS = 5,
	NORECOVERY;
GO
RESTORE LOG [WideWorldImporters]
FROM	
	DISK = N'C:\SQLData\Backup\SERVER_WideWorldImporters_LOG_20170926_123000.BAK'
WITH
	STATS = 5,
	NORECOVERY;
GO

-- Bring the database online
RESTORE LOG [WideWorldImporters] WITH RECOVERY;
GO
