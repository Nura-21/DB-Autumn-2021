--LAB 4
--EX 1

--A
/*
    1. PRE-design or conceptual design - starts from analysing of requirements.
When every data requirement is stored and analyzed, the next thing that we need to do is creating a conceptual database plan.
You can make design everywhere where you can write or draw. We have some websites for drawing design of database.
Also, you can draw in usual paper :)

    2. Logical Design - where is logic?
The logical phase of database design is also called the data modeling mapping phase.
This phase gives us a result of relation schemas. The basis for these schemas is the ER or the Class Diagram.
To create the relation schemas is mainly mechanical operation. There are rules for transferring the ER model
or class diagram to relation schemas.

    3. Normalization - is it really necessary?
Normalization is, in fact, the last piece of the logical design puzzle.
The main purpose of normalization is to remove superfluity and every other potential anomaly during the update.
Normalization in database design is a way to change the relation schema to reduce any superfluity.

    4. Physical Design - let's create!
The last phase of database design is the physical design phase. In this phase, we implement the database design.
Here, a DBMS (Database Management System) must be chosen to use.
Also, the indexes and the integrity constraints (rules) are defined in this phase.
And finally the data is added and the database can finally be tested.
*/

--B
/* ER - Entity-Relationship
   Using ER we can take some table like "Entity" and make relations between other Entities. So we can make easier
   designing and pondering of database. First three steps of designing we can take as steps of ER modeling.
   Nowadays, we use Crow's foot notation in designs.
*/

--EX 2
--A
--Simple - each of attributes is simple and doesn't consist of anything else
CREATE TABLE student(
    id              INTEGER         PRIMARY KEY,
    gender          VARCHAR         NOT NULL CHECK(gender IN('Male', 'Female')),
    b_date          DATE            NOT NULL,
    nation          VARCHAR         NOT NULl,
    study_year      INTEGER         NOT NULL,
    gpa             FLOAT           NOT NULL CHECK(gpa >= 0 and gpa <= 4)
);

--Derived - Full name of student consists of f_name and s_name
CREATE TABLE student_full_name(
    id              INTEGER         REFERENCES student(id) PRIMARY KEY,
    f_name          VARCHAR(25)     NOT NULL,
    s_name          VARCHAR(25)     NOT NULL
);

--Composite - one address consist of several attributes
CREATE TABLE student_address(
    id              INTEGER         REFERENCES student(id),
    city            VARCHAR         NOT NULL,
    street          VARCHAR         NOT NULL,
    house           VARCHAR         NOT NULL
);

--Multi Valued - one student can have multiple phone numbers
CREATE TABLE student_phone_numbers(
    id              INTEGER         REFERENCES student(id) ON DELETE CASCADE,
    phone_number    VARCHAR         PRIMARY KEY
);

INSERT INTO student VALUES(1,'Male',to_date('21/10/2002','dd/mm/yyyy'),'Kazakh',2,3.5);
INSERT INTO student_phone_numbers VALUES(1,'001');
INSERT INTO student_phone_numbers VALUES(1,'002');
INSERT INTO student_phone_numbers VALUES(1,'003');

--B
CREATE TABLE university(
    name            VARCHAR         PRIMARY KEY,
    address         VARCHAR         UNIQUE NOT NULL,
    rector_name     VARCHAR         NOT NULL,
    found_year      INTEGER         NOT NULL CHECK (found_year >= 1900 AND found_year <= 2022),
    website         VARCHAR         UNIQUE NOT NULL,
    student_amount  INTEGER         NOT NULL CHECK (student_amount >= 0)
);

CREATE TABLE department(
    u_name          VARCHAR         NOT NULL REFERENCES university(name) ON DELETE CASCADE,
    dept_name       VARCHAR         PRIMARY KEY,
    budget          INTEGER         CHECK (budget >= 0)
);

CREATE TABLE course(
    course_id       VARCHAR(8)      PRIMARY KEY,
    t_id            INTEGER         NOT NULL REFERENCES instructor(id) ON DELETE CASCADE,
    dept_name       VARCHAR         NOT NULL REFERENCES department(dept_name) ON DELETE CASCADE,
    title           VARCHAR         UNIQUE NOT NULL,
    credits         INTEGER         NOT NULL CHECK(credits >= 0 AND credits <= 6)
);

