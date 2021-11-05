--EX 1
--A
SELECT * FROM dealer CROSS JOIN client;

--B
SELECT dealer.name,client.name,client.city,sell.id,sell.date,sell.amount
FROM sell LEFT JOIN
    dealer ON dealer.id = sell.dealer_id LEFT JOIN
        client ON client.id = sell.client_id;

--C
--We don't take that client belongs to only one dealer
SELECT dealer.name,client.name,client.city FROM dealer INNER JOIN client
    ON  dealer.location = client.city;
--Now we take
SELECT dealer.name,client.name FROM dealer INNER JOIN client
    ON dealer.id = client.dealer_id AND dealer.location = client.city;

--D
SELECT sell.id,sell.amount,client.name,client.city
FROM sell INNER JOIN client ON sell.client_id = client.id
    AND sell.amount BETWEEN 100 AND 500;

--E
SELECT dealer.name, client.name FROM client LEFT JOIN dealer
    ON dealer.id=client.dealer_id
    ORDER BY dealer.id;

--F
SELECT client.name,client.city,dealer.name,dealer.charge FROM client LEFT JOIN dealer
    ON dealer.id=client.dealer_id;

--G
SELECT client.name,client.city,dealer.name,dealer.charge FROM client INNER JOIN dealer
    ON dealer.id=client.dealer_id AND dealer.charge > 0.12;

--H
SELECT client.name, client.city, sell.id, sell.date, sell.amount, dealer.name, dealer.charge FROM sell INNER JOIN
    client ON sell.client_id = client.id INNER JOIN dealer ON sell.dealer_id = dealer.id;

--I
SELECT client.name,client.city,client.priority, dealer.name, sell.id, sell.date, sell.amount FROM client LEFT JOIN dealer
    ON dealer.id=client.dealer_id LEFT JOIN sell
    ON sell.client_id=client.id
    WHERE sell.amount>=2000
        AND client.priority IS NOT NULL;

--EX 2
--A
CREATE VIEW A AS (SELECT date, COUNT(DISTINCT id), AVG(amount),SUM(amount) FROM sell GROUP BY date);
SELECT * FROM A;

--B
CREATE VIEW B AS (SELECT date, SUM(amount) FROM sell GROUP BY date ORDER BY 2 DESC LIMIT 5);
SELECT * FROM B;

--C
CREATE VIEW C AS (SELECT dealer_id, COUNT(DISTINCT id), AVG(amount),SUM(amount) FROM sell GROUP BY dealer_id);
SELECT * FROM C;

--D
CREATE VIEW D AS (SELECT dealer.name, sell.dealer_id, COUNT(sell.dealer_id), SUM(sell.amount) * dealer.charge AS earned
FROM sell INNER JOIN dealer ON sell.dealer_id = dealer.id
GROUP BY dealer_id, dealer.charge,dealer.name);
SELECT * FROM D;

--E
CREATE VIEW E AS (SELECT dealer.location, COUNT(DISTINCT sell.id), AVG(sell.amount), SUM(sell.amount) as am FROM sell INNER JOIN
    dealer ON sell.dealer_id = dealer.id GROUP BY dealer.location ORDER BY 2 ASC);
SELECT * FROM E;

--F
CREATE VIEW F AS (SELECT client.city, COUNT(client.city), SUM(sell.amount), AVG(sell.amount)
    FROM client INNER JOIN sell ON client.id = sell.client_id
    GROUP BY client.city);
SELECT * FROM F;

--G
--DIDN'T UNDERSTAND
