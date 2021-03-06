--1 step
CREATE DATABASE laboratory_work1;

--2 step
CREATE TABLE employees(num SERIAL,
                        first_name VARCHAR(50),
                        last_name VARCHAR(50),
                        middle_name VARCHAR(50),
                        birth_date DATE);
--3 step
ALTER TABLE employees ADD COLUMN admin_group INTEGER,
                    ADD COLUMN salary INTEGER;

--4step
ALTER TABLE employees
    ALTER COLUMN admin_group SET DATA TYPE BOOLEAN USING admin_group::BOOLEAN;

--5step
ALTER TABLE employees ALTER COLUMN admin_group SET DEFAULT FALSE,
                    ALTER COLUMN salary SET DEFAULT 10000;

--6step
ALTER TABLE employees ADD PRIMARY KEY(num);

--7step
CREATE TABLE jobs(num SERIAL,
                name VARCHAR(50),
                employees_num INTEGER,
                description VARCHAR(50));

--8step
DROP TABLE jobs;
DROP TABLE employees;

--9step
DROP DATABASE laboratory_work1;

--defense
ALTER TABLE employees ALTER COLUMN first_name SET DEFAULT 'Ivan';
ALTER TABLE employees ALTER COLUMN last_name SET DEFAULT 'Ivanov';

INSERT INTO employees (first_name)
VALUES('Sasha'),('Egor');

SELECT * FROM employees;