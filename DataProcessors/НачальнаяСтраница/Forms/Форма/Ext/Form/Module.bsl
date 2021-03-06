﻿
Процедура ОбновитьДерево()
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Задача.Ссылка КАК Задача,
	|	Задача.ПроектГруппа КАК Проект,
	|	ВЫБОР
	|		КОГДА Задача.Состояние = ЗНАЧЕНИЕ(Справочник.СостоянияЗадач.Завершена)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Выполнена,
	|	Задача.Ответственный КАК Ответственный,
	|	Задача.СрокЗадачи КАК СрокЗадачи,
	|	Задача.ЗатраченоЧасовПлан КАК ПланВремя,
	|	Задача.ДатаЗавершенияПлан КАК ПланСдачи,
	|	Задача.Состояние КАК Статус,
	|	Задача.Наименование КАК Наим,
	|	Задача.СтоимостьЗадачи КАК Стоимость,
	|	Задача.ПроцентВыполнения КАК ПроцентВыполнения,
	|	Задача.Заказчик КАК Заказчик
	|ИЗ
	|	Справочник.Задача КАК Задача
	|ГДЕ
	|	1 = 1
	|	И 2 = 2
	|	И НЕ Задача.ПометкаУдаления
	|	И ВЫБОР
	|			КОГДА &ВыводитьЗавершенные
	|				ТОГДА 1 = 1
	|			ИНАЧЕ Задача.Состояние <> ЗНАЧЕНИЕ(Справочник.СостоянияЗадач.Завершена)
	|		КОНЕЦ
	|ИТОГИ ПО
	|	Проект";
	
	Запрос.Параметры.Вставить("ВыводитьЗавершенные", ВыводитьЗавершенные);
	Если ЗначениеЗаполнено(Проект) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "1 = 1", "Задача.ПроектГруппа = &ПроектГруппа");
		Запрос.Параметры.Вставить("ПроектГруппа", Проект);
	КонецЕсли; 
	Если ЗначениеЗаполнено(ДатаЗапроса) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "2 = 2", "Задача.СрокЗадачи МЕЖДУ &НачДата И &КонДата");
		Запрос.Параметры.Вставить("НачДата", НачалоДня(ДатаЗапроса.ДатаНачала));
		Запрос.Параметры.Вставить("КонДата", КонецДня(ДатаЗапроса.ДатаОкончания));
	КонецЕсли; 
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаПроект = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ДеревоОбъект = РеквизитФормыВЗначение("Дерево");
	ДеревоОбъект.Строки.Очистить();
	
	Пока ВыборкаПроект.Следующий() Цикл
		СтрокаПроект = ДеревоОбъект.Строки.Добавить();
		СтрокаПроект.Наим = ВыборкаПроект.Проект;
		Выборка = ВыборкаПроект.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтрокаЗадача = СтрокаПроект.Строки.Добавить();
			СтрокаЗадача.Задача = Выборка.Задача;
			СтрокаЗадача.Наим = Выборка.Наим;
			СтрокаЗадача.Выполнено = Выборка.Выполнена;
			СтрокаЗадача.Ответственный = Выборка.Ответственный;
			СтрокаЗадача.СрокЗадачи = Выборка.СрокЗадачи;
			СтрокаЗадача.ПланСдачи = Выборка.ПланСдачи;
			СтрокаЗадача.Стоимость = Выборка.Стоимость;
			СтрокаЗадача.Статус = Выборка.Статус;
			СтрокаЗадача.ПроцентВыполнения = Выборка.ПроцентВыполнения;
			СтрокаЗадача.ПланВремя = Выборка.ПланВремя;
			СтрокаЗадача.Заказчик = Выборка.Заказчик;
		КонецЦикла; 
	КонецЦикла;	 	
	
	ЗначениеВРеквизитФормы(ДеревоОбъект, "Дерево");
	
КонецПроцедуры

&НаКлиенте
Процедура РаскрытьВетвиДерева()
	
	ЭлементыДерева = Дерево.ПолучитьЭлементы();
    Для каждого ЭлементДерева Из ЭлементыДерева Цикл
        Элементы.Дерево.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
		Если ЭлементДерева.СрокЗадачи <> Дата(1,1,1) И ЭлементДерева.СрокЗадачи < ТекущаяДата() Тогда
			Элементы.Дерево.ЦветФона = WebЦвета.Красный;
		КонецЕсли; 
    КонецЦикла;
	
	//ЭлементыДерева = ДеревоСтатусов.ПолучитьЭлементы();
	//Для каждого ЭлементДерева Из ЭлементыДерева Цикл
	//    Элементы.ДеревоСтатусов.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
	//КонецЦикла;
	
