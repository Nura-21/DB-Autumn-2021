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

DO $$
DECLARE bal INTEGER;
         lim INTEGER;
        BEGIN;
        SAVEPOINT s1;
        UPDATE accounts
        SET balance = balance - 400
        WHERE account_id = 'RS88012';
        UPDATE accounts
        SET balance = balance + 400
        WHERE account_id = 'NT10204';
        SELECT balance INTO bal FROM accounts WHERE account_id = 'RS88012';
        SELECT accounts.limit INTO lim FROM accounts WHERE account_id = 'RS88012';
        if bal < lim THEN
        ROLLBACK TO SAVEPOINT s1;
            UPDATE transactions SET status = 'rollback' WHERE id = 3;
        ELSE
            COMMIT;
            UPDATE transactions SET status = 'commited' WHERE id = 3;
        END IF;
    END;
$$
--6)
DO $$
    DECLARE
        bal INT;
        lim INT;
    BEGIN
        INSERT INTO transactions VALUES(4,now(),'RS88012','NT10204',400,'init');
        UPDATE accounts SET balance=balance-99
        WHERE account_id='RS88012';
        UPDATE accounts SET balance=balance+99
        WHERE account_id='NT10204';
        SELECT accounts.balance INTO bal FROM accounts WHERE account_id='RS88012';
        SELECT accounts.limit INTO lim FROM accounts WHERE account_id='RS88012';
        IF bal < lim THEN
            UPDATE accounts SET balance=balance+400
            WHERE account_id='RS88012';
            UPDATE accounts SET balance=balance-400
            WHERE account_id='NT10204';
            UPDATE transactions SET status = 'rollback' WHERE id=4;
        ELSE
            UPDATE transactions SET status = 'commit' WHERE id=4;
        END IF;
        COMMIT;
END$$;



DO $$
    DECLARE
        bal INT;
        lim INT;
    BEGIN
        INSERT INTO transactions VALUES(4,now(),'RS88012','NT10204',400,'init');
        SELECT accounts.balance INTO bal FROM accounts WHERE account_id='RS88012';
        SELECT accounts.limit INTO lim FROM accounts WHERE account_id='RS88012';
        IF bal < lim THEN
            UPDATE transactions SET status = 'rollback' WHERE id=4;
        ELSE
            UPDATE accounts SET balance=balance-400
            WHERE account_id='RS88012';
            UPDATE accounts SET balance=balance+400
            WHERE account_id='NT10204';
            UPDATE transactions SET status = 'commit' WHERE id=4;
        END IF;
        COMMIT;
END$$;