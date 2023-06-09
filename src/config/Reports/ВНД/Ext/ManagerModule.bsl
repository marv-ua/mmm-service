﻿Функция ВнешниеНаборыДанных(ДатаНач, ДатаКон, Организация) Экспорт

	тз = ОписаниеТаблицыРезультата();
	
	ТаблицаБаз = мммСервер.ПолучитьТаблицуСерверов(ДатаКон, Организация);

	Прогон = 1;
	МассивОрганизацийСОшибками = Новый Массив;

	Для Каждого ВыборкаДетальныеЗаписи Из ТаблицаБаз Цикл
		Если Не ВыборкаДетальныеЗаписи.Пометка Тогда
			Продолжить;
		КонецЕсли;

		ДлительныеОперации.СообщитьПрогресс(Окр(100*Прогон/ТаблицаБаз.Количество()), СокрЛП(ВыборкаДетальныеЗаписи.Ссылка.НаименованиеСокращенное),);
		Если НЕ ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Сервер)
			ИЛИ НЕ ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.База)
			ИЛИ НЕ ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Пользователь) Тогда
			Продолжить;
		КонецЕсли;	

		Актуальность = РегистрыСведений.АктуальностьОрганизаций.ПолучитьПоследнее(ДатаКон, Новый Структура("Организация", ВыборкаДетальныеЗаписи.Ссылка));
		Если НЕ Актуальность.Активна Тогда 
			Продолжить;
		КонецЕсли;	

		Попытка
			СоединениеУстановлено = Ложь;
			Для сч = 1 По 3 Цикл
				Попытка
					Прокси = мммСервер.ПолучитьПрокси(ВыборкаДетальныеЗаписи.Сервер, 
						ВыборкаДетальныеЗаписи.База,
						ВыборкаДетальныеЗаписи.Пользователь,
						ВыборкаДетальныеЗаписи.Пароль
					);
					СоединениеУстановлено = Истина;
					Прервать;
				Исключение
				КонецПопытки;
			КонецЦикла;
			Если НЕ СоединениеУстановлено Тогда
				Продолжить;
			КонецЕсли;	

			///////////////////////////////////////////////////////////////////
			ОСКД = Отчеты.ВНД.ПолучитьМакет("ВНД");

			// сериализуем
			ЗаписьXML = Новый ЗаписьXML;
			ЗаписьXML.УстановитьСтроку();
			СериализаторXDTO.ЗаписатьXML(ЗаписьXML, ОСКД);
			стрОСКД = ЗаписьXML.Закрыть();
			Если ВыборкаДетальныеЗаписи.Ссылка.БазаУТП Тогда
				стрОСКД = СтрЗаменить(стрОСКД, "Организация = &amp;Организация", "");
				стрОСКД = СтрЗаменить(стрОСКД, "ЗНАЧЕНИЕ(Плансчетов.хозрасчетный.РасчетыСПоставщикамиИПодрядчиками)",
					"ЗНАЧЕНИЕ(Плансчетов.хозрасчетный."+РегистрыСведений.Меппинг.ПолучитьЗамену(ВыборкаДетальныеЗаписи.Ссылка, "РасчетыСПоставщикамиИПодрядчиками")+")");
				стрОСКД = СтрЗаменить(стрОСКД, "ЗНАЧЕНИЕ(Плансчетов.хозрасчетный.РасчетыСПокупателямиИЗаказчиками)",
					"ЗНАЧЕНИЕ(Плансчетов.хозрасчетный."+РегистрыСведений.Меппинг.ПолучитьЗамену(ВыборкаДетальныеЗаписи.Ссылка, "РасчетыСПокупателямиИЗаказчиками")+")");
				стрОСКД = СтрЗаменить(стрОСКД, "Счет.Код В (""62.05"")",
					"Счет.Код В ("""+РегистрыСведений.Меппинг.ПолучитьЗамену(ВыборкаДетальныеЗаписи.Ссылка, "62.05")+""")");
				стрОСКД = СтрЗаменить(стрОСКД, "КОГДА ХозрасчетныйОбороты.Счет.Код = ""60.01""",
					"КОГДА ХозрасчетныйОбороты.Счет.Код = """+РегистрыСведений.Меппинг.ПолучитьЗамену(ВыборкаДетальныеЗаписи.Ссылка, "60.01")+"""");
				стрОСКД = СтрЗаменить(стрОСКД, "КОГДА ХозрасчетныйОбороты.Счет.Код = ""62.05""",
					"КОГДА ХозрасчетныйОбороты.Счет.Код = """+РегистрыСведений.Меппинг.ПолучитьЗамену(ВыборкаДетальныеЗаписи.Ссылка, "62.05")+"""");
				стрОСКД = СтрЗаменить(стрОСКД, "Счет.Код = ""60.01""", "Счет.Код = """+ РегистрыСведений.Меппинг.ПолучитьЗамену(ВыборкаДетальныеЗаписи.Ссылка, "60.01") + """");
				стрОСКД = СтрЗаменить(стрОСКД, "КорСчет.Код = ""62.05""", "КорСчет.Код = """+ РегистрыСведений.Меппинг.ПолучитьЗамену(ВыборкаДетальныеЗаписи.Ссылка, "62.05") + """");
			КонецЕсли;

			ВыполняемыйКод = СтрШаблон("
				|// десериализуем макет
				|ЧтениеXML = Новый ЧтениеXML;
				|ЧтениеXML.УстановитьСтроку(""%1"");
				|ОСКД = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
				|
				|НастройкиОСКД = ОСКД.НастройкиПоУмолчанию;
				|
				|ТаблДокум = Новый ТаблицаЗначений;
				|ПараметрыДанныхОСКД = НастройкиОСКД.ПараметрыДанных.Элементы;
				|ЭлементОрганизация = ПараметрыДанныхОСКД.Найти(""Организация"");
				|ЭлементОрганизация.Использование = Истина;
				|"+?(ВыборкаДетальныеЗаписи.Ссылка.БазаУТП,"Темп = %2;","
				|ЭлементОрганизация.Значение = Справочники.Организации.НайтиПоРеквизиту(""ИНН"", ""%2"");
				|")+"
				|ЭлементНачалоПериода = ПараметрыДанныхОСКД.Найти(""ПериодНач"");
				|ЭлементНачалоПериода.Использование = Истина;
				|ЭлементНачалоПериода.Значение = НачалоДня(Дата(%3));
				|
				|ЭлементКонецПериода = ПараметрыДанныхОСКД.Найти(""ПериодКон"");
				|ЭлементКонецПериода.Использование = Истина;
			//	|ЭлементКонецПериода.Значение = Новый Граница(КонецДня(Дата(%4)),ВидГраницы.Включая);					
				|ЭлементКонецПериода.Значение = КонецДня(Дата(%4));					
				|
				|КомпоновщикМакетаОСКД = Новый КомпоновщикМакетаКомпоновкиДанных;
				|Макет = КомпоновщикМакетаОСКД.Выполнить(ОСКД, НастройкиОСКД,,, Тип(""ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений""));
				|
				|ПроцессорКомпоновкиОСКД = Новый ПроцессорКомпоновкиДанных;
				|ПроцессорКомпоновкиОСКД.Инициализировать(Макет);
				|
				|ПроцессорВыводаОСКД = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
				|ПроцессорВыводаОСКД.УстановитьОбъект(ТаблДокум);
				|ПроцессорВыводаОСКД.Вывести(ПроцессорКомпоновкиОСКД);
				|
				|
				|ВозвращаемоеЗначение = ТаблДокум;
				|"
				, СтрЗаменить(СтрЗаменить(стрОСКД,"""",""""""), Символы.ПС, Символы.ПС+"|")
				, ВыборкаДетальныеЗаписи.Ссылка.ИНН
				, Формат(ДатаНач, "ДФ=yyyy,MM,dd")
				, Формат(ДатаКон, "ДФ=yyyy,MM,dd")
			);

			Ответ = мммСервер.ДеСериализовать(
				Прокси.RunCode(ВыполняемыйКод)
			);

			Если НЕ Ответ.Ошибка Тогда
				//ЧтениеXML = Новый ЧтениеXML;
				//ЧтениеXML.УстановитьСтроку(Ответ.Результат);
				//ТабДок = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);		
				
				Если ТипЗнч(Ответ.Результат) = Тип("ТаблицаЗначений") Тогда
					Для Каждого Стр Из Ответ.Результат Цикл
						Если ПустаяСтрока(Стр.Счет) Тогда
							Продолжить;
						КонецЕсли;	
						
						НоваяСтрока = тз.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрока, Стр);
						НоваяСтрока.Организация = ВыборкаДетальныеЗаписи.Ссылка;
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
			///////////////////////////////////////////////////////////////////			

		Исключение
			//МассивОрганизацийСОшибками.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
			Сообщить(СтрШаблон("Не удалось выполнить запрос по организации %1", ВыборкаДетальныеЗаписи.Ссылка));
			ЗаписьЖурналаРегистрации("Отчет затраты", УровеньЖурналаРегистрации.Ошибка, ,,ОписаниеОшибки());
		КонецПопытки;
		Прогон = Прогон + 1;
	КонецЦикла;

	Возврат Новый Структура("ВнешнийНабор", тз);

КонецФункции

Функция ОписаниеТаблицыРезультата() Экспорт
	тз = новый ТаблицаЗначений;
	тз.Колонки.Добавить("Счет", Новый ОписаниеТипов("Строка"));
	тз.Колонки.Добавить("Организация");
	тз.Колонки.Добавить("Субконто1", Новый ОписаниеТипов("Строка"));
	тз.Колонки.Добавить("Группа", Новый ОписаниеТипов("Строка"));
	тз.Колонки.Добавить("СуммаНачальныйОстаток", Новый ОписаниеТипов("Число"));
	тз.Колонки.Добавить("СуммаОборотДт", Новый ОписаниеТипов("Число"));
	тз.Колонки.Добавить("СуммаОборотКт", Новый ОписаниеТипов("Число"));
	тз.Колонки.Добавить("СуммаКонечныйОстаток", Новый ОписаниеТипов("Число"));
	Возврат тз;
КонецФункции	