КонецПроцедуры
 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура ФлажокПриИзменении(Элемент)
	
	ИДТекущейСтроки = Элементы["Дерево"].ТекущаяСтрока;
	
	Если ИДТекущейСтроки <> Неопределено Тогда
		
		ЭлементКоллекции = ЭтаФорма["Дерево"].НайтиПоИдентификатору(ИДТекущейСтроки);
				
		УстановкаФлажков(ЭлементКоллекции, ЭлементКоллекции.Выполнено);
		
		Родитель = ЭлементКоллекции.ПолучитьРодителя();
		Пока Родитель <> Неопределено Цикл
			Родитель.Выполнено = ?(УстановленноДляВсех(ЭлементКоллекции), Истина, Ложь);
			Родитель.Выполнено = ?(СнятоДляВсех(ЭлементКоллекции), Истина, Ложь);
			ЭлементКоллекции = Родитель;
			Родитель = ЭлементКоллекции.ПолучитьРодителя();
		КонецЦикла;
		
	КонецЕсли;
	
	ОбновитьДерево();
	РаскрытьВетвиДерева();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановкаФлажков(ЭлементКоллекции, ЗначениеПометки)
	
	ЗадачаВыполнена(ЭлементКоллекции.Задача, ЗначениеПометки);
	ПодчинЭлементы = ЭлементКоллекции.ПолучитьЭлементы();
	Для Каждого ТекЭлемент Из ПодчинЭлементы Цикл
		ТекЭлемент.Выполнено = ЗначениеПометки;
		ЗадачаВыполнена(ТекЭлемент.Задача, ЗначениеПометки);
		УстановкаФлажков(ТекЭлемент, ТекЭлемент.Выполнено);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗадачаВыполнена(ЗадачаСсылка, ЗначениеПометки)
	
	ЗадачаОбъект = ЗадачаСсылка.ПолучитьОбъект();
	Если ЗначениеПометки Тогда
		ЗадачаОбъект.Состояние = Справочники.СостоянияЗадач.Завершена;
	Иначе	
		ЗадачаОбъект.Состояние = Справочники.СостоянияЗадач.Выполняется;
	КонецЕсли; 
	ЗадачаОбъект.Записать();
	
КонецПроцедуры
 

&НаКлиенте
Функция УстановленноДляВсех(ЭлементКоллекции)
	
	СоседниеЭлементы = ЭлементКоллекции.ПолучитьРодителя().ПолучитьЭлементы();
	Для Каждого ТекЭлемент Из СоседниеЭлементы Цикл
		Если ТекЭлемент.Выполнено <> ЭлементКоллекции.Выполнено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Функция СнятоДляВсех(ЭлементКоллекции)
	
	СоседниеЭлементы = ЭлементКоллекции.ПолучитьРодителя().ПолучитьЭлементы();
	Для Каждого ТекЭлемент Из СоседниеЭлементы Цикл
		Если НЕ ТекЭлемент.Выполнено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ПроектПриИзмененииНаСервере()
	
	ПараметрыСеанса.ТекущийПроект = Проект;
	ОбновитьДерево();
	
КонецПроцедуры


&НаКлиенте
Процедура ПроектПриИзменении(Элемент)
	ПроектПриИзмененииНаСервере();
	РаскрытьВетвиДерева();
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьСписок(Команда)
	
	ОбновитьДерево();
	РаскрытьВетвиДерева();
	
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьЗадачу(Команда)
	
	ПараметрыФормы = Новый Структура("Проект", Проект);
	ОткрытьФорму("Справочник.Задача.ФормаОбъекта", ПараметрыФормы);
	ОбновитьДерево();
	РаскрытьВетвиДерева();
	
КонецПроцедуры


&НаКлиенте
Процедура ДеревоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекЗадача = Элементы.Дерево.ТекущиеДанные.Задача;
	П = Новый Структура("Ключ", ТекЗадача);
	Форма = ПолучитьФорму("Справочник.Задача.ФормаОбъекта", П);
	Форма.Открыть();
	
КонецПроцедуры


&НаКлиенте
Процедура ДатаЗапросаПриИзменении(Элемент)
	ОбновитьДерево();
	РаскрытьВетвиДерева();
КонецПроцедуры


&НаСервере
Процедура ДобавитьБыструюЗадачуНаСервере()
	
	Если СокрЛП(врЗадачаНаим) <> "" Тогда
		спрЗадача = Справочники.Задача.СоздатьЭлемент();
		спрЗадача.ДатаСоздания = ТекущаяДата();
		спрЗадача.ДатаИзменения = ТекущаяДата();
		спрЗадача.СрокЗадачи = врЗадачаСрок;
		спрЗадача.ПроектГруппа = врЗадачаПроект;
		спрЗадача.Состояние = Справочники.СостоянияЗадач.Создана;
		спрЗадача.Наименование = врЗадачаНаим;
		спрЗадача.ОписаниеЗадачи = Новый ХранилищеЗначения(врЗадачаОпис);
		спрЗадача.ПостановщикЗадачи = ПараметрыСеанса.ТекущийПользователь;
		
		Попытка
			спрЗадача.Записать();
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки; 
		врЗадачаНаим = "";
		врЗадачаОпис = "";
		врЗадачаПроект = Справочники.Проекты.ПустаяСсылка();
		врЗадачаСрок = Дата(1,1,1);
	КонецЕсли; 
	
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьБыструюЗадачу(Команда)
	
	ДобавитьБыструюЗадачуНаСервере();
	ОбновитьДерево();
	РаскрытьВетвиДерева();
	
