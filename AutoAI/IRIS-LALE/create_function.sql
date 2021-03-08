create or replace function iris_autoai_predict(float, float, float, float)
  returns char(100)
  returns null on null input
  parameter style npsgeneric
  language python
  no sql
  external name '/home/db2inst1/db2_machine_learning/AutoAI/IRIS-LALE/iris_udf.py';
