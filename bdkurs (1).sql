-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3307
-- Время создания: Июн 19 2025 г., 14:29
-- Версия сервера: 8.0.30
-- Версия PHP: 8.1.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `bdkurs` пример бд 
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete` (`id` INT)   BEGIN
delete from Zapch where (idZap = id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert` (`id` INT, `Cena` INT, `TU` INT)   BEGIN
insert into Zapch(idZap, CenaZap,TypeUsl_idUsl) values (id , Cena, TU) ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update` (`id` INT, `Naz` VARCHAR(20))   BEGIN
update Zapch set NaimenZap = Naz where id = idZap;
end$$

--
-- Функции
--
CREATE DEFINER=`root`@`localhost` FUNCTION `find_average_cena_zap` () RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
   DECLARE sum_cena_zap DECIMAL(10, 2);
   SELECT AVG(CenaZap) INTO sum_cena_zap FROM Zapch;
   
   IF sum_cena_zap IS NULL THEN
      RETURN NULL;
   ELSE
      RETURN sum_cena_zap;
   END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `chek`
--

CREATE TABLE `chek` (
  `idChek` int NOT NULL,
  `Akt` int NOT NULL,
  `DateChek` date DEFAULT NULL,
  `Zapch_idZap` int NOT NULL,
  `Zayavka_idZ` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `chek`
--

INSERT INTO `chek` (`idChek`, `Akt`, `DateChek`, `Zapch_idZap`, `Zayavka_idZ`) VALUES
(1, 1, '2023-10-13', 1, 1),
(2, 2, '2023-10-16', 3, 2),
(3, 3, '2023-10-17', 12, 3),
(4, 4, '2023-10-16', 5, 4),
(5, 5, '2023-10-16', 8, 5),
(6, 6, '2023-10-20', 2, 6),
(7, 7, '2023-10-22', 13, 7),
(8, 8, '2023-10-27', 6, 8),
(9, 9, '2023-10-30', 4, 9),
(10, 10, '2023-11-01', 11, 10),
(11, 11, '2024-10-10', 12, 11),
(12, 11, '2024-10-16', 1, 11),
(13, 11, '2024-10-16', 13, 11),
(14, 11, '2025-03-23', 10, 9),
(15, 11, '2025-03-11', 12, 12),
(8888, 11, '2025-03-14', 8, 8);

-- --------------------------------------------------------

--
-- Структура таблицы `client`
--

CREATE TABLE `client` (
  `idClient` int NOT NULL,
  `FamCl` varchar(15) DEFAULT NULL,
  `ImyaCl` varchar(10) DEFAULT NULL,
  `OtchCl` varchar(15) DEFAULT NULL,
  `AdrCl` varchar(30) DEFAULT NULL,
  `KontCl` varchar(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `client`
--

INSERT INTO `client` (`idClient`, `FamCl`, `ImyaCl`, `OtchCl`, `AdrCl`, `KontCl`) VALUES
(1, 'Карамзин', 'Игорь', 'Сергеевич', 'Пролетарская ул., д. 17 кв. 3', '89114563743'),
(2, 'Балабанов', 'Александр', 'Николаевич', 'Озерный пер., д. 11 кв.83', '89123414324'),
(3, 'Крылов', 'Арсений', 'Витальевич', 'Вокзальная ул., д. 18 кв.127', '89432419587'),
(4, 'Мысов', 'Егор', 'Антонович', 'Калинина ул., д. 9 кв.155', '89646726354'),
(5, 'Васенин', 'Кирилл', 'Янович', 'Парковая ул., д. 13 кв.160', '89664528644'),
(6, 'Браверман', 'Евпатий', 'Игнатьевич', 'Колхозная ул., д. 7 кв.38', '89706463976'),
(7, 'Маликов', 'Попейг', 'Артемович', 'Почтовая ул., д. 25 кв.101', '89630523546'),
(8, 'Вдовин', 'Марк', 'Романович', 'Дачная ул., д. 16 кв.148', '89352256064'),
(9, 'Баласанян', 'Армен', 'Давидович', 'Майская ул., д. 20 кв.173', '89502431242'),
(10, 'Митюрин', 'Адольф', 'Викторович', 'Садовая ул., д. 3 кв.164', '89114533234'),
(11, '11', '12', '12', '12', '2'),
(12, 'fewf', 'vdsv', 'vfv', 'vdfb', ' vc '),
(13, 'eewqe', 'qewq', 'eqw', 'eqwe', '3123'),
(14, 'fererer', 'fdsfsf', 'faddsf', 'fafd', 'fdad');

-- --------------------------------------------------------

--
-- Структура таблицы `mark`
--

CREATE TABLE `mark` (
  `idMark` int NOT NULL,
  `NaimenMark` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `mark`
--

INSERT INTO `mark` (`idMark`, `NaimenMark`) VALUES
(1, 'Chevrolet'),
(2, 'Renault'),
(3, 'Suzuki'),
(4, 'Mercedes'),
(5, 'Audi'),
(6, 'BMW'),
(7, 'KIA'),
(8, 'Mustang'),
(9, 'Cadillac'),
(10, 'Volkswagen'),
(11, 'dsa');

-- --------------------------------------------------------

--
-- Структура таблицы `model`
--

CREATE TABLE `model` (
  `idModel` int NOT NULL,
  `NaimenModel` varchar(20) DEFAULT NULL,
  `Mark_idMark` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `model`
--

INSERT INTO `model` (`idModel`, `NaimenModel`, `Mark_idMark`) VALUES
(1, 'Impala', 1),
(2, 'Logan', 2),
(3, 'Swift', 3),
(4, 'AMG', 4),
(5, 'A5', 5),
(6, 'M3', 6),
(7, 'Rio', 7),
(8, 'GT500', 8),
(9, 'Escalade', 9),
(10, 'Golf', 10),
(11, 'da', 1),
(12, 'суфс', 2),
(13, 'csac', 7),
(14, '3213ё23', 3),
(15, '312312', 1),
(16, '42113', 1),
(17, '123123123', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `sotrudnik`
--

CREATE TABLE `sotrudnik` (
  `idSotr` int NOT NULL,
  `FamSotr` varchar(15) DEFAULT NULL,
  `ImyaSotr` varchar(10) DEFAULT NULL,
  `OtchSotr` varchar(15) DEFAULT NULL,
  `kontSotr` varchar(11) DEFAULT NULL,
  `idStat` int DEFAULT NULL,
  `Login` varchar(15) DEFAULT NULL,
  `password` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `sotrudnik`
--

INSERT INTO `sotrudnik` (`idSotr`, `FamSotr`, `ImyaSotr`, `OtchSotr`, `kontSotr`, `idStat`, `Login`, `password`) VALUES
(1, 'Антипов', 'Петр', 'Робертович', '89615876857', 1, 'Antip123', 'Antip123'),
(2, 'Карпов', 'Владимир', 'Владимирович', '89756643790', 1, 'Karp123', 'Karp123'),
(3, 'Мишустин', 'Олег', 'Николаевич', '89054252552', 1, 'Mish123', 'Mish123'),
(4, 'Володин', 'Кирилл', 'Васильевич', '89032432254', 2, 'Vol123', 'Vol123'),
(5, 'Мишин', 'Игнат', 'Петрович', '89653547363', 3, 'Mishin123', 'Mishin123'),
(6, 'fewf', 'vrg', 'fsev', 'vsdv', 3, 'dae', NULL),
(7, '32', 'аыва', 'аыфа', '414', 1, '421', NULL),
(8, 'r3r', 'r13', 'r13', '312', 1, '321', '321'),
(9, 'dadwad', 'dawdawd', 'dawd', '52524542542', 1, 'dawdaw', 'dawdwa');

-- --------------------------------------------------------

--
-- Структура таблицы `status`
--

CREATE TABLE `status` (
  `idStat` int NOT NULL,
  `NaimenStat` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `status`
--

INSERT INTO `status` (`idStat`, `NaimenStat`) VALUES
(1, 'Механик'),
(2, 'Администратор'),
(3, 'Ст. механик ');

-- --------------------------------------------------------

--
-- Структура таблицы `ts`
--

CREATE TABLE `ts` (
  `idTs` int NOT NULL,
  `GosNum` varchar(9) DEFAULT NULL,
  `Model_idModel` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `ts`
--

INSERT INTO `ts` (`idTs`, `GosNum`, `Model_idModel`) VALUES
(1, 'АЕ342К39', 1),
(2, 'УК104Т39', 2),
(3, 'РО793М39', 3),
(4, 'СТ094О39', 4),
(5, 'ОР431Р39', 5),
(6, 'МТ056К39', 6),
(7, 'РА462А39', 7),
(8, 'РТ361К39', 8),
(9, 'НЕ451С39', 9),
(10, 'КР523К39', 10),
(11, '321123', 14);

-- --------------------------------------------------------

--
-- Структура таблицы `typerab`
--

CREATE TABLE `typerab` (
  `idRab` int NOT NULL,
  `NaimenRab` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `typerab`
--

INSERT INTO `typerab` (`idRab`, `NaimenRab`) VALUES
(1, 'Ремонт коробки передач'),
(2, 'Ремонт ДВС'),
(3, 'кузовной ремонт'),
(4, 'Ремонт трансмисии'),
(5, 'Замена масла'),
(6, 'Ремонт и диагностика электрики'),
(7, 'Ремонт системы охлаждения'),
(8, 'Ремонт ходовой части'),
(9, 'Ремонт выхлопной системы '),
(10, 'Ремонт Системы кондиционирования'),
(11, 'Шиномонтаж');

-- --------------------------------------------------------

--
-- Структура таблицы `typeusl`
--

CREATE TABLE `typeusl` (
  `idUsl` int NOT NULL,
  `NaimenUsl` varchar(70) DEFAULT NULL,
  `CenaUsl` int DEFAULT NULL,
  `TypeRab_idRab` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `typeusl`
--

INSERT INTO `typeusl` (`idUsl`, `NaimenUsl`, `CenaUsl`, `TypeRab_idRab`) VALUES
(1, 'Замена АКПП', 7000, 1),
(2, 'Замена МКПП', 6000, 1),
(3, 'Замена поршней ', 4000, 2),
(4, 'Ликвидация трещин', 3000, 2),
(5, 'Установка гильз', 4000, 2),
(6, 'Ремонт порогов ', 2000, 3),
(7, 'Замена порогов ', 4000, 3),
(8, 'Стапельные работы ', 6000, 3),
(9, 'Окраска кузова ', 7000, 3),
(10, 'Ремонт раздаточных коробок', 8000, 4),
(11, 'Замена цилиндра сцепления', 2000, 4),
(12, 'Замена привода ШРУС', 3000, 4),
(13, 'Замена масла в двигателе', 500, 5),
(14, 'Замена воздушного фильтра ', 300, 5),
(15, 'Замена салонного фильтра ', 500, 5),
(16, 'Ремонт стартера ', 1500, 6),
(17, 'Ремонт генератора ', 3000, 6),
(18, 'Прошивка блоков ЭБУ', 6000, 6),
(19, 'Замена термостата', 1000, 7),
(20, 'Замена насоса системы охлаждения ', 2500, 7),
(21, 'Замена вентиляторов охлаждения ', 2000, 7),
(22, '2131', 123, 11);

-- --------------------------------------------------------

--
-- Структура таблицы `zapch`
--

CREATE TABLE `zapch` (
  `idZap` int NOT NULL,
  `NaimenZap` varchar(20) DEFAULT NULL,
  `CenaZap` double DEFAULT NULL,
  `TypeUsl_idUsl` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `zapch`
--

INSERT INTO `zapch` (`idZap`, `NaimenZap`, `CenaZap`, `TypeUsl_idUsl`) VALUES
(0, '4314', 300, 3),
(1, 'АКПП', 545, 1),
(2, 'МКПП', 3000, 2),
(3, 'Поршень ', 2000, 3),
(4, 'Гильза', 500, 5),
(5, 'Порог', 1500, 7),
(6, 'Цилиндр сцепления', 2000, 11),
(7, 'Привод ШУРС', 3000, 12),
(8, 'Масло', 5008, 13),
(9, 'Возд. фильтр', 700, 14),
(10, 'Салон. фильтр', 700, 15),
(11, 'Термостат', 1500, 19),
(12, 'Насос сис. охл.', 1200, 20),
(13, 'Вент. охл.', 500, 21),
(14, 'Раздат. коробка', 1400, 10);

--
-- Триггеры `zapch`
--
DELIMITER $$
CREATE TRIGGER `zapch_AFTER_INSERT` AFTER INSERT ON `zapch` FOR EACH ROW BEGIN
	IF NEW.CenaZap < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Цена указана неверно';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `zapch_BEFORE_INSERT` BEFORE INSERT ON `zapch` FOR EACH ROW BEGIN
	Set NEW.CenaZap = NEW.CenaZap * 1.4;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `zayavka`
--

CREATE TABLE `zayavka` (
  `idZ` int NOT NULL,
  `DateZ` date DEFAULT NULL,
  `OpisProb` varchar(40) DEFAULT NULL,
  `Ts_idTs` int NOT NULL,
  `Client_idClient` int DEFAULT NULL,
  `Sotrudnik_idSotrudnik` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `zayavka`
--

INSERT INTO `zayavka` (`idZ`, `DateZ`, `OpisProb`, `Ts_idTs`, `Client_idClient`, `Sotrudnik_idSotrudnik`) VALUES
(1, '2023-10-11', 'Поломка АКПП', 4, 1, 1),
(2, '2023-10-13', 'Машина не едет', 3, 2, 2),
(3, '2023-10-14', 'Поломка сис. охл.', 6, 3, 3),
(4, '2023-10-15', 'Сгнившие пороги', 5, 4, 2),
(5, '2023-10-16', 'Отсутствие масла ', 2, 5, 4),
(6, '2023-10-19', 'Не переключает передачи', 1, 6, 1),
(7, '2023-10-21', 'Поломка вентилятора охл.', 9, 8, 5),
(8, '2023-10-25', 'Проблема сцепления', 8, 7, 2),
(9, '2023-10-27', 'Стертые гильзы', 7, 9, 4),
(10, '2023-10-30', 'Поломка термостата', 10, 10, 3),
(11, '2024-10-01', 'не заводиться', 1, 12, 6),
(12, '2024-10-14', '321', 10, 12, 5);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `chek`
--
ALTER TABLE `chek`
  ADD PRIMARY KEY (`idChek`),
  ADD KEY `fk_Chek_Zapch1_idx` (`Zapch_idZap`),
  ADD KEY `fk_Chek_Zayavka1_idx` (`Zayavka_idZ`);

--
-- Индексы таблицы `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`idClient`);

