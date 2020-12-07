-- This is a classification use case using a decision tree.

-- These statements help diagnose errors. Uncomment and place after
-- failing procedures when needed.
--
--   values idax.last_message_code;
--   values idax.last_message;

-- Drop old versions of objects that will be created here.

drop table crickets_train;
drop table crickets_test;
drop table crickets_result;
call idax.drop_model('model=CRICKETS_LINEAR_REGRESSION_MODEL');

-- Display summary statistics for the input columns in the base data table.
-- The columns in the table are either text or numeric (no datas, times,
-- or timestamps).

call idax.summary1000
(
  'intable=crickets,
   outtable=crickets_summary'
);

select * from crickets_summary;
select * from crickets_summary_num;

call idax.drop_summary1000('intable=crickets_summary');

-- The IDAX.SPLIT_DATA procedure will create the following two tables:
--  1) CRICKETS_TRAIN: Same definition as base table, with 95% of the rows.
--  2) CRICKETS_TEST: Same definition as base table, with 5% of the rows.

call idax.split_data
(
  'intable=CRICKETS,
   traintable=CRICKETS_TRAIN,
   testtable=CRICKETS_TEST,
   id=ID,
   fraction=0.95'
);

-- Verify output counts.

select count(*) from crickets;
select count(*) from crickets_train;
select count(*) from crickets_test;

-- Train the model. There are a number of optional parameters that can
-- be specified and adjusted but for simplicity I'm going with the defaults.

call idax.linear_regression
(
  'model=CRICKETS_LINEAR_REGRESSION_MODEL,
   intable=CRICKETS_TRAIN,
   id=ID,
   target=TEMPERATURE'
);

-- Print details about the model.

call idax.print_model('model=CRICKETS_LINEAR_REGRESSION_MODEL');

-- Score the held back test data. This will create a table called
-- CRICKETS_RESULT with two columns:
--  1) ID
--  2) TEMPERATURE (based on the model target specified above).

call idax.predict_linear_regression
(
  'model=CRICKETS_LINEAR_REGRESSION_MODEL,
   intable=CRICKETS_TEST,
   id=ID,
   outtable=CRICKETS_RESULT'
);

-- Query a sample of the results table.

select count(*) from crickets_result;
select * from crickets_result order by id fetch first 5 rows only;

-- Show both the actual value (from base table) and predicted value, just
-- to see how they compare.

select a.id,
       int(a.temperature) as actual,
       int(b.temperature) as predicted
  from crickets a, crickets_result b
  where a.id = b.id
  order by a.id;

-- Calculate the percent correct between the actual and predicted values from
-- the test table. This isn't a typical evaluation technique, it's just for
-- my own curiousity to see how different things are. It doesn't in any way
-- indicate how close things are... that's better determined by the common
-- evaluation approaches of mean absolute error (MAE) and mean squared error
-- (MSE), both of which are calculated below.

with different_count (num_different) as
       (select count(*)
        from crickets a, crickets_result b
        where a.id = b.id and int(a.temperature) <> int(b.temperature)),
     total_count (total_rows) as
       (select count(*)
        from crickets_test)
select total_rows,
       num_different,
       (num_different * 100 / total_rows) as percent_different
  from different_count,
       total_count;

-- Calculate the mean absolute error of the predictions.

call idax.mae
(
   'intable=CRICKETS_TEST,
    id=ID,
    target=TEMPERATURE,
    resulttable=CRICKETS_RESULT,
    resultid=ID,
    resulttarget=TEMPERATURE'
);

-- Calculate the mean squared error of the predictions.

call idax.mse
(
   'intable=CRICKETS_TEST,
    id=ID,
    target=TEMPERATURE,
    resulttable=CRICKETS_RESULT,
    resultid=ID,
    resulttarget=TEMPERATURE'
);
