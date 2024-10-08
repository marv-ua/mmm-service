﻿#Область ПрограммныйИнтерфейс
Процедура ОтправитьДанныев7(Параметры, ЭтаФорма, Элементы) Экспорт
	
	Данные = Параметры.ВыделенныеСтроки;

	БазаОле = Неопределено;
	Если ЗатратыСерверПереопределяемый.ПодключатьсяК7НаСервере() Тогда
		БазаОле = мммСервер.ПодключитьсяКБазеМММКлиент();
	Иначе
		#Если Клиент Тогда
		БазаОле = мммКлиент.ПодключитьсяКБазеМММКлиент();
		#КонецЕсли
	КонецЕсли;
	
	Если Параметры.ОчищатьДокументыПередВыгрузкой Тогда
		
		МИНН = Новый Массив;
		МПериод = Новый Массив;
		Для Каждого Эл Из Данные Цикл
			Запись = ЗатратыСервер.ПолучитьЗаписьПоКлючу(Эл);
			МИНН.Добавить(Запись.ИНН);
			МПериод.Добавить(Запись.Период);
		КонецЦикла;
		
		МИНН = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МИНН);
		МПериод = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МПериод);
		
		Для Каждого Период из МПериод Цикл
			Для Каждого Инн Из МИНН Цикл
				ОчиститьВыписки(БазаОле, Период, ИНН);
			КонецЦикла;
		КонецЦикла;
		
		Если Не Параметры.НеВыгружатьКассу Тогда
			Для Каждого Период из МПериод Цикл
				Для Каждого Инн Из МИНН Цикл
					ОчиститьОперации(БазаОле, Период, ИНН);
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;

	Если НЕ БазаОле = Неопределено Тогда

		ТекНомер = 0;
		Для Каждого Эл Из Данные Цикл

			Запись = Неопределено;
			Если ТипЗнч(Эл) = Тип("РегистрСведенийКлючЗаписи.ДанныеКВыгрузкеВ7") Тогда
				Запись = ЗатратыСервер.ПолучитьЗаписьПоКлючу(Эл);
			Иначе
				Запись = ЗатратыКлиентСервер.СтруктураДанных(Эл);
			КонецЕсли;

			#Если Клиент Тогда
			Состояние(Запись.Группа, 100 * (ТекНомер / Данные.Количество()), Запись.Счет + ", " + Запись.КорСчет + ", " + Запись.ВидОперации, БиблиотекаКартинок.ОбменДанными32);
			ОбработкаПрерыванияПользователя();
			#КонецЕсли
			Элементы.Очередь.Обновить();

			Если Запись.Документ = ПредопределенноеЗначение("Перечисление.ВидыВыгружаемыхДокументов.Выписка") Тогда
				ОтправитьВыписку(БазаОле, Запись, ЭтаФорма.Затирать,, Параметры.НеВыгружатьКассу);
			ИначеЕсли Запись.Документ = ПредопределенноеЗначение("Перечисление.ВидыВыгружаемыхДокументов.Операция") Тогда
				Если Не Параметры.НеВыгружатьКассу Тогда
					ОтправитьОперацию(БазаОле, Запись,, ЭтаФорма.Затирать);
				КонецЕсли;
			ИначеЕсли Запись.Документ = ПредопределенноеЗначение("Перечисление.ВидыВыгружаемыхДокументов.ПоступлениеМатериалов") Тогда
				ОтправитьПоступлениеМатериалов(БазаОле, Запись);
			ИначеЕсли Запись.Документ = ПредопределенноеЗначение("Перечисление.ВидыВыгружаемыхДокументов.ПоступлениеТоваров") Тогда
				ОтправитьПоступлениеТоваров(БазаОле, Запись);
			ИначеЕсли Запись.Документ = ПредопределенноеЗначение("Перечисление.ВидыВыгружаемыхДокументов.УслугиСтороннихОрганизаций") Тогда
				ОтправитьУслугиСтороннихОрганизаций(БазаОле, Запись);
				//ЗаполнитьУслугиСтороннихОрганизацийНаКлиенте(БазаОле, Запись.Период);
			КонецЕсли;

			ТекНомер = ТекНомер + 1;
		КонецЦикла;
	Иначе
		Сообщить("Не удалось подключиться к базе ммм");
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьУслугиСтороннихОрганизаций(Период) Экспорт
	БазаОле = Неопределено;
	Если ЗатратыСерверПереопределяемый.ПодключатьсяК7НаСервере() Тогда
		БазаОле = мммСервер.ПодключитьсяКБазеМММКлиент();
	Иначе
		#Если Клиент Тогда
		БазаОле = мммКлиент.ПодключитьсяКБазеМММКлиент();
		#КонецЕсли
	КонецЕсли;

	Если НЕ БазаОле = Неопределено Тогда
		ЗаполнитьУслугиСтороннихОрганизацийНаКлиенте(БазаОле, Период);
	Иначе
		Сообщить("Не удалось подключиться к базе ммм");
	КонецЕсли;
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Процедура ОчиститьОперации(БазаОле, Период, ИНН)

	// основную кассу не выгружаем, ее мы загрузим из управленца
	Если ЗатратыСерверПереопределяемый.Счет50(ИНН) = ЗатратыСерверПовтИсп.СчетКассаПоУмолчанию() Тогда
		Возврат;
	КонецЕсли;
	
	ДокОперация = БазаОле.CreateObject("Операция");
	Если ДокОперация.ВыбратьПоЗначению(Период, КонецМесяца(Период), "ИНН", ИНН) Тогда
		
		ДокОперация.ВыбратьПроводки();
		ПроводкаНайдена = Ложь;
		Пока ДокОперация.ПолучитьПроводку() Цикл
			#Если Клиент Тогда
			ОбработкаПрерыванияПользователя();
			#КонецЕсли
			
			ДокОперация.SetAttrib("Сумма", 0);

		КонецЦикла;
		
		Попытка
			ДокОперация.Write();
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	
	КонецЕсли;
		

