CREATE DATABASE hello;



CREATE TABLE highschooler
(
    id  INTEGER PRIMARY KEY,
    name varchar(255),
    grade INTEGER
);

CREATE TABLE likes
(
    id1  int REFERENCES highschooler (id),
    id2  int REFERENCES highschooler (id),
        PRIMARY KEY (id1, id2)
);

CREATE TABLE friend
(
    id1  int REFERENCES highschooler (id),
    id2  int REFERENCES highschooler (id),
        PRIMARY KEY (id1, id2)
);


INSERT INTO highschooler
VALUES (1510,'Jordan',9),
       (1689,'Gabriel',9),
       (1381,'Tiffany',9),
       (1709,'Cassandra',9),
       (1101,'Haley',10),
       (1782,'Andrew',10),
       (1468,'Kris',10),
       (1641,'Brittany',10),
       (1247,'Alexis',11),
       (1316,'Austin',11),
       (1911,'Gabriel',11),
       (1501,'Jessica',11),
       (1304,'Jordan',12),
       (1025,'John',12),
       (1934,'Kyle',12),
       (1661,'Logan',12);


INSERT INTO friend
VALUES (1510,1381),
       (1510,1689),
       (1689,1709),
       (1381,1247),
       (1709,1247),
       (1689,1782),
       (1782,1316),
       (1782,1304),
       (1468,1101),
       (1468,1641),
       (1101,1641),
       (1247,1911);

INSERT INTO likes
VALUES (1689,1709),
       (1709,1689),
       (1782,1709),
       (1911,1247),
       (1247,1468),
       (1641,1468),
       (1316,1304),
       (1501,1934),
       (1934,1501),
       (1025,1101);

--1
SELECT name FROM highschooler AS h
    JOIN friend AS f on h.id = f.id1
WHERE f.id2 = 1689;

--3
SELECT name, grade FROM highschooler AS h
    JOIN likes AS l on h.id = l.id2
GROUP BY h.id
HAVING count(id1) > 1;


--2
1. By default, the parameter’s type of any parameter in
PostgreSQL is IN parameter. You can pass the IN
parameters to the function but you cannot get them
back as a part of result.

2. TheOUTparameters are deﬁned as part of the function
arguments list and are returned back as a part of the
result.

3. • The INOUT parameter is the combination IN and OUT
parameters.

• It means that the caller can pass the value to the
function.

• The function then changes the argument and passes
the value back as a part of the result.

4. PL/pgSQL VARIADIC
parameters
• A PostgreSQL function can accept a variable number
of arguments with one condition that all arguments
have the same data type.

• The arguments are passed to the function as an array.

• See the following example:






