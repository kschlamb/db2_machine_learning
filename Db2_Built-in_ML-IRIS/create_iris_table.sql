-- Create table with training data.

drop table iris;

create table iris (id int not null generated always as identity,
                   sepal_length dec(2,1),
                   sepal_width  dec(2,1),
                   petal_length dec(2,1),
                   petal_width  dec(2,1),
                   class_name   char(10));

import from ../CSV_Datasets/iris_species.csv of del insert into iris
  (sepal_length, sepal_width, petal_length, petal_width, class_name);

select count(*) from iris;
select * from iris fetch first 5 rows only;
