--1  Create database called «lab6»
CREATE DATABASE lab6;

--2 Create following tables:
CREATE TABLE locations
(
    location_id    SERIAL PRIMARY KEY,
    street_address VARCHAR(25),
    postal_code    VARCHAR(12),
    city           VARCHAR(30),
    state_province VARCHAR(12)
);

CREATE TABLE departments
(
    department_id   SERIAL PRIMARY KEY,
    department_name VARCHAR(50) UNIQUE,
    budget          INTEGER,
    location_id     INTEGER REFERENCES locations
);

CREATE TABLE employees
(
    employee_id   SERIAL PRIMARY KEY,
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    email         VARCHAR(50),
    phone_number  VARCHAR(20),
    salary        INTEGER,
    department_id INTEGER REFERENCES departments
);

--3 Enter 5 values rows to each table locations, department
--employees. The values of column department id should be: 40, 50, 60,
--70, 80
INSERT INTO locations(street_address, postal_code, city, state_province)
VALUES ('221b Baker Street', 'BS01', 'London', 'Gr London'),
       ('20 W 34th St.', 'empstbl02', 'New-York', 'New-York'),
       ('1 Apple Park Way', 'apple03', 'Cupertino', 'California'),
       ('1-7-1 Konan', 'sony04', 'Tokyo', 'Tokyo'),
       ('Tole bi 59', 'kbtu05', 'Almaty', 'Almaty');

INSERT INTO departments(department_id, department_name, budget, location_id)
VALUES (40, 'Sherlock Holmes office', 500000, 1),
       (50, 'Empire State Building', 600000, 2),
       (60, 'Apple', 700000, 3),
       (70, 'Sony', 800000, 4),
       (80, 'KBTU', 900000, 5);

INSERT INTO employees(first_name, last_name, email, phone_number, salary, department_id)
VALUES ('Daniil', 'Koilybayev', 'dnst@gmail.com', '87772821101', 200000, 70),
       ('Sherlock', 'Holmes', 'sherLock@gmail.com', '87772821102', 120000, 40),
       ('Elliot', 'Anderson', 'fsociety@gmail.com', '87772821103', 130000, 70),
       ('Tim', 'Cook', 'makeMoney@gmail.com', '87772821104', 1000000, 60),
       ('Askar', 'Akshabayev', 'askar@gmail.com', '87772821105', 200000, 80);

--4  Select the first name, last name, department id, and department name for each employee.
SELECT e.first_name, e.last_name, e.department_id, d.department_name
FROM employees AS e
         NATURAL JOIN departments AS d;

--5  Select the first name, last name, department id and department name, for all employees for departments 80 or 40.
SELECT e.first_name, e.last_name, e.department_id, d.department_name
FROM employees AS e
         JOIN departments AS d ON e.department_id = d.department_id AND (d.department_id = 80 OR d.department_id = 40);

--6  Select the first and last name, department, city, and state  province for each employee.
SELECT e.first_name, e.last_name, department_name, city, state_province
FROM employees AS e
         JOIN departments AS d ON e.department_id = d.department_id
         JOIN locations AS l ON d.location_id = l.location_id;

--7  Select all departments including those where does not have  any employee.
SELECT *
FROM departments AS d
         LEFT JOIN employees AS e ON d.department_id = e.department_id;

--8  Select the first name, last name, department id and name, for  all employees who have or have not any department.
SELECT e.first_name, e.last_name, d.department_id, d.department_name
FROM employees AS e
         LEFT JOIN departments AS d ON e.department_id = d.department_id;

--9 Select the employee last name, first name , who works in Almaty city
SELECT e.last_name, e.first_name, l.city
FROM employees AS e
         JOIN departments AS d ON e.department_id = d.department_id
         JOIN locations AS l ON d.location_id = l.location_id
WHERE l.city = 'Almaty';


-- Show department where is no employee
SELECT *
FROM departments AS d
         LEFT JOIN employees AS e ON d.department_id = e.department_id
WHERE e.department_id IS NULL;