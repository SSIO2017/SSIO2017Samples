--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 6: ADMINISTERING SECURITY AND PERMISSIONS
-- T-SQL SAMPLE 5
--
ALTER SERVER ROLE serveradmin ADD MEMBER [domain\katie.sql];
GO
ALTER SERVER ROLE processadmin DROP MEMBER [domain\katie.sql];
GO

USE Master;
GO
CREATE LOGIN [domain\katie.sql] FROM WINDOWS;
GO
GRANT CONTROL SERVER TO [domain\katie.sql] ;
DENY VIEW SERVER STATE TO [domain\katie.sql];
GO

EXECUTE AS LOGIN = 'domain\katie.sql';
SELECT * FROM sys.dm_exec_cached_plans;
GO
REVERT;
GO

-- Output:
-- Msg 300, Level 14, State 1, Line 7
-- VIEW SERVER STATE permission was denied on object 'server', database 'master'.
-- Msg 297, Level 16, State 1, Line 7
-- The user does not have permission to perform this action.