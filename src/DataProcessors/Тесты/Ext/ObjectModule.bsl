﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Запускает прогон тестов
//
Процедура ВыполнитьТестыНаСервере() Экспорт
	
	Если ТестироватьСоединениеЧерезПрокси Тогда
		Тест_СоединениеЧерезПрокси();
	КонецЕсли;
	Если ТестироватьПолучениеСпискаРелизовВСайта1С Тогда
		Тест_ПолучениеСпискаРелизовВСайта1С();
	КонецЕсли;
	Тест_ПараметрыЗаписиJson();
	Тест_URLБезСхемы();
	Тест_ПередачаПараметровВСтрокуЗапроса();
	Тест_ПередачаПараметровВСтрокуЗапросаКомбинированный();	
	Тест_РезультатКакJsonGet();
	Тест_РезультатКакJsonPost();
	Тест_РезультатКакДвоичныеДанные();
	Тест_РезультатКакТекст();
	Тест_ПередачаПроизвольныхЗаголовков();	
	Тест_ОтправкаДанныхФормы();
	Тест_ОтправкаJson();
	Тест_Таймаут();
	Тест_BasicAuth();
	Тест_DigestAuth();
	Тест_ПолучитьGZip();                                   
	Тест_GetJson();
	Тест_PostJson();
	Тест_PostИРедирект();
	Тест_GetJsonСтруктура();
	Тест_PutJson();
	Тест_DeleteJson();
	Тест_GetУспешныйРедиректОтносительныйАдрес();
	Тест_GetУспешныйРедиректАбсолютныйАдрес();
	Тест_GetЗацикленныйРедирект();
	Тест_GetОтключенныйРедирект();
	Тест_Ошибка404();
	Тест_РаботаССессиями();	
	Тест_Options();
	Тест_Head();
	Тест_Delete();
	Тест_Patch();
	Тест_УстановкаCookies();
	Тест_ОтправитьCookies();
	Тест_POST_MultipartFormData_ТолькоФайл();
	Тест_POST_MultipartFormData_ФайлыИПоляФормы();
	Тест_ПараметрыЗапросаТолькоКлюч();
	Тест_ОтправкаXml();
	Тест_СложныеПараметрыЗапроса();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Тесты

Процедура Тест_СоединениеЧерезПрокси()
	
	Прокси = Новый ИнтернетПрокси;
	Прокси.Установить("http", ПроксиСервер, ПроксиПорт);
	КоннекторHTTP.GetJson("http://httpbin.org/headers",, Новый Структура("Прокси", Прокси));
	
	ТестПройден("Тест_СоединениеЧерезПрокси");

КонецПроцедуры

Процедура Тест_ПараметрыЗаписиJson()
	
	ПараметрыЗаписиJSON = Новый Структура("ПереносСтрок", ПереносСтрокJSON.Нет);
	Json = Новый Структура;
	Json.Вставить("field", "value");
	Json.Вставить("field2", "value2");
	Результат = КоннекторHTTP.PostJson("http://httpbin.org/anything", Json, Новый Структура("ПараметрыЗаписиJSON", ПараметрыЗаписиJSON));
	УтверждениеВерно(Результат["data"], "{""field"":""value"",""field2"":""value2""}");
	
	ТестПройден("Тест_ПараметрыЗаписиJson");
	
КонецПроцедуры

Процедура Тест_URLБезСхемы()
	
	Ответ = КоннекторHTTP.Get("httpbin.org/get");
	Результат = КоннекторHTTP.КакJson(Ответ);
	УтверждениеВерно(Ответ.URL, "http://httpbin.org/get");
	
	ТестПройден("Тест_URLБезСхемы");
	
КонецПроцедуры

