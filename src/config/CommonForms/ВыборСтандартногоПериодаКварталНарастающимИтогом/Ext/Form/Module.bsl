﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "НачалоПериода,КонецПериода");
	ДатаНачалаГода = ?(ЗначениеЗаполнено(КонецПериода), НачалоГода(КонецПериода), НачалоГода(ТекущаяДатаСеанса()));
	ЦветТекущегоПериода = ЦветаСтиля.ВыборСтандартногоПериодаФонКнопки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьАктивныйПериод();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПерейтиНаГодНазад(Команда)
	
	ДатаНачалаГода = НачалоГода(ДатаНачалаГода - 1);
	
	УстановитьАктивныйПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаГодВперед(Команда)
	
	ДатаНачалаГода = КонецГода(ДатаНачалаГода) + 1;
	
	УстановитьАктивныйПериод();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал1(Команда)
	
	ВыбратьКвартал(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал2(Команда)
	
	ВыбратьКвартал(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал3(Команда)
	
	ВыбратьКвартал(3);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал4(Команда)
	
	ВыбратьКвартал(4);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПолугодие1(Команда)
	
	ВыбратьПолугодие(1);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать9Месяцев(Команда)

	НачалоПериода = ДатаНачалаГода;
	КонецПериода  = Дата(Год(ДатаНачалаГода), 9 , 30);
	ВыполнитьВыборПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьГод(Команда)

	НачалоПериода = ДатаНачалаГода;
	КонецПериода  = КонецГода(ДатаНачалаГода);
	ВыполнитьВыборПериода();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьАктивныйПериод()

	Если НачалоКвартала(НачалоПериода) = НачалоКвартала(КонецПериода) Тогда
		НомерМесяца = Месяц(НачалоПериода);
		НомерКвартала = Цел((НомерМесяца + 3) / 3);
		ТекущийЭлемент = Элементы["ВыбратьКвартал" + НомерКвартала];
	ИначеЕсли НачалоГода(НачалоПериода) = НачалоГода(КонецПериода) Тогда
		НомерМесяцаНачала = Месяц(НачалоПериода);
		НомерМесяцаКонца  = Месяц(КонецПериода);
		Если НомерМесяцаНачала <= 3 И НомерМесяцаКонца <= 6 Тогда
			ТекущийЭлемент = Элементы["ВыбратьПолугодие1"];
		ИначеЕсли НомерМесяцаНачала <= 3 И НомерМесяцаКонца <= 9 Тогда
			ТекущийЭлемент = Элементы["Выбрать9Месяцев"];
		Иначе
			ТекущийЭлемент = Элементы["ВыбратьГод"];
		КонецЕсли;
	Иначе
		ТекущийЭлемент = Элементы["ВыбратьГод"];
	КонецЕсли;

	ТекущийЭлемент.ЦветФона = ЦветТекущегоПериода;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыборПериода()

	РезультатВыбора = Новый Структура("НачалоПериода,КонецПериода", НачалоПериода, КонецДня(КонецПериода));
	ОповеститьОВыборе(РезультатВыбора);

КонецПроцедуры 

&НаКлиенте
Процедура ВыбратьКвартал(НомерКвартала)
	
	НачалоПериода = Дата(Год(ДатаНачалаГода), 1 + (НомерКвартала - 1) * 3, 1);
	
	КонецПериода  = КонецКвартала(НачалоПериода);
	
	ВыполнитьВыборПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПолугодие(НомерПолугодия)

	НачалоПериода = Дата(Год(ДатаНачалаГода), 1 + (НомерПолугодия - 1) * 6, 1);
	КонецПериода  = КонецМесяца(ДобавитьМесяц(НачалоПериода, 5));
	ВыполнитьВыборПериода();
	
КонецПроцедуры

