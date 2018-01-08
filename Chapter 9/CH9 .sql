--In Connection 1, execute the following TSQL code:
DROP TABLE IF EXISTS AnyTable;
CREATE TABLE AnyTable (
id INT NOT NULL IDENTITY(1,1) PRIMARY KEY
, ANumber INT NOT NULL );
GO
INSERT INTO AnyTable (ANumber) VALUES (1),(3);
GO 
BEGIN TRAN Update1;
UPDATE AnyTable 
SET ANumber = 4 where ANumber > 1;

--In Connection 2, execute the following TSQL code:
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
BEGIN TRAN Update2
UPDATE AnyTable WITH (UPDLOCK)
SET ANumber = 4 where ANumber > 1;

--Back in Connection 1, execute the following TSQL code:
COMMIT TRAN Update1

--Note that Connection 2 immediately fails, returning the following error message:
--Msg 3960, Level 16, State 2, Line 8
--Snapshot isolation transaction aborted due to update conflict. You cannot use snapshot isolation to access table 'dbo.AnyTable' directly or indirectly in database 'test' to update, delete, or insert the row that has been modified or deleted by another transaction. Retry the transaction or change the isolation level for the update/delete statement.
