--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 5: PROVISIONING AZURE SQL DATABASE
-- T-SQL SAMPLE 1
--
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
