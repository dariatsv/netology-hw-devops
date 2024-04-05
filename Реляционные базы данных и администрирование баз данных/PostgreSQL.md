# Домашнее задание к занятию 4. «PostgreSQL»

## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
[Ссылка на docker-compose](docker/06-db-04-postgresql/docker-compose.yaml)

Подключитесь к БД PostgreSQL, используя `psql`.
```sql
# psql -U postgres 
psql (13.14 (Debian 13.14-1.pgdg120+2))
Type "help" for help.
```
Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД,
```sql
postgres=# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
---------------+----------+----------+------------+------------+-----------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
(4 rows)

```
- подключения к БД,
```sql
postgres=# \c postgres
You are now connected to database "postgres" as user "postgres".
postgres=# 
```
- вывода списка таблиц,
```sql
postgres=# \dt
Did not find any relations.
postgres=# 
```
- вывода описания содержимого таблиц,
```sql
\d <table_name>
```
- выхода из psql.
```sql
\q
```

## Задача 2

Используя `psql`, создайте БД `test_database`.
```sql
postgres=# create database test_database;
CREATE DATABASE
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
```sql
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \i /data/backup/postgres/test_dump.sql
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
    setval
--------
    8
    (1 row)

ALTER TABLE

test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner   
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

```
Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```sql
test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```
Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders`
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления, и полученный результат.
```sql

test_database=# SELECT attname, avg_width FROM pg_stats WHERE tablename = 'orders' order by avg_width desc limit 1;
 attname | avg_width 
---------+-----------
 title   |        16
(1 row)

```
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили
провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.
* Создание таблицы с условием, где price price>499
  ```sql
  CREATE TABLE orders_1
  (
    LIKE orders INCLUDING ALL,
    CHECK (price > 499)
  );
  ```
* Создание таблицы с условием, где price <= 499
  ```sql
  CREATE TABLE orders_2
  (
    LIKE orders INCLUDING ALL,
    CHECK (price <= 499)
  );
  ```

* Перенос данных из исходной таблицы orders в созданные таблицы
  ```sql
  INSERT INTO orders_1 SELECT * FROM orders WHERE price > 499;
  INSERT INTO orders_2 SELECT * FROM orders WHERE price <= 499;
  ```


Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?
Можно, если бы изначально бы предусмотрели. Скрипт, который нужно было использовать при проектировании:
```sql
CREATE TABLE orders_1 PARTITION OF orders
    FOR VALUES GREATER THAN ('499');

CREATE TABLE orders_2 PARTITION OF orders
    FOR VALUES FROM ('0') TO ('499');
```

## Задача 4

Используя утилиту `pg_dump`, создайте бекап БД `test_database`.
```sql
pg_dump -U postgres -v -f /data/backup/postgres/test_database.sql 
```
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?
```sql
CREATE TABLE public.orders
(
  id    integer               NOT NULL,
  title character varying(80) NOT NULL UNIQUE,
  price integer DEFAULT 0
);
```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

