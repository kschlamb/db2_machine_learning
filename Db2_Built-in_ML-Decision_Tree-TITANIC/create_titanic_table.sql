-- Create table with training data.

drop table titanic;

create table titanic(passenger_id int not null,
                     survived int not null,
                     pclass int,
                     name char(70),
                     sex char(10),
                     age int,
                     sibsp int,
                     parch int,
                     ticket char(50),
                     fare float,
                     cabin char(50),
                     embarked char(50));

import from ../CSV_Datasets/titanic.csv of del insert into titanic;

select count(*) from titanic;
select * from titanic fetch first 5 rows only;

