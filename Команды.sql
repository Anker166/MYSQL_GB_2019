
-- Запрос на актеров, продюсеров, режиссеров и т.д. для фильма
SELECT 
	f.name AS Film, 
	f.production_year AS `Production year`, 
	GROUP_CONCAT(CONCAT(ip.firstname, ' ' ,ip.lastname) ORDER BY ip.firstname) AS Name, 
	w.name AS Profession 
FROM films AS f
LEFT JOIN
	film_people AS fp ON fp.film_id = f.id
LEFT JOIN
	industry_people AS ip ON fp.people_id=ip.id
LEFT JOIN
	people_work AS pw ON ip.id = pw.people_id
LEFT JOIN 
	works AS w ON pw.work_id = w.id
WHERE f.id = 1
GROUP BY w.name
ORDER BY w.name;

-- Запрос на постеры, трейлеры и кадры для фильма
SELECT 
	f.name AS Film,
	f.production_year AS `Production year`, 
	m.name AS Filename, 
	mt.name AS Filetype 
FROM films AS f
LEFT JOIN
	media AS m ON m.film_id = f.id
LEFT JOIN
	media_types AS mt ON mt.id=m.media_type_id
WHERE f.id = 1
ORDER BY mt.name;

-- Запрос на количество фильмов, снятых в стране
SELECT c.name AS Country, COUNT(f.id) AS `Number of films` FROM countries AS c 
LEFT JOIN
film_country AS fc ON fc.country_id=c.id
LEFT JOIN
films AS f ON f.id = fc.film_id
GROUP BY c.name
ORDER BY `Number of films` DESC;

-- Представление для вывода 20 фильмов с максимальным рейтингом
DROP VIEW IF EXISTS high_rating_films;
CREATE VIEW high_rating_films AS 
	SELECT 
	f.name AS Film, 
	f.production_year AS `Year`, 
	f.film_likes AS Rating 
	FROM films AS f 
	WHERE f.film_likes >= 5 
	ORDER BY film_likes DESC
	LIMIT 20;

SELECT * FROM high_rating_films;

-- Представление для вывода списка фильмов по годам выпуска
DROP VIEW IF EXISTS films_by_year;
CREATE VIEW films_by_year AS 
	SELECT 
	f.name AS Film, 
	f.production_year AS `Year` 
	FROM films AS f 
	ORDER BY f.production_year DESC;

SELECT * FROM films_by_year;

-- Представление для вывода сборов фильма
DROP VIEW IF EXISTS films_fees;
CREATE VIEW films_fees AS 
	SELECT 
		f.name AS Film, 
		f.production_year AS `Year`,
		c.name AS Country,
		fees.film_fees AS Fees
	FROM films AS f 
	LEFT JOIN
		fees ON fees.film_id = f.id
	LEFT JOIN 
		countries AS c ON c.id = fees.country_id 
	WHERE f.id = 1
	ORDER BY fees.film_fees DESC;

SELECT * FROM films_fees;


-- Процедура для поиска фильмов по жанру
DROP PROCEDURE IF EXISTS films_on_genres;
DELIMITER //
CREATE PROCEDURE films_on_genres (IN genre_name VARCHAR(255))
BEGIN
	SET @genre = genre_name;
	SELECT f.name AS Film, GROUP_CONCAT(g.name ORDER BY g.name) AS Genres from films AS f 
	LEFT JOIN film_genre AS fg ON fg.film_id = f.id
	LEFT JOIN genres AS g ON g.id = fg.genre_id
	GROUP BY f.name
	HAVING Genres LIKE CONCAT('%', @genre,'%');
END//
DELIMITER ;

CALL films_on_genres('Thriller');


-- Процедура для поиска сеансов в кинотеатре
DROP PROCEDURE IF EXISTS films_on_cinemas;
DELIMITER //
CREATE PROCEDURE films_on_cinemas (IN cinema_name VARCHAR(255))
BEGIN
	SET @cinema = cinema_name;
	SELECT 
		c.name AS Cinema, 
		f.name AS Film,
		cs.session_date AS `Date`, 
		cs.session_time AS `Time`, 
		cs.price AS Price 
		FROM cinemas AS c
		LEFT JOIN
			cinemas_sessions as cs ON cs.cinema_id=c.id
		LEFT JOIN
			films AS f ON f.id = cs.film_id
		WHERE c.name LIKE @cinema
		ORDER BY `Date`, `Time`;
END//
DELIMITER ;

CALL films_on_cinemas('nemo');


