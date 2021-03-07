-- Run command: db2 -tvf create_multiply_udf.sql

CREATE OR REPLACE FUNCTION MULTIPLY_UDF(INT, INT)
  RETURNS INT
  LANGUAGE PYTHON
  PARAMETER STYLE NPSGENERIC
  FENCED
  ALLOW PARALLEL
  NO EXTERNAL ACTION
  NO SQL
  EXTERNAL NAME '/home/db2inst1/db2_machine-learning/Sample_Db2_Python_UDFs/multiply/multiply_udf.py';
