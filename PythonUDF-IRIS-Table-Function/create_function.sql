create or replace function iris_table_udf(float, float, float, float)
  returns table (species char(10), probability float)
  returns null on null input
  parameter style npsgeneric
  language python
  no sql
  fenced
  not threadsafe
  disallow parallel
  no dbinfo
  deterministic
  no external action
  no final call
  external name '/home/db2inst1/db2_machine_learning/PythonUDF-IRIS-Table-Function/iris_table_udf.py';
