create or replace function iris_udf(float, float, float, float)
  returns char(10)
  returns null on null input
  parameter style npsgeneric
  language python
  no sql
  external name '/home/db2inst1/db2_machine_learning/PythonUDF-PreBuiltModel-IRIS-with-Trigger/iris_udf.py';
