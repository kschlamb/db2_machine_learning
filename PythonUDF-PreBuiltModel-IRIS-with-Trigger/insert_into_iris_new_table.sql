-- Insert flower measurements into the new table. The trigger will automatically
-- determine the species type and insert it into the table at the same time.

insert into iris_new (sepal_length, sepal_width, petal_length, petal_width) values (4.8, 3.0, 1.4, 0.1);
insert into iris_new (sepal_length, sepal_width, petal_length, petal_width) values (5.2, 2.7, 1.7, 1.0);
insert into iris_new (sepal_length, sepal_width, petal_length, petal_width) values (6.4, 3.0, 5.8, 2.3);

-- Validate that the species name is filled in.

select * from iris_new;