--
-- Индексы таблицы `mark`
--
ALTER TABLE `mark`
  ADD PRIMARY KEY (`idMark`);

--
-- Индексы таблицы `model`
--
ALTER TABLE `model`
  ADD PRIMARY KEY (`idModel`),
  ADD KEY `fk_Model_Mark_idx` (`Mark_idMark`);

--
-- Индексы таблицы `sotrudnik`
--
ALTER TABLE `sotrudnik`
  ADD PRIMARY KEY (`idSotr`),
  ADD KEY `idStat` (`idStat`);

--
-- Индексы таблицы `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`idStat`);

--
-- Индексы таблицы `ts`
--
ALTER TABLE `ts`
  ADD PRIMARY KEY (`idTs`),
  ADD KEY `fk_Ts_Model1_idx` (`Model_idModel`);

--
-- Индексы таблицы `typerab`
--
ALTER TABLE `typerab`
  ADD PRIMARY KEY (`idRab`);

--
-- Индексы таблицы `typeusl`
--
ALTER TABLE `typeusl`
  ADD PRIMARY KEY (`idUsl`),
  ADD KEY `fk_TypeUsl_TypeRab1_idx` (`TypeRab_idRab`);

--
-- Индексы таблицы `zapch`
--
ALTER TABLE `zapch`
  ADD PRIMARY KEY (`idZap`),
  ADD KEY `fk_Zapch_TypeUsl1_idx` (`TypeUsl_idUsl`);

--
-- Индексы таблицы `zayavka`
--
ALTER TABLE `zayavka`
  ADD PRIMARY KEY (`idZ`),
  ADD KEY `fk_Zayavka_Ts1_idx` (`Ts_idTs`),
  ADD KEY `fk_Zayavka_Client1_idx` (`Client_idClient`),
  ADD KEY `fk_Zayavka_Mehanik1_idx` (`Sotrudnik_idSotrudnik`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `status`
--
ALTER TABLE `status`
  MODIFY `idStat` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `chek`
--
ALTER TABLE `chek`
  ADD CONSTRAINT `fk_Chek_Zapch1` FOREIGN KEY (`Zapch_idZap`) REFERENCES `zapch` (`idZap`),
  ADD CONSTRAINT `fk_Chek_Zayavka1` FOREIGN KEY (`Zayavka_idZ`) REFERENCES `zayavka` (`idZ`);

--
-- Ограничения внешнего ключа таблицы `model`
--
ALTER TABLE `model`
  ADD CONSTRAINT `fk_Model_Mark` FOREIGN KEY (`Mark_idMark`) REFERENCES `mark` (`idMark`);

--
-- Ограничения внешнего ключа таблицы `sotrudnik`
--
ALTER TABLE `sotrudnik`
  ADD CONSTRAINT `sotrudnik_ibfk_1` FOREIGN KEY (`idStat`) REFERENCES `status` (`idStat`);

--
-- Ограничения внешнего ключа таблицы `ts`
--
ALTER TABLE `ts`
  ADD CONSTRAINT `fk_Ts_Model1` FOREIGN KEY (`Model_idModel`) REFERENCES `model` (`idModel`);

--
-- Ограничения внешнего ключа таблицы `typeusl`
--
ALTER TABLE `typeusl`
  ADD CONSTRAINT `fk_TypeUsl_TypeRab1` FOREIGN KEY (`TypeRab_idRab`) REFERENCES `typerab` (`idRab`);

--
-- Ограничения внешнего ключа таблицы `zapch`
--
ALTER TABLE `zapch`
  ADD CONSTRAINT `fk_Zapch_TypeUsl1` FOREIGN KEY (`TypeUsl_idUsl`) REFERENCES `typeusl` (`idUsl`);

--
-- Ограничения внешнего ключа таблицы `zayavka`
--
ALTER TABLE `zayavka`
  ADD CONSTRAINT `fk_Zayavka_Client` FOREIGN KEY (`Client_idClient`) REFERENCES `client` (`idClient`),
  ADD CONSTRAINT `fk_Zayavka_Client1` FOREIGN KEY (`Client_idClient`) REFERENCES `client` (`idClient`),
  ADD CONSTRAINT `fk_Zayavka_Mehanik1` FOREIGN KEY (`Sotrudnik_idSotrudnik`) REFERENCES `sotrudnik` (`idSotr`),
  ADD CONSTRAINT `fk_Zayavka_Ts1` FOREIGN KEY (`Ts_idTs`) REFERENCES `ts` (`idTs`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
