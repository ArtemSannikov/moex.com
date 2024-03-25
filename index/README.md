# Глобальные справочники ISS

Метод ```index``` возвращает список глобальных справочников ISS, которые доступны на сайте [MOEX.com](https://iss.moex.com/iss/reference/28)

**Примечание**:
> Запросы для create, insert и view формированы для СУБД PostgreSQL.

**Как получить данные**:
1. Запустить скрипт ```run_index.py```, он получит данные с биржи MOEX и сформирует итоговые файлы;
2. Открыть директорию ```result_file``` и выполнить запросы ```create``` и ```insert``` в БД;
3. Открыть директорию ```view``` и выполнить запросы в БД;
4. Вывести данные метода ```index``` можно при помощи следующих SQL-запросов:
```sql
SELECT * FROM v_boardgroups_index_moex;
SELECT * FROM v_boards_index_moex;
SELECT * FROM v_durations_index_moex;
SELECT * FROM v_engines_index_moex;
SELECT * FROM v_markets_index_moex;
SELECT * FROM v_securitycollections_index_moex;
SELECT * FROM v_securitygroups_index_moex;
SELECT * FROM v_securitytypes_index_moex;
```