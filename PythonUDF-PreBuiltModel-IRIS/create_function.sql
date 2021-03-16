create or replace function iris_dectree_predict(float, float, float, float)
  returns char(10)
  returns null on null input
  parameter style npsgeneric
  language python
  no sql
  fenced
  external name '/home/db2inst1/db2_machine_learning/PythonUDF-PreBuiltModel-IRIS/iris_udf.py';
