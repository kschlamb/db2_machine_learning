-- Run command: db2 -tvf create_add_udf.sql

create or replace function add_udf(integer, integer)
  returns integer
  language python
  parameter style npsgeneric
  fenced
  returns null on null input
  no sql
  external name '/home/db2inst1/db2_machine_learning/Sample_Db2_Python_UDFs/add/add_udf.py';
