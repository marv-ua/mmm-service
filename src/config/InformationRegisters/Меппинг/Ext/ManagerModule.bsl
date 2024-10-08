﻿Функция ПолучитьЗамену(Организация, ЧтоЗаменять, ТипДанных = Неопределено) Экспорт

	Если ТипДанных = Неопределено Тогда
		ТипДанных = ПредопределенноеЗначение("Перечисление.ТипыДанныхМеппинга.Счет");
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Меппинг.ЧемЗаменять КАК ЧемЗаменять
	               |ИЗ
	               |	РегистрСведений.Меппинг КАК Меппинг
	               |ГДЕ
	               |	Меппинг.ТипДанных = &ТипДанных
	               |	И Меппинг.ЧтоЗаменять = &ЧтоЗаменять
	               |	И Меппинг.Организация = &Организация";
	Запрос.УстановитьПараметр("ТипДанных", ТипДанных);
	Запрос.УстановитьПараметр("ЧтоЗаменять", ЧтоЗаменять);
	Запрос.УстановитьПараметр("Организация", Организация);

	Попытка
		РезультатЗапроса = Запрос.Выполнить();
	Исключение
		Возврат ЧтоЗаменять;
	КонецПопытки;
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат ЧтоЗаменять;
	КонецЕсли;

	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.ЧемЗаменять;

КонецФункции