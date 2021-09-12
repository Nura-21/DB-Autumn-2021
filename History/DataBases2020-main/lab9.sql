-- 1. Create database called «lab9»
CREATE DATABASE lab9;

-- 2. Create following tables «salesman», «customers» and «orders»:
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

-- 3. Create a view for those salesmen belongs to the city
-- New York.
CREATE VIEW salesman_new_york AS
SELECT *
FROM salesman
WHERE city = 'New York';

SELECT *
FROM salesman_new_york;


-- 4. Create a view that shows for each order the salesman
-- and customer by name.
CREATE VIEW orders_with_people AS
SELECT o.ord_no, s.name AS salesman_name, c.cust_name AS customer_name
FROM orders AS o
         JOIN salesman AS s ON o.salesman_id = s.salesman_id
         JOIN customers AS c ON o.customer_id = c.customer_id;
SELECT *
FROM orders_with_people;





-- 5. Create a view that shows all of the customers who
-- have the  highest grade.
CREATE VIEW highest_grade AS
SELECT cust_name, grade
FROM customers
WHERE grade = (SELECT max(grade) FROM customers);
SELECT *
FROM highest_grade;



-- 6. Create a view that shows the number of the salesman
-- in each  city.
CREATE VIEW each_city_salesman AS
SELECT count(salesman_id) AS salesmen_count, city
FROM salesman
GROUP BY city;

SELECT *
FROM each_city_salesman;




-- 7. Create a view that shows each salesman with more
-- than one  customers.
CREATE VIEW salesman_customers AS
SELECT name
FROM salesman
WHERE salesman_id IN
      (SELECT salesman_id FROM customers AS c GROUP BY(c.salesman_id) HAVING (count(cust_name) > 1));
SELECT *
FROM salesman_customers;




-- 8. Create a view  with LIKE operator (example cities New
-- York, Paris; or etc).
CREATE VIEW b_names AS
SELECT cust_name, city
FROM customers
WHERE cust_name LIKE 'B%';
SELECT *
FROM b_names;




-- 9. Create a view with a JOIN statement.
CREATE VIEW salesmen_and_customers AS
SELECT s.name AS salesman_name, c.cust_name AS cust_name
FROM salesman AS s
         JOIN customers AS c ON s.salesman_id = c.salesman_id;
SELECT *
FROM salesmen_and_customers;


-- 10. Create a view with UNION.
CREATE VIEW salesmen_with_customers_union AS
SELECT s.salesman_id
FROM salesman AS s
UNION
SELECT c.salesman_id
FROM customers AS c;

SELECT *
FROM salesmen_with_customers_union;

-- 11. Create a view  with ORDER BY clause.
CREATE VIEW each_city_salesman_ord AS
SELECT count(salesman_id) AS salesmen_count, city
FROM salesman
GROUP BY city
ORDER BY salesmen_count DESC;
SELECT *
FROM each_city_salesman_ord;


--12. Create a view rename the view abc to xyz
ALTER VIEW each_city_salesman_ord RENAME TO count_salesmen;
SELECT *
FROM count_salesmen;



-- 13. Create a view  with GROUP BY clause.
CREATE VIEW customers_cnt AS
SELECT count(customer_id) AS customers, salesman_id
FROM customers
GROUP BY salesman_id;

SELECT *
FROM customers_cnt;