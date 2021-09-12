-- Step 1. Create database called «laboratory_work_4»
CREATE DATABASE laboratory_work_4;

-- Step 2-3. Create following tables «Warehouses» and «Packs» and following meanings:
CREATE TABLE Warehouses
(
    code     SERIAL PRIMARY KEY,
    location VARCHAR(255),
    capacity INTEGER
);

CREATE TABLE Packs
(
    code      CHAR(4),
    contents  VARCHAR(255),
    value     REAL,
    warehouse INTEGER,
    FOREIGN KEY (warehouse) REFERENCES Warehouses (code)
);
INSERT INTO Warehouses(location, capacity)
VALUES ('Chicago', 3),
       ('Chicago', 4),
       ('New York', 7),
       ('Los Angeles', 2),
       ('San Francisco', 8);

INSERT INTO Packs
VALUES ('0MN7', 'Rocks', 180, 3),
       ('4H8P', 'Rocks', 250, 1),
       ('4RT3', 'Scissors', 190, 4),
       ('7G3H', 'Rocks', 200, 1),
       ('8JN6', 'Papers', 75, 1),
       ('8Y6U', 'Papers', 50, 3),
       ('9J6F', 'Papers', 175, 2),
       ('LL08', 'Rocks', 140, 4),
       ('P0H6', 'Scissors', 125, 1),
       ('P2T6', 'Scissors', 150, 2),
       ('TU55', 'Papers', 90, 5);

-- Step 4. Select all packs with all columns.
SELECT *
FROM Packs;

-- Step 5. Select all packs with a value larger than $180.
SELECT *
FROM Packs
WHERE value > 180;

-- Step 6. Select all the packs distinct by contents.
SELECT DISTINCT(contents)
FROM Packs;

-- Step 7. Select the warehouse code and the number of the packs in
-- each warehouse.
SELECT warehouse, count(*)
FROM Packs
GROUP BY warehouse;

-- Step 8. Same as previous exercise,
-- but select only those warehouses where the number of the packs is greater than 2.
SELECT warehouse, count(*)
FROM Packs
GROUP BY warehouse
HAVING count(*) > 2;

-- Step 9. Create a new warehouse in Texas with a capacity for 5
-- packs.
INSERT INTO Warehouses(location, capacity)
VALUES ('Texas', 5);

-- Step 10. Create a new pack, with code "H5RT",
-- containing "Papers" with a value of $350, and located in warehouse 2.
INSERT INTO Packs
VALUES ('H5RT', 'Papers', 350, 2);

-- Step 11. Reduce the value of the third largest pack by 18%.
UPDATE Packs
SET value=value * 0.82
WHERE value = (SELECT value FROM Packs ORDER BY value  DESC NULLS LAST OFFSET 2 LIMIT 1 );

-- Step 12. Remove all packs with a value lower than $150.
DELETE
FROM Packs
WHERE value < 150;

-- Step 13. Remove all packs which is located in Chicago. Statement
-- should return all deleted data.
DELETE
FROM Packs
    USING Warehouses
WHERE Packs.warehouse = Warehouses.code
  AND Warehouses.location = 'Chicago'
RETURNING *;


-- Clear data.
DROP TABLE Packs;
DROP TABLE Warehouses;
DROP DATABASE laboratory_work_4;


--Defense example on any, some, all
SELECT *
FROM Packs;
SELECT *
FROM Warehouses;

SELECT *
FROM Packs
WHERE warehouse > ALL (SELECT avg(code) FROM Warehouses);

SELECT *
FROM Packs
WHERE code IN ('0MN7');

