--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 13: MANAGING AND MONITORING SQL SERVER
-- T-SQL SAMPLE 15
--

-- Resource governor classifier script 
CREATE FUNCTION dbo.fnCLASSIFIER() RETURNS sysname 
WITH SCHEMABINDING AS
BEGIN
	-- Note that any request that does not get classified goes into the 'default' group.
	DECLARE @grp_name sysname
	IF (
		--Use built-in functions for connection string properties
		HOST_NAME() IN ('reportserver1','reportserver2')
		--OR APP_NAME() IN ('some application')
		--AND SUSER_SNAME() IN ('whateveruser')
	)      
	BEGIN
		SET @grp_name = 'GovGroupReports';
	END
	
	RETURN @grp_name
END;
GO

-- Register the classifier function with Resource Governor
ALTER RESOURCE GOVERNOR WITH (CLASSIFIER_FUNCTION= dbo.fnCLASSIFIER);

-- Query the status of Resource Governor and the name of the classifier function 
SELECT rgc.is_enabled, o.name
FROM sys.resource_governor_configuration AS rgc
	INNER JOIN master.sys.objects AS o ON rgc.classifier_function_id = o.object_id
	INNER JOIN master.sys.schemas AS s ON o.schema_id = s.schema_id;  

-- Create Pool and Group
CREATE RESOURCE POOL GovPoolMAXDOP1;
CREATE WORKLOAD GROUP GovGroupReports;
GO
ALTER RESOURCE POOL GovPoolMAXDOP1
WITH (-- MIN_CPU_PERCENT = value
     --,MAX_CPU_PERCENT = value
     --,MIN_MEMORY_PERCENT = value 
     MAX_MEMORY_PERCENT = 50 
);
GO

ALTER WORKLOAD GROUP GovGroupReports
WITH (
     --IMPORTANCE = { LOW | MEDIUM | HIGH } 
     --,REQUEST_MAX_CPU_TIME_SEC = value 
     --,REQUEST_MEMORY_GRANT_TIMEOUT_SEC = value 
     --,GROUP_MAX_REQUESTS = value 
     REQUEST_MAX_MEMORY_GRANT_PERCENT = 30
   , MAX_DOP = 1
)
USING GovPoolMAXDOP1;

-- Start or Reconfigure Resource Governor --Understand before enabling!!!
/*
ALTER RESOURCE GOVERNOR RECONFIGURE;
*/
GO

--Disable Resource Governor
ALTER RESOURCE GOVERNOR DISABLE;
GO

--Monitor Availability Groups
SELECT rgg.group_id
	, rgp.pool_id
	, Pool_Name = rgp.name
	, Group_Name = rgg.name
	, session_count= ISNULL(count(s.session_id) ,0)
FROM sys.dm_resource_governor_workload_groups AS rgg
	LEFT OUTER JOIN sys.dm_resource_governor_resource_pools AS rgp ON rgg.pool_id = rgp.pool_id
	LEFT OUTER JOIN sys.dm_exec_sessions AS s ON s.group_id = rgg.group_id
GROUP BY rgg.group_id, rgp.pool_id, rgg.name, rgp.name
ORDER BY rgg.name, rgp.name;
