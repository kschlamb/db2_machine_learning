-- This is a classification use case using a decision tree.

-- These statements help diagnose errors. Uncomment and place after
-- failing procedures when needed.
--
--   values idax.last_message_code;
--   values idax.last_message;

-- Drop old versions of objects that will be created here.

drop table iris_train;
drop table iris_test;
drop table iris_result;
drop table iris_cmatrix;
call idax.drop_model('model=IRIS_TREE_MODEL');

-- Display summary statistics for the input columns in the base data table.
-- The columns in the table are either text or numeric (no datas, times,
-- or timestamps).

call idax.summary1000
(
  'intable=iris,
   outtable=iris_summary'
);

select * from iris_summary;
select * from iris_summary_num;
select * from iris_summary_char;

call idax.drop_summary1000('intable=iris_summary');

-- The IDAX.SPLIT_DATA procedure will create the following two tables:
--  1) IRIS_TRAIN: Same definition as base table, with 95% of the rows.
--  2) IRIS_TEST: Same definition as base table, with 5% of the rows.

call idax.split_data
(
  'intable=IRIS,
   traintable=IRIS_TRAIN,
   testtable=IRIS_TEST,
   id=ID,
   fraction=0.95'
);

-- Verify output counts.

select count(*) from iris;
select count(*) from iris_train;
select count(*) from iris_test;

-- Train the model. There are a number of optional parameters that can
-- be specified and adjusted but for simplicity I'm going with the defaults.

call idax.grow_dectree
(
  'model=IRIS_TREE_MODEL,
   intable=IRIS_TRAIN,
   id=ID,
   target=CLASS_NAME'
);

-- Print details about the model.

call idax.print_model('model=IRIS_TREE_MODEL');

-- Prune the tree. Pruning is a data compression technique that reduces the
-- size of the decision tree by removing sections of the tree that are
-- non-critical and redundant. Pruning reduces the complexity of the final
-- classifier, and can improve predictive accuracy by the reduction of
-- overfitting.

call idax.prune_dectree
(
  'model=IRIS_TREE_MODEL,
  valtable=IRIS_TEST'
);

-- Print details about the pruned model. This may be different from the
-- pre-pruning information shown above.

call idax.print_model('model=IRIS_TREE_MODEL');

-- Score the held back test data. This will create a table called IRIS_RESULT
-- with two columns:
--  1) ID
--  2) CLASS_NAME (based on the model target specified above).

call idax.predict_dectree
(
  'model=IRIS_TREE_MODEL,
   intable=IRIS_TEST,
   outtable=IRIS_RESULT,
   id=ID'
);

-- Query a sample of the results table.

select count(*) from iris_result;
select * from iris_result order by id fetch first 5 rows only;

-- Show both the actual value (from base table) and predicted value, just
-- to see how they compare.

select a.id,
       a.class_name as actual,
       b.class as predicted
  from iris a, iris_result b
  where a.id = b.id
  order by a.id;

-- Calculate the percent correct between the actual and predicted values from
-- the test table.

with different_count (num_different) as
       (select count(*)
        from iris a, iris_result b
        where a.id = b.id and a.class_name <> b.class),
     total_count (total_rows) as
       (select count(*)
        from iris_test)
select total_rows,
       num_different,
       (num_different * 100 / total_rows) as percent_different
  from different_count,
       total_count;

-- Calculate and show the confusion matrix.

call idax.confusion_matrix
(
  'intable=IRIS_TEST,
   id=ID,
   target=CLASS_NAME,
   resulttable=IRIS_RESULT,
   resultID=ID,
   resulttarget=CLASS,
   matrixTable=IRIS_CMATRIX'
);

select * from iris_cmatrix;
