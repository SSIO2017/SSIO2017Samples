--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 11: DEVELOPING, DEPLOYING, AND MANAGING DATA RECOVERY
-- T-SQL SAMPLE 3
--

-- Restore point in time using timestamp
RESTORE LOG [WideWorldImporters]
FROM
	DISK = N'C:\SQLData\Backup\SERVER_WideWorldImporters_LOG_20170926_123000.BAK'
WITH
	STOPAT = 'Sep 26, 2017 12:28 AM',
	STATS = 5,
	RECOVERY;
GO
-- Or restore point in time using LSN
-- Assume that this LSN is where the bad thing happened
RESTORE LOG [WideWorldImporters]
FROM DISK = N'C:\SQLData\Backup\SERVER_WideWorldImporters_LOG_20170926_123000.BAK'
WITH
	STOPBEFOREMARK = 'lsn:0x0000029f:00300212:0002',
	STATS = 5,
	RECOVERY;
GO
