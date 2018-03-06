--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 12: IMPLEMENTING HIGH AVAILABILITY AND DISASTER RECOVERY
-- T-SQL SAMPLE 5
--

-- Creating the availability group with three synchronous replicas

CREATE AVAILABILITY GROUP [LinuxAG1]
    WITH (DB_FAILOVER = ON, CLUSTER_TYPE = EXTERNAL)
    FOR REPLICA ON
        N'server1' 
         WITH (
            ENDPOINT_URL = N'tcp://server1:5022',
            AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
            FAILOVER_MODE = EXTERNAL,
            SEEDING_MODE = AUTOMATIC
            ),
        N'server2' 
         WITH ( 
            ENDPOINT_URL = N'tcp://server2:5022', 
            AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
            FAILOVER_MODE = EXTERNAL,
            SEEDING_MODE = AUTOMATIC
            ),
        N'server3'
        WITH( 
           ENDPOINT_URL = N'tcp://server3:5022', 
           AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
           FAILOVER_MODE = EXTERNAL,
           SEEDING_MODE = AUTOMATIC
           );
GO

ALTER AVAILABILITY GROUP [LinuxAG1] GRANT CREATE ANY DATABASE;
GO