КонецПроцедуры

Процедура ОчиститьВыписки(БазаОле, Период, ИНН)

	Док = БазаОле.CreateObject("Документ");
	ДокВыписка = БазаОле.CreateObject("Документ.Выписка");
	Док.UseJournal("Банк");

	Если Док.SelectByValue(Период, КонецМесяца(Период), "ИНН", ИНН) Тогда

		Пока Док.GetDocument() Цикл
			Попытка
				ДокВыписка.FindDocument(Док.ТекущийДокумент());
			Исключение
				ЗатратыСерверПереопределяемый.Пауза(1);
				Док.GetDocument();
			КонецПопытки;
			Попытка
				ДокВыписка.FindDocument(Док.ТекущийДокумент());
			Исключение
				ЗатратыСерверПереопределяемый.Пауза(5);
				Док.GetDocument();
			КонецПопытки;
			Попытка
				ДокВыписка.FindDocument(Док.ТекущийДокумент());
			Исключение
				Продолжить;
			КонецПопытки;


			Если ДокВыписка.FindDocument(Док.ТекущийДокумент()) = 1 Тогда

				СтрокаНайдена = Ложь;
				ДокВыписка.SelectLines();
				Пока ДокВыписка.GetLine() Цикл
					#Если Клиент Тогда
					ОбработкаПрерыванияПользователя();
					#КонецЕсли

					Если (ДокВыписка.Приход <> 0) Или ДокВыписка.Расход <> 0 Тогда
						ДокВыписка.Приход = 0;
						ДокВыписка.Расход = 0;
						СтрокаНайдена = Истина;
					КонецЕсли;

				КонецЦикла;
				Сообщить(
					"Выписка " + СокрЛП(ДокВыписка.НомерДок) + " от " + СокрЛП(ДокВыписка.ДатаДок) + " Документ очищен, ИНН" + ИНН
					, СтатусСообщения.Внимание
				);
				Если СтрокаНайдена Тогда
					Попытка
						ДокВыписка.Записать();
					Исключение
						Сообщить(ОписаниеОшибки());
					КонецПопытки;
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтправитьВыписку(БазаОле, Данные, Затирать, ИсходныеДанные = Неопределено, НеВыгружатьКассу = Ложь)

	// подразумеваем что Исходные данные указываются при подмене, а если произошла подмена то статус в процессе уже установлен
	Если ИсходныеДанные = Неопределено Тогда
		ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_ВПроцессе());
	КонецЕсли;

	Док = БазаОле.CreateObject("Документ");
	ДокВыписка = БазаОле.CreateObject("Документ.Выписка");
	Док.UseJournal("Банк");

	// оплата за: 
	// 1. делаем перемещение на 51 счет на фирму за кого платим
	// 2. делаем оплату поставщику в выписке фирмы которая платит
	// Итерации:
	// 0 - Стандартная выгрузка
	// 1 - перемещение расход на фирму за которую платим
	// 2 - перемещение приход на фирму за которую платим
	// 3 - оплата потавщику с фирмы за которую платим
	Если Не Данные.ОплатаЗа = Неопределено Тогда
		// если фирма платит сама за себя - это не оплата по тройственному
		Если НЕ Данные.ОплатаЗа.Организация = Данные.Организация Тогда

			// крайне не желательно чтоб отчюда формировалась в итоге еще и операция ДелатьЗеркальнуюОперацию
			ПервичныеДанные = Новый ФиксированнаяСтруктура(Данные);
			// 1
			Данные.ВидОперации = ЗатратыСервер.ВидОперацииВыпискаПеремещениеНа51(ПервичныеДанные.Организация, ПервичныеДанные.ОплатаЗа.Организация);
			Данные.ОплатаЗа = Неопределено;
			ОтправитьВыписку(БазаОле, Данные, Затирать, ПервичныеДанные);

			// 2
			Данные.ВидОперации = ЗатратыСервер.ВидОперацииВыпискаПеремещениеНа51(ПервичныеДанные.ОплатаЗа.Организация, ПервичныеДанные.Организация);
			Данные.Организация = ПервичныеДанные.ОплатаЗа.Организация;
			Данные.ИНН = ЗатратыСервер.ИннОрганизации(ПервичныеДанные.ОплатаЗа.Организация);
			Данные.СуммаОперации = -Данные.СуммаОперации;
			Данные.Группа = ЗатратыСервер.ПолучитьГруппуПоИНН(Данные.Период, Данные.ИНН);
			Данные.ОплатаЗа = Неопределено;
			ОтправитьВыписку(БазаОле, Данные, Затирать, ПервичныеДанные);
			
			// 3
			ЗаполнитьЗначенияСвойств(Данные, ПервичныеДанные);
			Данные.Организация = ПервичныеДанные.ОплатаЗа.Организация;
			Данные.ИНН = ЗатратыСервер.ИннОрганизации(ПервичныеДанные.ОплатаЗа.Организация);
			Данные.ВидОперации = ЗатратыСервер.ВидОперацииВыпискаОплатаПоТройственному(ПервичныеДанные.ОплатаЗа.Организация, Данные.ВидОперации);
			Данные.Группа = ЗатратыСервер.ПолучитьГруппуПоИНН(Данные.Период, Данные.ИНН);
			Данные.ОплатаЗа = Неопределено;
			ОтправитьВыписку(БазаОле, Данные, Затирать, ПервичныеДанные);

			Возврат;

		КонецЕсли;
	КонецЕсли;

	Если Док.SelectByValue(Данные.Период, КонецМесяца(Данные.Период), "ИНН", Данные.ИНН) Тогда

		Пока Док.GetDocument() Цикл
			Попытка
				ДокВыписка.FindDocument(Док.ТекущийДокумент());
			Исключение
				ЗатратыСерверПереопределяемый.Пауза(1);
				Док.GetDocument();
			КонецПопытки;
			Попытка
				ДокВыписка.FindDocument(Док.ТекущийДокумент());
			Исключение
				ЗатратыСерверПереопределяемый.Пауза(5);
				Док.GetDocument();
			КонецПопытки;
			Попытка
				ДокВыписка.FindDocument(Док.ТекущийДокумент());
			Исключение
				Продолжить;
			КонецПопытки;


			Если ДокВыписка.FindDocument(Док.ТекущийДокумент()) = 1 Тогда

				СтрокаНайдена = Ложь;
				ДокВыписка.SelectLines();
				Пока ДокВыписка.GetLine() Цикл
					#Если Клиент Тогда
					ОбработкаПрерыванияПользователя();
					#КонецЕсли
					СтрокаНайдена = Ложь;
					ТекСтрока = СтруктураСтрокиВыписки(ДокВыписка);
					ДопПараметры = Неопределено;
					ДелатьЗеркальнуюОперацию = Ложь;
					Если ЗатратыСервер.ВыпискаПроверитьСтроку(Данные, ТекСтрока, ДопПараметры, ДелатьЗеркальнуюОперацию) Тогда

						СтрокаНайдена = Истина;
						Если Данные.СуммаОперации > 0 Тогда 
							Если (ДокВыписка.Приход > 0) и (Данные.СуммаОперации <> ДокВыписка.Приход) Тогда
								Сообщить(
									"Выписка " + СокрЛП(ДокВыписка.НомерДок) + " от " + СокрЛП(ДокВыписка.ДатаДок) + " по строке " + ДокВыписка.НомерСтроки +
									", Сумма= " + ДокВыписка.Приход + " отличается от загружаемой суммы= " + Данные.СуммаОперации + 
									", Вид движения: " + ДокВыписка.ВидДвижения.Наименование + ", Счет: " + Данные.Счет +  ", КорСчет: " + ДокВыписка.КоррСчет.Код	
									, СтатусСообщения.Внимание
								);

							КонецЕсли;
							ДокВыписка.SetAttrib("Приход", ?(ДокВыписка.Приход > 0, ?(Затирать, Данные.СуммаОперации, ДокВыписка.Приход + Данные.СуммаОперации), Данные.СуммаОперации));
			
						Иначе
							Если (ДокВыписка.Расход > 0) и (Данные.СуммаОперации <>  ДокВыписка.Расход)  Тогда
								Сообщить(
									"Выписка " + СокрЛП(ДокВыписка.НомерДок) + " от " + СокрЛП(ДокВыписка.ДатаДок) + " по строке " + ДокВыписка.НомерСтроки +
									", Сумма= " + ДокВыписка.Расход + " отличается от загружаемой суммы= " + Данные.СуммаОперации + 
									", Вид движения: " + ДокВыписка.ВидДвижения.Наименование + ", Счет: " + Данные.Счет + ", КорСчет: " + ДокВыписка.КоррСчет.Код
									, СтатусСообщения.Внимание
								);

							КонецЕсли;
							ДокВыписка.SetAttrib("Расход", ?(ДокВыписка.Расход > 0, ?(Затирать, -1*Данные.СуммаОперации, ДокВыписка.Расход + ((-1)*Данные.СуммаОперации)), -1*Данные.СуммаОперации));

						КонецЕсли;

						ЗаписатьДок(ДокВыписка, ?(не ИсходныеДанные = Неопределено, ИсходныеДанные, Данные), ДопПараметры);
						Если ДелатьЗеркальнуюОперацию Тогда
							Если НеВыгружатьКассу Тогда
								Продолжить;
							КонецЕсли;

							ПервичныеДанные = Новый ФиксированнаяСтруктура(Данные);

							стОперации = Новый Структура;
							стОперации.Вставить("СчДт", ?(Данные.СуммаОперации > 0, "51", ТекСтрока.КоррСчет));
							стОперации.Вставить("СчКт", ?(Данные.СуммаОперации > 0, ТекСтрока.КоррСчет, "51"));
							стОперации.Вставить("Субконто1", Данные.Группа);
							стОперации.Вставить("СуммаОперации", Данные.СуммаОперации);
							стОперации.Вставить("ВидОперации", Данные.ВидОперации);
							стОперации.Вставить("ИНН", Данные.ИНН);
							стОперации.Вставить("Документ", ПредопределенноеЗначение("Перечисление.ВидыВыгружаемыхДокументов.Операция"));
							стОперации.Вставить("Группа", Данные.Группа);
							стОперации.Вставить("Период", Данные.Период);
							стОперации.Вставить("Организация", Данные.Организация);	
							
							Ответ = ОтправитьЗеркальнуюОперацию(БазаОле, стОперации,,Затирать, ПервичныеДанные);
							Если Ответ.Успешно Тогда
								ЗатратыСервер.УстановитьСтатус(ПервичныеДанные, ЗатратыКлиентСервер.СтатусОтправки_Успешно(),, Ответ.Док);
							Иначе
								ЗатратыСервер.УстановитьСтатус(ПервичныеДанные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), Ответ.СтрокаОшибки,,);
							КонецЕсли;
						КонецЕсли;

						Прервать;

					КонецЕсли;
				КонецЦикла;	
			КонецЕсли;		
		КонецЦикла;
		
		Если НЕ СтрокаНайдена Тогда
			ТекстСообщения = "Не найдена строка в документе " + Данные.ИНН + ", " + Данные.Период + ", " + Данные.Организация + 
				Данные.Документ + ", Счет: " + Данные.Счет + ", Кор. счет: " + Данные.КорСчет + ", "+ 
				СокрЛП(Данные.ВидОперации) + ", " + Данные.Группа;
			Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное
			);
			ЗатратыСервер.УстановитьСтатус(?(не ИсходныеДанные = Неопределено, ИсходныеДанные, Данные), ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);
		КонецЕсли;		
		
	КонецЕсли;
	
