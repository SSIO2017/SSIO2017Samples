/*
	Conversion
*/

-- FLOAT(53) is the same as FLOAT, mantissa size only specified as an example
DECLARE @int INT, @float53 FLOAT(53);

SET @float53 = CAST(25 AS FLOAT)/7;
SET @int = @float53;

-- Floating point value is truncated
SELECT @float53 'Float', @int 'Integer';

-- Default precision is 18, scale is 0
DECLARE @decimal DECIMAL(18, 6), @decimal6 DECIMAL(12, 2);

SET @decimal = @float53;
SET @decimal6 = CAST(@float53 AS FLOAT(6));

-- Floating point value is rounded
SELECT @float53 'Float', @decimal 'Decimal', @decimal6 'Decimal 6';

DECLARE @float53b FLOAT = (CAST(22 AS FLOAT) / 7) - 3;
-- Observe how precision increased
SELECT @float53b 'Float';

SET @decimal6 = @float53b;
-- Decimal with fewer than 17 precision rounds down to 0
SELECT @decimal6 'Decimal 6';