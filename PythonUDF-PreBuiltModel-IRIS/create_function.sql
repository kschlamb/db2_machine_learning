-- Run command: db2 -tvf create_function.sh

CONNECT TO TESTDB;

CREATE OR REPLACE FUNCTION IRIS_DECTREE_PREDICT(FLOAT, FLOAT, FLOAT, FLOAT)
  RETURNS CHAR(60)
  LANGUAGE PYTHON
  parameter style NPSGENERIC
  FENCED
  ALLOW PARALLEL
  NO EXTERNAL ACTION
  RETURNS NULL ON NULL INPUT
  NO SQL
  external name '/home/db2inst1/db2_machine-learning/PythonUDF-PreBuiltModel-IRIS/iris_scoring_udf.py';

CONNECT RESET;