Процедура Тест_ПередачаПараметровВСтрокуЗапроса()
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("name", СтрРазделить("Иванов,Петров", ","));
	ПараметрыЗапроса.Вставить("salary", Формат(100000, "ЧГ="));
	
	Ответ = КоннекторHTTP.Get("https://httpbin.org/anything/params", ПараметрыЗапроса);	
	Результат = КоннекторHTTP.КакJson(Ответ);
	
	УтверждениеВерно(Ответ.URL, "https://httpbin.org/anything/params?name=%D0%98%D0%B2%D0%B0%D0%BD%D0%BE%D0%B2&name=%D0%9F%D0%B5%D1%82%D1%80%D0%BE%D0%B2&salary=100000");
	УтверждениеВерно(Результат["url"], "https://httpbin.org/anything/params?name=Иванов&name=Петров&salary=100000");
	УтверждениеВерно(Результат["args"]["salary"], "100000");
	УтверждениеВерно(СтрСоединить(Результат["args"]["name"], ","), "Иванов,Петров");
	
	ТестПройден("Тест_ПередачаПараметровВСтрокуЗапроса");
	
КонецПроцедуры

Процедура Тест_ПередачаПараметровВСтрокуЗапросаКомбинированный()
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("name", СтрРазделить("Иванов,Петров", ","));
	ПараметрыЗапроса.Вставить("salary", Формат(100000, "ЧГ="));
	
	Результат = КоннекторHTTP.GetJson("https://httpbin.org/anything/params?post=Программист", ПараметрыЗапроса);	
	
	УтверждениеВерно(Результат["args"]["salary"], "100000");
	УтверждениеВерно(Результат["args"]["post"], "Программист");
	УтверждениеВерно(СтрСоединить(Результат["args"]["name"], ","), "Иванов,Петров");
	
	ТестПройден("Тест_ПередачаПараметровВСтрокуЗапросаКомбинированный");
	
КонецПроцедуры

Процедура Тест_РезультатКакJsonGet()
	
	Результат = КоннекторHTTP.GetJson("https://httpbin.org/get");
	УтверждениеВерно(Результат["url"], "https://httpbin.org/get");
	
	ТестПройден("Тест_РезультатКакJsonGet");
	
КонецПроцедуры

Процедура Тест_РезультатКакJsonPost()
	
	Результат = КоннекторHTTP.КакJson(КоннекторHTTP.Post("https://httpbin.org/post"));
	УтверждениеВерно(Результат["url"], "https://httpbin.org/post");
	
	ТестПройден("Тест_РезультатКакJsonPost");
	
КонецПроцедуры

Процедура Тест_РезультатКакДвоичныеДанные()
	
	Результат = КоннекторHTTP.КакДвоичныеДанные(КоннекторHTTP.Get("http://httpbin.org/image/png"));
	
	УтверждениеВерно(ТипЗнч(Результат), Тип("ДвоичныеДанные"));
	УтверждениеВерно(ПосчитатьMD5(Результат), "5cca6069f68fbf739fce37e0963f21e7");
	
	ТестПройден("Тест_РезультатКакДвоичныеДанные");
	
КонецПроцедуры

Процедура Тест_РезультатКакТекст()
	
	Результат = КоннекторHTTP.КакТекст(КоннекторHTTP.Get("http://httpbin.org/encoding/utf8"));
	УтверждениеВерно(СтрНайти(Результат, "Зарегистрируйтесь сейчас на Десятую Международную"), 3931);
	
	ТестПройден("Тест_РезультатКакТекст");
	
КонецПроцедуры

Процедура Тест_ПередачаПроизвольныхЗаголовков()
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("X-My-Header", "Hello");
	Результат = КоннекторHTTP.GetJson("http://httpbin.org/headers",, Новый Структура("Заголовки", Заголовки));
	
	УтверждениеВерно(Результат["headers"]["X-My-Header"], "Hello");
	
	ТестПройден("Тест_ПередачаПроизвольныхЗаголовков");
	
КонецПроцедуры

