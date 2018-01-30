RESTORE DATABASE [WideWorldImporters]
FROM
	DISK = N'C:\SQLData\Backup\SERVER_WideWorldImporters_FULL_20170918_210912.BAK'
WITH
	MOVE N'WideWorldImporters' TO N'C:\SQLData\WWI.mdf',
	MOVE N'WideWorldImporters_log' TO N'C:\SQLData\WWI.ldf',
	STATS = 5,
	RECOVERY;
GO
