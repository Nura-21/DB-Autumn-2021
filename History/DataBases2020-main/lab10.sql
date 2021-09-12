-- 0. Create database called «lab10»
CREATE DATABASE lab10;

-- 1. Create following tables:
CREATE TABLE salesman
(
    salesman_id INTEGER PRIMARY KEY,
    name        VARCHAR(100),
    city        VARCHAR(50),
    commission  REAL
);

CREATE TABLE customers
(
    customer_id INTEGER PRIMARY KEY,
    cust_name   VARCHAR(100),
    city        VARCHAR(50),
    grade       INTEGER,
    salesman_id INTEGER REFERENCES salesman
);

CREATE TABLE orders
(
    ord_no      INTEGER PRIMARY KEY,
    purch_amt   REAL,
    ord_date    DATE,
    customer_id INTEGER REFERENCES customers,
    salesman_id INTEGER REFERENCES salesman
);

CREATE TABLE reviewer
(
    rID  INTEGER PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE movie
(
    mID      INTEGER PRIMARY KEY,
    title    VARCHAR(100),
    year     INTEGER,
    director VARCHAR(100)
);

CREATE TABLE rating
(
    rID        INTEGER REFERENCES reviewer,
    mID        INTEGER REFERENCES movie,
    stars      INTEGER,
    ratingDate DATE
);

INSERT INTO salesman(salesman_id, name, city, commission)
VALUES (5001, 'James Hoog', 'New York', 0.15),
       (5002, 'Nail Knite', 'Paris', 0.13),
       (5005, 'Pit Alex', 'London', 0.11),
       (5006, 'Mc Lyon', 'Paris', 0.14),
       (5003, 'Lauson Hen', NULL, 0.12),
       (5007, 'Paul Adam', 'Rome', 0.13);

INSERT INTO customers(customer_id, cust_name, city, grade, salesman_id)
VALUES (3002, 'Nick Rimando', 'New York', 100, 5001),
       (3005, 'Graham Zusi', 'California', 200, 5002),
       (3001, 'Brad Guzan', 'London', NULL, 5005),
       (3004, 'Fabian Johns', 'Paris', 300, 5006),
       (3007, 'Brad Davis', 'New York', 200, 5001),
       (3009, 'Geoff Camero', 'Berlin', 100, 5003),
       (3008, 'Julian Green', 'London', 300, 5002);

INSERT INTO orders(ord_no, purch_amt, ord_date, customer_id, salesman_id)
VALUES (70001, 150.5, '2012-10-05', 3005, 5002),
       (70009, 270.65, '2012-09-10', 3001, 5005),
       (70002, 65.26, '2012-10-05', 3002, 5001),
       (70004, 110.5, '2012-08-17', 3009, 5003),
       (70007, 948.5, '2012-09-10', 3005, 5002),
       (70005, 2400.6, '2012-07-27', 3007, 5001),
       (70008, 5760, '2012-09-10', 3002, 5001);

INSERT INTO reviewer
VALUES (201, 'Sarah Martinez'),
       (202, 'Daniel Lewis'),
       (203, 'Brittany Harris'),
       (204, 'Mike Anderson'),
       (205, 'Chris Jackson'),
       (206, 'Elizabeth Thomas'),
       (207, 'James Cameron'),
       (208, 'Ashley White');

INSERT INTO movie
VALUES (101, 'Gone with the Wind', 1939, 'Victor Fleming'),
       (102, 'Star Wars', 1977, 'George Lucas'),
       (103, 'The Sound of Music', 1965, 'Robert Wise'),
       (104, 'E.T.', 1982, 'Steven Spielberg'),
       (105, 'Titanic', 1997, 'James Cameron'),
       (106, 'Snow White', 1937, NULL),
       (107, 'Avatar', 2009, 'James Cameron'),
       (108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg');

INSERT INTO rating
VALUES (201, 101, 2, '2011-01-22'),
       (201, 101, 4, '2011-01-27'),
       (202, 106, 4, NULL),
       (203, 103, 2, '2011-01-20'),
       (203, 108, 4, '2011-01-12'),
       (203, 108, 2, '2011-01-30'),
       (204, 101, 3, '2011-01-09'),
       (205, 103, 3, '2011-01-27'),
       (205, 104, 2, '2011-01-22');

-- 2. Create role named «junior_dev» with login privilege.
CREATE ROLE junior_dev LOGIN;
SELECT *
from pg_roles
where rolname = 'junior_dev';

-- 3. Create a view that shows for each order the salesman and
-- customer by name. Grant all privileges to «junior_dev»
CREATE VIEW orders_with_people AS
SELECT o.ord_no, s.name AS salesman_name, c.cust_name AS customer_name
FROM orders AS o
         JOIN salesman AS s ON o.salesman_id = s.salesman_id
         JOIN customers AS c ON o.customer_id = c.customer_id;
SELECT *
FROM orders_with_people;

GRANT ALL PRIVILEGES ON orders_with_people TO junior_dev;

-- 4. Create a view that shows all of the customers who have the
-- highest grade. Grant only select statements to «junior_dev»
CREATE VIEW highest_grade AS
SELECT cust_name, grade
FROM customers
WHERE grade = (SELECT max(grade) FROM customers);
SELECT *
FROM highest_grade;
GRANT SELECT ON highest_grade TO junior_dev;

-- 5. Create role «intern» and give all privileges of «junior_dev».
CREATE ROLE intern;
REASSIGN OWNED BY junior_dev TO intern;



-- 6. Create view for selecting all years that have a movie that  received
-- a rating of 4 or 5 stars, and sort them in increasing order.

CREATE VIEW high_star_movies_years AS
SELECT m.year, r.stars
FROM movie AS m
         JOIN rating AS r ON m.mID = r.mID
WHERE r.stars = 4
   OR r.stars = 5
ORDER BY m.year;

SELECT * FROM high_star_movies_years;

-- 7. Create role with login and role creation privileges.
CREATE ROLE role_with_login_createrole LOGIN CREATEROLE;
SELECT *
from pg_roles
where rolname = 'role_with_login_createrole';


-- 8. Give all privileges of default role to new role.
CREATE ROLE new_role LOGIN;
GRANT ALL PRIVILEGES  ON ALL TABLES IN SCHEMA public to new_role;
ALTER ROLE new_role WITH SUPERUSER CREATEDB CREATEROLE REPLICATION PASSWORD '12345678';
SELECT *
from pg_roles
where rolname = 'new_role';


DROP ROLE new_role;

SELECT * FROM lab10.pg_catalog.pg_roles;
-- 9. Create a role student with a password
-- Create a role student with a password that is valid until the end of 2021.
-- After one second in 2021, the password is no longer valid.
-- Create a role admin that can create databases and manage roles

CREATE ROLE student WITH LOGIN PASSWORD '12345678' VALID UNTIL '2021-01-01';
CREATE ROLE admin_ivan LOGIN PASSWORD 'vanya123456' CREATEDB CREATEROLE;

SELECT *
from pg_roles
where rolname = 'student' or rolname = 'admin_ivan' ;


-- 10. Change a student role's password
-- Remove a student role's password
ALTER ROLE student WITH PASSWORD 'toohardpassword';
ALTER ROLE student WITH PASSWORD NULL;

