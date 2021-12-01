DROP INDEX product_name, shipper_name, id_customer, id_store, id_wh;

CREATE INDEX CONCURRENTLY product_name ON product(barcode);
CREATE INDEX CONCURRENTLY shipper_name ON shipper(name);
CREATE INDEX CONCURRENTLY id_customer ON customer(ID);
CREATE INDEX CONCURRENTLY id_store ON store(ID);
CREATE INDEX CONCURRENTLY id_wh ON warehouse(ID);


-- DONE - Calculating sales.total_price
CREATE FUNCTION get_price(which INTEGER) RETURNS INTEGER
LANGUAGE plpgsql AS $$
    DECLARE last_price INTEGER;
    BEGIN
        last_price = (SELECT price.price FROM price, product
            WHERE which = product.barcode
                AND product.barcode = price.ID);
        RETURN last_price;
    END;
    $$;

CREATE FUNCTION calc_one() RETURNS TRIGGER
LANGUAGE plpgsql AS $$
    BEGIN
        new.total_price = new.amount * get_price(new.product);
        RETURN new;
    END;
    $$;
DROP FUNCTION calc_one();

CREATE TRIGGER calc_total
    BEFORE INSERT ON sales
    FOR EACH ROW
    EXECUTE FUNCTION calc_one();

INSERT INTO sales VALUES (6, 2, 4, current_timestamp,2,70);


-- DONE - Calculation contracts.total_price
CREATE TRIGGER calc_total
    BEFORE INSERT ON contracts
    FOR EACH ROW
    EXECUTE FUNCTION calc_one();

INSERT INTO contracts VALUES(2, 1, 1, current_timestamp, 2, 5, DEFAULT, 12);


-- DONE - Calculating ships.total_price
CREATE TRIGGER calc_total
    BEFORE INSERT ON ships
    FOR EACH ROW
    EXECUTE FUNCTION calc_one();

INSERT INTO ships VALUES (DEFAULT,'DMS','000004',2,4,2,current_timestamp, 'Aqtobe',55);
INSERT INTO ships VALUES (DEFAULT,'DMS','000005',2,3,2,current_timestamp, 'Almaty',55);


-- DONE - VIEW for All shipping
CREATE VIEW all_shipping AS(
SELECT DISTINCT ships.ship_id,ships.track_code,customer.name AS customer_name,
       product.name AS product_name,ships.amount, price.price,ships.total_price,
       shipper.name AS shipper_name,ships.address,ships.status
        FROM product,ships,customer,price,shipper
        WHERE product.barcode = price.ID
            AND ships.product = product.barcode
            AND customer.ID = ships.customer_id
            AND shipper.name = ships.s_name
            ORDER BY ship_id ASC);
DROP VIEW all_shipping;


-- DONE - VIEW for All sales
CREATE VIEW all_sales AS(
SELECT DISTINCT sales.SALE_ID,customer.name AS customer_name,
       product.name AS product_name,sales.amount, price.price,sales.total_price,
        sales.date
        FROM product,sales,customer,price
        WHERE product.barcode = price.ID
            AND sales.product = product.barcode
            AND customer.ID = sales.customer
            );
DROP VIEW all_sales;


-- DONE - Correct Insertion to store_wh and wh_info
CREATE PROCEDURE insert_store(which INTEGER, which_pr INTEGER, how_much INTEGER)
LANGUAGE plpgsql AS $$
    BEGIN
        IF EXISTS(SELECT product_id FROM store_wh WHERE product_id = which_pr AND which = ID) THEN
            UPDATE store_wh SET amount = amount + how_much WHERE product_id = which_pr AND which = ID;
        ELSE INSERT INTO store_wh VALUES (which, which_pr, how_much);
        END IF;
    END ;
    $$;

CREATE PROCEDURE insert_warehouse(which INTEGER, which_pr INTEGEr, how_much INTEGER)
LANGUAGE  plpgsql AS $$
    BEGIN
        IF EXISTS(SELECT product_id FROM wh_info WHERE product_id = which_pr AND which = ID) THEN
            UPDATE wh_info SET amount = amount + how_much WHERE product_id = which_pr AND which = ID;
        ELSE INSERT INTO wh_info VALUES (which, which_pr, how_much);
        END IF;
    END;
    $$;


