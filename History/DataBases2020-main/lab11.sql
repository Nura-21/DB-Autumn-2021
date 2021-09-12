CREATE DATABASE lab11;
-- 1.  Create function that returns cube of number.
CREATE FUNCTION myCube(a INTEGER) RETURNS INTEGER AS
$$
BEGIN
    RETURN a * a * a;
END;
$$
    LANGUAGE PLPGSQL
;
SELECT myCube(3);

-- 2.  Create function that returns average sum of numbers.

CREATE OR REPLACE FUNCTION MyAverage(VARIADIC list NUMERIC[],
                                     OUT average_ NUMERIC)
AS
$$
BEGIN
    SELECT INTO average_ AVG(list[i])
    FROM generate_subscripts(list, 1) g(i);
END;
$$
    LANGUAGE plpgsql;

SELECT *
FROM MyAverage(1, 2, 3, 4, 5, 6, 7, 8);


-- 3.  Create function that returns max number of numbers.
CREATE OR REPLACE FUNCTION max_min(VARIADIC list NUMERIC[],
                                   OUT max_ NUMERIC,
                                   OUT min_ NUMERIC)
AS
$$
BEGIN
    SELECT INTO max_ MAX(list[i])
    FROM generate_subscripts(list, 1) g(i);
    SELECT INTO min_ MIN(list[i])
    FROM generate_subscripts(list, 1) g(i);
END;
$$
    LANGUAGE plpgsql;


SELECT max_
FROM max_min(1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2);

-- 4.  Create function that returns min number of numbers.

SELECT min_
FROM max_min(1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2);

-- 5.  Create function that returns count of numbers.
CREATE OR REPLACE FUNCTION count_(VARIADIC list NUMERIC[],
                                  OUT cnt NUMERIC)
AS
$$
BEGIN
    SELECT INTO cnt COUNT(list[i])
    FROM generate_subscripts(list, 1) g(i);
END;
$$
    LANGUAGE plpgsql;

SELECT *
FROM count_(1, 2, 3, 4, 3, 2, 1, 2, 3, 4, 2, 2);


-- 6.  Create function that returns table of students with columns: id, name, specialty,
-- birth date, address, mobile number


CREATE TABLE students
(
    id            SERIAL,
    name          VARCHAR(30),
    specialty     VARCHAR(30),
    birth_date    DATE,
    address       VARCHAR(40),
    mobile_number VARCHAR(30),
    height        INTEGER
);

INSERT INTO students (name, specialty, birth_date, address, mobile_number,height)
VALUES ('John', 'FIT', '1995-01-01', 'NY', '87772821111',180),
       ('Jack', 'FIT', '1995-02-02', 'LA', '8777282222',185),
       ('Johny', 'MCM', '1995-03-03', 'SF', '8777282333',183);

CREATE OR REPLACE FUNCTION get_students_table()
    RETURNS TABLE
            (
                id            INTEGER,
                name          VARCHAR(30),
                speciality    VARCHAR(30),
                birth_date    DATE,
                address       VARCHAR(40),
                mobile_number VARCHAR(30),
                height INTEGER
            )
AS
$$
BEGIN
    RETURN QUERY SELECT s.id,
                        s.name,
                        s.specialty,
                        s.birth_date,
                        s.address,
                        s.mobile_number,
                        s.height
                 FROM students s;
END;
$$
    LANGUAGE 'plpgsql';

SELECT get_students_table();

-- 7. Show the table of students
SELECT *
FROM get_students_table();


-- 8.  Create function that returns max height among students
CREATE OR REPLACE FUNCTION get_max_height(OUT max_ NUMERIC)
AS
$$
BEGIN
    SELECT INTO max_ MAX(height)
    FROM students;
END;
$$
    LANGUAGE 'plpgsql';


SELECT get_max_height();