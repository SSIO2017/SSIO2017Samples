/*
	Sample script to accompany SQL Server 2017 Administration Inside Out
	
	(c) 2018, All rights reserved.
	
	Chapter 5: Provisioning Azure SQL Database
*/

-- Create a blank database on the current logical SQL Server
CREATE DATABASE Contoso COLLATE Latin1_General_CI_AS
    (EDITION = 'standard', SERVICE_OBJECTIVE = 'S0');
-- Create a copy of the Contoso database on the current logical SQL Server
CREATE DATABASE Contoso_copy AS COPY OF Contoso;

-- Set, modify, and delete a database-level firewall rule
EXEC sp_set_database_firewall_rule N'Headquarters', '1.2.3.4', '1.2.3.4';
EXEC sp_set_database_firewall_rule N'Headquarters', '1.2.3.4', '1.2.3.6';
EXEC sp_delete_database_firewall_rule N'Headquarters';

-- Create Azure AD user accounts
CREATE USER [l.penor@contoso.com] FROM EXTERNAL PROVIDER;
CREATE USER [Sales Managers] FROM EXTERNAL PROVIDER;