-- DONE -- Replenishment of warehouses
DROP PROCEDURE for_warehouse(id_req INTEGER);
DROP FUNCTION update_wh CASCADE;
DROP TRIGGER replenish ON replenishment;

CREATE PROCEDURE for_warehouse(id_req INTEGER)
LANGUAGE plpgsql AS $$
        DECLARE how_much INTEGER;
            from_where INTEGER;
            which INTEGER;
        BEGIN
            how_much = (SELECT amount FROM replenishment WHERE REQ_ID = id_req);
            from_where = (SELECT wh_id FROM replenishment WHERE REQ_ID = id_req);
            which = (SELECT product_id FROM replenishment WHERE REQ_ID = id_req);
            IF EXISTS(SELECT * FROM wh_info,replenishment WHERE wh_info.ID = replenishment.wh_id
                AND replenishment.REQ_ID = id_req AND replenishment.product_id = wh_info.product_id) THEN
                UPDATE wh_info SET amount = amount + how_much
                    WHERE wh_info.id = from_where AND wh_info.product_id = which;
            ELSE INSERT INTO wh_info VALUES (from_where, which, how_much);
            END IF;
            UPDATE replenishment SET done = TRUE WHERE REQ_ID = id_req;
        END;
    $$;

CREATE FUNCTION update_wh() RETURNS TRIGGER
LANGUAGE plpgsql AS $$
        BEGIN
        CALL for_warehouse(new.REQ_ID);
        RETURN new;
        END;
    $$;

CREATE TRIGGER replenish
    AFTER INSERT ON replenishment
    FOR EACH ROW
    EXECUTE FUNCTION update_wh();


INSERT INTO replenishment VALUES (6, 1, 3, 100);
INSERT INTO replenishment VALUES (7, 1, 3, 100);

DELETE FROM replenishment WHERE req_id IN (6,7);


-- DONE -- Request
DROP PROCEDURE for_store(id_req INTEGER);
DROP FUNCTION update_store() CASCADE;
DROP TRIGGER make_request on request;

CREATE PROCEDURE for_store(id_req INTEGER)
LANGUAGE plpgsql AS $$
    DECLARE from_where INTEGER;
        where_from INTEGER;
        which INTEGER;
        how_much INTEGER;
    BEGIN
        from_where = (SELECT store_id FROM request WHERE REQ_ID = id_req);
        where_from = (SELECT wh_id FROM request WHERE REQ_ID = id_req);
        which = (SELECT product_id FROM request WHERE REQ_ID = id_req);
        how_much = (SELECT amount FROM request WHERE REQ_ID = id_req);
        IF EXISTS(SELECT * FROM store_wh WHERE ID = from_where AND product_id = which) THEN
            UPDATE store_wh SET amount = amount + how_much WHERE ID = from_where AND product_id = which;
        ELSE INSERT INTO store_wh VALUES (from_where, which, how_much);
        END IF;
        IF (SELECT amount FROM wh_info WHERE ID = where_from AND product_id = which) - how_much < 0 THEN
                UPDATE wh_info SET amount = 0 WHERE ID = where_from AND product_id = which;
        ELSE UPDATE wh_info SET amount = amount - how_much WHERE ID = where_from AND product_id = which;
        END IF;
        UPDATE request SET done = TRUE WHERE req_id = id_req;
    END;
    $$;

CREATE FUNCTION update_store() RETURNS TRIGGER
LANGUAGE plpgsql AS $$
    BEGIN
       CALL for_store(new.REQ_ID);
       RETURN new;
    END;
    $$;

CREATE TRIGGER make_request
    AFTER INSERT ON request
    FOR EACH ROW
    EXECUTE FUNCTION update_store();


-- SELECTS
-- Print by categories
CREATE VIEW by_categorioes AS (SELECT DISTINCT product.name,manuf_cat.manuf,type_cat.type FROM sales,product,manuf_cat,type_cat
    WHERE sales.product = product.barcode
        AND product.m_cat = manuf_cat.ID
        AND product.t_cat = type_cat.ID);


