CREATE DATABASE testing_my_endterm;
DROP DATABASE last_lab_exm;
CREATE TABLE highschooler(
    ID INT PRIMARY KEY,
    name VARCHAR(30),
    grade INT
);


CREATE TABLE friend(
    ID1 INT REFERENCES highschooler(ID),
    ID2 INT references highschooler(ID)
)


CREATE TABLE likes(
    ID1 INT REFERENCES highschooler(ID),
    ID2 INT references highschooler(ID)
)


INSERT INTO highschooler
VALUES(1510,'Jordan',9),
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
       (1689,1782),
       (1782,1468),
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

--1 task
SELECT h.name FROM highschooler AS h
    JOIN friend f on h.ID = f.ID1
    JOIN highschooler h1 on h1.ID = f.ID2
WHERE h1.name = 'Gabriel';

--2 task

SELECT h.name as "Name of who likes",h.grade,h1.name as "Who liked",h1.grade FROM highschooler AS h
    JOIN likes l on h.ID = l.ID1
    JOIN highschooler h1 on h1.ID = l.ID2
WHERE (h.grade-h1.grade) > 1;

--3 task
SELECT name,grade FROM highschooler as h
JOIN likes l on h.ID = l.ID2
GROUP BY h.id
HAVING count(l.id2)>1;


--4 task
SELECT name,grade FROM highschooler as h
WHERE h.ID NOT IN(
    SELECT ID1 FROM friend f, highschooler h1
    WHERE h1.grade<>h.grade AND h1.ID = f.ID2 AND h.ID=f.ID1
    )
ORDER BY grade,name ASC;

--5 task
SELECT h.name,h.grade,h1.name,h1.grade
FROM highschooler h, highschooler h1,likes l,likes l1
WHERE (h.ID=l.ID1 and h1.ID=l.ID2) and (h1.ID=l1.ID2 and h1.ID=l1.ID1)
ORDER BY h1.name,h.name;


CREATE TABLE T(
    a INT,
    b INT,
    c INT
);

INSERT INTO T
VALUES (1,1,3),
       (2,2,3),
       (2,1,4),
       (2,3,5),
       (2,4,1),
       (3,3,4);


CREATE VIEW V as SELECT a+b as d, c FROM T;

SELECT d,sum(c) FROM V Group BY d HAVING count(*)<>1;