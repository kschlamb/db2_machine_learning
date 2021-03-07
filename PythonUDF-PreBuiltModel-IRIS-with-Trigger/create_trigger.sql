-- Run command: db2 -td@ -vf create_trigger.sql
--
-- Table "iris_new" must be created prior to running this.

create or replace trigger predict_iris_trigger
    before insert on iris_new
    referencing new as n
    for each row
        set n.species_name = (values (iris_udf(sepal_length, sepal_width,
                                               petal_length, petal_width)))@
