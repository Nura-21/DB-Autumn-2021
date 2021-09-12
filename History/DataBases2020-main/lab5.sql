--1. Create database called «lab5»
CREATE DATABASE lab5;

--2. Create following table «customers» and «orders»:
CREATE TABLE customers
(
    customer_id INT,
    cust_name   VARCHAR(60),
    city        VARCHAR(30),
    grade       INT,
    salesman_id INT,
    PRIMARY KEY (customer_id, salesman_id)
);

CREATE TABLE orders
(
    ord_no      INT UNIQUE,
    purch_amt   FLOAT,
    ord_date    DATE,
    customer_id INT,
    salesman_id INT,
    FOREIGN KEY (customer_id, salesman_id) REFERENCES customers (customer_id, salesman_id)
);

INSERT INTO customers
VALUES (3002, 'Nick Rimando', 'New York', 100, 5001),
       (3005, 'Graham Zusi', 'California', 200, 5002),
       (3001, 'Brad Guzan', 'London', NULL, 5005),
       (3004, 'Fabian Johns', 'Paris', 300, 5006),
       (3007, 'Brad Davis', 'New York', 200, 5001),
       (3009, 'Geoff Camero', 'Berlin', 100, 5003),
       (3008, 'Julian Green', 'London', 300, 5002);

INSERT INTO orders
VALUES (70001, 150.5, '2012-10-05', 3005, 5002),
       (70009, 270.65, '2012-09-10', 3001, 5005),
       (70002, 65.26, '2012-10-05', 3002, 5001),
       (70004, 110.5, '2012-08-17', 3009, 5003),
       (70007, 948.5, '2012-09-10', 3005, 5002),
       (70005, 2400.6, '2012-07-27', 3007, 5001),
       (70008, 5760, '2012-09-10', 3002, 5001);

--3. Select the total purchase amount of all orders.
SELECT sum(purch_amt)
FROM orders;

--4. Select the average purchase amount of all orders.
SELECT avg(purch_amt)
FROM orders;

--5. Select how many customer have listed their names.
SELECT count(*)
FROM customers
WHERE cust_name IS NOT NULL;

--6. Select the minimum purchase amount of all the orders.
SELECT min(purch_amt)
FROM orders;

--7. Select customer with all information whose name ends with the letter 'b'.
SELECT *
FROM customers
WHERE cust_name LIKE '%b %';


--8. Select orders which made by customers from ‘New York’.
SELECT *
FROM orders,
     customers
WHERE customers.city = 'New York'
  AND orders.customer_id = customers.customer_id;

--9. Select customers with all information who has order with purchase amount more than 10.
SELECT *
FROM customers,
     orders
WHERE orders.customer_id = customers.customer_id
  AND orders.purch_amt > 10;


--10. Select total grade of all customers.
SELECT sum(grade)
FROM customers;


--11. Select all customers who have listed their names.
SELECT *
FROM customers
WHERE cust_name IS NOT NULL;

--12. Select the maximum grade of all the customers.
SELECT max(grade)
FROM customers;

--Clear data.
DROP TABLE orders;
DROP TABLE customers;
DROP DATABASE lab5;


--Defense: lab 5 : example case , coalesce

SELECT city
FROM customers;

SELECT city,
       CASE
           WHEN city = 'New York' THEN 'NY'
           WHEN city = 'London' THEN 'LNDN'
           ELSE 'Undefined'
           END
FROM customers;


SELECT COALESCE(grade, -1)
FROM customers;