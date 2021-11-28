--LAB 8
--EX 1
--A
CREATE FUNCTION A(n INTEGER) RETURNS INTEGER
LANGUAGE plpgsql AS  $$
    BEGIN
        RETURN n + 1;
    END
    $$;
SELECT A(5);

--B
CREATE FUNCTION B(a INTEGER, b INTEGER) RETURNS INTEGER
LANGUAGE plpgsql AS $$
    BEGIN
        RETURN a + b;
    END
    $$;
SELECT B(5,6);

--C
CREATE FUNCTION C(n INTEGER) RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
    BEGIN
       IF n % 2 = 0 THEN
           RETURN TRUE;
       ELSE RETURN FALSE;
       END IF;
    END
    $$;
SELECT C(4);
SELECT C(5);

--D password should have at least 1 Upper, Lower, Number and more than 8 characters
CREATE FUNCTION D(password VARCHAR) RETURNS BOOLEAN
LANGUAGE plpgsql AS $$
    BEGIN
        IF password SIMILAR TO '%[a-z]%' AND
           password SIMILAR TO '%[A-Z]%' AND
           password SIMILAR TO '%[0-9]%' AND
           length(password) >= 8 THEN
            RETURN TRUE;
        ELSE RETURN FALSE;
        end if;
    END
    $$;
SELECT D('1hhhhH');
SELECT D('asldkaslkdjalwkjdlkjlkjALSKDJLKAJDLK123123');
--E
CREATE TYPE tuple AS (f INTEGER, s INTEGER);
CREATE FUNCTION E(n INTEGER) RETURNS tuple
LANGUAGE plpgsql AS $$
    BEGIN
       RETURN (n, n * n);
    END;
    $$;
SELECT f AS initial, s as square FROM E(5) ;
DROP FUNCTION E;
--EX 2
--Table
CREATE TABLE test_t(
    time TIMESTAMP,
    birth TIMESTAMP,
    age INTEGER,
    price INTEGER,
    password VARCHAR,
    sq_price tuple
);

DROP TABLE test_t;

--A
DROP TRIGGER trig_a on test_t;
DROP FUNCTION func_a CASCADE;


CREATE FUNCTION func_a() RETURNS TRIGGER
LANGUAGE plpgsql AS $$
    BEGIN
        new.time = current_timestamp;
        RETURN new;
    END;
    $$;

CREATE TRIGGER trig_a
    BEFORE INSERT OR UPDATE ON test_t
    FOR EACH ROW
    EXECUTE FUNCTION func_a();

INSERT INTO test_t(time) VALUES (to_timestamp(1));

--B
DROP TRIGGER trig_b ON test_t;
DROP FUNCTION func_b CASCADE;


CREATE FUNCTION func_b() RETURNS TRIGGER
LANGUAGE plpgsql AS $$
    BEGIN
        new.age = date_part('year', age(new.birth));
        RETURN new;
    END;
    $$;

CREATE TRIGGER trig_b
    BEFORE INSERT ON test_t
    FOR EACH ROW
    EXECUTE FUNCTION func_b();

INSERT INTO test_t VALUES (to_timestamp(1), to_timestamp(1));

--C
DROP TRIGGER trig_c ON test_t;
DROP FUNCTION func_c CASCADE;

CREATE FUNCTION func_c() RETURNS TRIGGER
LANGUAGE plpgsql AS $$
    BEGIN
        new.price = 1.12 * new.price;
        RETURN new;
    END;
    $$;

CREATE TRIGGER trig_c
    BEFORE INSERT ON test_t
    FOR EACH ROW
    EXECUTE FUNCTION func_c();

INSERT INTO test_t(price) VALUES (100);

--D
DROP TRIGGER trig_d ON test_t;
DROP FUNCTION func_d CASCADE;


CREATE FUNCTION func_d() RETURNS TRIGGER
LANGUAGE plpgsql AS $$
    BEGIN
        RAISE EXCEPTION 'DONT DELETE IT!';
    END;
    $$;

CREATE TRIGGER trig_d
    BEFORE DELETE ON test_t
    FOR EACH ROW
    EXECUTE PROCEDURE func_d();

DELETE FROM test_t;

--E
DROP TRIGGER trig_e ON test_t;
DROP FUNCTION func_e CASCADE;

CREATE FUNCTION func_e() RETURNS TRIGGER
LANGUAGE plpgsql AS $$
    BEGIN
        new.sq_price = E(new.price);
        IF NOT D(new.password) THEN
            RAISE EXCEPTION 'Wrong!';
        END IF;
        RETURN new;
    END;
    $$;

CREATE TRIGGER trig_e
    BEFORE INSERT ON test_t
    FOR EACH ROW
    EXECUTE FUNCTION func_e();

INSERT INTO test_t( price, password) VALUES(10,'Hhaksdjlaw1');

--EX 3
--The main difference between FUNCTION and PROCEDURE is that FUNCTION RETURNS some value, PROCEDURE don't.

--EX 4
--Table
CREATE TABLE work(
    salary INTEGER,
    age INTEGER,
    work_exp INTEGER,
    discount INTEGER
);
DROP TABLE work;
INSERT INTO work VALUES (100000, 45, 15);
INSERT INTO work VALUES(50000, 25, 5);
--A
CREATE PROCEDURE A()
LANGUAGE plpgsql AS $$
    BEGIN
        UPDATE work SET salary = salary * (1 + 0.1 * (work.work_exp / 2));
        UPDATE work SET discount = 10 + (1 * (work_exp - 5)) WHERE work_exp > 5;
        UPDATE work SET discount = 10 WHERE work_exp <= 5;
    END;
    $$;
--B
CREATE PROCEDURE B()
LANGUAGE plpgsql AS $$
    BEGIN
        UPDATE work SET salary = salary * 1.15 WHERE age >= 40;
        UPDATE work SET salary = salary * 1.15, discount = 20 WHERE work_exp > 8;
    END;
    $$;
CALL A();
CALL B();

--EX 5
WITH RECURSIVE recommenders(recommender, member) AS (
    SELECT recommendedby, memid FROM cd.members UNION ALL
    SELECT cd.member.recommendedby, recommenders.member FROM recommenders
        INNER JOIN cd.members
                ON cd.members.memid = recommenders.recommender)
SELECT recommenders.member AS member, recommenders.recommender, cd.members.firstname, cd.members.surname
    FROM recommenders INNER JOIN cd.members
        ON recommenders.recommender = cd.members.memid
            WHERE recommenders.member = 22  OR recommenders.member = 12
ORDER BY recommenders.member ASC, recommenders.recommender DESC;