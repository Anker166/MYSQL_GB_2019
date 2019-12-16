DROP DATABASE IF EXISTS kinopoisk_project;
CREATE DATABASE kinopoisk_project;
USE kinopoisk_project;

-- Таблица с описанием фильмов
DROP TABLE IF EXISTS films;
CREATE TABLE films (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	tagline VARCHAR(255),
	production_year YEAR,
	age_limnit INT,
	MPAA VARCHAR(50),
	duration TIME,
	plot TEXT,
	film_likes FLOAT(3,2) DEFAULT 0,
	INDEX (name)
);

-- Таблица для типа медиафайлов
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	created_at DATETIME DEFAULT NOW()
);

-- Таблица для медиафайлов
DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	film_id BIGINT UNSIGNED NOT NULL,
	media_type_id BIGINT UNSIGNED NOT NULL, 
	file_size INT,
	metadata VARCHAR(255),
	description TEXT,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (film_id) REFERENCES films(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (media_type_id) REFERENCES media_types(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Таблица Стран
DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
	id SERIAL,
	name VARCHAR(255),
	cinema_number INT UNSIGNED NOT NULL,
	PRIMARY KEY (id, name)
);

-- Таблица в которой указано в какой стране произведен фильм
DROP TABLE IF EXISTS film_country;
CREATE TABLE film_country (
	id SERIAL PRIMARY KEY,
	film_id BIGINT UNSIGNED NOT NULL,
	country_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (film_id) REFERENCES films(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (country_id) REFERENCES countries(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Кассовые сборы фильма
DROP TABLE IF EXISTS fees;
CREATE TABLE fees (
	id SERIAL PRIMARY KEY, 
	film_id BIGINT UNSIGNED NOT NULL,
	country_id BIGINT UNSIGNED NOT NULL,
	film_fees INT UNSIGNED,
	started_at DATETIME,
	finished_at DATETIME,
	FOREIGN KEY (film_id) REFERENCES films(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (country_id) REFERENCES countries(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Люди из индустрии кино
DROP TABLE IF EXISTS industry_people;
CREATE TABLE industry_people (
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(255),
    lastname VARCHAR(255),
    height FLOAT(3,2) UNSIGNED,
    birthday DATETIME,
    birthday_TOWN VARCHAR(255),
    family VARCHAR(255),
    INDEX (firstname),
    INDEX (lastname)
);

-- Работы людей из индустрии кино
DROP TABLE IF EXISTS works;
CREATE TABLE works (
	id SERIAL, 
	name VARCHAR(255),
    PRIMARY KEY (id, name)
);


-- Какой человек кем работает
DROP TABLE IF EXISTS people_work;
CREATE TABLE people_work (
	id SERIAL PRIMARY KEY,
	people_id BIGINT UNSIGNED NOT NULL,
	work_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (people_id) REFERENCES industry_people(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (work_id) REFERENCES works(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Какой человек участвовал в каком фильме
DROP TABLE IF EXISTS film_people;
CREATE TABLE film_people (
	id SERIAL PRIMARY KEY,
    people_id BIGINT UNSIGNED NOT NULL,
	film_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (people_id) REFERENCES industry_people(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (film_id) REFERENCES films(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Жанры кино
DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
	id SERIAL, 
	name VARCHAR(255),
    PRIMARY KEY (id, name)
);

-- Какие жанры у каждого фильма
DROP TABLE IF EXISTS film_genre;
CREATE TABLE film_genre (
	id SERIAL PRIMARY KEY,
	film_id BIGINT UNSIGNED NOT NULL,
	genre_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (film_id) REFERENCES films(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (genre_id) REFERENCES genres(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Компании производители фильмов
DROP TABLE IF EXISTS companies;
CREATE TABLE companies (
	id SERIAL, 
	name VARCHAR(255),
	description VARCHAR(255),
	country_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id, name),
    FOREIGN KEY (country_id) REFERENCES countries(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Связь компаний и фильмов
DROP TABLE IF EXISTS film_company;
CREATE TABLE film_company (
	id SERIAL PRIMARY KEY,
	film_id BIGINT UNSIGNED NOT NULL,
	company_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (film_id) REFERENCES films(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (company_id) REFERENCES companies(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Пользователи
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	login VARCHAR(255),
	firstname VARCHAR(255),
	lastname VARCHAR(255),
	gender CHAR(1),
    birthday DATE,
    hometown VARCHAR(100),
	user_status ENUM("Обычный", "Доверенный"),
    created_at DATETIME DEFAULT NOW(),
    INDEX (login)
);

-- Рейтинг фильма
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	id SERIAL PRIMARY KEY,
	user_id  BIGINT UNSIGNED NOT NULL,
	film_id BIGINT UNSIGNED NOT NULL,
	body TEXT,
	rating ENUM("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"),
    created_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (film_id) REFERENCES films(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Триггер для пересчета рейтинга фильма, полученное значение записывает в таблицу films
DELIMITER //
DROP TRIGGER IF EXISTS film_likes//
CREATE DEFINER=`root`@`localhost` TRIGGER `film_likes`
AFTER INSERT ON `likes` FOR EACH ROW BEGIN
	UPDATE films 
		SET films.film_likes = ROUND((films.film_likes + NEW.rating - 1)/(SELECT COUNT(likes.id) FROM likes WHERE likes.film_id = NEW.film_id), 2) 
		WHERE films.id = NEW.film_id;
END//
DELIMITER ;

-- Кинотеатры
DROP TABLE IF EXISTS cinemas;
CREATE TABLE cinemas (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	state VARCHAR(255),
	city VARCHAR(255),
	street VARCHAR(255),	
	building INT,
	house INT,
	underground VARCHAR(255),
	site VARCHAR(255),
	phone BIGINT,
	description TEXT,
    created_at DATETIME DEFAULT NOW(),
	INDEX (name)
);


-- Кинотеатры в странах
DROP TABLE IF EXISTS cinemas_countries;
CREATE TABLE cinemas_countries (
	id SERIAL PRIMARY KEY,
	cinema_id BIGINT UNSIGNED NOT NULL,
	country_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (cinema_id) REFERENCES cinemas(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (country_id) REFERENCES countries(id) ON UPDATE CASCADE ON DELETE CASCADE
);


-- Сеансы в кинотеатрах
DROP TABLE IF EXISTS cinemas_sessions;
CREATE TABLE cinemas_sessions (
	id SERIAL PRIMARY KEY,
	cinema_id BIGINT UNSIGNED NOT NULL,
	film_id BIGINT UNSIGNED NOT NULL,
	session_time TIME,
	price INT,
	description VARCHAR(255),
	session_date DATE,
	FOREIGN KEY (film_id) REFERENCES films(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (cinema_id) REFERENCES cinemas(id) ON UPDATE CASCADE ON DELETE CASCADE
);
