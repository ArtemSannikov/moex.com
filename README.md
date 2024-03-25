# Moex.com
Методы с сайта Moex.com (Московская биржа - крупнейший российский биржевой холдинг)

### Метод
* /iss/index | Глобальные справочники ISS ([перейти](https://iss.moex.com/iss/reference/28))
* /iss/engines | Список доступных торговых систем ([перейти](https://iss.moex.com/iss/reference/40))
* /iss/securitygroups | Группы ценных бумаг ([перейти](https://iss.moex.com/iss/reference/127))



### Необходимые пакеты Python
* ```bs4``` (получение DOM-дерева страницы, [подробнее..](https://pypi.org/project/beautifulsoup4/));
* ```lxml``` (парсер, который будет использован в связке с ```bs4```, [подробнее..](https://pypi.org/project/lxml/));
* ```fake_user_agent``` (генерация фейковых user-agent для запросов к серверу, [подробнее..](https://pypi.org/project/fake-useragent/));
* ```requests``` ([подробнее..](https://pypi.org/project/requests/));
* ```json```  (для работы с json: ```pip install json```);
* ```shutil``` (для работы с директориями: ```pip install shutil```);
* ```datetime``` (для работы с датой ```pip install datetime```).