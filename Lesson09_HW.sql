/*
Практическое задание по теме “Транзакции,
переменные, представления”
1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте
транзакции.
2. Создайте представление, которое выводит название name товарной позиции из таблицы
products и соответствующее название каталога name из таблицы catalogs.
3. по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены
разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и
2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в
соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она
отсутствует.
4. (по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте
запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих
записей.
*/

-- 1 задание
START TRANSACTION;
INSERT INTO sample.users
    SELECT * FROM shop.users
WHERE id = 1
ON DUPLICATE KEY UPDATE
    sample.users.name = shop.users.name,
    sample.users.birthday_at = shop.users.birthday_at,
    sample.users.created_at = shop.users.created_at,
    sample.users.updated_at = shop.users.updated_at;
COMMIT;

-- 2 задание
CREATE VIEW procat (product, catalog_name)
AS SELECT products.name, catalogs.name FROM products, catalogs
WHERE catalogs.id = products.catalog_id;
SELECT * FROM procat;

/*
Практическое задание по теме “Хранимые процедуры и
функции, триггеры"
1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от
текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с
12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый
вечер", с 00:00 до 6:00 — "Доброй ночи".
© geekbrains.ru
2. В таблице products есть два текстовых поля: name с названием товара и description с его
описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля
принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь
того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям
NULL-значение необходимо отменить операцию.
3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
Числами Фибоначчи называется последовательность в которой число равно сумме двух
предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.
 */

-- 1 задание
DELIMITER //
DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello ()
RETURNS TEXT DETERMINISTIC
BEGIN
    CASE
        WHEN '06:00:00' <= CURTIME() AND CURTIME() < '12:00:00'
            THEN RETURN 'Доброе утро';
        WHEN '12:00:00' <= CURTIME() AND CURTIME() < '18:00:00'
            THEN RETURN 'Добрый день';
        WHEN '18:00:00' <= CURTIME() AND CURTIME() < '24:00:00'
            THEN RETURN 'Добрый вечер' ;
        WHEN '00:00:00' <= CURTIME() AND CURTIME() < '06:00:00'
            THEN RETURN 'Доброй ночи';
    END CASE;
END//
DELIMITER ;
SELECT hello ();

-- 2 задание
DELIMITER //
DROP TRIGGER IF EXISTS product_name_description_not_null//
CREATE DEFINER=`root`@`localhost` TRIGGER `product_name_description_not_null`
BEFORE INSERT ON `products` FOR EACH ROW BEGIN
    IF NEW.name IS NULL AND NEW.description IS NULL  THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Так заполнять таблицу нельзя! Заполните либо поле name либо поле description!';
    END IF;
END//
DELIMITER ;
INSERT INTO products (price) VALUES (1234);