КонецПроцедуры


&НаСервере
Процедура УдалитьЗадачуНаСервере(Задача)

	Если ТипЗнч(Задача) = Тип("СправочникСсылка.Задача") Тогда
		ЗадачаОбъект = Задача.ПолучитьОбъект();
		ЗадачаОбъект.УстановитьПометкуУдаления(Истина);
	Иначе
		Сообщить("Нельзя удалять проект!");
	КонецЕсли; 
	
КонецПроцедуры


&НаКлиенте
Процедура УдалитьЗадачу(Команда)
	
	//Если Вопрос("Удалить задачу?", РежимДиалогаВопрос.ДаНет, 0) = КодВозвратаДиалога.Да Тогда
		ТекЗадача = Элементы.Дерево.ТекущиеДанные.Задача;
		УдалитьЗадачуНаСервере(ТекЗадача);
		ОбновитьДерево();
		РаскрытьВетвиДерева();
	//КонецЕсли; 
	
КонецПроцедуры


&НаКлиенте
Процедура ПроверитьПочту(Команда)
	
	Форма = ПолучитьФорму("Обработка.ПроверкаПочты.Форма");
	Форма.Открыть();
	ОбновитьДерево();
	РаскрытьВетвиДерева();
	
КонецПроцедуры


&НаКлиенте
Процедура ВыводитьЗавершенныеПриИзменении(Элемент)
	ОбновитьДерево();
	РаскрытьВетвиДерева();
КонецПроцедуры


&НаКлиенте
Процедура ДеревоСтатусовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекЗадача = Элементы.ДеревоСтатусов.ТекущиеДанные.Задача;
	П = Новый Структура("Ключ", ТекЗадача);
	Форма = ПолучитьФорму("Справочник.Задача.ФормаОбъекта", П);
	Форма.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Запуск(Команда)
	Если ЗначениеЗаполнено(ТекЗадачаТаймера) Тогда
		ПодключитьОбработчикОжидания("Время", 1, Ложь);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Стоп(Команда)
	Если ЗначениеЗаполнено(ТекЗадачаТаймера) Тогда
		ОтключитьОбработчикОжидания("Время");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура Время()
	
	КолвоСекунд = КолвоСекунд + 1;
	Если КолвоСекунд > 59 Тогда
		КолвоМинут = КолвоМинут + 1;
		КолвоСекунд = 0;
		//запишем в задачу
		Если ЗначениеЗаполнено(ТекЗадачаТаймера) Тогда
			СохранитьВремяЗадачи(ТекЗадачаТаймера, КолвоЧасов*60 + КолвоМинут);	
		КонецЕсли; 
	КонецЕсли;
	Если КолвоМинут > 59 Тогда
		КолвоЧасов = КолвоЧасов + 1;
		КолвоМинут = 0;
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура СохранитьВремяЗадачи(Задача, КолвоМинутЗадачи)
	
	ЗадачаОбъект = Задача.ПолучитьОбъект();
	Часов = Цел(КолвоМинутЗадачи/60);
	Минут = (КолвоМинутЗадачи - (Часов * 60)) / 60;
	ЗадачаОбъект.ЗатраченоЧасовФакт = Часов + Минут;
	ЗадачаОбъект.Записать();
	
КонецПроцедуры


&НаКлиенте
Процедура ЗадачуВТаймер(Команда)
	ТекЗадачаТаймера = Элементы.Дерево.ТекущиеДанные.Задача;
	ЗаполнитьВремяТаймера(ТекЗадачаТаймера);
КонецПроцедуры


&НаКлиенте
Процедура ТекЗадачаТаймераПриИзменении(Элемент)
	
	ЗаполнитьВремяТаймера(ТекЗадачаТаймера);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВремяТаймера(Задача)
	
	Часов = Цел(ТекЗадачаТаймера.ЗатраченоЧасовФакт);
	Минут = (ТекЗадачаТаймера.ЗатраченоЧасовФакт - Часов) * 60;
	КолвоЧасов = Часов;
	КолвоМинут = Минут;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекЗадачаТаймераОчистка(Элемент, СтандартнаяОбработка)
	КолвоЧасов = 0;
	КолвоМинут = 0;
	КолвоСекунд = 0;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОбновитьГлавноеОкно" Тогда
		ОбновитьДерево();
		РаскрытьВетвиДерева();
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбработкаСообщений", 30);
	
КонецПроцедуры
 
&НаКлиенте
Процедура ОбработкаСообщений()
	
	ОбщийМодульЗадачи.ПолучитьUpdate();
	ОбщийМодульЗадачи.ОбработатьЗапросы();

КонецПроцедуры
