--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 14: AUTOMATING SQL SERVER ADMINISTRATION
-- T-SQL SAMPLE 4
--

-- Add as step 1 on every AAG-aware job
IF NOT EXISTS (SELECT @@SERVERNAME, *
	FROM sys.dm_hadr_availability_replica_states  rs
	INNER JOIN sys.availability_databases_cluster dc ON rs.group_id = dc.group_id
	WHERE is_local = 1
		AND role_desc = 'PRIMARY'
		-- Any databases in the same Availability Group
		AND dc.database_name in (N'databasename1', N'databasename2') 
)
BEGIN
	PRINT 'local SQL instance is not primary, skipping';
	THROW 50000, 'Do not continue', 1;
END;
