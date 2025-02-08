﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ОБЪЕКТА

////////////////////////////////////////////////////////////////////////////////
// Обработчик события "Проверка заполнения"
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	
	// Если это группа,
	Если ЭтоГруппа Тогда
		// дальнейшие проверки не  имеют смысла
		Возврат;
	КонецЕсли;

	// Сами проверим реквизит ВидЦен
	Если ВидЦен.Пустая() Тогда

		// Сообщим пользователю о том, что информация не консистентна
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Контрагенту необходимо задать вид цен!'", "ru");
		Сообщение.Поле  = "ВидЦен";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();

		// Удалим реквизит из списка автоматически проверяемых
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ВидЦен"));
		// Уведомим платформу, что дальнейшая работа не имеет смысла
		Отказ = Истина;

	КонецЕсли;

	// Если заполнено поле "Улица"
	Если НЕ ПустаяСтрока(Улица) Тогда

		// Тогда, должны быть заполнены и поля Регион, Город, и Дом.
		ПроверяемыеРеквизиты.Добавить("Регион");
		ПроверяемыеРеквизиты.Добавить("Город");
		ПроверяемыеРеквизиты.Добавить("Дом");

	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ЭлектроннаяПочта) Тогда
		// Проверим, корректно ли введен адрес электронной почты.
		Если НЕ ПроверитьАдресЭлектроннойПочты() Тогда
			// Сообщим пользователю о том, что информация не консистентна
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = НСтр("ru = 'Введен некорректный адрес электронной почты!'", "ru");
			Сообщение.Поле  = "ЭлектроннаяПочта";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
		
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Сообщить("Разработка по TASK-2");
	
	
КонецПроцедуры

&НаСервере
Функция ПроверитьАдресЭлектроннойПочты()
#Если НЕ (МобильноеПриложениеСервер ИЛИ МобильныйАвтономныйСервер) Тогда
	Возврат РаботаСПочтойВызовСервера.ЭлектронныйАдресКорректный(ЭлектроннаяПочта);
#КонецЕсли

#Если (МобильноеПриложениеСервер ИЛИ МобильныйАвтономныйСервер) Тогда
	Возврат Истина;
#КонецЕсли

КонецФункции