-- Products from stores
CREATE VIEW inventory AS (SELECT store.name as STORE, product.name,manuf_cat.manuf,price.price, store_wh.amount FROM price,product,store_wh,manuf_cat,store
        WHERE store_wh.product_id = product.barcode
            AND product.m_cat = manuf_cat.ID
            AND price.ID = product.barcode
            AND store.ID = store_wh.ID);


-- 1 -- Remaking ship
UPDATE ships SET status = 'ROLLBACK' WHERE s_name = 'USPS' and track_code = '123456';

CREATE PROCEDURE re_ship(ship VARCHAR,code VARCHAR(6))
LANGUAGE plpgsql AS $$
    DECLARE who INTEGER;
        what INTEGER;
        how_much INTEGER;
        from_where INTEGER;
        where_from VARCHAR;
    BEGIN
        who = (SELECT customer_id FROM ships WHERE track_code = code AND ships.s_name = ship);
        what = (SELECT product FROM ships WHERE track_code = code AND ships.s_name = ship);
        how_much = (SELECT amount FROM ships WHERE track_code = code AND ships.s_name = ship);
        from_where = (SELECT store_id FROM ships WHERE track_code = code AND ships.s_name = ship);
        where_from = (SELECT address FROM ships WHERE track_code = code AND ships.s_name = ship);
        INSERT INTO ships VALUES (DEFAULT, ship, code, who, what, from_where, current_timestamp , where_from, how_much);
    END;
    $$;
DROP PROCEDURE re_ship(ship VARCHAR, code VARCHAR);
CALL re_ship('USPS','123456');


-- 2 -- Print customer which has bought the most by price last year
SELECT DISTINCT customer.name,sales.total_price FROM sales,customer
    WHERE sales.customer = customer.ID
        AND sales.total_price = (SELECT MAX(total_price) FROM sales
            WHERE date >= '2021-01-01')
    GROUP BY customer.name,sales.total_price;


-- 3 -- TOP 2 products by dollar-amount in past year
CREATE FUNCTION all_bills(per timestamp) RETURNS TABLE(name VARCHAR, product INT, count BIGINT, total_price INT)
LANGUAGE plpgsql AS $$
    BEGIN
       RETURN QUERY (SELECT customer.name, sales.product, SUM(sales.amount),sales.total_price FROM customer, sales
                    WHERE sales.customer = customer.ID and sales.date > per
                    GROUP BY customer.name, sales.product,sales.total_price
                UNION ALL
                SELECT customer.name, ships.product, SUM(ships.amount),ships.total_price FROM customer, ships
                    WHERE ships.customer_id = customer.ID AND ships.dely_date > per
                    GROUP BY customer.name, ships.product, ships.total_price
                UNION ALL
                SELECT customer.name, contracts.product, SUM(contracts.amount),contracts.total_price FROM customer, contracts
                    WHERE contracts.customer_id = customer.ID AND contracts.date > per
                    GROUP BY customer.name, contracts.product, contracts.total_price ORDER BY name);
    END;
    $$;
DROP FUNCTION all_bills;
SELECT product,SUM(total_price) as total FROM all_bills(to_date('01-01-2021','dd-mm-yyyy'))
GROUP BY product ORDER BY total DESC LIMIT 2;


-- 4 -- TOP 2 products by unit in the past year
SELECT product,SUM(count) as total FROM all_bills(to_date('01-01-2021','dd-mm-yyyy'))
GROUP BY product ORDER BY total DESC LIMIT 2;


-- 5 -- Those products that are out-stock at every store
SELECT product.name FROM product,store_wh,store
    WHERE store_wh.id = store.id
      AND store.region = 'California'
      AND store_wh.amount = 0
      AND store_wh.product_id = product.barcode;


-- 6 -- NOT DELIVERED ships
CREATE VIEW not_delivered_in_time AS (
SELECT * FROM ships WHERE dely_date < current_timestamp ORDER BY ship_id ASC);