КонецПроцедуры	

Функция ОтправитьЗеркальнуюОперацию(БазаОле, Данные, ИННПоиска = "", Затирать = Ложь, ИсходныеДанные = Неопределено)

	РекурсивныйВызов = НЕ ПустаяСтрока(ИННПоиска);
	Если ПустаяСтрока(ИННПоиска) Тогда
		Если Данные.СчДт = "50.33" ИЛИ Данные.СчКт = "50.33" Тогда
			ИННПоиска = "7807227468";
		ИначеЕсли Данные.СчДт = "50.11" ИЛИ Данные.СчКт = "50.11" Тогда
			ИННПоиска = "7807183186";
		ИначеЕсли Данные.СчДт = "50.22" ИЛИ Данные.СчКт = "50.22" Тогда
			ИННПоиска = "7807191719";
		ИначеЕсли Данные.СчДт = "50.3.1" ИЛИ Данные.СчКт = "50.3.1" Тогда
			ИННПоиска = "7807236582";
		Иначе
			ИННПоиска = Данные.ИНН;
		КонецЕсли;	
	КонецЕсли;	
	ПроводкаНайдена = Ложь;
	
	Если ЗатратыСерверПереопределяемый.Счет50(ИННПоиска, КонецМесяца(Данные.Период)) = "50.1" Тогда
		Возврат Новый Структура("Успешно,СтрокаОшибки,Док", Истина,"", "");
	КонецЕсли;

	ДокОперация = БазаОле.CreateObject("Операция");
	Если ДокОперация.ВыбратьПоЗначению(Данные.Период, КонецМесяца(Данные.Период), "ИНН", ИННПоиска) Тогда

		ДокОперация.ВыбратьПроводки();
		ПроводкаНайдена = Ложь;
		Пока ДокОперация.ПолучитьПроводку() Цикл
			#Если Клиент Тогда
			ОбработкаПрерыванияПользователя();
			#КонецЕсли

			ТекСтрока = СтруктураСтрокиОперации(ДокОперация);
			СуммаПоМодулю = Истина;
			Если ТекСтрока.СчДт = Данные.СчДт И ТекСтрока.СчКт = Данные.СчКт 
				И ((ТекСтрока.СубконтоДт1 = Данные.Субконто1 И Данные.СуммаОперации > 0)
				ИЛИ (ТекСтрока.СубконтоКт1 = Данные.Субконто1 И Данные.СуммаОперации < 0)) Тогда
				ПроводкаНайдена = Истина;
				Если (ТекСтрока.Сумма <> 0) и (Данные.СуммаОперации <>  ТекСтрока.Сумма)  Тогда
					Сообщить(
						"Операция " + СокрЛП(ДокОперация.Document.НомерДок) + " от " + СокрЛП(ДокОперация.OperDate) + " по строке " + ДокОперация.DocLineNum() +
						", Сумма= " + ТекСтрока.Сумма + " отличается от загружаемой суммы= " + Данные.СуммаОперации + 
						", Содержание: " + ТекСтрока.СодержаниеПроводки + ", Счет Дт: " + ТекСтрока.СчДт +  ", Счет Кт: " + ТекСтрока.СчКт	
						, СтатусСообщения.Внимание
					);

				КонецЕсли;
				ДокОперация.SetAttrib("Сумма", 
					?((Данные.СуммаОперации < 0) И (СуммаПоМодулю), ?(Затирать, -1* Данные.СуммаОперации, -1* Данные.СуммаОперации + ?(ЗначениеЗаполнено(ТекСтрока.Сумма), ТекСтрока.Сумма, 0)),
																 	?(Затирать, 	Данные.СуммаОперации, 	  Данные.СуммаОперации + ?(ЗначениеЗаполнено(ТекСтрока.Сумма), ТекСтрока.Сумма, 0))
					)
				);
				
				Попытка
					ДокОперация.Write();
					Сообщить("Записана сумма в Операцию " + ДокОперация.Document.НомерДок + " от " + ДокОперация.OperDate + ", номер строки " + ДокОперация.EntryNumber());

					Возврат Новый Структура("Успешно,СтрокаОшибки,Док", Истина,"", "Записана сумма в Операцию " + ДокОперация.Document.НомерДок + " от " + ДокОперация.OperDate + ", номер строки " + ДокОперация.EntryNumber()); 
				Исключение
					Сообщить(ОписаниеОшибки());

					Возврат Новый Структура("Успешно,СтрокаОшибки,Док", Ложь,ОписаниеОшибки(),"");
				КонецПопытки;
				Прервать;
			КонецЕсли;	
			
		КонецЦикла;	
		
		Если НЕ ПроводкаНайдена Тогда
			
			Если РекурсивныйВызов Тогда
				ТекстСообщения = "Не найдена строка в документе " + Данные.ИНН + ", " + Данные.Период + ", " + Данные.Организация + 
					Данные.Документ + ", Счет: " + Данные.СчДт + ", Кор. счет: " + Данные.СчКт + ", "+ 
					СокрЛП(Данные.ВидОперации) + ", " + Данные.Группа;
				Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное
				);

				Возврат Новый Структура("Успешно,СтрокаОшибки,Док", Ложь, ТекстСообщения,"");
			Иначе
				//Возврат ОтправитьЗеркальнуюОперацию(БазаОле, Данные, "5050505050", Затирать);	
				ТекстСообщения = "Не найдена операция для организации " + Данные.Организация + ", ИНН: " + Данные.ИНН + ", группа: " + ?(Данные.Группа = "Перс", "Перс", ?(Данные.Группа = "П20", "П20", Данные.ИНН));
				Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное);

				Возврат Новый Структура("Успешно,СтрокаОшибки,Док", Ложь, ТекстСообщения,"");
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если РекурсивныйВызов И ИННПоиска = "5050505050" Тогда
			ТекстСообщения = "Не найдена операция для организации " + Данные.Организация + ", ИНН: " + Данные.ИНН + ", группа: " + ?(Данные.Группа = "Перс", "Перс", ?(Данные.Группа = "П20", "П20", Данные.ИНН));
			Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное);

			Возврат Новый Структура("Успешно,СтрокаОшибки,Док", Ложь, ТекстСообщения,"");
		Иначе
			//Возврат ОтправитьЗеркальнуюОперацию(БазаОле, Данные, "5050505050", Затирать);	
			ТекстСообщения = "Не найдена операция для организации " + Данные.Организация + ", ИНН: " + Данные.ИНН + ", группа: " + ?(Данные.Группа = "Перс", "Перс", ?(Данные.Группа = "П20", "П20", Данные.ИНН));
			Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное);

			Возврат Новый Структура("Успешно,СтрокаОшибки,Док", Ложь, ТекстСообщения,"");
		КонецЕсли;	
	КонецЕсли;	

