--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 4: PROVISIONING DATABASES
-- T-SQL SAMPLE 5
--
ALTER DATABASE databasename SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--...
ALTER DATABASE databasename SET MULTI_USER;
