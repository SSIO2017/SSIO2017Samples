-- Backing up the DMK for the WideWorldImporters database

USE WideWorldImporters;
GO
BACKUP MASTER KEY TO FILE = 'c:\SecureLocation\wwi_database_master_key'
    ENCRYPTION BY PASSWORD = '<UseAReallyStrongPassword>';
GO  
