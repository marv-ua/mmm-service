﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ПрограммныйИнтерфейс

Функция СохранитьОрганизацию(СтрокаОтвета, Перезаписывать = Ложь) Экспорт
	
	ЭтоНовый = Ложь;
	Если ЗначениеЗаполнено(СтрокаОтвета.ИНН) Тогда
		спр = Справочники.Организации.НайтиПоРеквизиту("ИНН", СтрокаОтвета.ИНН);
	Иначе
		спр = Справочники.Организации.НайтиПоНаименованию(СтрокаОтвета.Наименование);	
	КонецЕсли;	
	Если НЕ ЗначениеЗаполнено(спр) Тогда
		спр = Справочники.Организации.СоздатьЭлемент();
		ЭтоНовый = Истина;
	Иначе
		спр = спр.ПолучитьОбъект();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(спр, СтрокаОтвета);	
	
	Если НЕ ЭтоНовый И НЕ Перезаписывать Тогда
		Возврат спр.Ссылка;
	КонецЕсли;	
	
	Попытка
		спр.Записать();
		Возврат спр.Ссылка;
	Исключение
		ЗаписьЖурналаРегистрации("СохранениеЭлементаОрганизация", УровеньЖурналаРегистрации.Ошибка, Метаданные.Справочники.Организации, спр.Ссылка, ОписаниеОшибки());
	КонецПопытки;	
	
	Возврат Неопределено;
	
КонецФункции

Функция НайтиОрганизацию(СтрокаОтвета, Перезаписывать = Ложь) Экспорт
	
	ЭтоНовый = Ложь;
	Если ЗначениеЗаполнено(СтрокаОтвета.ИНН) Тогда
		Возврат Справочники.Организации.НайтиПоРеквизиту("ИНН", Формат(СтрокаОтвета.ИНН, "ЧГ=0"));
	Иначе
		Возврат Справочники.Организации.НайтиПоНаименованию(СтрокаОтвета.Наименование);	
	КонецЕсли;	
	
	Возврат Неопределено;
	
КонецФункции


Процедура ЗаписатьРасположениеФирм(Организация, Сервер, ИмяБазы, Логин, Пароль) Экспорт
	
	Менеджер = РегистрыСведений.РасположениеФирм.СоздатьМенеджерЗаписи();
	Менеджер.Период = НачалоДня(ТекущаяДатаСеанса());
	Менеджер.Организация = Организация;
	Менеджер.Прочитать();
	Менеджер.Сервер = Сервер;
	Менеджер.ИмяБазы = ИмяБазы;
	Менеджер.Логин = Логин;
	Менеджер.Пароль = Пароль;
	Менеджер.Период = НачалоДня(ТекущаяДатаСеанса());
	Менеджер.Организация = Организация;
	
	Менеджер.Записать();
	
КонецПроцедуры	

#КонецОБласти
#КонецЕсли