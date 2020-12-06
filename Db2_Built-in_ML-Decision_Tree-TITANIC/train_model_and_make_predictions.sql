-- This is a classification use case using a decision tree.

-- These statements help diagnose errors. Uncomment and place after
-- failing procedures when needed.
--
--   values idax.last_message_code;
--   values idax.last_message;

-- Drop old versions of objects that will be created here.

drop table titanic_train;
drop table titanic_test;
drop table titanic_result;
drop table titanic_cmatrix;
call idax.drop_model('model=TITANIC_TREE_MODEL');

-- Display summary statistics for the input columns in the base data table.
-- The columns in the table are either text or numeric (no datas, times,
-- or timestamps).

call idax.summary1000
(
  'intable=titanic,
   outtable=titanic_summary'
);

select * from titanic_summary;
select * from titanic_summary_num;
select * from titanic_summary_char;

call idax.drop_summary1000('intable=titanic_summary');

-- The IDAX.SPLIT_DATA procedure will create the following two tables:
--  1) TITANIC_TRAIN: Same definition as base table, with 95% of the rows.
--  2) TITANIC_TEST: Same definition as base table, with 5% of the rows.

call idax.split_data
(
  'intable=TITANIC,
   traintable=TITANIC_TRAIN,
   testtable=TITANIC_TEST,
   id=PASSENGER_ID,
   fraction=0.95'
);

-- Verify output counts.

select count(*) from titanic;
select count(*) from titanic_train;
select count(*) from titanic_test;

-- Train the model. There are a number of optional parameters that can
-- be specified and adjusted but for simplicity I'm going with the defaults.
-- The target, SURVIVED, is a numeric value, which has a type of "continuous"
-- by default. It needs to be a nominal value, which it is, and so we have
-- to explicitly tag it as such.

call idax.grow_dectree
(
  'model=TITANIC_TREE_MODEL,
   intable=TITANIC_TRAIN,
   id=PASSENGER_ID,
   target=SURVIVED,
   incolumn=SURVIVED:nom'
);

-- Print details about the model.

call idax.print_model('model=TITANIC_TREE_MODEL');

-- Prune the tree. Pruning is a data compression technique that reduces the
-- size of the decision tree by removing sections of the tree that are
-- non-critical and redundant. Pruning reduces the complexity of the final
-- classifier, and can improve predictive accuracy by the reduction of
-- overfitting.

call idax.prune_dectree
(
  'model=TITANIC_TREE_MODEL,
  valtable=TITANIC_TEST'
);

-- Print details about the pruned model. This may be different from the
-- pre-pruning information shown above.

call idax.print_model('model=TITANIC_TREE_MODEL');

-- Score the held back test data. This will create a table called
-- TITANIC_RESULT with two columns:
--  1) ID
--  2) SURVIVED (based on the model target specified above).

call idax.predict_dectree
(
  'model=TITANIC_TREE_MODEL,
   intable=TITANIC_TEST,
   outtable=TITANIC_RESULT,
   id=PASSENGER_ID'
);

-- Query a sample of the results table.

select count(*) from titanic_result;
select * from titanic_result order by id fetch first 5 rows only;

-- Show both the actual value (from base table) and predicted value, just
-- to see how they compare.

select a.passenger_id,
       a.survived as actual,
       b.class as predicted
  from titanic a, titanic_result b
  where a.passenger_id = b.id
  order by a.passenger_id;

-- Calculate the percent correct between the actual and predicted values from
-- the test table.

with different_count (num_different) as
       (select count(*)
        from titanic a, titanic_result b
        where a.passenger_id = b.id and a.survived <> b.class),
     total_count (total_rows) as
       (select count(*)
        from titanic_test)
select total_rows,
       num_different,
       (num_different * 100 / total_rows) as percent_different
  from different_count,
       total_count;

-- Calculate and show the confusion matrix.

call idax.confusion_matrix
(
  'intable=TITANIC_TEST,
   id=PASSENGER_ID,
   target=SURVIVED,
   resulttable=TITANIC_RESULT,
   resultID=ID,
   resulttarget=CLASS,
   matrixTable=TITANIC_CMATRIX'
);

select * from titanic_cmatrix;

-- Calculate accuracy, precision, and recall:
--
--  True positive (TP): Actual = 1, Predicted = 1
--  True negative (TN): Actual = 0, Predicted = 0
--  False positive (FP): Actual = 0, Predicted = 1
--  False negative (FN): Actual = 1, Predicted = 0
--
--  Accuracy:   ((TP + TN) / (TP + TN + FP + FN))
--  Precision:  (TP / (TP + FP))
--  Recall:     (TP / (TP + FN))

with tptab(tp) as (select dec(cnt) from titanic_cmatrix where real = 1 and prediction = 1),
     tntab(tn) as (select dec(cnt) from titanic_cmatrix where real = 0 and prediction = 0),
     fptab(fp) as (select dec(cnt) from titanic_cmatrix where real = 0 and prediction = 1),
     fntab(fn) as (select dec(cnt) from titanic_cmatrix where real = 1 and prediction = 0)
  select ((tp + tn) / (tp + tn + fp + fn)) as accuracy from tptab, tntab, fptab, fntab;

with tptab(tp) as (select dec(cnt) from titanic_cmatrix where real = 1 and prediction = 1),
     tntab(tn) as (select dec(cnt) from titanic_cmatrix where real = 0 and prediction = 0),
     fptab(fp) as (select dec(cnt) from titanic_cmatrix where real = 0 and prediction = 1),
     fntab(fn) as (select dec(cnt) from titanic_cmatrix where real = 1 and prediction = 0)
  select (tp / (tp + fp)) as precision from tptab, tntab, fptab, fntab;

with tptab(tp) as (select dec(cnt) from titanic_cmatrix where real = 1 and prediction = 1),
     tntab(tn) as (select dec(cnt) from titanic_cmatrix where real = 0 and prediction = 0),
     fptab(fp) as (select dec(cnt) from titanic_cmatrix where real = 0 and prediction = 1),
     fntab(fn) as (select dec(cnt) from titanic_cmatrix where real = 1 and prediction = 0)
  select (tp / (tp + fn)) as recall from tptab, tntab, fptab, fntab;
