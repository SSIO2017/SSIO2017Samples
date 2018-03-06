--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 6: ADMINISTERING SECURITY AND PERMISSIONS
-- T-SQL SAMPLE 6
--

-- Create a new custom server role
CREATE SERVER ROLE SupportViewServer;
GO

-- Grant permissions to the custom server role
-- Run DMVs, see server information
GRANT VIEW SERVER STATE TO SupportViewServer;

-- See metadata of any database
GRANT VIEW ANY DATABASE TO SupportViewServer; 

-- Set context to any database
GRANT CONNECT ANY DATABASE TO SupportViewServer; 

-- Permission to SELECT from any data object in any databases 
GRANT SELECT ALL USER SECURABLES TO SupportViewServer; 
GO

--Add the DBA team's accounts
ALTER SERVER ROLE SupportViewServer ADD MEMBER [domain\Katherine];
ALTER SERVER ROLE SupportViewServer ADD MEMBER [domain\Colby];
ALTER SERVER ROLE SupportViewServer ADD MEMBER [domain\David];
