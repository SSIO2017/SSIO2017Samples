--##############################################################################
--
-- SAMPLE SCRIPTS TO ACCOMPANY "SQL SERVER 2017 ADMINISTRATION INSIDE OUT"
--
-- © 2018 MICROSOFT PRESS
--
--##############################################################################
--
-- CHAPTER 8: UNDERSTANDING AND DESIGNING TABLES
-- T-SQL SAMPLE 1
--

-- Define the variables
DECLARE @point1 GEOMETRY,
	@point2 GEOMETRY,
	@distance FLOAT;

-- Initialize the geometric points
SET @point1 = geometry::STGeomFromText('POINT( 0  0)', 0);
SET @point2 = geometry::STGeomFromText('POINT(10 10)', 0);

-- Calculate the distance
SET @distance = @point1.STDistance(@point2);
SELECT @distance;

SELECT * FROM sys.spatial_reference_systems