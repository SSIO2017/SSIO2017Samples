--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 12: IMPLEMENTING HIGH AVAILABILITY AND DISASTER RECOVERY
-- T-SQL SAMPLE 6
--

-- Creating Pacemaker authentication and authorization

USE [master];
GO

CREATE LOGIN [pacemakerLogin] with PASSWORD = N'UseAReallyStrongMasterKeyPassword';
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [pacemakerLogin];

GRANT ALTER, CONTROL, VIEW DEFINITION
ON AVAILABILITY GROUP::LinuxAG1 TO pacemakerLogin;

GRANT VIEW SERVER STATE TO pacemakerLogin;