КонецФункции	

Процедура ОтправитьОперацию(БазаОле, Данные, ИННПоиска = "", Затирать = Ложь)

	// основную кассу не выгружаем, ее мы загрузим из управленца
	Если ЗатратыСерверПереопределяемый.Счет50(Данные.Организация) = ЗатратыСерверПовтИсп.СчетКассаПоУмолчанию() Тогда
		Возврат;
	КонецЕсли;
	
	РекурсивныйВызов = НЕ ПустаяСтрока(ИННПоиска);
	Если ПустаяСтрока(ИННПоиска) Тогда
		ИННПоиска = Данные.ИНН;
	КонецЕсли;	
	ПроводкаНайдена = Ложь;
	ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_ВПроцессе());
	
	ДокОперация = БазаОле.CreateObject("Операция");
	Если ДокОперация.ВыбратьПоЗначению(Данные.Период, КонецМесяца(Данные.Период), "ИНН", ИННПоиска) Тогда
		
		ДокОперация.ВыбратьПроводки();
		ПроводкаНайдена = Ложь;
		Пока ДокОперация.ПолучитьПроводку() Цикл
			#Если Клиент Тогда
			ОбработкаПрерыванияПользователя();
			#КонецЕсли
			
			ТекСтрока = СтруктураСтрокиОперации(ДокОперация);
			СуммаПоМодулю = Ложь;
			ДопПараметр = Неопределено;
			Если ЗатратыСервер.ОперацияПроверитьСтроку(Данные, ТекСтрока, СуммаПоМодулю, ДопПараметр) Тогда
				ПроводкаНайдена = Истина;
				
				Если НЕ ДопПараметр = Неопределено Тогда
					ЗатратыСервер.УстановитьСтатус(Данные, 
						?(ДопПараметр.Возврат, ЗатратыКлиентСервер.СтатусОтправки_Успешно(), ЗатратыКлиентСервер.СтатусОтправки_Ошибка()),
						?(ДопПараметр.Возврат, "", ДопПараметр.Описание),
						?(ДопПараметр.Возврат, ДопПараметр.Описание, "")
					);
					Прервать;
				КонецЕсли;	
				
				Если (ТекСтрока.Сумма <> 0) и (Данные.СуммаОперации <>  ТекСтрока.Сумма)  Тогда
					Сообщить(
						"Выписка " + СокрЛП(ДокОперация.Document.НомерДок) + " от " + СокрЛП(ДокОперация.OperDate) + " по строке " + ДокОперация.EntryNumber() +
						", Сумма= " + ТекСтрока.Сумма + " отличается от загружаемой суммы= " + Данные.СуммаОперации + 
						", Содержание: " + ТекСтрока.СодержаниеПроводки + ", Счет Дт: " + ТекСтрока.СчДт +  ", Счет Кт: " + ТекСтрока.СчКт	
						, СтатусСообщения.Внимание
					);
					
				КонецЕсли;
				ДокОперация.SetAttrib("Сумма", 
					?((Данные.СуммаОперации < 0) И (СуммаПоМодулю), ?(Затирать, -1* Данные.СуммаОперации, -1* 	Данные.СуммаОперации + 	?(ЗначениеЗаполнено(ТекСтрока.Сумма), ТекСтрока.Сумма, 0)),  	 
																 	?(Затирать, 	Данные.СуммаОперации, 		Данные.СуммаОперации + 	?(ЗначениеЗаполнено(ТекСтрока.Сумма), ТекСтрока.Сумма, 0))
					)
				);
				
				Попытка
					ДокОперация.Write();
					Сообщить("Записана сумма в Операцию " + ДокОперация.Document.НомерДок + " от " + ДокОперация.OperDate + ", номер строки " + ДокОперация.EntryNumber());
					ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Успешно(),, "Записана сумма в Операцию " + ДокОперация.Document.НомерДок + " от " + ДокОперация.OperDate + ", номер строки " + ДокОперация.EntryNumber());
				Исключение
					Сообщить(ОписаниеОшибки());
					ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ОписаниеОшибки());	
				КонецПопытки;
				Прервать;
			КонецЕсли;	
			
		КонецЦикла;	
		
		Если НЕ ПроводкаНайдена Тогда
			
			Если РекурсивныйВызов Тогда
				ТекстСообщения = "Не найдена строка в документе " + Данные.ИНН + ", " + Данные.Период + ", " + Данные.Организация + 
					Данные.Документ + ", Счет: " + Данные.Счет + ", Кор. счет: " + Данные.КорСчет + ", "+ 
					СокрЛП(Данные.ВидОперации) + ", " + Данные.Группа;
				Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное
				);
				ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);
			Иначе
				//ОтправитьОперацию(БазаОле, Данные, "5050505050", Затирать);	
				ТекстСообщения = "Не найдена операция для организации " + Данные.Организация + ", ИНН: " + Данные.ИНН + ", группа: " + ?(Данные.Группа = "Перс", "Перс", ?(Данные.Группа = "П20", "П20", Данные.ИНН));
				Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное);

				ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если РекурсивныйВызов Тогда
			ТекстСообщения = "Не найдена операция для организации " + Данные.Организация + ", ИНН: " + Данные.ИНН + ", группа: " + ?(Данные.Группа = "Перс", "Перс", ?(Данные.Группа = "П20", "П20", Данные.ИНН));
			Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное);
			ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);
		Иначе
			//ОтправитьОперацию(БазаОле, Данные, "5050505050", Затирать);	
			ТекстСообщения = "Не найдена операция для организации " + Данные.Организация + ", ИНН: " + Данные.ИНН + ", группа: " + ?(Данные.Группа = "Перс", "Перс", ?(Данные.Группа = "П20", "П20", Данные.ИНН));
			Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное);

			ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ОтправитьПоступлениеМатериалов(БазаОле, Данные)

	ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_ВПроцессе());

	Док = БазаОле.CreateObject("Документ.ПоступлениеМатериалов");

	Если Док.ВыбратьДокументы(Данные.Период, КонецМесяца(Данные.Период)) Тогда
		СтрокаНайдена = Ложь;
		Пока Док.ПолучитьДокумент() Цикл
			ДокИНН = Док.GetAttrib("ИНН");
			Если НЕ НРег(СокрЛП(ДокИНН)) = НРег(СокрЛП(Данные.ИНН)) Тогда
				Продолжить;
			КонецЕсли;
			СтрокаНайдена = Ложь;

			Если Док.GetLineByNum(1) Тогда
				СтрокаНайдена = Истина;
				Док.SetAttrib("Количество", Данные.СуммаОперации);
				Док.SetAttrib("Цена",1); 
				Док.SetAttrib("Сумма", Данные.СуммаОперации); 
				Док.SetAttrib("Всего", Данные.СуммаОперации);

				ЗаписатьДок(Док, Данные, Неопределено);

				ЗаполнитьПеремещениеМатериалов(БазаОле, Данные);

			Иначе
				ТекстСообщения = "Не найдена строка в документе " + Данные.ИНН + ", " + Данные.Период + ", " + Данные.Организация + 
					Данные.Документ + ", Счет: " + Данные.Счет + ", Кор. счет: " + Данные.КорСчет + ", "+ 
					СокрЛП(Данные.ВидОперации) + ", " + Данные.Группа;
				Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное
				);
				ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);
			КонецЕсли;
		КонецЦикла;
		
		Если НЕ СтрокаНайдена Тогда
			ТекстСообщения = "Не найдена строка в документе " + Данные.ИНН + ", " + Данные.Период + ", " + Данные.Организация + 
				Данные.Документ + ", Счет: " + Данные.Счет + ", Кор. счет: " + Данные.КорСчет + ", "+ 
				СокрЛП(Данные.ВидОперации) + ", " + Данные.Группа;
			Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное
			);
			ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьПеремещениеМатериалов(БазаОле, Данные)

	// статус не ставим так как при загрузке поступления статус уже установился
	//ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_ВПроцессе());

	Док = БазаОле.CreateObject("Документ.ТребованиеНакладная");

	Если Док.ВыбратьДокументы(Данные.Период, КонецМесяца(Данные.Период)) Тогда

		Если Док.ПолучитьДокумент() Тогда
			СтрокаНайдена = Истина;

			Док.DeleteLines();

			Ит = БазаОле.CreateObject("БухгалтерскиеИтоги");
			Ит.UseChartOfAccounts(БазаОле.EvalExpr("ОсновнойПланСчетов()"));
			Ит.UseSubconto(БазаОле.EvalExpr("ВидыСубконто.Материалы"), Неопределено, 1);
			Ит.DoQuery(НачалоМесяца(Данные.Период), КонецМесяца(Данные.Период), "10.1", Неопределено, Неопределено, 1, Неопределено, "СК");
			Ит.SelectSubconto(БазаОле.EvalExpr("ВидыСубконто.Материалы"));
			Пока Ит.ПолучитьСубконто(БазаОле.EvalExpr("ВидыСубконто.Материалы")) = 1 Цикл
				Если Не ЗначениеЗаполнено(Ит.TD(3)) Тогда
					Продолжить;
				КонецЕсли;
				Док.NewLine();
				Док.Материал = Ит.Subconto(БазаОле.EvalExpr("ВидыСубконто.Материалы"));
				Док.КоличествоЗатребовано = Ит.TD(3);
				Док.КоличествоОтпущено = Ит.TD(3);
				Док.Сумма = Ит.TD(3);
			КонецЦикла;

			ЗаписатьДок(Док, Данные, Неопределено);

		Иначе
			ТекстСообщения = "Не найдена строка в документе " + Данные.ИНН + ", " + Данные.Период + ", " + Данные.Организация + 
				Данные.Документ + ", Счет: " + Данные.Счет + ", Кор. счет: " + Данные.КорСчет + ", "+ 
				СокрЛП(Данные.ВидОперации) + ", " + Данные.Группа;
			Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное
			);
			ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);				
		КонецЕсли;
		
		Если НЕ СтрокаНайдена Тогда
			ТекстСообщения = "Не найден документ Перемещение материалов " + Данные.Период + ", " + Данные.Организация + 
				Данные.Документ + ", Счет: " + Данные.Счет + ", Кор. счет: " + Данные.КорСчет + ", "+ 
				СокрЛП(Данные.ВидОперации) + ", " + Данные.Группа;
			Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное
			);
			ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьУслугиСтороннихОрганизацийНаКлиенте(БазаОле, Период)

	// статус не ставим так как при загрузке поступления статус уже установился
	//ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_ВПроцессе());
	Данные = Неопределено;

	Док = БазаОле.CreateObject("Документ.УслугиСтороннихОрганизаций");

	Если Док.ВыбратьДокументы(Период, КонецМесяца(Период)) Тогда

		Пока Док.ПолучитьДокумент() Цикл
			Если ЗначениеЗаполнено(Док.GetAttrib("ИНН")) Тогда
				Продолжить;
			КонецЕсли;
			СтрокаНайдена = Ложь;

			ОлеСбк1 = Док.GetAttrib("Контрагент");
			ОлеСбк2 = Док.GetAttrib("Договор");

			// ОСВ
			Ит = БазаОле.CreateObject("БухгалтерскиеИтоги");
			Ит.UseChartOfAccounts(БазаОле.EvalExpr("ОсновнойПланСчетов()"));
			Ит.UseSubconto(БазаОле.EvalExpr("ВидыСубконто.Контрагенты"), ОлеСбк1, 2);
			Ит.UseSubconto(БазаОле.EvalExpr("ВидыСубконто.Договоры"), ОлеСбк2, 2);
			Ит.DoQuery(НачалоМесяца(Период), КонецМесяца(Период), "60.1", Неопределено, Неопределено, 1, Неопределено, "С");
			Ит.SelectAccounts();
			СуммаОборотДт = 0;
			Пока Ит.GetAccount() Цикл
				СуммаОборотДт = СуммаОборотДт + Ит.TD();
			КонецЦикла;
			//

			Если Док.GetLineByNum(1) Тогда
				СтрокаНайдена = Истина;
				Док.SetAttrib("Сумма", СуммаОборотДт);
				Док.SetAttrib("Всего", СуммаОборотДт);

				ЗаписатьДок(Док, Данные, Неопределено);
			Иначе
				ТекстСообщения = "Не получить первую строку в документе услуги сторонних организаций " + Док.НомерДок + " от " + Док.ДатаДок;
				Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное);
				ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);
			КонецЕсли;
		КонецЦикла;
		Если НЕ СтрокаНайдена Тогда
			ТекстСообщения = "Не найден документ Перемещение материалов " + Данные.Период + ", " + Данные.Организация + 
				Данные.Документ + ", Счет: " + Данные.Счет + ", Кор. счет: " + Данные.КорСчет + ", "+ 
				СокрЛП(Данные.ВидОперации) + ", " + Данные.Группа;
			Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное
			);
			ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Процедура ОтправитьПоступлениеТоваров(БазаОле, Данные)
	
	ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_ВПроцессе());
	
	Док = БазаОле.CreateObject("Документ");
	ДокПоступлениеТоваров = БазаОле.CreateObject("Документ.ПоступлениеТоваров");
	Док.UseJournal("Товары");
	
	Если Док.ВыбратьПоЗначению(Данные.Период, КонецМесяца(Данные.Период), "ИНН", 
		?(Данные.Группа = "Перс", "Перс", ?(Данные.Группа = "П20", "П20", Данные.ИНН))) Тогда
		
		Пока Док.ПолучитьДокумент() Цикл
			Если ДокПоступлениеТоваров.FindDocument(Док.CurrentDocument()) Тогда
				
				СтрокаНайдена = Ложь;
				//ДокПоступлениеМатериалов.ВыбратьСтроки();
				Если ДокПоступлениеТоваров.GetLineByNum(1) Тогда
					СтрокаНайдена = Истина;
					ДокПоступлениеТоваров.SetAttrib("Количество", Данные.СуммаОперации);
					ДокПоступлениеТоваров.SetAttrib("Цена",1); 
					ДокПоступлениеТоваров.SetAttrib("Сумма", Данные.СуммаОперации); 
					ДокПоступлениеТоваров.SetAttrib("Всего", Данные.СуммаОперации);
					
					ЗаписатьДок(ДокПоступлениеТоваров, Данные, Неопределено);
				КонецЕсли;
			Иначе
				ТекстСообщения = "Не найдена строка в документе " + Данные.ИНН + ", " + Данные.Период + ", " + Данные.Организация + 
					Данные.Документ + ", Счет: " + Данные.Счет + ", Кор. счет: " + Данные.КорСчет + ", "+ 
					СокрЛП(Данные.ВидОперации) + ", " + Данные.Группа;
				Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное
				);
				ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);				
			КонецЕсли;		
		КонецЦикла;
		
		Если НЕ СтрокаНайдена Тогда
			ТекстСообщения = "Не найдена строка в документе " + Данные.ИНН + ", " + Данные.Период + ", " + Данные.Организация + 
				Данные.Документ + ", Счет: " + Данные.Счет + ", Кор. счет: " + Данные.КорСчет + ", "+ 
				СокрЛП(Данные.ВидОперации) + ", " + Данные.Группа;
			Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное
			);
			ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);
		КонецЕсли;		
		
	КонецЕсли;	
	
