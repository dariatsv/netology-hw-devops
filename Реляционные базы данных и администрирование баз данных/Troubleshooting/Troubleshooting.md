# Домашнее задание к занятию 6. «Troubleshooting»

## Задача 1

Перед выполнением задания ознакомьтесь с документацией по [администрированию MongoDB](https://docs.mongodb.com/manual/administration/).

Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD-операция в MongoDB и её
нужно прервать.

Вы как инженер поддержки решили произвести эту операцию:

- напишите список операций, которые вы будете производить для остановки запроса пользователя;
  - Ответ: находим долгую операцию с помощью метода currentOp(), забираем из полученного ответа opId и вызываем метод для остановки запроса killOp({opId})
- предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB.
  - Ответ: можно установить ограничения на выполнение запроса с помощью метода maxTimeMS(), но вначале нужно выяснить максимальное время для запроса, так как оно может подойти не для всех ситуаций

    
## Задача 2

Перед выполнением задания познакомьтесь с документацией по [Redis latency troobleshooting](https://redis.io/topics/latency).

Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL.
Причём отношение количества записанных key-value-значений к количеству истёкших значений есть величина постоянная и
увеличивается пропорционально количеству реплик сервиса.

При масштабировании сервиса до N реплик вы увидели, что:

- сначала происходит рост отношения записанных значений к истекшим,
- Redis блокирует операции записи.

Как вы думаете, в чём может быть проблема?

Ответ:
Возможно, если в Redis множество ключей, у которых срок действия истекает в одно и то же время и при этом они составляют не менее 25% от текущей совокупности ключей с установленным сроком действия, 
Redis может заблокировать, чтобы процент ключей, срок действия которых уже истек, был ниже 25%.

## Задача 3

Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей в таблицах базы
пользователи начали жаловаться на ошибки вида:
```python
InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '
```

Как вы думаете, почему это начало происходить и как локализовать проблему?

Ответ:

Данная ошибка возникает при выполнении длительный запрос, проблемы с сетевым подключением, большой объем данных

Какие пути решения этой проблемы вы можете предложить?

Ответ:

Как вариант можно увеличить timeout, увеличение ресурсов на сервере базы данных

## Задача 4


Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с
большим объёмом данных лучше, чем MySQL.

После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

`postmaster invoked oom-killer`

Как вы думаете, что происходит?

Ответ:

Не хватает оперативной памяти

Как бы вы решили эту проблему?

Ответ:

Увеличивать сразу ресурсы вряд ли стоит, вначале стоило бы разобраться в проблеме и оптимизировать потребление памяти

Доработка. 
Вопрос: Возникло небольшое вопрос к 4 заданию, какие параметры конфига Postgres вы бы настроили, чтобы решить проблемы с памятью?

Ответ:
Относительно [документации Postgres](https://www.postgresql.org/docs/16/runtime-config-resource.html) в конфигурационном файле postgres.conf я бы попробовала настроить такие параметры как:
1. shared_buffers
   1. Объем памяти, который сервер базы данных использует для буферов общей памяти. При больших нагрузках стоит выделять более 40% оперативной памяти, а отсюда нужно будет увеличивать max_wal_size
2. work_mem
   1. Максимальный объем памяти, который будет использоваться операцией запроса (например, сортировкой или хэш-таблицей) перед записью во временные файлы на диске. 

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории. 

---

