CREATE DATABASE last_lab_exm;

CREATE TABLE goods
(
    id     SERIAL PRIMARY KEY,
    title  VARCHAR(30) NOT NULL,
    price  DEC(15, 2)  NOT NULL,
    amount INTEGER
);


INSERT INTO goods(title, price, amount)
VALUES ('Cola', 300.0, 1000),
       ('Pepsi', 350.0, 1000),
       ('Sprite', 320.0, 1000);

SELECT *
FROM goods;

BEGIN;

UPDATE goods
SET amount = amount - 300
WHERE title = 'Cola';
SAVEPOINT save_point_one;
UPDATE goods
SET amount = amount + 30000
WHERE title = 'Cola';
ROLLBACK TO save_point_one;
SELECT *
FROM goods;
COMMIT;