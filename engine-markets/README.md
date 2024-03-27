# Список рынков торговой системы

Метод ```/iss/engines/[engine]/markets``` возвращает список рынков торговой системы, которые доступны на сайте [MOEX.com](https://iss.moex.com/iss/reference/42)

**Примечание**:
> Запросы для create, insert и view формированы для СУБД PostgreSQL.

**Как получить данные**:
1. Запустить скрипт ```run_engine_markets.py```, он получит данные с биржи MOEX и сформирует итоговые файлы;
2. Открыть директорию ```result_file``` и выполнить запросы ```create``` и ```insert``` в БД;
3. Открыть директорию ```view``` и выполнить запрос в БД;
4. Вывести данные метода ```/iss/engines/[engine]/markets``` можно при помощи следующего SQL-запроса:
```sql
SELECT * FROM v_engine_markets_moex;
```