Процедура Тест_ОтправкаДанныхФормы()
	
	Данные = Новый Структура;
	Данные.Вставить("comments", "Постучать в дверь");
	Данные.Вставить("custemail", "vasya@mail.ru");
	Данные.Вставить("custname", "Вася");
	Данные.Вставить("custtel", "112");
	Данные.Вставить("delivery", "20:20");
	Данные.Вставить("size", "medium");
	Данные.Вставить("topping", СтрРазделить("bacon,mushroom", ","));
	
	Ответ = КоннекторHTTP.Post("http://httpbin.org/post", Данные);
	УтверждениеВерно(Ответ.URL, "http://httpbin.org/post");
	Результат = КоннекторHTTP.КакJson(Ответ);
	УтверждениеВерно(Результат["form"]["size"], "medium");
	УтверждениеВерно(Результат["form"]["comments"], "Постучать в дверь");
	УтверждениеВерно(Результат["form"]["custemail"], "vasya@mail.ru");
	УтверждениеВерно(Результат["form"]["delivery"], "20:20");
	УтверждениеВерно(Результат["form"]["custtel"], "112");	

	ТестПройден("Тест_ОтправкаДанныхФормы");
	
КонецПроцедуры

Процедура Тест_ОтправкаJson()
	
	Json = Новый Структура;
	Json.Вставить("Сотрудник", "Иванов Иван Петрович");
	Json.Вставить("Должность", "Разнорабочий");
	
	Результат = КоннекторHTTP.PostJson("http://httpbin.org/post", Json);
	
	УтверждениеВерно(Результат["json"]["Сотрудник"], "Иванов Иван Петрович");
	УтверждениеВерно(Результат["json"]["Должность"], "Разнорабочий");
	
	Результат = КоннекторHTTP.PutJson("http://httpbin.org/put", Json);
	УтверждениеВерно(Результат["json"]["Сотрудник"], "Иванов Иван Петрович");
	УтверждениеВерно(Результат["json"]["Должность"], "Разнорабочий");
	
	ТестПройден("Тест_ОтправкаJson");
	
КонецПроцедуры

Процедура Тест_Таймаут()
	
	Попытка
		Ответ = КоннекторHTTP.Get("https://httpbin.org/delay/10",, Новый Структура("Таймаут", 1));
	Исключение
		ВерноеИсключение(ИнформацияОбОшибке(), СтрРазделить("Превышено время ожидания|Timeout exceeded", "|"));
	КонецПопытки;
	
	ТестПройден("Тест_Таймаут");
	
КонецПроцедуры

Процедура Тест_ПолучитьGZip()
	
	Результат = КоннекторHTTP.GetJson("http://httpbin.org/gzip");
	УтверждениеВерно(Результат["gzipped"], Истина);
	
	ТестПройден("Тест_ПолучитьGZip");
	
КонецПроцедуры
	
Процедура Тест_BasicAuth()
	
	Результат = КоннекторHTTP.GetJson("https://user:pass@httpbin.org/basic-auth/user/pass");
	УтверждениеВерно(Результат["authenticated"], Истина);
	УтверждениеВерно(Результат["user"], "user");

	Аутентификация = Новый Структура("Пользователь, Пароль", "user", "pass");
	Результат = КоннекторHTTP.GetJson(
		"https://httpbin.org/basic-auth/user/pass",,
		Новый Структура("Аутентификация", Аутентификация));
	УтверждениеВерно(Результат["authenticated"], Истина);
	УтверждениеВерно(Результат["user"], "user");

	Аутентификация = Новый Структура("Пользователь, Пароль, Тип", "user", "pass", "Basic");
	Результат = КоннекторHTTP.GetJson(
		"https://httpbin.org/basic-auth/user/pass",,
		Новый Структура("Аутентификация", Аутентификация));
	УтверждениеВерно(Результат["authenticated"], Истина);
	УтверждениеВерно(Результат["user"], "user");

	ТестПройден("Тест_BasicAuth");
	
КонецПроцедуры

Процедура Тест_DigestAuth()
			
	Аутентификация = Новый Структура("Пользователь, Пароль, Тип", "user", "pass", "Digest");
	Результат = КоннекторHTTP.GetJson(
		"https://httpbin.org/digest-auth/auth/user/pass",,
		Новый Структура("Аутентификация", Аутентификация));
	УтверждениеВерно(Результат["authenticated"], Истина);
	УтверждениеВерно(Результат["user"], "user");
	
	Аутентификация = Новый Структура("Пользователь, Пароль, Тип", "guest", "guest", "Digest");
	Результат = КоннекторHTTP.Get(
		"https://jigsaw.w3.org/HTTP/Digest/",,
		Новый Структура("Аутентификация", Аутентификация));		
	УтверждениеВерно(Результат.КодСостояния, 200);

	ТестПройден("Тест_DigestAuth");
		
