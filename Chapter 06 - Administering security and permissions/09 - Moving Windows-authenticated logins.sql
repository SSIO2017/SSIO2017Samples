--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 6: ADMINISTERING SECURITY AND PERMISSIONS
-- T-SQL SAMPLE 9
--

-- Create windows logins
SELECT
	CreateTSQL_Source = 'CREATE LOGIN [' + name + '] FROM WINDOWS WITH DEFAULT_DATABASE = [' + default_database_name + '], DEFAULT_LANGUAGE = [' + default_language_name + ']'
FROM sys.server_principals
WHERE type IN ('U','G')
	AND name NOT LIKE 'NT %'
	AND is_disabled = 0
ORDER BY name, type_desc;