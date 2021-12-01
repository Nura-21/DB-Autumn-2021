/*
--EX 1
We have two main types that we can use to store large-object types.
1 : BLOB (Binary Large Object)
    - large collection of uninterpreted binary data
2 : CLOB (Character Large Object)
    - large collection of character data
*/

--EX 2.1
CREATE ROLE accountant;
CREATE ROLE administrator;
CREATE ROLE support;
GRANT SELECT, INSERT ON accounts, transactions TO accountant;
GRANT ALL PRIVILEGES ON accounts, customers, transactions TO administrator;
GRANT INSERT, UPDATE, DELETE ON accounts, customers TO support;

--EX 2.2
CREATE USER adam;
CREATE USER eva;
CREATE USER kooks;
GRANT administrator to kooks;
GRANT accountant to eva;
GRANT support to adam;

--EX 2.3
CREATE USER god;
GRANT ALL PRIVILEGES on accounts, customers, transactions TO god WITH GRANT OPTION;

--EX 2.4
REVOKE ALL PRIVILEGES ON accounts, customers, transactions FROM god;

--EX 3.2
ALTER TABLE customers
    ALTER COLUMN name SET NOT NULL,
    ALTER COLUMN birth_date SET NOT NULL;

--EX 5.1
CREATE INDEX acc_info ON accounts (customer_id, currency);

--EX 5.2
CREATE INDEX bal_info ON accounts (currency, balance);

--EX 6
CREATE PROCEDURE insert_data(amnt INTEGER, trans_id INTEGER, from_acc VARCHAR, to_acc VARCHAR)
LANGUAGE plpgsql
AS $$
    DECLARE lim int;
            bal int;
    BEGIN
        INSERT INTO transactions VALUES(trans_id,now(),from_acc,to_acc,amnt,'init');
        SELECT accounts.balance INTO bal FROM accounts WHERE account_id=from_acc;
        SELECT accounts.limit INTO lim FROM accounts WHERE account_id=from_acc;
        IF bal < lim or bal < amnt THEN
            ROLLBACK;
            INSERT INTO transactions VALUES(trans_id,now(),from_acc,to_acc,amnt,'rollback');
        ELSE
            UPDATE accounts SET balance = balance - amnt WHERE account_id=from_acc;
            UPDATE accounts SET balance = balance + amnt WHERE account_id=to_acc;
            UPDATE transactions SET status = 'commited' WHERE id = trans_id;
        END IF;
    COMMIT;
    END
$$;
CALL insert_data(100, 9, 'RS88012', 'NT10204');