КонецПроцедуры

Процедура Тест_GetJson()
	
	Результат = КоннекторHTTP.GetJson("https://httpbin.org/get");
	УтверждениеВерно(Результат["url"], "https://httpbin.org/get");
	
	ТестПройден("Тест_GetJson");
	
КонецПроцедуры

Процедура Тест_GetJsonСтруктура()
	
	ПараметрыПреобразованияJSON = Новый Структура("ПрочитатьВСоответствие", Ложь);
	Результат = КоннекторHTTP.GetJson("http://httpbin.org/json",, Новый Структура("ПараметрыПреобразованияJSON", ПараметрыПреобразованияJSON));
	УтверждениеВерно(Результат.slideshow.author, "Yours Truly");
	УтверждениеВерно(Результат.slideshow.date, "date of publication");
	УтверждениеВерно(Результат.slideshow.slides.Количество(), 2);
	УтверждениеВерно(Результат.slideshow.title, "Sample Slide Show");
	
	ТестПройден("Тест_GetJsonСтруктура");
	
КонецПроцедуры

Процедура Тест_PostJson()
	
	ПараметрыПреобразованияJSON = Новый Структура;
	ПараметрыПреобразованияJSON.Вставить("ИменаСвойствСоЗначениямиДата", "Дата");
	
	Json = Новый Структура;
	Json.Вставить("Дата", '20190121002400');
	Json.Вставить("Число", 5);
	Json.Вставить("Булево", True);
	Json.Вставить("Строка", "Привет");
		
	Результат = КоннекторHTTP.PostJson(
		"https://httpbin.org/post", 
		Json, 
		Новый Структура("ПараметрыПреобразованияJSON", ПараметрыПреобразованияJSON));
	УтверждениеВерно(Результат["url"], "https://httpbin.org/post");
	УтверждениеВерно(Результат["json"]["Дата"], '20190121002400');
	УтверждениеВерно(Результат["json"]["Число"], 5);
	УтверждениеВерно(Результат["json"]["Булево"], True);
	УтверждениеВерно(Результат["json"]["Строка"], "Привет");

	ТестПройден("Тест_PostJson");
	
КонецПроцедуры

Процедура Тест_PostИРедирект()
	
	Ответ = КоннекторHTTP.Get("https://httpbin.org/redirect-to?url=https%3A%2F%2Fya.ru&status_code=301");
	УтверждениеВерно(Ответ.КодСостояния, 200);
	
	Ответ = КоннекторHTTP.Post("https://httpbin.org/redirect-to?url=https%3A%2F%2Fya.ru&status_code=301");
	УтверждениеВерно(Ответ.КодСостояния, 301);

	ТестПройден("Тест_PostИРедирект");
	
КонецПроцедуры

Процедура Тест_PutJson()
	
	Результат = КоннекторHTTP.PutJson("https://httpbin.org/put", Новый Структура("Название", "КоннекторHTTP"));
	УтверждениеВерно(Результат["url"], "https://httpbin.org/put");
	УтверждениеВерно(Результат["json"]["Название"], "КоннекторHTTP");
	
	ТестПройден("Тест_PutJson");
	
КонецПроцедуры

Процедура Тест_DeleteJson()
	
	Результат = КоннекторHTTP.DeleteJson("https://httpbin.org/delete", Новый Структура("Название", "КоннекторHTTP"));
	УтверждениеВерно(Результат["url"], "https://httpbin.org/delete");
	УтверждениеВерно(Результат["json"]["Название"], "КоннекторHTTP");
	
	ТестПройден("Тест_DeleteJson");
	
КонецПроцедуры

Процедура Тест_GetУспешныйРедиректОтносительныйАдрес()
	
	Ответ = КоннекторHTTP.Get("https://httpbin.org/relative-redirect/6");
	Результат = КоннекторHTTP.КакJson(Ответ);
	
	УтверждениеВерно(Ответ.КодСостояния, 200);
	УтверждениеВерно(Результат["url"], "https://httpbin.org/get");
	
	ТестПройден("Тест_GetУспешныйРедиректОтносительныйАдрес");
	