КонецПроцедуры		

Процедура ОтправитьУслугиСтороннихОрганизаций(БазаОле, Данные)

	ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_ВПроцессе());

	Док = БазаОле.CreateObject("Документ");
	ДокПоступлениеМатериалов = БазаОле.CreateObject("Документ.УслугиСтороннихОрганизаций");
	Док.UseJournal("УслугиСтороннихОрганизаций");

	Если Док.ВыбратьПоЗначению(Данные.Период, КонецМесяца(Данные.Период), "ИНН", 
		?(Данные.Группа = "Перс", "Перс", ?(Данные.Группа = "П20", "П20", Данные.ИНН))) Тогда

		Пока Док.ПолучитьДокумент() Цикл
			Если ДокПоступлениеМатериалов.FindDocument(Док.ТекущийДокумент()) Тогда

				СтрокаНайдена = Ложь;

				Если ДокПоступлениеМатериалов.GetLineByNum(1) Тогда
					СтрокаНайдена = Истина;
					ДокПоступлениеМатериалов.SetAttrib("Сумма", Данные.СуммаОперации);
					ДокПоступлениеМатериалов.SetAttrib("Всего", Данные.СуммаОперации);

					ЗаписатьДок(ДокПоступлениеМатериалов, Данные, Неопределено);
				КонецЕсли;
			Иначе
				ТекстСообщения = "Не найдена строка в документе " + Данные.ИНН + ", " + Данные.Период + ", " + Данные.Организация + 
					Данные.Документ + ", Счет: " + Данные.Счет + ", Кор. счет: " + Данные.КорСчет + ", "+ 
					СокрЛП(Данные.ВидОперации) + ", " + Данные.Группа;
				Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное
				);
				ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);
			КонецЕсли;
		КонецЦикла;

		Если НЕ СтрокаНайдена Тогда
			ТекстСообщения = "Не найдена строка в документе " + Данные.ИНН + ", " + Данные.Период + ", " + Данные.Организация + 
				Данные.Документ + ", Счет: " + Данные.Счет + ", Кор. счет: " + Данные.КорСчет + ", "+ 
				СокрЛП(Данные.ВидОперации) + ", " + Данные.Группа;
			Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное
			);
			ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ТекстСообщения);
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Процедура ЗаписатьДок(Док, Данные, ДопПараметры)
	
	Попытка
		Док.Записать();
		Док.Провести();
		Сообщить("Записан документ "+ Док.НомерДок + ", от "+ Док.ДатаДок + ", номер строки: " + Док.НомерСтроки);
		ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Успешно(),, 
			"Записан документ "+ Док.НомерДок + ", от "+ Док.ДатаДок + ", номер строки: " + Док.НомерСтроки,
			ДопПараметры
		);
	Исключение
		Сообщить(ОписаниеОшибки());
		ЗатратыСервер.УстановитьСтатус(Данные, ЗатратыКлиентСервер.СтатусОтправки_Ошибка(), ОписаниеОшибки());
	КонецПопытки;	
	
