--step 1
CREATE DATABASE laboratory_work2;

--step 2
CREATE TABLE countries(id SERIAL PRIMARY KEY ,
                    name VARCHAR(30),
                    district_id INT,
                    population INT);

--step 3
INSERT INTO countries VALUES(1,'Japan',1,126389518);


--step 4
INSERT INTO countries VALUES(2,'USA');


--step 5
INSERT INTO countries VALUES(3,'Russia',NULL,144000000);


--step 6
INSERT INTO countries (id,name, district_id, population)
    VALUES (4,'Kazakhstan',4,18000000),
           (5,'Germany',5,83000000),
           (6,'Canada',6,37000000);


--step 7
ALTER TABLE countries ALTER COLUMN name
    SET DEFAULT 'Earth';


--step 8
INSERT INTO countries
    VALUES(7,DEFAULT,7,123232);


--step 9
INSERT INTO countries DEFAULT VALUES;


--step 10
CREATE TABLE countries_new (LIKE countries);


--step 11
INSERT INTO countries_new SELECT * FROM countries;


--step 12
UPDATE countries_new SET district_id=1 WHERE district_id IS NULL;


--step 13
ALTER TABLE countries_new
    ADD COLUMN "New Population" INT;

UPDATE countries_new SET "New Population" = population*1.15;


--step 14
DELETE FROM countries_new WHERE population<100000;



--уменьшит кол-во населения на 40 процентов вывести в отдельную колонку
--удалить все записи которые заканчиваются на стан


ALTER TABLE countries_new
    ADD COLUMN "Third Generation" INT;

UPDATE countries_new SET "Third Generation" = "New Population"*0.6;

INSERT INTO countries_new  VALUES (20,'Kazakhstan',4,18000000);
SELECT * FROM countries_new;

DELETE FROM countries_new WHERE lower("right"(name,4)) = 'stan';

SELECT * FROM countries_new;