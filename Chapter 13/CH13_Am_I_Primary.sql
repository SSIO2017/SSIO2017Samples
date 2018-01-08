
--add as step 1 on every AAG-aware job
IF NOT EXISTS (
SELECT @@SERVERNAME, *
   FROM sys.dm_hadr_availability_replica_states  rs
   inner join sys.availability_databases_cluster dc
   on rs.group_id = dc.group_id
   WHERE is_local = 1
   and role_desc = 'PRIMARY'
   and dc.database_name in (N'databasename1', N'databasename2') --Any databases in the same Availability Group
)
  BEGIN

	print 'local SQL instance is not primary, skipping';
	throw 50000, 'Do not continue', 1;

  END;
