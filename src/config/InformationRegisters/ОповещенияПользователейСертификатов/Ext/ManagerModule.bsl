﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область СлужебныеПроцедурыИФункции

// Прочитать отметку о напоминании.
// 
// Параметры:
//  Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
// 
// Возвращаемое значение:
//  Булево, Неопределено - отметка о напоминании (Истина - Оповещен, больше не напоминать)
//
Функция ПрочитатьОтметкуОНапоминании(Сертификат) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОповещенияПользователейСертификатов.Оповещен
	|ИЗ
	|	РегистрСведений.ОповещенияПользователейСертификатов КАК ОповещенияПользователейСертификатов
	|ГДЕ
	|	ОповещенияПользователейСертификатов.Сертификат = &Сертификат
	|	И ОповещенияПользователейСертификатов.Пользователь = &Пользователь";

	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	Запрос.УстановитьПараметр("Сертификат", Сертификат);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат Не ВыборкаДетальныеЗаписи.Оповещен;
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти
#КонецЕсли