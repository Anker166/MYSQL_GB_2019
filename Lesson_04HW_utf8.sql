/*
Практическое задание по теме “CRUD - операции”. Урок 4, вебинар.
1.Повторить все действия по доработке БД vk.
2.Заполнить новые таблицы.
3.Повторить все действия CRUD.
4.Подобрать сервис-образец для курсовой работы.
*/


USE vk;

/*
 1. Добавил столбец is_deleted к таблице users 
 */
ALTER TABLE vk.users ADD is_deleted BIT DEFAULT 1 NULL;


/*
 2. Заполнил таблицы с помощью сервиса  http://filldb.info/
 */

/*
 3. Повторил действия CRUD из вебинара
 */

/*
 4. Хочу выполнить курсовую работу на основе сайта кинопоиск
 */


INSERT INTO users (firstname, lastname, email, phone)
VALUES ('Ruben', 'Neon', 'rubneo@bk.net', '9777777777')

insert into users
SET
	firstname = 'asdas',
	lastname = 'fgsf',
	email = 'asda@asdfa',
	phone = '343241221'
;

SELECT firstname, phone from users
limit 1;


INSERT INTO friend_requests (`initiator_user_id`,`target_user_id`,`status`)
values (1,2,'requested');

UPDATE friend_requests 
set status = 'approved'
WHERE initiator_user_id = 1 and status ='requested';

UPDATE friend_requests
set confirmed_at = now()
WHERE initiator_user_id = 1 and status ='approved';


INSERT INTO messages values
('1','1','2','Voluptatem ut quaerat quia. Pariatur esse amet ratione qui quia. In necessitatibus reprehenderit et. Nam accusantium aut qui quae nesciunt non.','1995-08-28 22:44:29'),
('2','2','1','Sint dolores et debitis est ducimus. Aut et quia beatae minus. Ipsa rerum totam modi sunt sed. Voluptas atque eum et odio ea molestias ipsam architecto.',now())
;

DELETE FROM messages
where from_user_id = 1;

INSERT INTO messages values
('1','1','2','Voluptatem ut quaerat quia. Pariatur esse amet ratione qui quia. In necessitatibus reprehenderit et. Nam accusantium aut qui quae nesciunt non.','1995-08-28 22:44:29')
;

truncate table messages;

INSERT INTO messages (from_user_id, to_user_id, body, created_at) values
('1','2','Voluptatem ut quaerat quia. Pariatur esse amet ratione qui quia. In necessitatibus reprehenderit et. Nam accusantium aut qui quae nesciunt non.','1995-08-28 22:44:29'),
('2','1','Sint dolores et debitis est ducimus. Aut et quia beatae minus. Ipsa rerum totam modi sunt sed. Voluptas atque eum et odio ea molestias ipsam architecto.',now())
;

DELETE FROM messages
where from_user_id = 1;

INSERT INTO messages (from_user_id, to_user_id, body, created_at) values
('1','2','Voluptatem ut quaerat quia. Pariatur esse amet ratione qui quia. In necessitatibus reprehenderit et. Nam accusantium aut qui quae nesciunt non.','1995-08-28 22:44:29')
;