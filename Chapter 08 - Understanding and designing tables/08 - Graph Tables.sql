--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 8: UNDERSTANDING AND DESIGNING TABLES
-- T-SQL SAMPLE 8
--
CREATE TABLE People (
    PersonId INT NOT NULL PRIMARY KEY CLUSTERED,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL
) AS NODE;

CREATE TABLE Relationships (
    RelationshipType NVARCHAR(50) NOT NULL
) AS EDGE;

-- Insert a few sample people
-- $node_id is implicit and skipped
INSERT INTO People VALUES
	(1, 'Karina', 'Jakobsen'),
	(2, 'David', 'Hamilton'),
	(3, 'James', 'Hamilton');

-- Insert a few sample relationships
-- The first sub-select retrieves the $node_id of the from_node
-- The second sub-select retrieves the $node_id of the to node
INSERT INTO Relationships VALUES
	((SELECT $node_id FROM People WHERE PersonId = 1),
	 (SELECT $node_id FROM People WHERE PersonId = 2),
	 'spouse'),
	((SELECT $node_id FROM People WHERE PersonId = 2),
	 (SELECT $node_id FROM People WHERE PersonId = 3),
	 'father');

-- Simple graph query
SELECT P1.FirstName + ' is the ' + R.RelationshipType +
	' of ' + P2.FirstName + '.'
FROM People P1, People P2, Relationships R
WHERE MATCH(P1-(R)->P2);