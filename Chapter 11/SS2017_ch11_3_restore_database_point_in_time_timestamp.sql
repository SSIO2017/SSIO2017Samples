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
