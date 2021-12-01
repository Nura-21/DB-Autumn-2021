INSERT INTO customer VALUES (1,'Adam','7777','Adam@world.kz');
INSERT INTO customer VALUES (2,'Eva','6666','Eva@world.kz');
INSERT INTO customer VALUES (3,'Third','5555','Third@world.kz');

INSERT INTO type_cat VALUES (1,'Phone');

INSERT INTO manuf_cat VALUES (1,'Apple');
INSERT INTO manuf_cat VALUES (2,'Samsung');
INSERT INTO manuf_cat VALUES (3,'Huawei');

INSERT INTO product VALUES (1,'Iphone X',1,1);
INSERT INTO product VALUES (2,'A51',1,2);
INSERT INTO product VALUES (3,'P20',1,3);
INSERT INTO product VALUES (4,'Iphone 11',1,1);

INSERT INTO price VALUES (1,12000);
INSERT INTO price VALUES (2,9000);
INSERT INTO price VALUES(3,5000);
INSERT INTO price VALUES(4,15000);

INSERT INTO warehouse VALUES (1,'Main WH','Kooksova 1','+7(771) 777-77-77');
INSERT INTO warehouse VALUES (2,'Second WH','Kooksova 2','+7(777) 777-77-77');

CALL insert_warehouse(1,1,100);
CALL insert_warehouse(1,2,50);
CALL insert_warehouse(2,1,70);

INSERT INTO store VALUES (1, 'Main Store','California');
INSERT INTO store VALUES (2,'Second Store','Kooksova');

CALL insert_store(1,1,50);
CALL insert_store(1,2,60);
CALL insert_store(2,1,10);
CALL insert_store(2,3,5);

INSERT INTO shipper VALUES('USPS');
INSERT INTO shipper VALUES('DMS');
INSERT INTO shipper VALUES('FedEx');

INSERT INTO ships VALUES(DEFAULT,'USPS','123456',1,3,1,current_timestamp,'California',1);
INSERT INTO ships VALUES(DEFAULT,'FedEx','000001',2,1,1,current_timestamp,'Kooksova',2);
INSERT INTO ships VALUES(DEFAULT,'FedEx','000002',1,4,2,current_timestamp,'Kooksova',69);
INSERT INTO ships VALUES(DEFAULT,'DMS','000003',1,2,1,current_timestamp,'Kooksova',15 );
INSERT INTO ships VALUES(DEFAULT,'DMS','009090',1,1,1,to_timestamp(1),'Kooksova 123',9);

INSERT INTO sales (SALE_ID,customer, product, date, store, amount) VALUES (1,1,1,current_timestamp,1,3);
INSERT INTO sales (SALE_ID,customer, product, date, store, amount) VALUES (2,2,3,current_timestamp,1,5);
INSERT INTO sales (SALE_ID,customer, product, date, store, amount) VALUES (3,2,4,current_timestamp,1,10);
INSERT INTO sales (SALE_ID,customer, product, date, store, amount) VALUES (4,1,4,current_timestamp,2,20);
INSERT INTO sales (SALE_ID,customer, product, date, store, amount) VALUES (5,2,1,to_timestamp('2002-02-02','yyyy-mm-dd'),2,50);

INSERT INTO replenishment VALUES (1,2,2,66);
INSERT INTO replenishment VALUES (2,1,1,55);
INSERT INTO replenishment VALUES (3,2,3,99);
INSERT INTO replenishment VALUES (4,2,3,11);
INSERT INTO replenishment VALUES (5,2,4,11);

INSERT INTO request VALUES(1,1,1,1,30);
INSERT INTO request VALUES(2,2,1,2,33);