КонецПроцедуры

Процедура Тест_GetУспешныйРедиректАбсолютныйАдрес()
	
	Ответ = КоннекторHTTP.Get("https://httpbin.org/absolute-redirect/6");
	Результат = КоннекторHTTP.КакJson(Ответ);
	
	УтверждениеВерно(Ответ.КодСостояния, 200);
	УтверждениеВерно(Результат["url"], "https://httpbin.org/get");
	
	ТестПройден("Тест_GetУспешныйРедиректАбсолютныйАдрес");
	
КонецПроцедуры

Процедура Тест_GetЗацикленныйРедирект()
	
	Попытка
		Результат = КоннекторHTTP.КакJson(КоннекторHTTP.Get("http://httpbin.org/redirect/31"));
	Исключение
		ВерноеИсключение(ИнформацияОбОшибке(), "СлишкомМногоПеренаправлений");
	КонецПопытки;
	
	ТестПройден("Тест_GetЗацикленныйРедирект");
	
КонецПроцедуры

Процедура Тест_GetОтключенныйРедирект()
	
	Параметры = Новый Структура("РазрешитьПеренаправление", Ложь);	
	Ответ = КоннекторHTTP.Get("http://httpbin.org/redirect-to?url=http%3A%2F%2Fhttpbin.org%2Fget&status_code=307",, Параметры);
	
	УтверждениеВерно(Ответ.КодСостояния, 307);
	
	ТестПройден("Тест_GetОтключенныйРедирект");
	
КонецПроцедуры

Процедура Тест_Ошибка404()
	
	Ответ = КоннекторHTTP.Get("http://httpbin.org/status/404");
	
	УтверждениеВерно(Ответ.КодСостояния, 404);
	
	ТестПройден("Тест_Ошибка404");
	
КонецПроцедуры

Процедура Тест_РаботаССессиями()
	
	Сессия = КоннекторHTTP.СоздатьСессию();
	КоннекторHTTP.ВызватьМетодВСеансе(Сессия, "GET", "https://httpbin.org/cookies/set/key/value");
	Ответ = КоннекторHTTP.ВызватьМетодВСеансе(Сессия, "GET", "https://httpbin.org/cookies");
	Результат = КоннекторHTTP.КакJson(Ответ);
	
	УтверждениеВерно(Результат["cookies"]["key"], "value"); 
	
	ТестПройден("Тест_РаботаССессиями");
	
КонецПроцедуры

Процедура Тест_ПолучениеСпискаРелизовВСайта1С()
	
	Сессия = КоннекторHTTP.СоздатьСессию();
	Ответ = КоннекторHTTP.ВызватьМетодВСеансе(Сессия, "GET", "https://releases.1c.ru/total");
	
	Данные = Новый Структура;
	Данные.Вставить("execution", ИзвлечьExecution(Ответ));
	Данные.Вставить("username", Логин); 	
	Данные.Вставить("password", Пароль);
	Данные.Вставить("_eventId", "submit");
	Данные.Вставить("geolocation", "");
	Данные.Вставить("submit", "Войти");
	Данные.Вставить("rememberMe", "on");
	
	Ответ = КоннекторHTTP.ВызватьМетодВСеансе(Сессия, "POST", Ответ.URL, Новый Структура("Данные", Данные));
	
	УтверждениеВерно(Ответ.URL, "https://releases.1c.ru/total");
	УтверждениеВерно(Ответ.КодСостояния, 200);
	
	ТестПройден("Тест_ПолучениеСпискаРелизовВСайта1С");
	
КонецПроцедуры

Процедура Тест_Options()
	
	Ответ = КоннекторHTTP.Options("http://httpbin.org/anything");
	
	УтверждениеВерно(Ответ.КодСостояния, 200);
	
	ТестПройден("Тест_Options");
	
КонецПроцедуры

