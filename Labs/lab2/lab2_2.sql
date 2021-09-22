-- 2 EXERCISE
CREATE TABLE products(
    id VARCHAR PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    description TEXT,
    price DOUBLE PRECISION NOT NULL CHECK(price > 0)
);

CREATE TABLE customers(
    id INTEGER PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    delivery_address text NOT NULL
);

CREATE TABLE orders(
    code INTEGER PRIMARY KEY,
    customer_id INTEGER,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    total_sum DOUBLE PRECISION NOT NULL CHECK(total_sum > 0),
    is_paid BOOLEAN NOT NULL
);

CREATE TABLE order_items(
    product_id VARCHAR UNIQUE NOT NULL,
    order_code INTEGER UNIQUE NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (order_code) REFERENCES orders(code) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK(quantity > 0)
);