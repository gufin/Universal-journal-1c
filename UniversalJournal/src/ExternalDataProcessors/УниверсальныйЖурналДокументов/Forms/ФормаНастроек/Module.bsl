//Доделать вывод синонимов а не имен метаданных
&НаКлиенте
Процедура ОбъектНастрокиПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ОбъектНастроки) Тогда
		ЗаполнитьТабличныеЧасти();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабличныеЧасти()
	
	ТабличныеЧасти.Очистить();
	КолонкиТЧ.Очистить();
	
	НастройкиТЧ = ХранилищеОбщихНастроек.Загрузить("НастройкаОтображенияТабличныхЧастей",,Строка(ПараметрыСеанса.ТекущийПользователь));
	
	Если НастройкиТЧ <> Неопределено Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("ОбъектНастройки",ОбъектНастроки);
		НастройкиТЧ.НайтиСтроки(СтруктураПоиска);
		НайденныеСтроки = НастройкиТЧ.НайтиСтроки(СтруктураПоиска);
		Если НайденныеСтроки.Количество() > 0 Тогда
			Для Каждого СтрокаНастройки Из НайденныеСтроки Цикл
				НС = КолонкиТЧ.Добавить();
				ЗаполнитьЗначенияСвойств(НС,СтрокаНастройки);
			КонецЦикла;	
			//Добавить проверку на новые реквизиты
			НастройкиТЧ.Свернуть("ТабличнаяЧасть, ТЧИспользовать, ОбъектНастройки");
			Для Каждого СтрокаНастройки Из НастройкиТЧ Цикл
				Если  ОбъектНастроки = СтрокаНастройки.ОбъектНастройки Тогда
					НС					= ТабличныеЧасти.Добавить();
					НС.ТабличнаяЧасть	= СтрокаНастройки.ТабличнаяЧасть;
					НС.Использовать		= СтрокаНастройки.ТЧИспользовать;
				КонецЕсли;
			КонецЦикла;
			//Добавить проверку на новые табличные части
		Иначе
			ЗаполнитьТаблицы();	
		КонецЕсли;				
	Иначе
		ЗаполнитьТаблицы();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицы()
	
	//Для Каждого ТабличнаяЧасть Из ОбъектНастроки.Метаданные().ТабличныеЧасти Цикл
	Для Каждого ТабличнаяЧасть Из Метаданные.Документы.Найти(ОбъектНастроки).ТабличныеЧасти Цикл
		НС					= ТабличныеЧасти.Добавить();
		НС.ТабличнаяЧасть	= ТабличнаяЧасть.Имя;
		НС.Использовать		= Ложь;
		Для Каждого РеквизитТЧ Из ТабличнаяЧасть.Реквизиты Цикл
			НС					= КолонкиТЧ.Добавить();
			НС.ТабличнаяЧасть	= ТабличнаяЧасть.Имя;
			НС.Колонка			= РеквизитТЧ.Имя;
			НС.Использовать		= Ложь;
			НС.ОбъектНастройки 	= ОбъектНастроки;
			НС.ТЧИспользовать   = Ложь;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ТабличныеЧастиПриАктивизацииСтроки(Элемент)
	
	//КолонкиТЧ.Очистить();
	ТекСтрока = Элементы.ТабличныеЧасти.ТекущиеДанные;
	Если ТекСтрока<>Неопределено Тогда
		ТекТабличнаяЧасть = ТекСтрока.ТабличнаяЧасть;
		Отбор = Новый Структура;
		Отбор.Вставить("ТабличнаяЧасть", ТекТабличнаяЧасть);
		Элементы.КолонкиТЧ.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранитьНастройкиНаСервере();
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиНаСервере()
	
	ТЗНастроек = РеквизитФормыВЗначение("КолонкиТЧ");
	
	ТекущиеНастройки = ХранилищеОбщихНастроек.Загрузить("НастройкаОтображенияТабличныхЧастей");
	Если ТекущиеНастройки <> Неопределено Тогда
		МассивСтрокДляУдаления = Новый Массив;
		Для Каждого СтрокаНастройки Из ТекущиеНастройки Цикл
			Если СтрокаНастройки.ОбъектНастройки = ОбъектНастроки Тогда
				МассивСтрокДляУдаления.Добавить(СтрокаНастройки);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Элм Из МассивСтрокДляУдаления Цикл
			ТекущиеНастройки.Удалить(Элм);	
		КонецЦикла;
		
		Для Каждого СтрокаНовойНастройки Из ТЗНастроек Цикл
			НС = ТекущиеНастройки.Добавить();
			ЗаполнитьЗначенияСвойств(НС,СтрокаНовойНастройки);
		КонецЦикла;
		ХранилищеОбщихНастроек.Сохранить("НастройкаОтображенияТабличныхЧастей",,ТекущиеНастройки);
	Иначе
		ХранилищеОбщихНастроек.Сохранить("НастройкаОтображенияТабличныхЧастей",,ТЗНастроек);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличныеЧастиИспользоватьПриИзменении(Элемент)
	
	ТекСтрока = Элементы.ТабличныеЧасти.ТекущиеДанные;
	Если ТекСтрока<>Неопределено Тогда
		Для Каждого Строка Из КолонкиТЧ Цикл
			Если Строка.ТабличнаяЧасть = ТекСтрока.ТабличнаяЧасть Тогда
				Строка.ТЧИспользовать = ТекСтрока.Использовать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ОбъектИсточникСписка") Тогда
		ОбъектНастроки = Параметры.ОбъектИсточникСписка;
		Документ = Параметры.Документ;
		Если ЗначениеЗаполнено(ОбъектНастроки) Тогда
			ЗаполнитьТабличныеЧасти();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры





