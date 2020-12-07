#!/bin/bash

# This script creates a database in which the built-in machine learning
# routines can be used.

db2stop
db2set DB2_ENABLE_ML_PROCEDURES=YES
db2start
db2 -v create database testdb using codeset UTF-8 territory US pagesize 16384
db2 -v connect to testdb
db2 -v create tablespace ml_tbspc
db2 -v "call sysinstallobjects('IDAX', 'C', 'ML_TBSPC', null)"
db2 -v "grant use of tablespace ml_tbspc to public"
db2 -v connect reset
