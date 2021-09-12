CREATE DATABASE lab8;

-- Created and filled table countries:
CREATE TABLE countries
(
    name       VARCHAR(30),
    population INT
);

INSERT INTO countries(name, population)
SELECT 'country_' || i, i * 1000
FROM generate_series(1, 100000) i;

SELECT count(*)
FROM countries;

TRUNCATE countries;


-- Created and filled table departments
CREATE TABLE departments
(
    department_id INT PRIMARY KEY,
    budget        INT
);

INSERT INTO departments(department_id, budget)
SELECT i, i * 1000
FROM generate_series(1, 100000) i;

SELECT count(*)
FROM departments;

TRUNCATE departments;


-- Created and filled table employees
CREATE TABLE employees
(
    name          VARCHAR(50),
    surname       VARCHAR(50),
    salary        INT,
    department_id INT REFERENCES departments
);

INSERT INTO employees(name, surname, salary, department_id)
SELECT 'name_' || i, 'surname_' || i, i * 100, i
FROM generate_series(1, 100000) i;

SELECT count(*)
FROM employees;

TRUNCATE employees;


-- 1. Created index for countries on column name
EXPLAIN ANALYSE
SELECT *
FROM countries
WHERE name = 'country_50000';

CREATE INDEX countries_name ON countries (name);
DROP INDEX countries_name;

-- 2. Created index for two cases
CREATE INDEX employees_name_surname ON employees (name, surname);
DROP INDEX employees_name_surname;

EXPLAIN ANALYSE
SELECT *
FROM employees
WHERE name = 'name_50000'
  AND surname = 'surname_50000';

-- 3. Create unique index

CREATE UNIQUE INDEX employees_salary ON employees (salary);
DROP INDEX employees_salary;

EXPLAIN ANALYSE
SELECT count(*)
FROM employees
WHERE salary > 500000
  AND salary < 700000;

-- 4. CREATE Index on substring
CREATE INDEX employee_name_substring ON employees (SUBSTRING(name FROM 1 FOR 4));
DROP INDEX employee_name_substring;

EXPLAIN ANALYSE
SELECT count(*)
FROM employees
WHERE substring(name FROM 1 FOR 4) = 'name';

-- 5.
CREATE INDEX employees_id ON employees (department_id);
CREATE INDEX departments_id ON departments (department_id);
CREATE INDEX employees_salary ON employees (salary);
CREATE INDEX departments_budget ON departments (budget);

DROP INDEX employees_id;
DROP INDEX departments_id;
DROP INDEX employees_salary;
DROP INDEX departments_budget;


EXPLAIN ANALYSE
SELECT count(*)
FROM employees AS e
         JOIN departments AS d ON d.department_id = e.department_id
WHERE d.budget > 300000
  AND e.salary < 300000;

--6
CREATE INDEX employees_rtree_id ON employees USING btree(salary);
DROP INDEX employees_rtree_id;

EXPLAIN ANALYSE
SELECT count(*)
FROM employees
WHERE salary > 500000
  AND salary < 700000;


--7
CREATE INDEX departments_hash_budget ON departments USING HASH(budget);
DROP INDEX departments_hash_budget;

EXPLAIN ANALYSE
SELECT *
FROM departments
WHERE budget = 100000;


--8
CREATE UNIQUE INDEX countries_unique_name_population ON countries(name,population);
DROP INDEX countries_unique_name_population;

EXPLAIN ANALYSE
SELECT *
FROM countries
WHERE name = 'country_50000' and population>1000;