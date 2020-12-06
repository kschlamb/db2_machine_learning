-- This is a classification use case using a decision tree.

-- These statements help diagnose errors. Uncomment and place after
-- failing procedures when needed.
--
--   values idax.last_message_code;
--   values idax.last_message;

-- Drop old versions of objects that will be created here.

drop table abalone_train;
drop table abalone_test;
drop table abalone_result;
call idax.drop_model('model=ABALONE_LINEAR_REGRESSION_MODEL');

-- Display summary statistics for the input columns in the base data table.
-- The columns in the table are either text or numeric (no datas, times,
-- or timestamps).

call idax.summary1000
(
  'intable=abalone,
   outtable=abalone_summary'
);

select * from abalone_summary;
select * from abalone_summary_num;
select * from abalone_summary_char;

call idax.drop_summary1000('intable=abalone_summary');

-- The IDAX.SPLIT_DATA procedure will create the following two tables:
--  1) ABALONE_TRAIN: Same definition as base table, with 95% of the rows.
--  2) ABALONE_TEST: Same definition as base table, with 5% of the rows.

call idax.split_data
(
  'intable=ABALONE,
   traintable=ABALONE_TRAIN,
   testtable=ABALONE_TEST,
   id=ID,
   fraction=0.95'
);

-- Verify output counts.

select count(*) from abalone;
select count(*) from abalone_train;
select count(*) from abalone_test;

-- Train the model. There are a number of optional parameters that can
-- be specified and adjusted but for simplicity I'm going with the defaults.

call idax.linear_regression
(
  'model=ABALONE_LINEAR_REGRESSION_MODEL,
   intable=ABALONE_TRAIN,
   id=ID,
   target=RINGS'
);

-- Print details about the model.

call idax.print_model('model=ABALONE_LINEAR_REGRESSION_MODEL');

-- Score the held back test data. This will create a table called
-- ABALONE_RESULT with two columns:
--  1) ID
--  2) RINGS (based on the model target specified above).

call idax.predict_linear_regression
(
  'model=ABALONE_LINEAR_REGRESSION_MODEL,
   intable=ABALONE_TEST,
   id=ID,
   outtable=ABALONE_RESULT'
);

-- Query a sample of the results table.

select count(*) from abalone_result;
select * from abalone_result order by id fetch first 5 rows only;

-- Show both the actual value (from base table) and predicted value, just
-- to see how they compare.

select a.id,
       a.rings as actual,
       int(b.rings) as predicted
  from abalone a, abalone_result b
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
        from abalone a, abalone_result b
        where a.id = b.id and a.rings <> int(b.rings)),
     total_count (total_rows) as
       (select count(*)
        from abalone_test)
select total_rows,
       num_different,
       (num_different * 100 / total_rows) as percent_different
  from different_count,
       total_count;

-- Calculate the mean absolute error of the predictions.

call idax.mae
(
   'intable=ABALONE_TEST,
    id=ID,
    target=RINGS,
    resulttable=ABALONE_RESULT,
    resultid=ID,
    resulttarget=RINGS'
);

-- Calculate the mean squared error of the predictions.

call idax.mse
(
   'intable=ABALONE_TEST,
    id=ID,
    target=RINGS,
    resulttable=ABALONE_RESULT,
    resultid=ID,
    resulttarget=RINGS'
);
