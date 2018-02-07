/*
	DATABASE HAS
	- 3 FILEGROUPS: PRIMARY, FILEGROUP2, FILEGROUP3
*/

USE master;
GO

-- Replace 'C:\SQLData\Data\' with your data file path
CREATE DATABASE HorizPart
	-- Primary filegroup, for non-partitioned data
    ON        PRIMARY      (NAME = 'NonPart', FILENAME = 'C:\SQLData\Data\HorizPart.mdf'), 
	-- 3 filegroups for partitioned data
    FILEGROUP FILEGROUP2 (NAME = 'HorizPart1', FILENAME = 'C:\SQLData\Data\HorizPart1.ndf'), 
    FILEGROUP FILEGROUP3 (NAME = 'HorizPart2', FILENAME = 'C:\SQLData\Data\HorizPart2.ndf'),
    FILEGROUP FILEGROUP4 (NAME = 'HorizPart3', FILENAME = 'C:\SQLData\Data\HorizPart3.ndf')
	-- Log file
    LOG ON               (NAME = 'HorizPart_log', FILENAME = 'C:\SQLData\Data\HorizPart.ldf');
GO

USE HorizPart;
GO

/*
	SET UP PARTITIONING
*/
-- Create a partition function for February 1, 2017 through January 1, 2018
CREATE PARTITION FUNCTION MonthPartitioningFx (datetime2)
    -- Store the boundary values in the right partition
    AS RANGE RIGHT
	-- Each month is defined by its first day (the boundary value)
	FOR VALUES ('20170201', '20170301', '20170401',
        '20170501', '20170601', '20170701', '20170801',
        '20170901', '20171001', '20171101', '20171201', '20180101');

-- Create a partition scheme using the partition function
-- Place each trimester on its own partition
-- The most recent of the 13 months goes in the latest partition
CREATE PARTITION SCHEME MonthPartitioningScheme
    AS PARTITION MonthPartitioningFx
    TO (FILEGROUP2, FILEGROUP2, FILEGROUP2, FILEGROUP2,
        FILEGROUP3, FILEGROUP3, FILEGROUP3, FILEGROUP3,
        FILEGROUP4, FILEGROUP4, FILEGROUP4, FILEGROUP4, FILEGROUP4);

-- Create a partitioned table
CREATE TABLE 

-- Verify partitions
SELECT * FROM sys.dm_db_partition_stats;
SELECT * FROM sys.partitions;