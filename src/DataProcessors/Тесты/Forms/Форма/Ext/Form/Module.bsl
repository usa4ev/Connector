﻿#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьТесты(Команда)
	
	ВыполнитьТестыНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВыполнитьТестыНаСервере()
	
	Если ПроверитьЗаполнение() Тогда
		РеквизитФормыВЗначение("Объект").ВыполнитьТестыНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
