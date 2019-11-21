
/*
Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”

1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR 
	и в них долгое время помещались значения в формате "20.10.2017 8:10". 
	Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
	0, если товар закончился и выше нуля, если на складе имеются запасы. 
	Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
	Однако, нулевые запасы должны выводиться в конце, после всех записей.
4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
	Месяцы заданы в виде списка английских названий ('may', 'august')
5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
	SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
*/

-- 1 задание
UPDATE users SET created_at = NOW(), updated_at = NOW();


-- 2 задание
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';
INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05', '05.10.1990 10:05', '05.10.1990 10:05'),
  ('Наталья', '1984-11-12', '12.11.1984 11:12', '12.11.1984 11:12'),
  ('Александр', '1985-05-20', '20.05.1985 05:20', '20.05.1985 05:20'),
  ('Сергей', '1988-02-14', '14.02.1988 02:14', '14.02.1988 02:14'),
  ('Иван', '1998-01-12', '12.01.1998 01:12', '12.01.1998 01:12'),
  ('Мария', '1992-08-29', '29.08.1992 08:29', '29.08.1992 08:29');

UPDATE users SET
created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'),
updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
ALTER TABLE users MODIFY created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users MODIFY updated_at DATETIME DEFAULT CURRENT_TIMESTAMP;


-- 3 задание
INSERT storehouses_products (value) VALUES
(0),(2500),(0),(30),(500),(1);
SELECT value FROM storehouses_products ORDER BY
value = 0 ASC, value ASC;
*/

-- 4 задание
SELECT name
FROM users
WHERE MONTHNAME(birthday_at) = 'may' OR MONTHNAME(birthday_at) = 'august';


-- 5 задание
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY id = 5 DESC, id ASC;


/*
Практическое задание теме “Агрегация данных”
1. Подсчитайте средний возраст пользователей в таблице users
2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
	Следует учесть, что необходимы дни недели текущего года, а не года рождения.
3. (по желанию) Подсчитайте произведение чисел в столбце таблицы
*/

-- 1 задание
SELECT
name,
AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())),
FROM users
GROUP BY name
WITH ROLLUP;

-- 2 задание

-- Решил задание для тех дней, которые есть в бд
SELECT 
DAYNAME(CONCAT(YEAR(NOW()), '-', MONTH(birthday_at), '-', DAY(birthday_at))) as days,
COUNT(*)
FROM users
GROUP BY days;

/*
Так как в бд нет данных по всем дням решил переделать, 
сделав отдельную таблицу со всеми днями недели и записав в нее данные из запроса, 
не понял можно ли сделать UPDATE результатами запроса
*/

DROP TABLE IF EXISTS birthday_week;
CREATE TABLE birthday_week (
	week_day VARCHAR(255) PRIMARY KEY,
	birthday_number INT UNSIGNED DEFAULT 0
);

INSERT INTO 
	birthday_week (week_day, birthday_number)
SELECT 
DAYNAME(CONCAT(YEAR(NOW()), '-', MONTH(birthday_at), '-', DAY(birthday_at))) as days,
COUNT(*)
FROM users
GROUP BY days;

INSERT IGNORE birthday_week (week_day) VALUES
('Monday'), 
('Tuesday'), 
('Wednesday'),
('Thursday'), 
('Friday'), 
('Saturday'), 
('Sunday');
*/

-- 3 задание
CREATE TABLE example (
	value INT UNSIGNED
);

INSERT INTO example VALUES (1), (2), (3), (4), (5);

SELECT ROUND(EXP(SUM(LOG(value)))) FROM example;
