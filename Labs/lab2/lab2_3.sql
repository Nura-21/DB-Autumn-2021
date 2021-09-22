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