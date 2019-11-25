
/*
Урок 6
Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”. 
Работаем с БД vk и данными, которые вы сгенерировали ранее:
- Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, 
который больше всех общался с нашим пользователем.
- Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..
- Определить кто больше поставил лайков (всего) - мужчины или женщины?
*/

-- 1 задание
-- Выполнил запрос для поиска максимального количества сообщений которые другие пользователи отправляли первому пользователю
SELECT from_user_id AS user_id, COUNT(id) as messages FROM messages
WHERE
to_user_id = 1 and
from_user_id IN
    (SELECT target_user_id FROM friend_requests WHERE initiator_user_id = 1 AND status = 'approved'
     UNION
     SELECT initiator_user_id FROM friend_requests WHERE target_user_id = 1 AND status = 'approved')
GROUP BY user_id
ORDER BY messages DESC LIMIT 1;

-- Выполнил запрос для поиска максимального количества сообщений которые первый пользователь отправлял другим
SELECT to_user_id AS user_id, COUNT(id) as messages FROM messages
WHERE
from_user_id = 1 and
to_user_id IN
    (SELECT target_user_id FROM friend_requests WHERE initiator_user_id = 1 AND status = 'approved'
     UNION
     SELECT initiator_user_id FROM friend_requests WHERE target_user_id = 1 AND status = 'approved')
GROUP BY user_id
ORDER BY messages DESC LIMIT 1;

-- Подскажите, как объединить эти запросы, чтобы найти максимум вообще во всех сообщениях, у меня это сделать не получилось...

-- 2 задание
SELECT COUNT(id) AS Likes
FROM likes
WHERE media_id IN 
	(SELECT id FROM media 
		WHERE user_id IN 
			(SELECT user_id FROM profiles WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10));

-- 3 задание
SELECT 'Female' as Gender, COUNT(id) AS Likes FROM likes 
	WHERE user_id IN 
		(SELECT user_id FROM profiles WHERE gender = 'f')
UNION
SELECT 'Male' as Gender, COUNT(id) AS Likes FROM likes
	WHERE user_id IN
		(SELECT user_id FROM profiles WHERE gender = 'm')
ORDER BY Likes DESC LIMIt 1;
