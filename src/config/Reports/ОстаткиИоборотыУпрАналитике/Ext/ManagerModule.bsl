﻿Процедура ВыполнитьКомпоновкуВФоне(СтруктураНастроек, АдресРезультатаВоВременномХранилище) Экспорт

	ТабличныйДокументРезультат = Новый ТабличныйДокумент;
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;

	Отчет = Отчеты[СтруктураНастроек.ИмяОтчета].Создать();
	Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Отчет.СхемаКомпоновкиДанных));
	Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(СтруктураНастроек.НастройкиКомпоновщика);
	Отчет.СкомпоноватьРезультат(ТабличныйДокументРезультат, ДанныеРасшифровки);

	ПоместитьВоВременноеХранилище(ДанныеРасшифровки, СтруктураНастроек.АдресДанныхРасшифровки);
	ПоместитьВоВременноеХранилище(ТабличныйДокументРезультат, АдресРезультатаВоВременномХранилище);

КонецПроцедуры