КонецПроцедуры	// ЗаписатьДок

Функция СтруктураСтрокиВыписки(ДокСтрока)

	ст = Новый Структура;
	ст.Вставить("НомерСтроки", ДокСтрока.НомерСтроки);
	ст.Вставить("КоличествоСтрок", ДокСтрока.КоличествоСтрок());
	Попытка
		ст.Вставить("ВидДвижения", СокрЛП(ДокСтрока.ВидДвижения.Наименование));
	Исключение
		ст.Вставить("ВидДвижения","");
	КонецПопытки;
	Попытка
		ст.Вставить("КоррСчет", ДокСтрока.КоррСчет.Код);
	Исключение
		ст.Вставить("КоррСчет","");
	КонецПопытки;		
	Попытка
		ст.Вставить("Субконто1", СокрЛП(ДокСтрока.Субконто1.Наименование));
	Исключение
		ст.Вставить("Субконто1","");
	КонецПопытки;
	Попытка
		ст.Вставить("Субконто2", СокрЛП(ДокСтрока.Субконто2.Наименование));
	Исключение
		ст.Вставить("Субконто2","");
	КонецПопытки;
	ст.Вставить("НазначениеПлатежа", СокрЛП(ДокСтрока.НазначениеПлатежа));
	ст.Вставить("СуммаПриход", СокрЛП(ДокСтрока.Приход));
	ст.Вставить("СуммаРасход", СокрЛП(ДокСтрока.Расход));

	Возврат ст;

