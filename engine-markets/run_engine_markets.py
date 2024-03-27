import requests
from fake_useragent import UserAgent
import os
import shutil
import json
from datetime import datetime

# Основные параметры скрипта, которые используются в функциях
# Имя таблицы SQL
TBL_NAME = 'engine_markets_moex'

# Дата на которую нужно получить данные
REQUIRED_DATE = '05.03.2024'

# Проверяем наличие необходимых директорий, если они отсутствуют, то создаем.
# Если они уже существуют, то удаляем в них всё содержимое.
def check_dir():

    # Список директорий, который должен быть в корне метода securInfo
    list_dir = ["json_file", "result_file"]

    for name_dir in list_dir:

        # Проверяем, существует ли директория в корне
        if os.path.isdir(name_dir):

            # Выполняем сканирование каждой директории на наличие файлов и каталогов
            for filename in os.listdir(name_dir):

                # Получаем относительный путь до файла в директории
                current_file_path = os.path.join(name_dir, filename)

                # Выполняем удаление лишних объектов в зависимости от их типа (файл или директория)
                try:
                    if os.path.isfile(current_file_path) or os.path.islink(current_file_path):
                        os.unlink(current_file_path)
                    elif os.path.isdir(current_file_path):
                        shutil.rmtree(current_file_path)
                except Exception as e:
                    print('Ошибка при удалении %s. Причина: %s' % (current_file_path, e))
        else:
            # Если директория из списка list_dir отсутствует, создаем её
            os.mkdir(name_dir)
    else:
        print(f'Проверка директорий завершена.')

# Формируем запрос и отправляем его на сервер www.nationalclearingcentre.ru
# Полученный результат записываем в файл
def get_code_page():

    # Формируем фейковый user-agent для запросов. Доступные браузеры ["chrome", "edge", "firefox", "safari"]
    fake_array_browser = UserAgent(browsers=["chrome", "firefox", "safari"])
    fake_browser = fake_array_browser.random

    # Формируем заголовки для запроса
    p_headers = {
        "Accept": "application/json, text/plain, */*",
        "Accept-Language": "ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7,la;q=0.6",
        "Accept-Encoding": "gzip, deflate, br",
        "Content-Encoding": "gzip",
        "Cache-Control": "no-cache",
        "User-Agent": fake_browser
    }

    # Создаём сессию
    s = requests.Session()

    '''
    1 этап: Получаем список торговых систем.
    Данный список потребуется в дальнейшем для формирования запросов к торговым системам.
    '''
    api_engines = f"https://iss.moex.com/iss/engines.json"
    get_engines = s.get(api_engines, headers=p_headers)

    if get_engines.status_code == 200:

        # Читаем данные по торговым системам и преобразуем в читаемый JSON
        get_le_json = get_engines.text
        read_le_json = json.loads(get_le_json)

        # Список, в котором будут храниться торговые системы
        list_engines = []

        # Проходимся циклом по списку торговых систем, чтобы сформировать запрос по каждой рыночной системе
        for l in range(0, len(read_le_json['engines']['data'])):
            markets = read_le_json['engines']['data'][l][1]
            list_engines.append(markets)
        else:
            print(f"Список торговых систем получен.")

    else:
        print(f'Что-то пошло не так! Получен следующий код HTTP: {get_engines.status_code}')

    '''
    2 этап: Получаем данные по рыночным системам в зависимости от торговых систем.
    '''
    for engine in list_engines:

        # Получаем список рынков в зависимости от рыночной системы
        api_markets = f'https://iss.moex.com/iss/engines/{engine}/markets.json'
        get_markets = s.get(api_markets, headers=p_headers)

        if get_markets.status_code == 200:

            # Читаем данные по рыночным системам и преобразуем в читаемый JSON
            get_markets_json = get_markets.text

            # Сохраняем данные JSON по рыночной системе в отдельный файл
            with open(f"json_file/page_{engine}.json", mode="w", encoding="utf-8") as file:
                file.write(get_markets_json)

        else:
            print(f'Что-то пошло не так! Получен следующий код HTTP: {get_markets.status_code}')

    else:
        print(f"Данные по рыночным системам получены.")

