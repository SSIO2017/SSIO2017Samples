--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 7: SECURING THE SERVER AND ITS DATA
-- T-SQL SAMPLE 4
--

-- Creating a server audit and setting it active
USE master;
GO

-- Create the server audit.
CREATE SERVER AUDIT Sales_Security_Audit
    TO FILE (FILEPATH = 'C:\SalesAudit');
GO  

-- Enable the server audit.
ALTER SERVER AUDIT Sales_Security_Audit
    WITH (STATE = ON);
GO