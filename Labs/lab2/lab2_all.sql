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
    quantity INTEGER NOT NULL CHECK(quantity > 0)
);



-- 3 EXERCISE
CREATE TABLE students(
    full_name VARCHAR PRIMARY KEY,
    age INTEGER NOT NULL CHECK(AGE > 0 and AGE < 100),
    birth_date DATE NOT NULL,
    gender VARCHAR NOT NULL,
    avg_grade INTEGER NOT NULL,
    inf_uslf TEXT NOT NULL,
    need_for_dorm TEXT,
    add_inf TEXT
);

CREATE TABLE instructors(
    full_name VARCHAR PRIMARY KEY,
    sp_lang VARCHAR NOT NULL,
    work_exp INTEGER NOT NULL CHECK(work_exp > 0),
    poss_of_remote_les BOOLEAN
);

CREATE TABLE lesson_participants(
    title VARCHAR NOT NULL,
    instr_name VARCHAR NOT NULL,
    part_studens VARCHAR NOT NULL,
    FOREIGN KEY (instr_name) REFERENCES instructors(full_name) ON DELETE CASCADE,
    FOREIGN KEY (part_studens) REFERENCES students(full_name) ON DELETE CASCADE,
    room_number INTEGER CHECK(room_number > 0 and room_number < 301)
);

INSERT INTO students VALUES ('Turdalin Nurassyl',18,to_date('21/10/2002','dd/mm/yyyy'), 'Male',4,'Love love');
INSERT INTO students VALUES ('Adam First',21,to_date('15/12/1999','dd/mm/yyyy'), 'Male',5,'First person');
INSERT INTO students VALUES ('Eva Second',21,to_date('09/12/1999','dd/mm/yyyy'), 'Female',5,'Second person');
INSERT INTO students VALUES ('Ava Third',19,to_date('22/11/2001','dd/mm/yyyy'), 'Female',3,'Third Person');

INSERT INTO instructors VALUES ('Beisenbek Baisakov','English, Russian, Kazakh', 10,TRUE);
INSERT INTO instructors VALUES ('Bobur Mukhsimbaev','English, Russian, Kazakh', 15,TRUE);
INSERT INTO instructors VALUES ('BRB','Russian!', 20,TRUE);
INSERT INTO instructors VALUES ('Askar Dzhumadildaev','English, Russian, Kazakh', 25,TRUE);

INSERT INTO lesson_participants VALUES ('ALGO','Beisenbek Baisakov','Turdalin Nurassyl',224);
INSERT INTO lesson_participants VALUES ('ALGO','Beisenbek Baisakov','Adam First',224);
INSERT INTO lesson_participants VALUES ('ALGO','Beisenbek Baisakov','Ava Third',224);

INSERT INTO lesson_participants VALUES ('Discrete','Askar Dzhumadildaev','Turdalin Nurassyl',241);
INSERT INTO lesson_participants VALUES ('Discrete','Askar Dzhumadildaev','Ava Third',241);
INSERT INTO lesson_participants VALUES ('Discrete','Askar Dzhumadildaev','Eva Second',241);



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