Процедура Тест_Head()
	
	Ответ = КоннекторHTTP.Head("http://httpbin.org/anything");
	
	УтверждениеВерно(Ответ.КодСостояния, 200);
	
	ТестПройден("Тест_Head");
	
КонецПроцедуры

Процедура Тест_Delete()
	
	Ответ = КоннекторHTTP.Delete("http://httpbin.org/delete");
	
	УтверждениеВерно(Ответ.КодСостояния, 200);
	
	ТестПройден("Тест_Delete");
	
КонецПроцедуры

Процедура Тест_Patch()
	
	Ответ = КоннекторHTTP.Patch("http://httpbin.org/patch");
	
	УтверждениеВерно(Ответ.КодСостояния, 200);
	
	ТестПройден("Тест_Patch");
	
КонецПроцедуры

Процедура Тест_УстановкаCookies()
	
	Результат = КоннекторHTTP.GetJson("http://httpbin.org/cookies/set/PHPSESSID/72a68cc1e55a4fbb9c0b8dbbeb49ca4f");
	
	УтверждениеВерно(Результат["cookies"]["PHPSESSID"], "72a68cc1e55a4fbb9c0b8dbbeb49ca4f");
	
	ТестПройден("Тест_УстановкаCookies");
	
КонецПроцедуры

Процедура Тест_ОтправитьCookies()
	
	Cookies = Новый Массив;
	Cookies.Добавить(Новый Структура("Наименование,Значение", "k1", Строка(Новый УникальныйИдентификатор)));
	Cookies.Добавить(Новый Структура("Наименование,Значение", "k2", Строка(Новый УникальныйИдентификатор)));
	Ответ = КоннекторHTTP.Get("http://httpbin.org/cookies",, Новый Структура("Cookies", Cookies));
	Результат = КоннекторHTTP.КакJson(Ответ);
	
	УтверждениеВерно(Результат["cookies"]["k1"], Cookies[0].Значение);
	УтверждениеВерно(Результат["cookies"]["k2"], Cookies[1].Значение);
	
	ТестПройден("Тест_ОтправитьCookies");
	
КонецПроцедуры

Процедура Тест_POST_MultipartFormData_ТолькоФайл()
	
	Файлы = Новый Структура;
	Файлы.Вставить("Имя", "f1");
	Файлы.Вставить("ИмяФайла", "file1.txt");
	Файлы.Вставить("Данные", Base64Значение("0J/RgNC40LLQtdGCLCDQnNC40YA="));
	Файлы.Вставить("Тип", "text/plain");
	
	Результат = КоннекторHTTP.PostJson("https://httpbin.org/post", Неопределено, Новый Структура("Файлы", Файлы));
	
	УтверждениеВерно(Результат["files"]["f1"], "Привет, Мир");
	
	ТестПройден("Тест_POST_MultipartFormData_ТолькоФайл");
	
КонецПроцедуры

Процедура Тест_POST_MultipartFormData_ФайлыИПоляФормы()
	
	Файлы = Новый Массив;
	Файлы.Добавить(Новый Структура("Имя,Данные,ИмяФайла", "f1", Base64Значение("ZmlsZTE="), "file1.txt"));
	Файлы.Добавить(Новый Структура("Имя,Данные,ИмяФайла", "f2", Base64Значение("ZmlsZTI="), "file2.txt"));
	
	Данные = Новый Структура("field1,field2", "value1", "Значение2");
	
	Результат = КоннекторHTTP.PostJson("https://httpbin.org/post", Неопределено, Новый Структура("Файлы,Данные", Файлы, Данные));
	
	УтверждениеВерно(Результат["files"]["f1"], "file1");
	УтверждениеВерно(Результат["files"]["f2"], "file2");
	УтверждениеВерно(Результат["form"]["field1"], "value1");
	УтверждениеВерно(Результат["form"]["field2"], "Значение2");
	
	ТестПройден("Тест_POST_MultipartFormData_ФайлыИПоляФормы");
	
КонецПроцедуры

Процедура Тест_ПараметрыЗапросаТолькоКлюч()

	Результат = КоннекторHTTP.GetJson("https://httpbin.org/get?key");
	УтверждениеВерно(Результат["args"]["key"], "");
	
	ТестПройден("Тест_ПараметрыЗапросаТолькоКлюч");
	
