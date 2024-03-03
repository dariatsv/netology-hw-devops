# Домашнее задание к занятию «Инструменты Git»

### Цель задания

В результате выполнения задания вы:

* научитесь работать с утилитами Git;
* потренируетесь решать типовые задачи, возникающие при работе в команде.

### Инструкция к заданию

1. Склонируйте [репозиторий](https://github.com/hashicorp/terraform) с исходным кодом Terraform.
2. Создайте файл для ответов на задания в своём репозитории, после выполнения прикрепите ссылку на .md-файл с ответами в личном кабинете.
3. Любые вопросы по решению задач задавайте в чате учебной группы.

------

## Задание

В клонированном репозитории:

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.
    Команда: git show aefea
    Результат:
        ```git
        commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
        		Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
        		Date:   Thu Jun 18 10:29:58 2020 -0400

                Update CHANGELOG.md
        ```

2. Ответьте на вопросы.

* Какому тегу соответствует коммит `85024d3`?
        Команда: git show 85024d3
        Результат:
            ```git
             commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
             Author: tf-release-bot <terraform@hashicorp.com>
             Date:   Thu Mar 5 20:56:10 2020 +0000

                 v0.12.23
            ```
* Сколько родителей у коммита `b8d720`? Напишите их хеши.
        Команда: git show --pretty=format:" %P" b8d720
        Результат:
            ```git
                56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b
            ```
* Перечислите хеши и комментарии всех коммитов, которые были сделаны между тегами  v0.12.23 и v0.12.24.
        Команда: git log v0.12.23..v0.12.24 --oneline
        Результат:
            ```git
                 33ff1c03b (tag: v0.12.24) v0.12.24
                 b14b74c49 [Website] vmc provider links
                 3f235065b Update CHANGELOG.md
                 6ae64e247 registry: Fix panic when server is unreachable
                 5c619ca1b website: Remove links to the getting started guide's old location
                 06275647e Update CHANGELOG.md
                 d5f9411f5 command: Fix bug when using terraform login on Windows
                 4b6d06cc5 Update CHANGELOG.md
                 dd01a3507 Update CHANGELOG.md
                 225466bc3 Cleanup after v0.12.23 release
                 85024d310 (tag: v0.12.23) v0.12.23
            ```
* Найдите коммит, в котором была создана функция `func providerSource`, её определение в коде выглядит так: `func providerSource(...)` (вместо троеточия перечислены аргументы).
        Команда: git log -S "func providerSource("
        Результат:
            ```git
             commit 8c928e83589d90a031f811fae52a81be7153e82f
             Author: Martin Atkins <mart@degeneration.co.uk>
             Date:   Thu Apr 2 18:04:39 2020 -0700
            ```
* Найдите все коммиты, в которых была изменена функция `globalPluginDirs`.
        Команда: git log -S "globalPluginDirs" --oneline
        Результат:
            ```git
             35a058fb3 main: configure credentials from the CLI config file
             c0b176109 prevent log output during init
             8364383c3 Push plugin discovery down into command package
            ```
* Кто автор функции `synchronizedWriters`?
        Команда: git log -S "func synchronizedWriters" --pretty=format:"%h - %an %ae %ad"
        Результат:
            ```git
             bdfea50cc - James Bardin j.bardin@gmail.com Mon Nov 30 18:02:04 2020 -0500
             5ac311e2a - Martin Atkins mart@degeneration.co.uk Wed May 3 16:25:41 2017 -0700
            ```