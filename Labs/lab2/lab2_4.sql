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