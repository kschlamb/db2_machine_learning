-- Run command: db2 -tvf call_multiple_udf.sql

-- These first three calls should fail due to NULL input.
VALUES (MULTIPLY_UDF(NULL, NULL));
VALUES (MULTIPLY_UDF(NULL, 12));
VALUES (MULTIPLY_UDF(7, NULL));

-- These two calls should be successful.
VALUES (MULTIPLY_UDF(28, 347));
VALUES (MULTIPLY_UDF(-96, 42));
