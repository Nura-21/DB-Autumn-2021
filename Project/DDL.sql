DROP TABLE type_cat;
DROP TABLE manuf_cat;
DROP TABLE product;
DROP TABLE price;
DROP TABLE warehouse;
DROP TABLE wh_info;
DROP TABLE store ;
DROP TABLE store_wh;
DROP TABLE request;
DROP TABLE replenishment;
DROP TABLE customer;
DROP TABLE ships CASCADE;
DROP TABLE shipper;
DROP TABLE contracts;
DROP TABLE sales;
DROP TABLE cards;

CREATE TABLE type_cat(
    ID          INTEGER         PRIMARY KEY,
    type        VARCHAR(40)     NOT NULL
);

CREATE TABLE manuf_cat(
    ID          INTEGER         PRIMARY KEY,
    manuf       VARCHAR(30)     NOT NULL
);

CREATE TABLE product(
    barcode     INTEGER         PRIMARY KEY,
    name        VARCHAR(30)     NOT NULL,
    t_cat       INTEGER         NOT NULL,
    m_cat       INTEGER         NOT NULL,
    FOREIGN KEY (t_cat) REFERENCES type_cat(ID) ON DELETE CASCADE,
    FOREIGN KEY (m_cat) REFERENCES manuf_cat(ID) ON DELETE CASCADE
);

CREATE TABLE price(
    ID          INTEGER       NOT NULL,
    FOREIGN KEY (ID) REFERENCES product(barcode) ON DELETE CASCADE,
    price       INTEGER         NOT NULL CHECK(price >= 0)
);

CREATE TABLE warehouse(
    ID          INTEGER         PRIMARY KEY,
    name        VARCHAR         NOT NULL,
    address     VARCHAR         NOT NULL,
    phone       VARCHAR         NOT NULL
);

CREATE TABLE wh_info(
    ID          INTEGER         NOT NULL,
    product_id  INTEGER         NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(barcode) ON DELETE CASCADE,
    FOREIGN KEY (ID) REFERENCES warehouse(ID) ON DELETE CASCADE,
    amount      INTEGER         NOT NULL CHECK(amount >= 0)
);

CREATE TABLE replenishment(
    REQ_ID      INTEGER         PRIMARY KEY,
    wh_id       INTEGER         NOT NULL,
    product_id  INTEGER         NOT NULL,
    amount      INTEGER         NOT NULL CHECK(amount >= 10),
    FOREIGN KEY (wh_id) REFERENCES warehouse(ID) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(barcode) ON DELETE CASCADE,
    done        BOOLEAN         DEFAULT FALSE
);

CREATE TABLE store(
    ID          INTEGER         PRIMARY KEY,
    name        VARCHAR(30)     NOT NULL,
    region      VARCHAR(40)     NOT NULL,
    phone       VARCHAR(12)
);

CREATE TABLE store_wh(
    ID          INTEGER         NOT NULL,
    product_id  INTEGER         NOT NULL,
    FOREIGN KEY (ID) REFERENCES store(ID) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(barcode) ON DELETE CASCADE,
    amount      INTEGER         NOT NULL CHECK(amount >= 0)
);

CREATE TABLE request(
    REQ_ID      SERIAL          PRIMARY KEY,
    wh_id       INTEGER         NOT NULL,
    store_id    INTEGER         NOT NULL,
    product_id  INTEGER         NOT NULL,
    amount      INTEGER         NOT NULL CHECK(amount >= 10),
    FOREIGN KEY (wh_id) REFERENCES warehouse(ID),
    FOREIGN KEY (product_id) REFERENCES product(barcode),
    FOREIGN KEY (store_id) REFERENCES store(ID),
    done        BOOLEAN         DEFAULT FALSE
);

CREATE TABLE customer(
    ID          INTEGER         PRIMARY KEY,
    name        VARCHAR         NOT NULL,
    phone       VARCHAR(12)     UNIQUE NOT NULL,
    email       VARCHAR         UNIQUE NOT NULL
);

CREATE TABLE cards(
    ID          INTEGER         UNIQUE NOT NULL,
    FOREIGN KEY (ID) REFERENCES customer(ID),
    card        VARCHAR(19)     UNIQUE NOT NULL
);

CREATE TABLE shipper(
    name        VARCHAR(5)      PRIMARY KEY,
    website     VARCHAR         ,
    phone       VARCHAR(12)
);

CREATE TABLE ships(
    ship_id     SERIAL         PRIMARY KEY,
    s_name      VARCHAR(5)      NOT NULL,
    FOREIGN KEY (s_name) REFERENCES shipper(name) ON DELETE CASCADE,
    track_code  VARCHAR(6)      NOT NULL,
    customer_id INTEGER         NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(ID) ON DELETE CASCADE,
    product  INTEGER         NOT NULL,
    FOREIGN KEY (product) REFERENCES product(barcode) ON DELETE CASCADE,
    store_id    INTEGER         NOT NULL,
    FOREIGN KEY (store_id) REFERENCES store(ID) ON DELETE CASCADE,
    dely_date   TIMESTAMP       NOT NULL,
    address     VARCHAR         NOT NULL,
    amount      INTEGER         NOT NULL CHECK(amount >= 1),
    total_price INTEGER         CHECK (total_price >= 1),
    status      VARCHAR         DEFAULT 'NOT PAID'
);
-- Status : ['NOT PAID','PAID','SENT','ROLLBACK','DELIVERED']

CREATE TABLE sales(
    SALE_ID     SERIAL          PRIMARY KEY,
    customer    INTEGER         NOT NULL,
    FOREIGN KEY (customer) REFERENCES customer(ID) ON DELETE CASCADE,
    product     INTEGER         NOT NULL,
    FOREIGN KEY (product) REFERENCES product(barcode) ON DELETE CASCADE,
    date        TIMESTAMP       NOT NULL,
    store       INTEGER         NOT NULL,
    FOREIGN KEY (store) REFERENCES store(ID) ON DELETE CASCADE,
    amount      INTEGER         NOT NULL CHECK(amount >= 1),
    total_price INTEGER         CHECK(total_price >= 0)
);

CREATE TABLE contracts(
    CON_ID      INTEGER         PRIMARY KEY,
    customer_id INTEGER         NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(ID) ON DELETE CASCADE,
    product     INTEGER         NOT NULL,
    FOREIGN KEY (product) REFERENCES product(barcode) ON DELETE CASCADE,
    date        TIMESTAMP       NOT NULL,
    store       INTEGER         NOT NULL,
    FOREIGN KEY (store) REFERENCES store(ID) ON DELETE CASCADE,
    amount      INTEGER         NOT NULL CHECK(amount >= 1),
    total_price INTEGER         NOT NULL CHECK(total_price >= 0),
    period      INTEGER         NOT NULL CHECK(period >= 1)--IN MONTH
);