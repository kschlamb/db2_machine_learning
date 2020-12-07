-- Create table with training data.

drop table crickets;

create table crickets (id int not null generated always as identity,
                       temperature float,
                       chirps_per_second int);

import from ../CSV_Datasets/cricket_chirps.csv of del insert into crickets (temperature, chirps_per_second);

select count(*) from crickets;
select * from crickets fetch first 5 rows only;
