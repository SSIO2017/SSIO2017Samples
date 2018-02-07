DROP TABLE IF EXISTS KeyTest;

CREATE TABLE NoKeyTest (
	Id INT);

CREATE TABLE KeyTest (
	Id INT,
	Val varchar(20),
	CONSTRAINT PK_KeyTest PRIMARY KEY (Id));

INSERT INTO KeyTest VALUES (1, 'One');

CREATE TABLE ForeignKeyTest (
	Id INT,
	KeyTestId INT,
	Val varchar(20),
	CONSTRAINT PK_ForeignKeyTest PRIMARY KEY (Id),
	CONSTRAINT FK_ForeignKeyTest_KeyTest FOREIGN KEY (KeyTestId) REFERENCES KeyTest (Id));

SELECT * FROM KeyTest;

INSERT INTO ForeignKeyTest VALUES (1, 1, 'One');

INSERT INTO ForeignKeyTest VALUES (2, 2, 'Two');

ALTER TABLE dbo.ForeignKeyTest
	NOCHECK CONSTRAINT FK_ForeignKeyTest_KeyTest;

INSERT INTO ForeignKeyTest VALUES (2, 2, 'Two');

SELECT * FROM ForeignKeyTest;
