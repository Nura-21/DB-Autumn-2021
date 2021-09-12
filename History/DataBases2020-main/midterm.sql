CREATE DATABASE midterm;
DROP DATABASE midterm;
CREATE TABLE movies
(
    id     SERIAL PRIMARY KEY,
    title  VARCHAR(255) NOT NULL UNIQUE,
    rating INTEGER,
    genre  VARCHAR(50)  NOT NULL
);

CREATE TABLE theaters
(
    id   SERIAL PRIMARY KEY,
    name varchar(255)              NOT NULL UNIQUE,
    size INTEGER CHECK (size >= 3) NOT NULL,
    city varchar(50)               NOT NULL,
);


INSERT INTO movies(title, rating, genre)
VALUES ('Citizen Kane', 5, 'Drama'),
       ('Singin'' in the Rain', 8, 'Comedy'),
       ('The Wizard of Oz', 2, 'Fantasy'),
       ('The Quiet Man', null, 'Comedy'),
       ('North by Northwest', null, 'Thriller'),
       ('The Last Tango in Paris', 9, 'Drama');

INSERT INTO theaters(name, size, city)
VALUES ('Kinopark Esentai', 15, 'Almaty'),
       ('Star Cinema Mega', 7, 'Almaty'),
       ('Kinopark 8', 9, 'Shymkent'),
       ('Star Cinema 15', 11, 'Aktau');

--2
SELECT DISTINCT ON (city) city, name
FROM theaters;

--3
SELECT *
FROM theaters
WHERE size IS NOT NULL
ORDER BY size DESC
LIMIT 3;

--4
SELECT *
FROM movies
ORDER BY rating DESC
OFFSET 2 LIMIT 1;

--5
SELECT *
FROM movies
WHERE rating IS NOT NULL;

--6
SELECT *
FROM movies
WHERE (genre = 'Comedy' OR genre = 'Fantasy')
  AND rating IS NOT NULL;


--7
SELECT id      AS "Movie ID",
       CASE
           WHEN rating IS NULL
               THEN format('The %s has no rating', title)
           WHEN rating BETWEEN 0 AND 3
               THEN format('The rating of %s is Low', title)
           WHEN rating BETWEEN 4 AND 7
               THEN format('The rating of %s is Medium', title)
           WHEN rating BETWEEN 8 AND 10
               THEN format('The rating of %s is High', title)
           END AS "MovieInfo"
FROM movies;


--8
CREATE TABLE movietheaters
(
    theater_id int REFERENCES theaters (id),
    movie_id   int REFERENCES movies (id),
    rating     int,
    PRIMARY KEY (theater_id, movie_id)
);


INSERT INTO movietheaters
VALUES (1, 5, 5),
       (3, 1, 7),
       (1, 3, 9),
       (4, 6, 6),
       (2, 3, 5),
       (4, 4, 7);


--9
SELECT *
FROM movies
WHERE id NOT IN (SELECT movie_id FROM movietheaters);

--10
SELECT upper(title), substr(title, 4), char_length(title)
FROM movies;

--11
UPDATE movies
SET rating = 1
WHERE rating IS NULL;

--12
DELETE
FROM movies
WHERE id NOT IN (SELECT movie_id FROM movietheaters);


--13
SELECT *
FROM movies
WHERE title LIKE ('S%o_');


--14
SELECT city, avg(size) AS "Average Size"
FROM theaters
GROUP BY city;


--15
SELECT *
FROM movies
WHERE id = ANY (SELECT movie_id FROM movietheaters GROUP BY movie_id HAVING count(movie_id) > 2);


