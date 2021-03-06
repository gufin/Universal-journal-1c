
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Получим таблицу используемых типов объектов (настройки пользователя)
	
	НастройкиИспользуемыхТипов = ХранилищеОбщихНастроек.Загрузить("НастройкиИспользуемыхТипов",,Строка(ПараметрыСеанса.ТекущийПользователь));
	
	Если НастройкиИспользуемыхТипов = Неопределено Тогда
		//Если настроек нет сформируем список по метаданным
		Для Каждого ОбъектМетаданных Из Метаданные.Документы Цикл
			НС 				= ТаблицаТипов.Добавить();
			НС.ИмяТипа 		= ОбъектМетаданных.Имя;
			НС.СинонимТипа 	= ОбъектМетаданных.Синоним;
		КонецЦикла;
	Иначе
		Для Каждого ОбъектМетаданных Из Метаданные.Документы Цикл
			НС 				= ТаблицаТипов.Добавить();
			НС.ИмяТипа 		= ОбъектМетаданных.Имя;
			НС.СинонимТипа 	= ОбъектМетаданных.Синоним;
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("ИмяТипа",ОбъектМетаданных.Имя);
			СтруктураПоиска.Вставить("СинонимТипа",ОбъектМетаданных.Синоним);
			НайденныеСтроки = НастройкиИспользуемыхТипов.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() > 0 Тогда
				НС.Использование = НайденныеСтроки[0].Использование;	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьНаСервере();
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура СохранитьНаСервере()

	//ТЗНастроек = РеквизитФормыВЗначение("ТаблицаТипов");
	
	ТЗНастроекДляСохранения = Новый ТаблицаЗначений;
	ТЗНастроекДляСохранения.Колонки.Добавить("ИмяТипа");
	ТЗНастроекДляСохранения.Колонки.Добавить("СинонимТипа");
	ТЗНастроекДляСохранения.Колонки.Добавить("Использование");

	Для Каждого Стр Из ТаблицаТипов Цикл
		Если Стр.Использование Тогда
			НС = ТЗНастроекДляСохранения.Добавить();
			ЗаполнитьЗначенияСвойств(НС,Стр);
		КонецЕсли;
	КонецЦикла;
	
	ХранилищеОбщихНастроек.Сохранить("НастройкиИспользуемыхТипов",,ТЗНастроекДляСохранения);

КонецПроцедуры // СохранитьНаСервере()

&НаКлиенте
Процедура НастроитьОтображениеТабличныхЧастей(Команда)
	
	ТекСтрока = Элементы.ТаблицаТипов.ТекущиеДанные;
	
	Если ТекСтрока <> Неопределено Тогда
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ОбъектИсточникСписка",ТекСтрока.ИмяТипа);
		ПараметрыФормы.Вставить("Документ",ТекСтрока.СинонимТипа);
		ОткрытьФорму(ПолучитьПолноеИмяФормы("ФормаНастроек"), ПараметрыФормы, ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		Сообщить("Необходимо выделить документ");
	КонецЕсли;
	

КонецПроцедуры

&НаКлиенте
Функция ПолучитьПолноеИмяФормы(ИмяФормы)

    //Возврат Лев(ЭтотОбъект.ИмяФормы, СтрНайти(ЭтотОбъект.ИмяФормы, ".", НаправлениеПоиска.СКонца)) + ИмяФормы;
	
	МассивСтрок = РазложитьСтрокуВМассивПодстрок(ЭтаФорма.ИмяФормы,".");
	КоличествоЭлементов = МассивСтрок.Количество()-1;
	
	РезультирующаяСтрока = "";
	Итерация = 0;
	Для Каждого Элм Из МассивСтрок Цикл
		Если Итерация < КоличествоЭлементов Тогда
			Если Итерация = 0 Тогда
				РезультирующаяСтрока = Элм;
			Иначе
				РезультирующаяСтрока=РезультирующаяСтрока+"."+ Элм;	
			КонецЕсли;
		КонецЕсли;
		Итерация=Итерация+1;
	КонецЦикла;
	
	РезультирующаяСтрока = РезультирующаяСтрока +"."+ ИмяФормы;
	
	Возврат РезультирующаяСтрока;

КонецФункции

// Разбивает строку на несколько строк по разделителю. Разделитель может иметь любую длину.
//
// Параметры:
//  Строка                 - Строка - текст с разделителями;
//  Разделитель            - Строка - разделитель строк текста, минимум 1 символ;
//  ПропускатьПустыеСтроки - Булево - признак необходимости включения в результат пустых строк.
//    Если параметр не задан, то функция работает в режиме совместимости со своей предыдущей версией:
//     - для разделителя-пробела пустые строки не включаются в результат, для остальных разделителей пустые строки
//       включаются в результат.
//     - если параметр Строка не содержит значащих символов или не содержит ни одного символа (пустая строка), то в
//       случае разделителя-пробела результатом функции будет массив, содержащий одно значение "" (пустая строка), а
//       при других разделителях результатом функции будет пустой массив.
//  СокращатьНепечатаемыеСимволы - Булево - сокращать непечатаемые символы по краям каждой из найденных подстрок.
//
// Возвращаемое значение:
//  Массив - массив строк.
//
// Примеры:
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",") - возвратит массив из 5 элементов, три из которых  - пустые
//  строки;
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",", Истина) - возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок(" один   два  ", " ") - возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок("") - возвратит пустой массив;
//  РазложитьСтрокуВМассивПодстрок("",,Ложь) - возвратит массив с одним элементом "" (пустой строкой);
//  РазложитьСтрокуВМассивПодстрок("", " ") - возвратит массив с одним элементом "" (пустой строкой);
//
// Примечание:
//  В случаях, когда разделителем является строка из одного символа, и не используется параметр СокращатьНепечатаемыеСимволы,
//  рекомендуется использовать функцию платформы СтрРазделить.
&НаСервере
Функция РазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено, СокращатьНепечатаемыеСимволы = Ложь) Экспорт
	
	Результат = Новый Массив;
	
	// Для обеспечения обратной совместимости.
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//
	
	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Если СокращатьНепечатаемыеСимволы Тогда
				Результат.Добавить(СокрЛП(Подстрока));
			Иначе
				Результат.Добавить(Подстрока);
			КонецЕсли;
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Если СокращатьНепечатаемыеСимволы Тогда
			Результат.Добавить(СокрЛП(Строка));
		Иначе
			Результат.Добавить(Строка);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 



