--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 6: ADMINISTERING SECURITY AND PERMISSIONS
-- T-SQL SAMPLE 4
--
USE [master];
GO
CREATE LOGIN DenyPrincipal WITH PASSWORD = N'deny';
GO
GRANT CONNECT SQL TO DenyPrincipal;
ALTER LOGIN DenyPrincipal ENABLE;
GO
USE [WideWorldImporters];
GO
CREATE USER DenyPrincipal FOR LOGIN DenyPrincipal;
GO
CREATE TABLE dbo.DenyPrincipalTable (
	ID INT IDENTITY (1, 1) NOT NULL CONSTRAINT PK_DenyPrincipalTable PRIMARY KEY,
	Text1 VARCHAR(100) 
);
GO
INSERT INTO dbo.DenyPrincipalTable (Text1) VALUES ('test');
GO 3

CREATE VIEW dbo.denyview WITH SCHEMABINDING AS
SELECT DenyView = text1 FROM dbo.DenyPrincipalTable;
GO

GRANT SELECT ON dbo.DenyView TO [DenyPrincipal]
GO

--Check current user impersonation
SELECT ORIGINAL_LOGIN(), CURRENT_USER; 

EXECUTE AS USER = 'DenyPrincipal';
SELECT * FROM dbo.DenyPrincipalTable;
GO
REVERT;
-- Output:
-- Msg 229, Level 14, State 5, Line 41
-- The SELECT permission was denied on the object 'DenyPrincipalTable', database 'WideWorldImporters', schema 'dbo'.

EXECUTE AS USER = 'DenyPrincipal';
SELECT * FROM dbo.DenyView;
GO
REVERT;
-- Output:
-- DenyView
-- test
-- test
-- test
GO

CREATE PROC dbo.DenySproc AS
BEGIN
	SELECT DenySproc = text1 
	FROM dbo.DenyPrincipalTable;
END
GO

GRANT EXECUTE ON dbo.DenySproc TO [DenyPrincipal];
GO

EXECUTE AS USER = 'DenyPrincipal';
EXEC dbo.DenySproc;
GO
REVERT;
GO
-- Output:
-- DenySproc
-- test
-- test
-- test
GO

CREATE PROC dbo.DenySproc_adhoc 
AS
BEGIN
	DECLARE @sql nvarchar(1000)
	SELECT @sql = 'select ExecSproc_adhoc = text1 FROM dbo.DenyPrincipalTable';
	EXEC sp_executesql @SQL;
END
GO

GRANT EXECUTE ON dbo.DenySproc_adhoc TO [DenyPrincipal];
GO

EXECUTE AS USER = 'DenyPrincipal';
EXEC dbo.DenySproc_adhoc;
GO
REVERT;

-- Output:
-- Msg 229, Level 14, State 5, Line 75
-- The SELECT permission was denied on the object 'DenyPrincipalTable', database 'WideWorldImporters', schema 'dbo'.
GO

CREATE FUNCTION dbo.DenyFunc()
RETURNS TABLE
AS RETURN
	SELECT DenyFunc = Text1 
	FROM dbo.DenyPrincipalTable;
GO

GRANT SELECT ON DBO.DenyFunc TO [DENYUSER];
GO

EXECUTE AS USER = 'DenyPrincipal';
SELECT * FROM DenyFunc();
GO
REVERT;
GO

-- Output:
-- DenyFun
-- test
-- test
-- test

DENY SELECT ON dbo.DenyPrincipalTable TO [DenyPrincipal];
GO
EXECUTE AS USER = 'DenyPrincipal';

-- Test the view 
SELECT * FROM dbo.denyview; 
GO
-- Test the stored procedure
EXEC dbo.DenySproc; 
GO

-- Test the function
SELECT * FROM DenyFunc();
GO
REVERT;
GO

-- Output:
-- DenyView
-- test
-- test
-- test
-- DenySproc
-- test
-- test
-- test
-- DenyFunc
-- test
-- test
-- test