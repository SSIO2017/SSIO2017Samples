USE rowversion;
GO

CREATE TABLE Versioned (
	Id INT IDENTITY (1, 1) PRIMARY KEY CLUSTERED NOT NULL,
	Val NVARCHAR(20),
	vers ROWVERSION);

INSERT INTO Versioned (Val) VALUES
	('Value A'),
	('Value B');

SELECT *
FROM Versioned;

-- This is causing duplicate rowversion values within the same database
SELECT *
INTO Versioned2
FROM Versioned;

SELECT * FROM Versioned2
UNION ALL
SELECT * FROM Versioned;

-- This is NOT causing duplicate rowversion values
SELECT Id, Val
INTO Versioned3
FROM Versioned;

ALTER TABLE Versioned3 
	ADD vers ROWVERSION;

SELECT * FROM Versioned3
UNION ALL
SELECT * FROM Versioned;

CREATE DATABASE rowversion2;
GO
USE rowversion2;
CREATE TABLE Versioned (
	Id INT IDENTITY (1, 1) PRIMARY KEY CLUSTERED NOT NULL,
	Val NVARCHAR(20),
	vers ROWVERSION);

INSERT INTO Versioned (Val) VALUES
	('Value A'),
	('Value B');

SELECT *
FROM Versioned;

CREATE TABLE Versioned4 (
	Id INT IDENTITY(1, 1) PRIMARY KEY CLUSTERED NOT NULL,
	--vers ROWVERSION,
	IdPlus2 AS Id + 2,
	val NVARCHAR(20)
);

INSERT INTO Versioned4 VALUES ('Value C');

DROP TABLE Versioned4;