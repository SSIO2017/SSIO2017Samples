--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 7: SECURING THE SERVER AND ITS DATA
-- T-SQL SAMPLE 5
--

-- Creating a server audit specification
USE [master];
GO

-- Create the server audit specification.
CREATE SERVER AUDIT SPECIFICATION Server_Audit
FOR SERVER AUDIT Sales_Security_Audit
    ADD (SERVER_OPERATION_GROUP),
    ADD (LOGOUT_GROUP),
    ADD (DATABASE_OPERATION_GROUP),
WITH (STATE = ON);
GO