-- Create table with training data.

drop table abalone;

create table abalone (id int not null generated always as identity,
                      sex char(1),
                      length int,
                      diameter int,
                      height int,
                      whole_weight dec(4,1),
                      shucked_weight dec(4,1),
                      viscera_weight dec(4,1),
                      shell_weight dec(4,1),
                      rings int);

import from ../CSV_Datasets/abalone.csv of del insert into abalone
  (sex, length, diameter, height, whole_weight, shucked_weight, viscera_weight, shell_weight, rings);

select count(*) from abalone;
select * from abalone fetch first 5 rows only;
