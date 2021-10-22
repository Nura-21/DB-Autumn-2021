--All shippings
SELECT ships.track_code,customer.name,product.name,price.price,shipper.name,ships.address,ships.amount,ships.status
    FROM product,ships,customer,price,shipper
    WHERE product.barcode = price.ID
        AND ships.product_id = product.barcode
        AND customer.ID = ships.customer_id
        AND shipper.name = ships.s_name;

--Correct Updating of warehouse
WITH wh_update AS (
    UPDATE wh_info SET amount =
        (wh_info.amount + (SELECT replenishment.amount
            FROM replenishment,wh_info
            WHERE replenishment.wh_id = wh_info.ID
            AND replenishment.product_id = wh_info.product_id
            AND replenishment.REQ_ID = 5
            AND replenishment.done = FALSE))
    FROM replenishment WHERE
    replenishment.wh_id = wh_info.ID
    AND replenishment.product_id = wh_info.product_id
        AND replenishment.REQ_ID = 5
        AND replenishment.done = FALSE
    RETURNING *
), update_status AS (
    UPDATE replenishment SET done = TRUE WHERE REQ_ID = 5
)
INSERT INTO wh_info (ID,product_id,amount) SELECT wh_id,product_id,amount FROM replenishment
    WHERE NOT EXISTS (SELECT * FROM wh_update) AND EXISTS (SELECT done FROM replenishment WHERE done = FALSE);
TRUNCATE wh_info;

--Updating status of replenishment not-auto
UPDATE replenishment SET done = TRUE FROM wh_info
        WHERE replenishment.wh_id = wh_info.ID
        AND replenishment.product_id = wh_info.product_id
        AND replenishment.REQ_ID = 5;

--Products from stores
SELECT product.name,manuf_cat.manuf,price.price, store_wh.amount FROM price,product,store_wh,manuf_cat
        WHERE store_wh.product_id = product.barcode
            AND product.m_cat = manuf_cat.ID
            AND price.ID = product.barcode
            AND store_wh.ID IN (1,2);

--Updating using exact REQ_ID
WITH warehouse_update AS (
    UPDATE wh_info SET amount =
        (wh_info.amount - (SELECT request.amount
        FROM request,wh_info
        WHERE request.wh_id = wh_info.ID
            AND request.product_id = wh_info.product_id
            AND request.REQ_ID = 1))
FROM request
WHERE request.wh_id = wh_info.ID
    AND request.product_id = wh_info.product_id
    AND request.REQ_ID = 1
), store_update AS (
    UPDATE store_wh SET amount =
        (store_wh.amount + (SELECT request.amount
        FROM request,wh_info
        WHERE request.wh_id = wh_info.ID
            AND request.product_id = wh_info.product_id
            AND request.REQ_ID = 1))
    FROM request
    WHERE request.store_id = store_wh.ID
        AND request.product_id = store_wh.product_id
        AND request.REQ_ID = 1
) UPDATE request SET done = TRUE WHERE REQ_ID = 1;

--1
UPDATE wh_info SET amount =
        (wh_info.amount - (SELECT request.amount
        FROM request,wh_info
        WHERE request.wh_id = wh_info.ID
            AND request.product_id = wh_info.product_id
            AND request.done = FALSE))
FROM request
WHERE request.wh_id = wh_info.ID
    AND request.product_id = wh_info.product_id
    AND request.done = FALSE;

--2 Update value, if not exist insert values
WITH store_update AS (UPDATE store_wh SET amount =
        (store_wh.amount + (SELECT request.amount
        FROM request,wh_info
        WHERE request.wh_id = wh_info.ID
            AND request.product_id = wh_info.product_id))
    FROM request
    WHERE request.store_id = store_wh.ID
        AND request.product_id = store_wh.product_id
    RETURNING *)
INSERT INTO store_wh (ID,product_id,amount) SELECT store_id,product_id,amount FROM request
WHERE NOT EXISTS (SELECT * FROM store_update);

--If we have in store inventory we update value
UPDATE store_wh SET amount =
        (store_wh.amount + (SELECT request.amount
        FROM request,wh_info
        WHERE request.wh_id = wh_info.ID
            AND request.product_id = wh_info.product_id
            AND request.REQ_ID = 2))
    FROM request
    WHERE request.store_id = store_wh.ID
        AND request.product_id = store_wh.product_id
        AND request.REQ_ID = 2;

--If not exist we insert
INSERT INTO store_wh (ID, product_id, amount) (SELECT store_id,product_id,amount FROM request
    WHERE request.REQ_ID = 2);

--3
UPDATE request SET done = TRUE WHERE REQ_ID = 2;

--Calculating sales.total_price
--SALE_ID #
UPDATE sales SET total_price = ((SELECT amount FROM sales WHERE SALE_ID = 9) *
    (SELECT price.price FROM price,product,sales
    WHERE price.ID = product.barcode
        AND product.barcode = sales.product
        AND sales.SALE_ID = 9)) WHERE SALE_ID = 9;

--Print by categories
SELECT DISTINCT product.name,manuf_cat.manuf,type_cat.type FROM sales,product,manuf_cat,type_cat
    WHERE sales.product = product.barcode
        AND product.m_cat = manuf_cat.ID
        AND product.t_cat = type_cat.ID
        AND type_cat.ID = 1;

--Print customer which has bought the most by price last year
SELECT DISTINCT customer.name,sales.total_price FROM sales,customer
    WHERE sales.customer = customer.ID
        AND sales.total_price = (SELECT MAX(total_price) FROM sales
            WHERE date >= '2021-01-01')
    GROUP BY customer.name,sales.total_price;

--Add online purchases in sales table, then change ships.status = PAID
INSERT INTO sales (customer, product, date, store, amount)
    (SELECT customer_id,product_id,current_timestamp,store_id,amount FROM ships
        WHERE status = 'NOT PAID');
UPDATE ships set status = 'NOT PAID';