КонецПроцедуры

Процедура Тест_ОтправкаXml()
	
	XML = 
	"<?xml version=""1.0"" encoding=""utf-8""?>
	|<soap:Envelope xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">
	|  <soap:Body>
	|    <GetCursOnDate xmlns=""http://web.cbr.ru/"">
	|      <On_date>2019-07-05</On_date>
	|    </GetCursOnDate>
	|  </soap:Body>
	|</soap:Envelope>";
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "text/xml; charset=utf-8");
	Заголовки.Вставить("SOAPAction", "http://web.cbr.ru/GetCursOnDate");
	Ответ = КоннекторHTTP.Post(
		"https://www.cbr.ru/DailyInfoWebServ/DailyInfo.asmx",
		XML, 
		Новый Структура("Заголовки", Заголовки));
	
	УтверждениеВерно(Ответ.КодСостояния, 200);
	УтверждениеВерно(Ответ.Заголовки.Получить("Content-Type"), "text/xml; charset=utf-8");
	
	ТестПройден("Тест_ОтправкаXml");
	
КонецПроцедуры

Процедура Тест_СложныеПараметрыЗапроса()

	Результат = КоннекторHTTP.GetJson(
		"https://httpbin.org/anything?jql=worklogDate >= 2017-04-01 AND worklogDate <= 2017-05-01&j&i=2");
	УтверждениеВерно(Результат["args"]["jql"], "worklogDate >= 2017-04-01 AND worklogDate <= 2017-05-01");
	УтверждениеВерно(Результат["args"]["j"], "");
	УтверждениеВерно(Результат["args"]["i"], "2");
	
	ТестПройден("Тест_СложныеПараметрыЗапроса");
	
КонецПроцедуры

#КонецОбласти

Функция ИзвлечьExecution(Ответ)
	
	HTML = КоннекторHTTP.КакТекст(Ответ);
	
	Начало = СтрНайти(HTML, "name=""execution""");
	Конец = СтрНайти(HTML, ">", НаправлениеПоиска.СНачала, Начало);
	КороткаяСтрока = Сред(HTML, Начало, Конец - Начало);
	
	Начало = СтрНайти(КороткаяСтрока, "value=""") + СтрДлина("value=""");
	Конец = СтрНайти(КороткаяСтрока, """", НаправлениеПоиска.СНачала, Начало); 
	
	Возврат Сред(КороткаяСтрока, Начало, Конец - Начало);
	
КонецФункции

Функция ПосчитатьMD5(Данные)
	
	Хеширование = Новый ХешированиеДанных(ХешФункция.MD5);
	Хеширование.Добавить(Данные);
	
	Возврат НРег(ПолучитьHexСтрокуИзДвоичныхДанных(Хеширование.ХешСумма));
	
КонецФункции

Процедура УтверждениеВерно(ЛевоеЗначение, ПравоеЗначение, Пояснение = "")
	
	Если ЛевоеЗначение <> ПравоеЗначение Тогда
		ВызватьИсключение(СтрШаблон("<%1> не равно <%2>: %3", ЛевоеЗначение, ПравоеЗначение, Пояснение));
	КонецЕсли;
	
КонецПроцедуры

Процедура ВерноеИсключение(ИнформацияОбОшибке, ОжидаемоеИсключение)
	
	ТекстИсключения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	Если ТипЗнч(ОжидаемоеИсключение) = Тип("Массив") Тогда
		ТекстНайден = Ложь;
		Для Каждого Элемент Из ОжидаемоеИсключение Цикл
			Если СтрНайти(ТекстИсключения, Элемент) Тогда
				ТекстНайден = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ТекстНайден Тогда
			ВызватьИсключение(ТекстИсключения);
		КонецЕсли		
	Иначе
		Если Не СтрНайти(ТекстИсключения, ОжидаемоеИсключение) Тогда
			ВызватьИсключение(ТекстИсключения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТестПройден(Тест)
	
	Сообщить(СтрШаблон("[OK] %1", Тест));
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
