--1. Create and fill tables.
CREATE DATABASE lab7;

CREATE TABLE salesmen
(
    salesman_id INT PRIMARY KEY,
    name        VARCHAR(50),
    city        VARCHAR(50),
    commission  FLOAT
);

CREATE TABLE customers
(
    customer_id INT PRIMARY KEY,
    cust_name   VARCHAR(50),
    city        VARCHAR(50),
    grade       INT,
    salesman_id INT REFERENCES salesmen
);

CREATE TABLE orders
(
    ord_no      INT,
    purch_amt   FLOAT,
    ord_date    DATE,
    customer_id INT REFERENCES customers,
    salesman_id INT REFERENCES salesmen
);

INSERT INTO salesmen
VALUES (5001, 'James Hoog', 'New York', 0.15),
       (5002, 'Nail Knite', 'Paris', 0.13),
       (5005, 'Pit Alex', 'London', 0.11),
       (5006, 'Mc Lyon', 'Paris', 0.14),
       (5007, 'Paul Adam', 'Rome', 0.13),
       (5003, 'Lauson Hen', 'San Jose', 0.12);

INSERT INTO customers
VALUES (3002, 'Nick Rimando', 'New York', 100, 5001),
       (3007, 'Brad Davis', 'New York', 200, 5001),
       (3005, 'Graham Zusi', 'California', 200, 5002),
       (3008, 'Julian Green', 'London', 300, 5002),
       (3004, 'Fabian Johnson', 'Paris', 300, 5006),
       (3009, 'Geoff Cameron', 'Berlin', 100, 5003),
       (3003, 'Jozy Altidor', 'Moscow', 200, 5007),
       (3001, 'Brad Guzan', 'London', NULL, 5005);

INSERT INTO orders
VALUES (70001, 150.5, '2012-10-05', 3005, 5002),
       (70009, 270.65, '2012-09-10', 3001, 5005),
       (70002, 65.26, '2012-10-05', 3002, 5001),
       (70004, 110.5, '2012-08-17', 3009, 5003),
       (70007, 948.5, '2012-09-10', 3005, 5002),
       (70005, 2400.6, '2012-07-27', 3007, 5001),
       (70008, 5760, '2012-09-10', 3002, 5001),
       (70010, 1983.43, '2012-10-10', 3004, 5006),
       (70003, 2480.4, '2012-10-10', 3009, 5003),
       (70012, 250.45, '2012-06-27', 3008, 5002),
       (70011, 75.29, '2012-08-17', 3003, 5007),
       (70013, 3045.6, '2012-04-25', 3002, 5001);

--2. Write a SQL statement to prepare a list with salesman name, customer name and
--their cities for the salesmen and customer who belongs to the same city.
SELECT s.name, c.cust_name, s.city, c.city
FROM salesmen AS s
         JOIN customers AS c ON s.city = c.city;

--3. Write a SQL statement to make a list with order no, purchase amount, customer
-- name and their cities for those orders which purchase amount between 500 and
-- 2000
SELECT o.ord_no, o.purch_amt, c.cust_name, c.city
FROM orders AS o
         JOIN customers AS c ON c.customer_id = o.customer_id
WHERE o.purch_amt >= 500
  AND o.purch_amt <= 2000;

--4. Write a SQL statement to know which salesman are working for which customer.
SELECT s.name, c.cust_name
FROM salesmen AS s
         JOIN customers AS c ON s.salesman_id = c.salesman_id;

--5. Write a SQL statement to find the list of customers who appointed a salesman for
-- their jobs who gets a commission from the company is more than 12%.
SELECT c.cust_name, s.name AS "salesman name", s.commission
FROM customers AS c
         JOIN salesmen AS s ON s.salesman_id = c.salesman_id AND s.commission > 0.12;

--6.
--  Write a SQL statement to make a report with customer name, city, order number,
-- order date, and order amount in ascending order according to the order date to find
-- that either any of the existing customers have placed no order or placed one or
-- more orders.
SELECT c.cust_name, c.city, o.ord_no, o.ord_date, o.purch_amt
FROM orders AS o
          LEFT JOIN customers AS c ON o.customer_id = c.customer_id
ORDER BY o.ord_date;

--7.
--  Write a SQL statement to make a list in ascending order for the salesmen who
-- works either for one or more customer or not yet join under any of the customers
SELECT name AS "salesman name", count(s.salesman_id) AS customers
FROM salesmen AS s
         LEFT JOIN customers AS c ON s.salesman_id = c.salesman_id
GROUP BY s.name
ORDER BY customers;

INSERT INTO customers
VALUES (2500, 'Daniil Koilybayev', 'Almaty', 100, 5001);

-- defense
SELECT c.cust_name, o.ord_no FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id=o.customer_id WHERE o.ord_no IS NULL;
