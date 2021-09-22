-- 1 EXERCISE
-- DDL 1
CREATE TABLE info(
    NAME varchar(25) NOT NULL,
    LAST_NAME varchar(25) NOT NULL,
    AGE integer CHECK(AGE > 0) NOT NULL,
    SEX varchar(6)
);
-- DDL 2
ALTER TABLE info ADD BIRTH_DATE date;

-- DML 1
INSERT INTO info VALUES ('Nurassyl', 'Trdln',18,'Male',to_date('21/10/2002','dd/mm/yyyy'));
INSERT INTO info VALUES ('Adam', 'First',25,'Male',to_date('15/12/1995','dd/mm/yyyy'));
INSERT INTO info VALUES ('Eva', 'Second',25,'Female',to_date('09/12/1995','dd/mm/yyyy'));

-- DML 2
DELETE FROM info WHERE SEX = 'Female';

-- DML 3
UPDATE info SET LAST_NAME = 'Turdalin' WHERE NAME = 'Nurassyl';

-- DML 4
SELECT * FROM info;

-- DDL 3
TRUNCATE TABLE info;

-- DDL 4
DROP TABLE info;