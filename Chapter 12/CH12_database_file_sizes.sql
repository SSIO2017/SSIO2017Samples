--View space inside the current database's data and log files
SELECT 
  DB = d.name
, d.recovery_model_desc
, Logical_File_Name = df.name
, Physical_File_Loc = df.physical_name
, df.File_ID
, df.type_desc
, df.state_desc
-- multiple # of pages by 8 to get KB, divide by 1024 to get MB
, FileSizeMB = size*8/1024.0 
, SpaceUsedMB = FILEPROPERTY(df.name, 'SpaceUsed')*8/1024.0
, AvailableMB =  size*8/1024.0 
  - CAST(FILEPROPERTY(df.name, 'SpaceUsed') AS int)*8/1024.0 
, 'Free%' = (((size*8/1024.0 ) 
  - (CAST(FILEPROPERTY(df.name, 'SpaceUsed') AS int)*8/1024.0 )) 
  / (size*8/1024.0 )) * 100.0
FROM sys.master_files df 
INNER JOIN sys.databases d
ON d.database_id = df.database_id
WHERE d.database_id = DB_ID();


--Find autogrowth events in recent history, using the default system trace
SELECT 
 DB = g.DatabaseName
, Logical_File_Name = mf.name
, Physical_File_Loc = mf.physical_name
, mf.type_desc
-- The size in MB (CONVERTed from the number of 8KB pages) the file increased.
, EventGrowth_MB = CONVERT(decimal(19,2),g.IntegerData*8/1024.) 
, g.StartTime --Time of the autogrowth event
-- Length of time (in seconds) necessary to extend the file.
, Event_Duration_s = CONVERT(decimal(19,2),g.Duration/1000./1000.) 
, Current_Auto_Growth_Set= CASE WHEN mf.is_percent_growth = 1 THEN CONVERT(char(2), mf.growth) + '%' ELSE CONVERT(varchar(30), mf.growth*8./1024.) + 'MB' END
, Current_File_Size_MB = CONVERT(decimal(19,2),mf.size*	8./1024.)
, d.recovery_model_desc
FROM fn_trace_gettable((select substring((SELECT path FROM sys.traces WHERE is_default =1), 0, charindex('\log_', (SELECT path FROM sys.traces WHERE is_default =1),0)+4)	+ '.trc'), default) g
INNER JOIN sys.master_files mf
ON mf.database_id = g.DatabaseID
AND g.FileName = mf.name
INNER JOIN sys.databases d
ON d.database_id = g.DatabaseID
ORDER BY StartTime desc;

--Find autogrwoth events using a new XEvents session
CREATE EVENT SESSION [autogrowths] ON SERVER 
ADD EVENT sqlserver.database_file_size_change(
    ACTION(package0.collect_system_time,sqlserver.database_id,sqlserver.database_name,sqlserver.sql_text)),
ADD EVENT sqlserver.databases_log_file_size_changed(
    ACTION(package0.collect_system_time,sqlserver.database_id,sqlserver.database_name,sqlserver.sql_text))
ADD TARGET package0.event_file(SET filename=N'F:\DATA\autogrowths.xel'),
ADD TARGET package0.histogram(SET filtering_event_name=N'sqlserver.database_file_size_change',source=N'database_name',source_type=(0))
WITH (STARTUP_STATE=ON);

--Shrink and grow a transaction log file for optimal VLF alignent
--Take a transaction log backup first to empty the log file as much as possible
DBCC SHRINKFILE (N'WWI_Log' , 0, TRUNCATEONLY); --TRUNCATEONLY returns all free space to the operating system
GO
USE [master];
ALTER DATABASE [WideWorldImporters] MODIFY FILE ( NAME = N'WWI_Log', SIZE = 8192000KB );
ALTER DATABASE [WideWorldImporters] MODIFY FILE ( NAME = N'WWI_Log', SIZE = 9437184KB );
GO




