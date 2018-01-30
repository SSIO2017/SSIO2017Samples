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
