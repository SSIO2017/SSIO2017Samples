--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 8: UNDERSTANDING AND DESIGNING TABLES
-- EXTRA T-SQL SAMPLE 4
--

DROP TABLE IF EXISTS HierarchyIdTest;

CREATE TABLE HierarchyIdTest (
    TestId INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	HId HIERARCHYID NOT NULL,
	TestValue NVARCHAR(20) NOT NULL
);

-- Insert a child without a parent
INSERT INTO HierarchyIdTest VALUES
	('/1/2/', 'Child w/out parent');
SELECT *, HId.ToString() 'Hierarchy'
FROM HierarchyIdTest;



-- Query the child withtout a parent as a descendant of the root?
SELECT *
FROM HierarchyIdTest
WHERE HId.IsDescendantOf('/') = 1;


-- Query the child without a parent as a descendant of the non-existing parent?
SELECT *
FROM HierarchyIdTest
WHERE HId.IsDescendantOf('/1/') = 1;

-- Create a duplicate hierarchyid value
INSERT INTO HierarchyIdTest VALUES
	('/3/1/', 'Duplicate 1'),
	('/3/1/', 'Duplicate 2');

-- Get all elements with value /3/1/
SELECT *, HId.ToString()
FROM HierarchyIdTest
WHERE HId = '/3/1/';

-- Create a child of /3/1/
INSERT INTO HierarchyIdTest VALUES
	('/3/1/1/', 'Duplicate''s child');
-- Get the child's parent
SELECT *, HId.ToString(), HId.GetAncestor(1).ToString()
FROM HierarchyIdTest
WHERE HId.GetAncestor(1) = '/3/1/';