CREATE TABLE dormitory(
    u_name          VARCHAR         NOT NULL REFERENCES university(name) ON DELETE CASCADE,
    dorm_id         VARCHAR         PRIMARY KEY,
    address         VARCHAR         UNIQUE NOT NULL,
    contacts        VARCHAR         NOT NULL
);

CREATE TABLE dorm_info(
    dorm_id         VARCHAR         NOT NULL REFERENCES dormitory(dorm_id) ON DELETE CASCADE,
    capacity        INTEGER         NOT NULL CHECK(capacity >= 0),
    current_amount  INTEGER         NOT NULL CHECK(current_amount >= 0 AND current_amount <= capacity),
    dorm_director   VARCHAR         NOT NULL
);

CREATE TABLE instructor(
    id              INTEGER         PRIMARY KEY,
    name            VARCHAR         NOT NULL,
    dept_name       VARCHAR         NOT NULL REFERENCES department(dept_name) ON DELETE CASCADE,
    age             INTEGER         NOT NULL CHECK(age >= 18 AND age <= 100)
);

CREATE TABLE office_registrar(
    u_name          VARCHAR         NOT NULL REFERENCES university(name) ON DELETE CASCADE,
    room            INTEGER         NOT NULL CHECK(room >= 0 AND room <= 100),
    phone           VARCHAR         UNIQUE NOT NULL,
    start_hr        INTEGER         NOT NULL CHECK(start_hr >= 0 AND start_hr < 24),
    end_hr          INTEGER         NOT NULL CHECK(end_hr > 0 AND end_hr<=24)
);

DROP TABLE office_registrar,university,instructor,dorm_info,dormitory,department,course;

--EX 3
-- ONE_to_ONE
-- One person have only one row with his info
CREATE TABLE person(
    id              INTEGER         PRIMARY KEY,
    full_name       VARCHAR         NOT NULL
);

CREATE TABLE person_info(
    id              INTEGER         NOT NULL REFERENCES person(id) ON DELETE CASCADE,
    city            VARCHAR         NOT NULL,
    phone           VARCHAR         NOT NULL,
    b_date          DATE            NOT NULL,
    age             INTEGER         NOT NULL CHECK(age >= 1 AND age<= 111),
    alive           BOOLEAN         NOT NULL
);

DROP TABLE person,person_info;

-- ONE_to_MANY
-- One customer can have many orders
CREATE TABLE customer(
    id              INTEGER         PRIMARY KEY,
    name            VARCHAR         NOT NULL
);

CREATE TABLE orders(
    order_id        INTEGER         PRIMARY KEY,
    customer_id     INTEGER         NOT NULL REFERENCES customer(id) ON DELETE CASCADE
);

DROP TABLE customer,orders;

--MANY_to_ONE
-- Showroom consists of many car
CREATE TABLE car(
    id              VARCHAR         PRIMARY KEY,
    brand           VARCHAR         NOT NULL,
    body            VARCHAR         NOT NULL,
    power           VARCHAR         NOT NULL
);

CREATE TABLE showroom(
    showroom_name   VARCHAR         NOT NULL,
    car_id          VARCHAR         NOT NULL REFERENCES car(id) ON DELETE CASCADE,
    price           INTEGER         NOT NULL CHECK(price>=1)
);

DROP TABLE car,showroom;

--MANY_to_MANY
--One student can have many classes and one class can have many students
CREATE TABLE stud(
    id              INTEGER         PRIMARY KEY,
    full_name       VARCHAR         NOT NULL,
    phone           VARCHAR
);

CREATE TABLE classes(
    id              INTEGER         PRIMARY KEY,
    title           VARCHAR         NOT NULL,
    room            INTEGER         NOT NULL CHECK(room >= 1 AND room <= 100)
);

CREATE TABLE stud_class(
    stud_id         INTEGER         NOT NULL REFERENCES stud(id) ON DELETE CASCADE,
    class_id        INTEGER         NOT NULL REFERENCES classes(id) ON DELETE CASCADE
);

DROP TABLE stud,classes,stud_class;