-- 7 -- BILL FOR MONTH
CREATE FUNCTION bill_for_period(who INTEGER, per TIMESTAMP) RETURNS TABLE(name VARCHAR,
product INT,
count BIGINT,
total_price INT)
LANGUAGE plpgsql AS $$
        BEGIN
            RETURN QUERY (SELECT customer.name, sales.product, SUM(sales.amount),sales.total_price FROM customer, sales
                    WHERE sales.customer = customer.ID AND sales.date > per AND customer.ID = who
                    GROUP BY customer.name, sales.product,sales.total_price
                UNION ALL
                SELECT customer.name, ships.product, SUM(ships.amount),ships.total_price FROM customer, ships
                    WHERE ships.customer_id = customer.ID AND ships.dely_date > per AND customer.ID = who
                    GROUP BY customer.name, ships.product, ships.total_price
                UNION ALL
                SELECT customer.name, contracts.product, SUM(contracts.amount),contracts.total_price FROM customer, contracts
                    WHERE contracts.customer_id = customer.ID AND contracts.date > per AND customer.ID = who
                    GROUP BY customer.name, contracts.product, contracts.total_price ORDER BY name);
        END;
    $$;

DROP FUNCTION bill_for_period;
SELECT * FROM bill_for_period(1,to_date('01-09-2021','dd-mm-yyyy'));
SELECT * FROM bill_for_period(2,to_date('01-09-2021','dd-mm-yyyy'));


-- DONE - Updating amounts of products FROM sales
CREATE PROCEDURE for_sale(id_sale INTEGER)
LANGUAGE plpgsql AS $$
    DECLARE which INTEGER;
        where_from INTEGER;
        how_much INTEGER;
    BEGIN
        which = (SELECT product FROM sales WHERE SALE_ID = id_sale);
        where_from = (SELECT store FROM sales WHERE SALE_ID = id_sale);
        how_much = (SELECT amount FROM sales WHERE SALE_ID = id_sale);
        UPDATE store_wh SET amount = amount - how_much WHERE product_id = which AND ID = where_from;
    END;
    $$;

CREATE FUNCTION after_sale() RETURNS TRIGGER
LANGUAGE plpgsql AS $$
    BEGIN
       CALL for_sale(new.SALE_ID);
       return new;
    END;
    $$;

CREATE TRIGGER update_store_after_sale
    AFTER INSERT ON sales
    FOR EACH ROW
    EXECUTE FUNCTION after_sale();

INSERT INTO sales VALUES (6,1,2,current_timestamp, 1,5);

-- DONE -- Information about all sales, ships, contracts
DROP FUNCTION everything(per timestamp);

CREATE FUNCTION everything(per timestamp) RETURNS TABLE(
    name VARCHAR,
    product INT,
    count BIGINT,
    total_price INT,
    date TIMESTAMP,
    store INT)
LANGUAGE plpgsql AS $$
    BEGIN
       RETURN QUERY (SELECT customer.name, sales.product, SUM(sales.amount),sales.total_price,sales.date,sales.store
                FROM customer, sales
                    WHERE sales.customer = customer.ID and sales.date > per
                    GROUP BY customer.name, sales.product,sales.total_price,sales.date,sales.store
                UNION ALL
                SELECT customer.name, ships.product, SUM(ships.amount),ships.total_price,ships.dely_date, ships.store_id
                FROM customer, ships
                    WHERE ships.customer_id = customer.ID AND ships.dely_date > per
                    GROUP BY customer.name, ships.product, ships.total_price,ships.dely_date, ships.store_id
                UNION ALL
                SELECT customer.name, contracts.product, SUM(contracts.amount),contracts.total_price,contracts.date,contracts.store
                FROM customer, contracts
                    WHERE contracts.customer_id = customer.ID AND contracts.date > per
                    GROUP BY customer.name, contracts.product, contracts.total_price,contracts.date,contracts.store ORDER BY date);
    END;
    $$;

SELECT * FROM everything(to_date('01-01-2021','dd-mm-yyyy'));
--CREATE VIEW for_managers AS (SELECT * FROM everything(to_date('01-01-2021','dd-mm-yyyy')));