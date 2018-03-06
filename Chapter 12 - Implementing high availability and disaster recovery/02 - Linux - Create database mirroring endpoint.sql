--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 12: IMPLEMENTING HIGH AVAILABILITY AND DISASTER RECOVERY
-- T-SQL SAMPLE 2
--

-- Setting up the database mirroring endpoint user and certificate

USE master;
GO

-- Create database mirroring endpoint user
CREATE LOGIN dbm_login WITH PASSWORD = '<UseAReallyStrongPassword>';

-- Create user for use by the database certificate later
CREATE USER dbm_user FOR LOGIN dbm_login;
GO

-- Create certificate
IF NOT EXISTS (SELECT * from sys.symmetric_keys
	WHERE name = '##MS_DatabaseMasterKey##')
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<UseAReallyStrongMasterKeyPassword>';

CREATE CERTIFICATE dbm_certificate WITH SUBJECT = 'dbm';

BACKUP CERTIFICATE dbm_certificate
    TO FILE = '/var/opt/mssql/data/dbm_certificate.cer'
    WITH PRIVATE KEY (
           FILE = '/var/opt/mssql/data/dbm_certificate.pvk',
           ENCRYPTION BY PASSWORD = '<UseAReallyStrongPrivateKeyPassword>'
    );
GO
