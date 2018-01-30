-- Creating Pacemaker authentication and authorization

USE [master];
GO

CREATE LOGIN [pacemakerLogin] with PASSWORD = N'UseAReallyStrongMasterKeyPassword';
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [pacemakerLogin];

GRANT ALTER, CONTROL, VIEW DEFINITION
ON AVAILABILITY GROUP::LinuxAG1 TO pacemakerLogin;

GRANT VIEW SERVER STATE TO pacemakerLogin;