# Функция для создания DDL-файла таблицы SQL
def create_tbl_sql():

    # Создаём DDL файл таблицы
    with open(f"result_file/create_tbl_{TBL_NAME}.ddl", mode="a+", encoding="utf-8") as create_tbl:

        # Удаление таблицы
        create_tbl.write(f'-- Удаление таблицы')
        create_tbl.write(f'\nDROP TABLE IF EXISTS {TBL_NAME};')

        # Создание таблицы
        create_tbl.write(f'\n-- Создание таблицы')
        create_tbl.write(f'\nCREATE TABLE {TBL_NAME} (')
        create_tbl.write(f'\n\trep_dt date,')
        create_tbl.write(f'\n\tengine text,')
        create_tbl.write(f'\n\tjson_method json')
        create_tbl.write(f'\n);')

        # Добавление комментария к таблице
        create_tbl.write(f'\n-- Добавление комментария к таблице')
        create_tbl.write(f'\nCOMMENT ON TABLE {TBL_NAME} IS \'Список рынков торговых системы (MOEX)\';')

        # Добавление комментариев к столбцам таблицы
        create_tbl.write(f'\n-- Добавление комментариев к столбцам таблицы')
        create_tbl.write(f'\nCOMMENT ON COLUMN {TBL_NAME}.rep_dt is \'Дата запроса\';')
        create_tbl.write(f'\nCOMMENT ON COLUMN {TBL_NAME}.engine is \'Торговая система\';')
        create_tbl.write(f'\nCOMMENT ON COLUMN {TBL_NAME}.json_method is \'Данные метода\';')

    print(f'DDL-файл для таблицы {TBL_NAME} готов.')

# Функция для чтения фалой JSON и создания файла с SQl-запросом
def read_code_page():

    # Открываем файл, в который будет записываться финальный sql-запрос
    with open(f"result_file/insert_{TBL_NAME}.sql", mode="a+", encoding="utf-8") as create_insert_sql:

        # Добавляем начальную строку оператора INSERT INTO
        create_insert_sql.write(f'INSERT INTO {TBL_NAME} (rep_dt, engine, json_method) VALUES ')

        # Выполняем сканирование директории "json_file". Затем открываем каждый файл и читаем его с последующей записью в финальный файл с sql-запросом
        for f in os.listdir("json_file"):

            # Открываем json-файл для чтения
            with open(f"json_file/{f}", mode="r", encoding="utf-8") as file_json:

                '''
                Из имени открытого файла {f} получаем наименование торговой системы.
                Выполняем замену символа "." на "_", чтобы создать список и в дальнейшем поулчить из него элемент с индексом [1]
                '''
                engine = f.replace('.', '_').split("_")[1]

                # Читаем открытый файл и записываем его содержимое в переменную
                data = file_json.read()

                # Добавляем строку в оператор INSERT INTO
                create_insert_sql.write(f"\n('{REQUIRED_DATE}', '{engine}', '{data}'),")

        else:
            print(f"Исходные файлы JSON обработаны.")

        # Удаляем лишнюю "запятую" в конце запроса после обработки JSON файлов.
        create_insert_sql.read()
        create_insert_sql.seek(0, 2) # Перемещаем курсор в конец файла
        create_insert_sql.seek(create_insert_sql.tell() - 1) # Перемещаем курсор на последний символ
        create_insert_sql.truncate() # Удаляем последний символ

        # Добавляем символ ";" в конец запроса.
        create_insert_sql.write(f'\n;')
        print(f'Файл result_file/insert_{TBL_NAME}.sql сформирован.')

def main():
    check_dir()
    get_code_page()
    create_tbl_sql()
    read_code_page()

if __name__ == '__main__':
    main()