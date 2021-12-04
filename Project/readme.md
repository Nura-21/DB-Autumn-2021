Turdalin Nurassyl
DATABASE PROJECT of Electronics vendor
In total, I have 16 tables, 5 views for information, 14 functions and triggers. 
Due to the fact that I started creating the relational model during mid-term, I had enough time to think over and make small details, think over the strong logic of the project.
As a result, the whole project came out + - 600 lines.
1) The table with products is the main one of the three smaller tables. This is a table with information about categories, manufacturers, prices for each product.
2) Store table. Even if it is logically one, I made two tables, where the main information is stored about the store itself, where their IDs are the prime keys. And the second table, which is essentially the store's inventory. Where information is stored with a link to which store, products, their quantity.
3) Warehouse table. The structure is very similar to the store table. The main table contains information about warehouses, the second table contains information about products and their quantity.
4) Replenishment table, in which each request must populate warehouses with specific products. For this table, I created a procedure that monitors whether this product is in stock or not.
5) A table of requests, in which each request must take a specific product from the warehouse and replenish the store's inventory. For this table, I also created a procedure that monitors the availability of these products.
6) The table of users in which their personal information is stored. For those users who should store information about a bank card, I created a separate table where this information will be stored.
7) One of the main tables is the sales table. Only purchases from stores are stored here, namely, the purchase number, who bought the product, the date of purchase, in which store it was purchased, how many pieces and the full price. A trigger has been made that will calculate the total price automatically.
8) A similar table, but with online purchases, namely, parcels. This is where the parcel track code and all the necessary information about the delivery are stored. A trigger was also made for the full amount.
9) Also a similar table, but with buyers' contracts. The structure is similar to the previous two tables, but there is information for how many months the contract was made.
There is also a trigger for calculating the full amount. (didn’t have time to make a trigger with a monthly fee).
10) There are 5 views. 1 - Table with all offline sales with more detailed information. 2 - Table with all deliveries with more detailed information. 3 - Table of all products by category. 4 - A table with all the products present in the inventory of stores. 5 - Table with parcels not delivered on time.
11) Made some very convenient functions that return tables, namely a table with all the prodiges, not only offline. Using union, I merged three sales tables. When calling the function, you can easily specify the period. And there is another function that simply shows all purchases.
Was automated using a trigger to decrease and replenish products in warehouses after replenishments or purchases.


Турдалин Нурасыл
ПРОЕКТ ПО БАЗАМ ДАННЫХ - Магазин электроники.
Суммарно, у меня получилось 16 таблиц, 5 вьюшек с информацией, 14 различных функций и триггеров. 
Благодаря тому что я начал создавать реляционную модель еще во время мидки, у меня было достаточно времени чтобы продумать и сделать маленькие детали, продумать сильную логику проекта. 
В итоге весь проект вышел +- 600 строк. 
1) Таблица с продуктами является главным трех меньших таблиц. Это таблица с информации категериями, производителями, ценами каждого продукта.
2) Таблица магазина. Пусть и логически она одна, я сделал две таблицы, где в главное хранится информация про сам магазин где их айди являются праймири ключами. А вторая таблица, по сути которая является инвентарем магазина. Где хранится информация с отссылкой на какой магазин, продукты, их количество.
3) Таблица склада. Структура является очень схожой с таблицой магазина. Главная таблица где информация про склады, вторая таблица с информации про продукты и их количество.
4) Таблица пополений, в которой каждый запрос должен заполнять склады конкретными продуктами. Для этой таблица я создал процедуру которая отслеживает есть ли этот продукт в складе или нет. 
5) Таблица запросов, в которой каждый запрос должен брать конкретный продукт из склада и делать пополнение инвентаря магазина. Для этой таблицы я также создал процедуру которая отслеживает наличие этих продуктов.
6) Таблица пользователей  в которой хранятся их личняя информация. Для тех пользователей у которых должна хранится информация про банковскую карту я создал отдельную таблицу где и будут хранится эта информация.
7) Одна из главных таблиц это таблица продаж. Здесь хранятся только покупки с магазинов, а именно номер покупки, кто купил, сам продукт, дата покупки, в каком магазине она была куплена, сколько штук и полная цена. Был сделан триггер который будет высчитывать полную цену автоматически.
8) Схожая таблица, но уже с онлайн покупками, а именно посылки. Здесь и хранится с трэк кодом посылки и вся нужная информация про доставку. Также был сделан триггер для полной суммы.
9) Также схожая таблица, но уже с контрактами покупателей. Структура схожая с прошлыми двумя таблицами, но тут есть информация на сколько месяцов был сделан контракт.
Также есть триггер для высчитывания полной суммы. (не успел сделать триггер с ежемесячной платой).
10) Есть 5 вьюшек. 1 - Таблица со всеми офлайн продажами с более подробной информацией. 2 - Таблица со всеми доставками с более подробной информацией. 3 - Таблица всех продуктов по категориям. 4 - Таблица со всеми присутсвующими продуктами в инвентарях магазинов. 5 - Таблица с не доставленными во время посылками.
11) Сделал несколько очень удобных функций, которые возвращают таблицы, а именно таблица со всеми продожами, не только офлайн. Используя унион обьеденил три таблицы с продажами. При вызове функции можно легко указывать период. И есть еще одна функция которая просто показывает все покупки. 
Была автоматизирована используя триггер уменьшение и пополение продуктов на складах после пополнений или покупок.  