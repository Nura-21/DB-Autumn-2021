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