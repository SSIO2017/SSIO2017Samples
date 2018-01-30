-- Turning on TDE on the WideWorldImporters database

USE master;
GO

-- Remember to back up this Database Master Key once it is created
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<UseAReallyStrongPassword>';
GO

CREATE CERTIFICATE WideWorldServerCert WITH SUBJECT = 'WWI DEK Certificate';
GO

USE WideWorldImporters;
GO

CREATE DATABASE ENCRYPTION KEY
    WITH ALGORITHM = AES_128
    ENCRYPTION BY SERVER CERTIFICATE WideWorldServerCert;
GO

ALTER DATABASE WideWorldImporters SET ENCRYPTION ON;  
GO
