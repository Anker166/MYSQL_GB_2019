/*
Практическое задание по теме “Оптимизация запросов”
1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в 
таблицах users, catalogs и products в таблицу logs помещается время и 
дата создания записи, название таблицы, идентификатор первичного ключа 
и содержимое поля name.
2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
 */

-- 1 задание
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	table_name VARCHAR(255),
	id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(255)
) ENGINE=Archive;

DELIMITER //
DROP TRIGGER IF EXISTS product_insert//
CREATE DEFINER=`root`@`localhost` TRIGGER `product_insert`
AFTER INSERT ON `products` FOR EACH ROW BEGIN
    INSERT INTO logs (table_name, id, name) VALUES
     ('products', NEW.id, NEW.name);
END//
DELIMITER ;

DELIMITER //
DROP TRIGGER IF EXISTS users_insert//
CREATE DEFINER=`root`@`localhost` TRIGGER `users_insert`
AFTER INSERT ON `users` FOR EACH ROW BEGIN
    INSERT INTO logs (table_name, id, name) VALUES
     ('users', NEW.id, NEW.name);
END//
DELIMITER ;

DELIMITER //
DROP TRIGGER IF EXISTS catalogs_insert//
CREATE DEFINER=`root`@`localhost` TRIGGER `catalogs_insert`
AFTER INSERT ON `catalogs` FOR EACH ROW BEGIN
    INSERT INTO logs (table_name, id, name) VALUES
     ('catalogs', NEW.id, NEW.name);
END//
DELIMITER ;

INSERT INTO users (name, birthday_at) VALUES
  ('Анатолий', '1990-10-05');

 INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i5-9900', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 9990.00, 1);
 
 INSERT INTO catalogs VALUES
  (NULL, 'Диски');
 
 /*
 Практическое задание по теме “NoSQL”
1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных
IP-адресов.
2. При помощи базы данных Redis решите задачу поиска имени пользователя 
по электронному адресу и наоборот, поиск электронного адреса пользователя
по его имени.
3. Организуйте хранение категорий и товарных позиций учебной базы данных 
shop в СУБД MongoDB.
  */
 
-- 1 задание
ZADD ip_count 0 192.168.1.1 0 192.168.1.2 0 192.168.1.3 0 192.168.1.4 0 192.168.1.5
ZINCRBY ip_count 1 192.168.1.1

-- 2 задание
SET John john@mail.com
SET john@mail.com john

GET John
GET john@mail.com

-- 3 задание
db.shop.insert{
	"catalogs":[
		{"id":"", "name":""}
	],
	"users":[
		{"id":"", "name":"", "birthday_at":"", "created_at":"", "updated_at":""}
	],
	"products":[
		{"id":"", "name":"", "description":"", "price":"", "catalog_id":"", "created_at":"", "updated_at":""}
	],
	"orders":[
		{"id":"", "user_id":"", "created_at":"", "updated_at":""}
	],
	"orders_products":[
		{"id":"", "order_id":"", "product_id":"", "total":"", "created_at":"", "updated_at":""}
	],
	"discounts":[
		{"id":"", "user_id":"", "product_id":"", "discount":"", "started_at":"", "finished_at":"", "created_at":"", "updated_at":""}
	],
	"storehouses":[
		{"id":"", "name":"", "created_at":"", "updated_at":""}
	],
	"storehouses_products":[
		{"id":"", "storehouse_id":"", "product_id":"", "value":"", "created_at":"", "updated_at":""}
	],
}