КонецФункции

Функция СтруктураСтрокиОперации(ДокСтрока)

	ст = Новый Структура;
	Попытка
		ст.Вставить("СодержаниеПроводки", СокрЛП(ДокСтрока.СодержаниеПроводки));
	Исключение
		ст.Вставить("СодержаниеПроводки","");
	КонецПопытки;
	Попытка
		ст.Вставить("СчДт", ДокСтрока.Дебет.Счет.Код);
	Исключение
		ст.Вставить("СчДт","");
	КонецПопытки;
	Попытка
		ст.Вставить("СубконтоДт1", СокрЛП(ДокСтрока.Дебет.Субконто(1).Наименование));
	Исключение
		ст.Вставить("СубконтоДт1","");
	КонецПопытки;
	Попытка
		ст.Вставить("СубконтоДт2", СокрЛП(ДокСтрока.Дебет.Субконто(2).Наименование));
	Исключение
		ст.Вставить("СубконтоДт2","");
	КонецПопытки;
	Попытка
		ст.Вставить("СчКт", ДокСтрока.Кредит.Счет.Код);
	Исключение
		ст.Вставить("СчКт","");
	КонецПопытки;		
	Попытка
		ст.Вставить("СубконтоКт1", СокрЛП(ДокСтрока.Кредит.Субконто(1).Наименование));
	Исключение
		ст.Вставить("СубконтоКт1","");
	КонецПопытки;
	Попытка
		ст.Вставить("СубконтоКт2", СокрЛП(ДокСтрока.Кредит.Субконто(2).Наименование));
	Исключение
		ст.Вставить("СубконтоКт2","");
	КонецПопытки;
	Попытка
		ст.Вставить("Сумма", ДокСтрока.Сумма);
	Исключение
		ст.Вставить("Сумма", 0);
	КонецПопытки;

	Возврат ст;

КонецФункции

#КонецОбласти