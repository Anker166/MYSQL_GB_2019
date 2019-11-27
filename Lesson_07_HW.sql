/*
УРОК 7. Курс “Базы данных”. Тема “Сложные запросы”
1.  Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
2.  Выведите список товаров products и разделов catalogs, который соответствует товару.
3.  (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
	Поля from, to и label содержат английские названия городов, поле name — русское. 
	Выведите список рейсов flights с русскими названиями городов.
*/

-- 1 задание

SELECT id, name, birthday_at FROM users WHERE EXISTS (SELECT 1 FROM orders WHERE user_id = users.id);

-- 2 задание

SELECT 
	p.id,
	p.name,
	p.price,
	c.name
FROM 
	products AS p
JOIN
	catalogs AS c
ON p.catalog_id=c.id;


-- 3 задание
DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
	id SERIAL,
	`from` VARCHAR(255),
	`to` VARCHAR(255)
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	label VARCHAR(255),
	name VARCHAR(255)
);

INSERT INTO flights (`from`, `to`)
VALUES
	('moscow', 'omsk'),
	('novgorod', 'kazan'),
	('irkutsk', 'moscow'),
	('omsk', 'irkutsk'),
	('moscow', 'kazan');

INSERT INTO cities (label, name) VALUES
	('moscow', 'Москва'),
	('novgorod', 'Новгород'),
	('irkutsk', 'Иркутск'),
	('omsk', 'Омск'),
	('kazan', 'Казань');

SELECT
	f.id AS `№`, c1.name AS `From`, c2.name AS `To`
FROM 
	flights AS f 
JOIN
	cities AS c1
ON
	f.`from`= c1.label
JOIN 
	cities AS c2
ON 
	f.`to` = c2.label
ORDER BY f.id;
