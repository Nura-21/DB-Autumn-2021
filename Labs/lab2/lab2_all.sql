-- 1 EXERCISE
-- DDL 1
CREATE TABLE info(
    NAME varchar(25) NOT NULL,
    LAST_NAME varchar(25) NOT NULL,
    AGE integer CHECK(AGE > 0) NOT NULL,
    SEX varchar(6)
);
-- DDL 2
ALTER TABLE info ADD BIRTH_DATE date;

-- DML 1
INSERT INTO info VALUES ('Nurassyl', 'Trdln',18,'Male',to_date('21/10/2002','dd/mm/yyyy'));
INSERT INTO info VALUES ('Adam', 'First',25,'Male',to_date('15/12/1995','dd/mm/yyyy'));
INSERT INTO info VALUES ('Eva', 'Second',25,'Female',to_date('09/12/1995','dd/mm/yyyy'));

-- DML 2
DELETE FROM info WHERE SEX = 'Female';

-- DML 3
UPDATE info SET LAST_NAME = 'Turdalin' WHERE NAME = 'Nurassyl';

-- DML 4
SELECT * FROM info;

-- DDL 3
TRUNCATE TABLE info;

-- DDL 4
DROP TABLE info;



-- 2 EXERCISE
CREATE TABLE products(
    id VARCHAR PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    description TEXT,
    price DOUBLE PRECISION NOT NULL CHECK(price > 0)
);

CREATE TABLE customers(
    id INTEGER PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    delivery_address text NOT NULL
);

CREATE TABLE orders(
    code INTEGER PRIMARY KEY,
    customer_id INTEGER,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    total_sum DOUBLE PRECISION NOT NULL CHECK(total_sum > 0),
    is_paid BOOLEAN NOT NULL
);

CREATE TABLE order_items(
    product_id VARCHAR UNIQUE NOT NULL,
    order_code INTEGER UNIQUE NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (order_code) REFERENCES orders(code) ON DELETE CASCADE,
    PRIMARY KEY (product_id,order_code),
    quantity INTEGER NOT NULL CHECK(quantity > 0)
);



-- 3 EXERCISE
CREATE TABLE students(
    id INTEGER PRIMARY KEY,
    full_name VARCHAR UNIQUE NULL,
    age INTEGER NOT NULL CHECK(AGE > 0 and AGE < 100)
);

CREATE TABLE students_info(
    student_id INTEGER UNIQUE NOT NULL,
    birth_date DATE NOT NULL,
    sex VARCHAR NOT NULL CHECK(sex = 'Male' or sex = 'Female'),
    avg_grade INTEGER NOT NULL,
    inf_uslf TEXT,
    need_for_dorm TEXT,
    add_inf TEXT,
    FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE
);

CREATE TABLE participants(
    student_id INTEGER NOT NULL,
    lesson_id VARCHAR NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    PRIMARY KEY (student_id, lesson_id)
);

CREATE TABLE lessons(
    id VARCHAR PRIMARY KEY,
    name_of_lesson VARCHAR NOT NULL,
    inst_id INTEGER NOT NULL,
    room INTEGER NOT NULL CHECK (room > 0 and room < 301),
    FOREIGN KEY (inst_id) REFERENCES instructors(id) ON DELETE CASCADE
);
CREATE TABLE instructors(
    id INTEGER PRIMARY KEY,
    full_name VARCHAR UNIQUE NOT NULL,
    poss_of_remote_les BOOLEAN
);

CREATE TABLE instructors_info(
    inst_id INTEGER UNIQUE NOT NULL,
    sp_lang VARCHAR NOT NULL,
    age INTEGER NOT NULL CHECK (age > 0 and age < 100),
    work_exp INTEGER NOT NULL CHECK(work_exp > 0 and work_exp < age),
    FOREIGN KEY (inst_id) REFERENCES instructors(id) ON DELETE CASCADE
);



INSERT INTO students VALUES (1,'Turdalin Nurassyl',18);
INSERT INTO students VALUES (2,'Adam First',21);
INSERT INTO students VALUES (3,'Eva Second',21);
INSERT INTO students VALUES (4,'Ava Third',19);

INSERT INTO instructors VALUES (1,'Beisenbek Baisakov',TRUE);
INSERT INTO instructors VALUES (2,'Askar Dzhumadildaev',TRUE);
INSERT INTO instructors VALUES (3,'BRB',TRUE);
INSERT INTO instructors VALUES (4,'Kooks NHK',TRUE);
INSERT INTO instructors VALUES (5,'Askar Akshabaev',TRUE);
INSERT INTO instructors VALUES (6,'Alimzhan Amanov',TRUE);

INSERT INTO lessons VALUES (101,'Algo',1,205);
INSERT INTO lessons VALUES (102,'Algo',5,206);
INSERT INTO lessons VALUES (103,'Algo',6,207);
INSERT INTO lessons VALUES (111,'Discrete',2,222);
INSERT INTO lessons VALUES (121,'Russian',3,115);
INSERT INTO lessons VALUES (135,'DB Practise',4,255);

INSERT INTO participants VALUES (1,101);
INSERT INTO participants VALUES (1,135);
INSERT INTO participants VALUES (2,101);

SELECT students.full_name,name_of_lesson,room,instructors.full_name FROM participants,students,lessons,instructors
WHERE participants.student_id = students.id and participants.lesson_id = lessons.id and lessons.inst_id = instructors.id;


-- 4 EXERCISE
INSERT INTO customers VALUES (21, 'Nurassyl Turdalin', current_timestamp, 'Islam Karimova 70');
INSERT INTO customers VALUES (01, 'Adam First', current_timestamp, 'Drevo Zhizni');
INSERT INTO customers VALUES (02, 'Eva Second', current_timestamp, 'Drevo Zhizni');

INSERT INTO products VALUES ('apl', 'Apple','Forbidden apple',42500);
INSERT INTO products VALUES ('ban', 'Banana','The best fruit',600);
INSERT INTO products VALUES ('wat', 'Water','One of the most important things for life',150);

INSERT INTO orders VALUES(1,1,42500 * 2, TRUE);
INSERT INTO orders VALUES(2,21,600 * 10, TRUE);
UPDATE orders SET is_paid = FALSE WHERE customer_id = 21;
DELETE FROM orders WHERE customer_id = 21;

INSERT INTO order_items VALUES ('apl',1,2);
INSERT INTO order_items VALUES ('ban',2,10);