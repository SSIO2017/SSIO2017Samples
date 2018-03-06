--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 6: ADMINISTERING SECURITY AND PERMISSIONS
-- T-SQL SAMPLE 1
--
SELECT DBUser_Name = dp.name
	, DBUser_SID = dp.sid
	, Login_Name = sp.name
	, Login_SID = sp.sid
	, SQLtext = 'ALTER USER [' + dp.name + '] WITH LOGIN = [' + ISNULL(sp.name, '???') + ']'
FROM sys.database_principals dp
	LEFT OUTER JOIN sys.server_principals sp ON dp.name = sp.name 
WHERE dp.is_fixed_role = 0
	AND sp.sid <> dp.sid 
	AND dp.principal_id > 1
	AND dp.sid <> 0x0
ORDER BY dp.name;