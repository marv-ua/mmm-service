﻿
&НаКлиенте
Процедура ОбновитьДанныеИзБазы7(Команда)
	
	База = мммКлиент.ПодключитьсяКБазеМММКлиент();
	
	Если НЕ База = Неопределено Тогда
		
		КОМБанковскиеСчета = База.CreateObject("Справочник.БанковскиеСчета");
		КОМБанковскиеСчета.ВыбратьЭлементы();
		Пока КОМБанковскиеСчета.ПолучитьЭлемент() = 1 Цикл
			ОбновитьСправочникСчетов(СокрЛП(КОМБанковскиеСчета.Наименование));
		КонецЦикла;	
		
	КонецЕсли;	


КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьСправочникСчетов(стрБС)
	
	Справочники.Счета7.СоздатьСчет7(стрБС);
	
КонецПроцедуры	
