﻿
Функция RunQuery(strQuery)
	
	Данные = ммм_Сервер.ДеСериализовать(strQuery);
	
	Если НЕ Данные.Свойство("ТекстЗапроса") Тогда
		Возврат ммм_Сервер.Сериализовать(
			ммм_Сервер.ПодготовитьСтруктуруОтвета(Истина, "Параметр не содержит в себе ТекстЗапроса")
		);
	КонецЕсли;	
	
	Запрос = Новый Запрос;	
	Запрос.Текст = Данные.ТекстЗапроса;
	Если Данные.Свойство("Параметры") Тогда
		Для Каждого Параметр Из Данные.Параметры Цикл
			Запрос.УстановитьПараметр(Параметр.Ключ, Параметр.Значение);	
		КонецЦикла;	
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатЗапроса = Неопределено Тогда
		Возврат ммм_Сервер.Сериализовать(
			ммм_Сервер.ПодготовитьСтруктуруОтвета(Истина, "Ошибка выполнения запроса")
		);		
	КонецЕсли;
	
	Возврат ммм_Сервер.Сериализовать(ммм_Сервер.ПодготовитьСтруктуруОтвета(,,РезультатЗапроса.Выгрузить()));
	
КонецФункции

Функция RunCode(strCode)
	
	ВозвращаемоеЗначение = Неопределено;

	Попытка
		УстановитьПривилегированныйРежим(Истина);
		Выполнить(strCode);
		УстановитьПривилегированныйРежим(Ложь);
		Возврат ммм_Сервер.Сериализовать(
			ммм_Сервер.ПодготовитьСтруктуруОтвета(Ложь,,ВозвращаемоеЗначение)
		);		
	Исключение
		Возврат ммм_Сервер.Сериализовать(
			ммм_Сервер.ПодготовитьСтруктуруОтвета(Истина, ОписаниеОшибки())
		);		
	КонецПопытки;
	
	
КонецФункции

	