-- This table must be created prior to creating the trigger.

drop table iris_new;

create table iris_new (sepal_length  dec(2,1),
                       sepal_width   dec(2,1),
                       petal_length  dec(2,1),
                       petal_width   dec(2,1),
                       species_name  char(10));
