/* ������������ ������� �� ���� "���������� ��". ���� 02.
1. ���������� ���� MySQL. �������� � �������� ���������� ���� .my.cnf,
   ����� � ��� ����� � ������, ������� ���������� ��� ���������.
2. �������� ���� ������ example, ���������� � ��� ������� users,
   ��������� �� ���� ��������, ��������� id � ���������� name.
3. �������� ���� ���� ������ example �� ����������� �������,
   ���������� ���������� ����� � ����� ���� ������ sample.
4. (�� �������) ������������ ����� �������� � ������������� ������� mysqldump.
   �������� ���� ������������ ������� help_keyword ���� ������ mysql.
   ������ ��������� ����, ����� ���� �������� ������ ������ 100 ����� �������.
*/


/*
������ ������� ���������. ����� �� ����� ��� �������� �� ����������.
 */

/*
������ �������
 */

CREATE DATABASE IF NOT EXISTS example;

USE example;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED,
  name VARCHAR(255) COMMENT '��� ������������'
) COMMENT = '������������';

CREATE DATABASE IF NOT EXISTS sample; --������ �� ��� �������� �������


/*
������ ������� �������� � �������, ������� ��������� ����.
 */

-- mysqldump -u root -p example > example.sql;
-- mysql -u root -p sample < example.sql;

/*
��������� ������� �������� � �������, ������� ��������� ����.
 */

--mysqldump -u root -p --where="true limit 100" mysql help_keyword > hk.sql