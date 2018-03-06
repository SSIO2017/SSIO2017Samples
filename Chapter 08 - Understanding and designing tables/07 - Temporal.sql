--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 8: UNDERSTANDING AND DESIGNING TABLES
-- T-SQL SAMPLE 7
--
-- ALL creates a union between the history and the current table
SELECT PersonID, FullName
    , CASE WHEN ValidTo = '9999-12-31 23:59:59.9999999' THEN 1
			ELSE 0 END 'IsCurrent'
FROM [Application].People
    FOR SYSTEM_TIME ALL
ORDER BY ValidFrom;

-- AS OF sub-clause returns all rows that were valid at one particular point
SELECT PersonID, FullName
    , CASE WHEN ValidTo = '9999-12-31 23:59:59.9999999' THEN 1
			ELSE 0 END 'IsCurrent'
FROM [Application].People
    FOR SYSTEM_TIME AS OF '2016-03-13'
ORDER BY ValidFrom;

-- FROM ... TO
SELECT PersonID, FullName
    , CASE WHEN ValidTo = '9999-12-31 23:59:59.9999999' THEN 1
			ELSE 0 END 'IsCurrent'
FROM [Application].People
    FOR SYSTEM_TIME FROM '2016-03-13' TO '2016-04-23'
ORDER BY ValidFrom;

-- BETWEEN ... AND
SELECT PersonID, FullName
    , CASE WHEN ValidTo = '9999-12-31 23:59:59.9999999' THEN 1
			ELSE 0 END 'IsCurrent'
FROM [Application].People
    FOR SYSTEM_TIME BETWEEN '2016-03-13' AND '2016-04-23'
ORDER BY ValidFrom;

-- CONTAINED IN
DECLARE @now DATETIME2 = SYSUTCDATETIME();
SELECT PersonID, FullName
    , CASE WHEN ValidTo = '9999-12-31 23:59:59.9999999' THEN 1
			ELSE 0 END 'IsCurrent'
FROM [Application].People
    FOR SYSTEM_TIME CONTAINED IN ('2016-03-13', @now)
ORDER BY ValidFrom;
