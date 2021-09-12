--1 Database creation
CREATE DATABASE laboratory_work3;

--2 Add some tables, and data from the given sql file
CREATE TABLE departments (
  code INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  budget DECIMAL NOT NULL
);

CREATE TABLE employees (
  ssn INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL ,
  lastname VARCHAR(255) NOT NULL ,
  department INTEGER NOT NULL ,
  city VARCHAR(255),
  FOREIGN KEY (department) REFERENCES departments(code)
);

CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL ,
  lastname VARCHAR(255) NOT NULL ,
  city VARCHAR(255)
);

INSERT INTO departments(code,name,budget) VALUES(14,'IT',65000);
INSERT INTO departments(code,name,budget) VALUES(37,'Accounting',15000);
INSERT INTO departments(code,name,budget) VALUES(59,'Human Resources',240000);
INSERT INTO departments(code,name,budget) VALUES(77,'Research',55000);
INSERT INTO departments(code,name,budget) VALUES(45,'Management',155000);
INSERT INTO departments(code,name,budget) VALUES(11,'Sales',85000);

INSERT INTO employees(ssn,name,lastname,department, city) VALUES('123234877','Michael','Rogers',14, 'Almaty');
INSERT INTO employees(ssn,name,lastname,department, city) VALUES('152934485','Anand','Manikutty',14, 'Shymkent');
INSERT INTO employees(ssn,name,lastname,department, city) VALUES('222364883','Carol','Smith',37, 'Astana');
INSERT INTO employees(ssn,name,lastname,department, city) VALUES('326587417','Joe','Stevens',37, 'Almaty');
INSERT INTO employees(ssn,name,lastname,department, city) VALUES('332154719','Mary-Anne','Foster',14, 'Astana');
INSERT INTO employees(ssn,name,lastname,department, city) VALUES('332569843','George','ODonnell',77, 'Astana');
INSERT INTO employees(ssn,name,lastname,department, city) VALUES('546523478','John','Doe',59, 'Shymkent');
INSERT INTO employees(ssn,name,lastname,department, city) VALUES('631231482','David','Smith',77, 'Almaty');
INSERT INTO employees(ssn,name,lastname,department, city) VALUES('654873219','Zacary','Efron',59, 'Almaty');
INSERT INTO employees(ssn,name,lastname,department, city) VALUES('745685214','Eric','Goldsmith',59, 'Atyrau');
INSERT INTO employees(ssn,name,lastname,department, city) VALUES('845657245','Elizabeth','Doe',14, 'Almaty');
INSERT INTO employees(ssn,name,lastname,department, city) VALUES('845657246','Kumar','Swamy',14, 'Almaty');

INSERT INTO customers(name,lastname, city) VALUES('John','Wills', 'Almaty');
INSERT INTO customers(name,lastname, city) VALUES('Garry','Foster', 'London');
INSERT INTO customers(name,lastname, city) VALUES('Amanda','Hills', 'Almaty');
INSERT INTO customers(name,lastname, city) VALUES('George','Doe', 'Tokyo');
INSERT INTO customers(name,lastname, city) VALUES('David','Little', 'Almaty');
INSERT INTO customers(name,lastname, city) VALUES('Shawn','Efron', 'Astana');
INSERT INTO customers(name,lastname, city) VALUES('Eric','Gomez', 'Shymkent');
INSERT INTO customers(name,lastname, city) VALUES('Elizabeth','Tailor', 'Almaty');
INSERT INTO customers(name,lastname, city) VALUES('Julia','Adams', 'Astana');


--3  Select the first name of all workers
SELECT name FROM employees;

--4  Select the last name of all workers, without duplicates.
SELECT DISTINCT lastname FROM employees;

--5  Select all the data of workers whose last name is «Smith".
SELECT * FROM employees WHERE lastname = 'Smith';

--6  Select all the data of workers whose last name is "Smith" or "Doe".
SELECT * FROM employees WHERE lastname='Smith' OR lastname='Doe';

--7 Select all the data of workers that work in branch 59.
SELECT * FROM employees WHERE department = 59;

--8  Select all the data of workers that work in branch 14 or branch 77.
--   Select all the data of workers who work in Almaty city.
SELECT * FROM employees WHERE department = 14 OR department = 77;
SELECT * FROM employees WHERE city = 'Almaty';

--9 Select the sum of all the branches' budgets.
SELECT sum(budget) AS common_budget FROM departments;

--10 count all employees at each department
SELECT department, count(*) FROM employees GROUP BY department;

--11 Select the branch code with more than 2 workers.
SELECT department FROM employees GROUP BY department
    HAVING count(*)>2;

SELECT department FROM employees GROUP BY department
    HAVING count(*)>2;

--12 Select the name of the branch with second highest budget.
SELECT name FROM departments ORDER BY budget DESC OFFSET 1 LIMIT 1;

--13 Select the name and last name of workers working for  branches with lowest and highest budget.
SELECT name,lastname FROM employees
WHERE department = (SELECT code FROM departments ORDER BY budget DESC LIMIT 1)
    OR department = (SELECT code FROM departments ORDER BY budget ASC LIMIT 1);


--14 Select the name of all workers and clients from Nursultan. Sorry there is only Astana
SELECT name FROM employees WHERE city='Nursultan' UNION
SELECT name FROM customers WHERE city='Nursultan';

--15 Select all branches with budget more than 55000, sorted by increasing budget and decreasing code
SELECT * FROM departments WHERE budget>55000 ORDER BY budget, code DESC;

--16  Reduce the budget of branch with lowest budget by 10%.
UPDATE departments SET budget=budget*0.9
    WHERE budget=(SELECT budget FROM departments ORDER BY budget LIMIT 1);
SELECT budget FROM departments ORDER BY budget LIMIT 1;

--17  Reassign all workers from the Research branch to the  IT branch.
UPDATE employees SET department = (SELECT code FROM departments WHERE name = 'IT')
WHERE department = (SELECT code FROM departments WHERE name = 'Research');


--18  Delete from the table all workers in the IT branch.
DELETE FROM employees WHERE department = (SELECT code FROM departments WHERE name = 'IT');

--19 Delete from the table all workers.
DELETE FROM employees;
SELECT * from employees;

--Defense: Task to lab 3: Select the code, name of the branch with second highest
-- budget . Reduce the budget of branch with lowest budget by 15%.

SELECT code,name FROM departments ORDER BY budget DESC OFFSET 1 LIMIT 1;

UPDATE departments SET budget=budget*0.85
    WHERE budget = (SELECT budget FROM departments ORDER BY budget LIMIT 1);

SELECT * FROM departments ORDER BY budget;


