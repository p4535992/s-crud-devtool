CREATE DATABASE  IF NOT EXISTS `$DATABASE` DEFAULT CHARACTER SET utf8  ;

USE `$DATABASE` ;

/*Table structure for table `masterattribute` */

DROP TABLE IF EXISTS  `masterattribute` ;

CREATE TABLE `masterattribute` (
  `Attributes` varchar(255) DEFAULT NULL,
  `UpdateDateTime` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `masterattribute` */

insert  into `masterattribute`(`Attributes`,`UpdateDateTime`) values 

('Gender','$CURRENTTIME'),

('MaritalStatus','$CURRENTTIME'),

('State','$CURRENTTIME');


/*Table structure for table `masteritemlist` */

DROP TABLE IF EXISTS  `masteritemlist` ;

CREATE TABLE `masteritemlist` (
  `RecordID` int(11) NOT NULL AUTO_INCREMENT,
  `Attribute` varchar(255) DEFAULT NULL,
  `Options` varchar(255) DEFAULT NULL,
  `UpdateDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`RecordID`),
  KEY `RecordID` (`RecordID`)
) ENGINE=MyISAM AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;

/*Data for the table `masteritemlist` */

insert  into `masteritemlist`(`RecordID`,`Attribute`,`Options`,`UpdateDateTime`) values 

(1,'Gender','Male','$CURRENTTIME'),

(2,'Gender','Female','$CURRENTTIME'),

(3,'MaritalStatus','Married','$CURRENTTIME'),

(4,'MaritalStatus','Unmarried','$CURRENTTIME'),

(5,'State','Andhra Pradesh','$CURRENTTIME'),

(6,'State','Andaman and Nicobar Islands','$CURRENTTIME'),

(7,'State','Arunachal Pradesh','$CURRENTTIME'),

(8,'State','Assam','$CURRENTTIME'),

(9,'State','Bihar','$CURRENTTIME'),

(10,'State','Chandigarh','$CURRENTTIME'),

(11,'State','Chhattisgarh','$CURRENTTIME'),

(12,'State','Dadra and Nagar Haveli','$CURRENTTIME'),

(13,'State','Daman and Diu','$CURRENTTIME'),

(14,'State','Delhi','$CURRENTTIME'),

(15,'State','Goa','$CURRENTTIME'),

(16,'State','Gujarat','$CURRENTTIME'),

(17,'State','Haryana','$CURRENTTIME'),

(18,'State','Himachal Pradesh','$CURRENTTIME'),

(19,'State','Jammu and Kashmir','$CURRENTTIME'),

(20,'State','Jharkhand','$CURRENTTIME'),

(21,'State','Karnataka','$CURRENTTIME'),

(22,'State','Kerala','$CURRENTTIME'),

(23,'State','Lakshadweep Islands','$CURRENTTIME'),

(24,'State','Madhya Pradesh','$CURRENTTIME'),

(25,'State','Maharashtra','$CURRENTTIME'),

(26,'State','Manipur','$CURRENTTIME'),

(27,'State','Meghalaya','$CURRENTTIME'),

(28,'State','Mizoram','$CURRENTTIME'),

(29,'State','Nagaland','$CURRENTTIME'),

(30,'State','Orissa','$CURRENTTIME'),

(31,'State','Pondicherry','$CURRENTTIME'),

(32,'State','Punjab','$CURRENTTIME'),

(33,'State','Rajasthan','$CURRENTTIME'),

(34,'State','Sikkim','$CURRENTTIME'),

(35,'State','Tamil Nadu','$CURRENTTIME'),

(36,'State','Telangana','$CURRENTTIME'),

(37,'State','Tripura','$CURRENTTIME'),

(38,'State','Uttar Pradesh','$CURRENTTIME'),

(39,'State','Uttarakhand','$CURRENTTIME'),

(40,'State','West Bengal','$CURRENTTIME');



/*Table structure for table `masteritemtable` */
 
DROP TABLE IF EXISTS `masteritemtable` ;

CREATE TABLE `masteritemtable` (
  `RecordID` int(11) NOT NULL AUTO_INCREMENT,
  `Attribute` varchar(255) DEFAULT NULL,
  `TableName` varchar(255) DEFAULT NULL,
  `ColumnName` varchar(255) DEFAULT NULL,
  `UpdateDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`RecordID`),
  KEY `RecordID` (`RecordID`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `masteritemtable` */

insert  into `masteritemtable`(`RecordID`,`Attribute`,`TableName`,`ColumnName`,`UpdateDateTime`) values 

(1,'Gender','sitemanager','Gender','$CURRENTTIME'),

(2,'MaritalStatus','sitemanager','MaritalStatus','$CURRENTTIME'),

(3,'State','sitemanager','State','$CURRENTTIME');


/*Table structure for table `debuglog` */

DROP TABLE IF EXISTS `debuglog`;

CREATE TABLE `debuglog` (
  `LogID` int(11) NOT NULL AUTO_INCREMENT,
  `LogTime` datetime DEFAULT NULL,
  `Context` varchar(255) DEFAULT NULL,
  `LogText` mediumtext,
  PRIMARY KEY (`LogID`),
  KEY `LogID` (`LogID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;  


/*Table structure for table `appsetting` */

DROP TABLE IF EXISTS  `appsetting` ;

CREATE TABLE `appsetting` (
  `RecordID` int(11) NOT NULL AUTO_INCREMENT,
  `Type` smallint(6) DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Description` mediumtext,
  `Value` varchar(255) DEFAULT NULL,
  `URL` mediumtext,
  `UpdateDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`RecordID`),
  KEY `RecordID` (`RecordID`),
  KEY `Name` (`Name`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Data for the table `appsetting` */

insert  into `appsetting`(`RecordID`,`Type`,`Name`,`Description`,`Value`,`URL`,`UpdateDateTime`) values 

(1,2,'ADMIN-LOGIN-TYPE','1 = AdminID, 2 = EmpCode, 3 = Mobile, 4 = Email, 5 = Username','5','','$CURRENTTIME'),

(2,2,'KEY-DISABLE-NORMAL','Activate disable_normal.js 1 = Disable & 2 = Enable</br>\nTo prohibited accesses for pressing Key-Board Keys Like</br>\nF12, CTRL + key(\"u\" , \"s\")','1','','$CURRENTTIME'),

(3,2,'KEY-DISABLE-HARD','Activate disable_hard.js 1 = Disable & 2 = Enable</br>\nTo prohibited accesses for pressing Key-Board Keys Like</br>\nF12</br>\nCTRL + key(\"u\", \"s\", \"a\", \"n\", \"c\", \"x\", \"y\", \"j\", \"w\")</br>\nRight click</br>\nText Select','1','','$CURRENTTIME'),

(4,1,'PASSWORD-CASE-SENSITIVE','Match case in password [Yes OR No]','YES','','$CURRENTTIME'),

(5,1,'ADMIN-LOGIN-ENABLE','Flag which controls whether login by Admin is allowed or not.','YES','','$CURRENTTIME'),

(6,1,'POST-LINK-FLAG','Pass Link Parameter as Form (method="post")','NO','','$CURRENTTIME');

/*Table structure for table `sitemanager` */

DROP TABLE IF EXISTS `sitemanager`;

CREATE TABLE `sitemanager` (
  `AdminID` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(255) DEFAULT NULL,
  `MiddleName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) DEFAULT NULL,
  `Gender` varchar(250) DEFAULT NULL,
  `BirthDate` date DEFAULT NULL,
  `MaritalStatus` varchar(255) DEFAULT NULL,
  `EmpCode` varchar(250) DEFAULT NULL,
  `JoiningDate` date DEFAULT NULL,
  `LeavingDate` date DEFAULT NULL,
  `Address` mediumtext,
  `City` varchar(250) DEFAULT NULL,
  `State` varchar(250) DEFAULT NULL,
  `PIN` varchar(6) DEFAULT NULL,
  `Landline` varchar(255) DEFAULT NULL,
  `Mobile` varchar(20) DEFAULT NULL,
  `Email` varchar(250) DEFAULT NULL,
  `Username` char(255) DEFAULT NULL,
  `Password` char(20) DEFAULT NULL,
  `PasswordType` smallint(6) DEFAULT '0',
  `AccessModule` varchar(255) DEFAULT NULL,
  `SuperAdminRight` smallint(6) DEFAULT NULL,
  `LoginRole` char(255) DEFAULT NULL,
  `CurrentStatus` smallint(6) DEFAULT NULL,
  `LoginStatus` smallint(6) DEFAULT NULL,
  `MultiLogin` smallint(6) DEFAULT NULL,
  `MenuType` varchar(255) DEFAULT NULL,
  `UpdateDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`AdminID`),
  KEY `AdminID` (`AdminID`),
  KEY `EmpCode` (`EmpCode`),
  KEY `Mobile` (`Mobile`),
  KEY `Email` (`Email`),
  KEY `Username` (`Username`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `sitemanager` */

insert  into `sitemanager`(`AdminID`,`FirstName`,`MiddleName`,`LastName`,`Gender`,`BirthDate`,`MaritalStatus`,`EmpCode`,`JoiningDate`,`LeavingDate`,`Address`,`City`,`State`,`PIN`,`Landline`,`Mobile`,`Email`,`Username`,`Password`,`PasswordType`,`AccessModule`,`SuperAdminRight`,`LoginRole`,`CurrentStatus`,`LoginStatus`,`MultiLogin`,`MenuType`,`UpdateDateTime`) values 

(1,'Ronak','H','Patel','Male','1991-03-14','Unmarried','12345','2016-06-01',NULL,'13, Dipesh Park Soc. B/H Bhagawati Vidhyalay School, Hirawadi Road, Bapunagar','Ahmedabad','Gujarat','382345','079-22777272','8690706855','holmes1491@gmail.com','admin','$WEBAPP',1,'',1,'Administrator',1,1,1,'topbar','$CURRENTTIME');


/*Table structure for table `accesslogofsitemanager` */

DROP TABLE IF EXISTS `accesslogofsitemanager`;

CREATE TABLE `accesslogofsitemanager` (
  `RecordID` int(11) NOT NULL AUTO_INCREMENT,
  `AdminID` int(11) DEFAULT NULL,
  `LoginTime` datetime DEFAULT NULL,
  `LogoutTime` datetime DEFAULT NULL,
  `IPAddress` varchar(50) DEFAULT '',
  `Flag` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`RecordID`),
  KEY `RecordID` (`RecordID`),
  KEY `AdminID` (`AdminID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `sitemanager_authorization` */

DROP TABLE IF EXISTS `sitemanager_authorization`;

CREATE TABLE `sitemanager_authorization` (
  `AuthorizationID` int(11) NOT NULL AUTO_INCREMENT,
  `AdminID` int(11) DEFAULT NULL,
  `ModuleID` int(11) DEFAULT NULL,
  `ModuleName` varchar(255) DEFAULT NULL,
  `ModuleActivityID` varchar(255) DEFAULT NULL,
  `UpdateDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`AuthorizationID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `sitemanager_authorization` */

insert  into `sitemanager_authorization`(`AuthorizationID`,`AdminID`,`ModuleID`,`ModuleName`,`ModuleActivityID`,`UpdateDateTime`) values 

(1,1,1,'DATABASE','1,2,3','$CURRENTTIME'),

(2,1,2,'SMS','1,2,3','$CURRENTTIME');

/*Table structure for table `sitemanager_photograph` */

DROP TABLE IF EXISTS `sitemanager_photograph`;

CREATE TABLE `sitemanager_photograph` (
  `RecordID` int(11) NOT NULL AUTO_INCREMENT,
  `AdminID` int(11) DEFAULT NULL,
  `FileName` varchar(255) DEFAULT NULL,
  `Photograph` longblob,
  `FileSize` int(11) DEFAULT NULL,
  `MIMEType` varchar(255) DEFAULT NULL,
  `UpdateDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`RecordID`),
  KEY `RecordID` (`RecordID`),
  KEY `AdminID` (`AdminID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `daily_backup` */

DROP TABLE IF EXISTS `daily_backup`;

CREATE TABLE `daily_backup` (
  `BackupID` int(11) NOT NULL AUTO_INCREMENT,
  `Path` mediumtext,
  `FileName` mediumtext,
  `PathDate` varchar(50) DEFAULT NULL,
  `BackupDate` date DEFAULT NULL,
  `DateTime` datetime DEFAULT NULL,
  `Flag` smallint(6) DEFAULT NULL,
  `UpdateDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`BackupID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `module` */

DROP TABLE IF EXISTS `module`;

CREATE TABLE `module` (
  `ModuleID` int(11) NOT NULL AUTO_INCREMENT,
  `ModuleName` varchar(255) DEFAULT NULL,
  `UpdateDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`ModuleID`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Data for the table `module` */

insert  into `module`(`ModuleID`,`ModuleName`,`UpdateDateTime`) values 

(1,'DATABASE','$CURRENTTIME'),

(2,'SMS','$CURRENTTIME');

/*Table structure for table `module_activity` */

DROP TABLE IF EXISTS `module_activity`;

CREATE TABLE `module_activity` (
  `ModuleActivityID` int(11) NOT NULL AUTO_INCREMENT,
  `ModuleActivityName` varchar(255) DEFAULT NULL,
  `UpdateDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`ModuleActivityID`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `module_activity` */

insert  into `module_activity`(`ModuleActivityID`,`ModuleActivityName`,`UpdateDateTime`) values 

(1,'ADD','$CURRENTTIME'),

(2,'CHANGE','$CURRENTTIME'),

(3,'DELETE','$CURRENTTIME');

/*Table structure for table `state_city` */

DROP TABLE IF EXISTS `state_city`;

CREATE TABLE `state_city` (
  `StateCityID` INT(11) NOT NULL AUTO_INCREMENT,
  `City` VARCHAR(255) DEFAULT NULL,
  `State` VARCHAR(255) DEFAULT NULL,
  `Country` VARCHAR(255) DEFAULT NULL,
  `UpdateDateTime` DATETIME DEFAULT NULL,
  PRIMARY KEY (`StateCityID`)
) ENGINE=MYISAM AUTO_INCREMENT=1583 DEFAULT CHARSET=utf8;

/*Data for the table `state_city` */

INSERT  INTO `state_city`(`StateCityID`,`City`,`State`,`Country`,`UpdateDateTime`) VALUES 

(1,'Port Blair','Andaman and Nicobar Islands','India','$CURRENTTIME'),

(2,'Adilabad','Andhra Pradesh','India','$CURRENTTIME'),

(3,'Adoni','Andhra Pradesh','India','$CURRENTTIME'),

(4,'Amadalavalasa','Andhra Pradesh','India','$CURRENTTIME'),

(5,'Amalapuram','Andhra Pradesh','India','$CURRENTTIME'),

(6,'Anakapalle','Andhra Pradesh','India','$CURRENTTIME'),

(7,'Anantapur','Andhra Pradesh','India','$CURRENTTIME'),

(8,'Badepalle','Andhra Pradesh','India','$CURRENTTIME'),

(9,'Banganapalle','Andhra Pradesh','India','$CURRENTTIME'),

(10,'Bapatla','Andhra Pradesh','India','$CURRENTTIME'),

(11,'Bellampalle','Andhra Pradesh','India','$CURRENTTIME'),

(12,'Bethamcherla','Andhra Pradesh','India','$CURRENTTIME'),

(13,'Bhadrachalam','Andhra Pradesh','India','$CURRENTTIME'),

(14,'Bhainsa','Andhra Pradesh','India','$CURRENTTIME'),

(15,'Bheemunipatnam','Andhra Pradesh','India','$CURRENTTIME'),

(16,'Bhimavaram','Andhra Pradesh','India','$CURRENTTIME'),

(17,'Bhongir','Andhra Pradesh','India','$CURRENTTIME'),

(18,'Bobbili','Andhra Pradesh','India','$CURRENTTIME'),

(19,'Bodhan','Andhra Pradesh','India','$CURRENTTIME'),

(20,'Chilakaluripet','Andhra Pradesh','India','$CURRENTTIME'),

(21,'Chirala','Andhra Pradesh','India','$CURRENTTIME'),

(22,'Chittoor','Andhra Pradesh','India','$CURRENTTIME'),

(23,'Cuddapah','Andhra Pradesh','India','$CURRENTTIME'),

(24,'Devarakonda','Andhra Pradesh','India','$CURRENTTIME'),

(25,'Dharmavaram','Andhra Pradesh','India','$CURRENTTIME'),

(26,'Eluru','Andhra Pradesh','India','$CURRENTTIME'),

(27,'Farooqnagar','Andhra Pradesh','India','$CURRENTTIME'),

(28,'Gadwal','Andhra Pradesh','India','$CURRENTTIME'),

(29,'Gooty','Andhra Pradesh','India','$CURRENTTIME'),

(30,'Gudivada','Andhra Pradesh','India','$CURRENTTIME'),

(31,'Gudur','Andhra Pradesh','India','$CURRENTTIME'),

(32,'Guntakal','Andhra Pradesh','India','$CURRENTTIME'),

(33,'Guntur','Andhra Pradesh','India','$CURRENTTIME'),

(34,'Hanuman Junction','Andhra Pradesh','India','$CURRENTTIME'),

(35,'Hindupur','Andhra Pradesh','India','$CURRENTTIME'),

(36,'Hyderabad','Andhra Pradesh','India','$CURRENTTIME'),

(37,'Ichchapuram','Andhra Pradesh','India','$CURRENTTIME'),

(38,'Jaggaiahpet','Andhra Pradesh','India','$CURRENTTIME'),

(39,'Jagtial','Andhra Pradesh','India','$CURRENTTIME'),

(40,'Jammalamadugu','Andhra Pradesh','India','$CURRENTTIME'),

(41,'Jangaon','Andhra Pradesh','India','$CURRENTTIME'),

(42,'Kadapa','Andhra Pradesh','India','$CURRENTTIME'),

(43,'Kadiri','Andhra Pradesh','India','$CURRENTTIME'),

(44,'Kagaznagar','Andhra Pradesh','India','$CURRENTTIME'),

(45,'Kakinada','Andhra Pradesh','India','$CURRENTTIME'),

(46,'Kalyandurg','Andhra Pradesh','India','$CURRENTTIME'),

(47,'Kamareddy','Andhra Pradesh','India','$CURRENTTIME'),

(48,'Kandukur','Andhra Pradesh','India','$CURRENTTIME'),

(49,'Karimnagar','Andhra Pradesh','India','$CURRENTTIME'),

(50,'Kavali','Andhra Pradesh','India','$CURRENTTIME'),

(51,'Khammam','Andhra Pradesh','India','$CURRENTTIME'),

(52,'Koratla','Andhra Pradesh','India','$CURRENTTIME'),

(53,'Kothagudem','Andhra Pradesh','India','$CURRENTTIME'),

(54,'Kothapeta','Andhra Pradesh','India','$CURRENTTIME'),

(55,'Kovvur','Andhra Pradesh','India','$CURRENTTIME'),

(56,'Kurnool','Andhra Pradesh','India','$CURRENTTIME'),

(57,'Kyathampalle','Andhra Pradesh','India','$CURRENTTIME'),

(58,'Macherla','Andhra Pradesh','India','$CURRENTTIME'),

(59,'Machilipatnam','Andhra Pradesh','India','$CURRENTTIME'),

(60,'Madanapalle','Andhra Pradesh','India','$CURRENTTIME'),

(61,'Mahbubnagar','Andhra Pradesh','India','$CURRENTTIME'),

(62,'Mancherial','Andhra Pradesh','India','$CURRENTTIME'),

(63,'Mandamarri','Andhra Pradesh','India','$CURRENTTIME'),

(64,'Mandapeta','Andhra Pradesh','India','$CURRENTTIME'),

(65,'Manuguru','Andhra Pradesh','India','$CURRENTTIME'),

(66,'Markapur','Andhra Pradesh','India','$CURRENTTIME'),

(67,'Medak','Andhra Pradesh','India','$CURRENTTIME'),

(68,'Miryalaguda','Andhra Pradesh','India','$CURRENTTIME'),

(69,'Mogalthur','Andhra Pradesh','India','$CURRENTTIME'),

(70,'Nagari','Andhra Pradesh','India','$CURRENTTIME'),

(71,'Nagarkurnool','Andhra Pradesh','India','$CURRENTTIME'),

(72,'Nandyal','Andhra Pradesh','India','$CURRENTTIME'),

(73,'Narasapur','Andhra Pradesh','India','$CURRENTTIME'),

(74,'Narasaraopet','Andhra Pradesh','India','$CURRENTTIME'),

(75,'Narayanpet','Andhra Pradesh','India','$CURRENTTIME'),

(76,'Narsipatnam','Andhra Pradesh','India','$CURRENTTIME'),

(77,'Nellore','Andhra Pradesh','India','$CURRENTTIME'),

(78,'Nidadavole','Andhra Pradesh','India','$CURRENTTIME'),

(79,'Nirmal','Andhra Pradesh','India','$CURRENTTIME'),

(80,'Nizamabad','Andhra Pradesh','India','$CURRENTTIME'),

(81,'Nuzvid','Andhra Pradesh','India','$CURRENTTIME'),

(82,'Ongole','Andhra Pradesh','India','$CURRENTTIME'),

(83,'Palacole','Andhra Pradesh','India','$CURRENTTIME'),

(84,'Palasa Kasibugga','Andhra Pradesh','India','$CURRENTTIME'),

(85,'Palwancha','Andhra Pradesh','India','$CURRENTTIME'),

(86,'Parvathipuram','Andhra Pradesh','India','$CURRENTTIME'),

(87,'Pedana','Andhra Pradesh','India','$CURRENTTIME'),

(88,'Peddapuram','Andhra Pradesh','India','$CURRENTTIME'),

(89,'Pithapuram','Andhra Pradesh','India','$CURRENTTIME'),

(90,'Pondur','Andhra pradesh','India','$CURRENTTIME'),

(91,'Ponnur','Andhra Pradesh','India','$CURRENTTIME'),

(92,'Proddatur','Andhra Pradesh','India','$CURRENTTIME'),

(93,'Punganur','Andhra Pradesh','India','$CURRENTTIME'),

(94,'Puttur','Andhra Pradesh','India','$CURRENTTIME'),

(95,'Rajahmundry','Andhra Pradesh','India','$CURRENTTIME'),

(96,'Rajam','Andhra Pradesh','India','$CURRENTTIME'),

(97,'Ramachandrapuram','Andhra Pradesh','India','$CURRENTTIME'),

(98,'Ramagundam','Andhra Pradesh','India','$CURRENTTIME'),

(99,'Rayachoti','Andhra Pradesh','India','$CURRENTTIME'),

(100,'Rayadurg','Andhra Pradesh','India','$CURRENTTIME'),

(101,'Renigunta','Andhra Pradesh','India','$CURRENTTIME'),

(102,'Repalle','Andhra Pradesh','India','$CURRENTTIME'),

(103,'Sadasivpet','Andhra Pradesh','India','$CURRENTTIME'),

(104,'Salur','Andhra Pradesh','India','$CURRENTTIME'),

(105,'Samalkot','Andhra Pradesh','India','$CURRENTTIME'),

(106,'Sangareddy','Andhra Pradesh','India','$CURRENTTIME'),

(107,'Sattenapalle','Andhra Pradesh','India','$CURRENTTIME'),

(108,'Siddipet','Andhra Pradesh','India','$CURRENTTIME'),

(109,'Singapur','Andhra Pradesh','India','$CURRENTTIME'),

(110,'Sircilla','Andhra Pradesh','India','$CURRENTTIME'),

(111,'Srikakulam','Andhra Pradesh','India','$CURRENTTIME'),

(112,'Srikalahasti','Andhra Pradesh','India','$CURRENTTIME'),

(113,'Suryapet','Andhra Pradesh','India','$CURRENTTIME'),

(114,'Tadepalligudem','Andhra Pradesh','India','$CURRENTTIME'),

(115,'Tadpatri','Andhra Pradesh','India','$CURRENTTIME'),

(116,'Tandur','Andhra Pradesh','India','$CURRENTTIME'),

(117,'Tanuku','Andhra Pradesh','India','$CURRENTTIME'),

(118,'Tenali','Andhra Pradesh','India','$CURRENTTIME'),

(119,'Tirupati','Andhra Pradesh','India','$CURRENTTIME'),

(120,'Tuni','Andhra Pradesh','India','$CURRENTTIME'),

(121,'Uravakonda','Andhra Pradesh','India','$CURRENTTIME'),

(122,'Venkatagiri','Andhra Pradesh','India','$CURRENTTIME'),

(123,'Vicarabad','Andhra Pradesh','India','$CURRENTTIME'),

(124,'Vijayawada','Andhra Pradesh','India','$CURRENTTIME'),

(125,'Vinukonda','Andhra Pradesh','India','$CURRENTTIME'),

(126,'Visakhapatnam','Andhra Pradesh','India','$CURRENTTIME'),

(127,'Vizianagaram','Andhra Pradesh','India','$CURRENTTIME'),

(128,'Wanaparthy','Andhra Pradesh','India','$CURRENTTIME'),

(129,'Warangal','Andhra Pradesh','India','$CURRENTTIME'),

(130,'Yellandu','Andhra Pradesh','India','$CURRENTTIME'),

(131,'Yemmiganur','Andhra Pradesh','India','$CURRENTTIME'),

(132,'Yerraguntla','Andhra Pradesh','India','$CURRENTTIME'),

(133,'Zahirabad','Andhra Pradesh','India','$CURRENTTIME'),

(134,'Rajampet','Andra Pradesh','India','$CURRENTTIME'),

(135,'Along','Arunachal Pradesh','India','$CURRENTTIME'),

(136,'Bomdila','Arunachal Pradesh','India','$CURRENTTIME'),

(137,'Itanagar','Arunachal Pradesh','India','$CURRENTTIME'),

(138,'Naharlagun','Arunachal Pradesh','India','$CURRENTTIME'),

(139,'Pasighat','Arunachal Pradesh','India','$CURRENTTIME'),

(140,'Abhayapuri','Assam','India','$CURRENTTIME'),

(141,'Amguri','Assam','India','$CURRENTTIME'),

(142,'Anandnagaar','Assam','India','$CURRENTTIME'),

(143,'Barpeta','Assam','India','$CURRENTTIME'),

(144,'Barpeta Road','Assam','India','$CURRENTTIME'),

(145,'Bilasipara','Assam','India','$CURRENTTIME'),

(146,'Bongaigaon','Assam','India','$CURRENTTIME'),

(147,'Dhekiajuli','Assam','India','$CURRENTTIME'),

(148,'Dhubri','Assam','India','$CURRENTTIME'),

(149,'Dibrugarh','Assam','India','$CURRENTTIME'),

(150,'Digboi','Assam','India','$CURRENTTIME'),

(151,'Diphu','Assam','India','$CURRENTTIME'),

(152,'Dispur','Assam','India','$CURRENTTIME'),

(153,'Gauripur','Assam','India','$CURRENTTIME'),

(154,'Goalpara','Assam','India','$CURRENTTIME'),

(155,'Golaghat','Assam','India','$CURRENTTIME'),

(156,'Guwahati','Assam','India','$CURRENTTIME'),

(157,'Haflong','Assam','India','$CURRENTTIME'),

(158,'Hailakandi','Assam','India','$CURRENTTIME'),

(159,'Hojai','Assam','India','$CURRENTTIME'),

(160,'Jorhat','Assam','India','$CURRENTTIME'),

(161,'Karimganj','Assam','India','$CURRENTTIME'),

(162,'Kokrajhar','Assam','India','$CURRENTTIME'),

(163,'Lanka','Assam','India','$CURRENTTIME'),

(164,'Lumding','Assam','India','$CURRENTTIME'),

(165,'Mangaldoi','Assam','India','$CURRENTTIME'),

(166,'Mankachar','Assam','India','$CURRENTTIME'),

(167,'Margherita','Assam','India','$CURRENTTIME'),

(168,'Mariani','Assam','India','$CURRENTTIME'),

(169,'Marigaon','Assam','India','$CURRENTTIME'),

(170,'Nagaon','Assam','India','$CURRENTTIME'),

(171,'Nalbari','Assam','India','$CURRENTTIME'),

(172,'North Lakhimpur','Assam','India','$CURRENTTIME'),

(173,'Rangia','Assam','India','$CURRENTTIME'),

(174,'Sibsagar','Assam','India','$CURRENTTIME'),

(175,'Silapathar','Assam','India','$CURRENTTIME'),

(176,'Silchar','Assam','India','$CURRENTTIME'),

(177,'Tezpur','Assam','India','$CURRENTTIME'),

(178,'Tinsukia','Assam','India','$CURRENTTIME'),

(179,'Amarpur','Bihar','India','$CURRENTTIME'),

(180,'Araria','Bihar','India','$CURRENTTIME'),

(181,'Areraj','Bihar','India','$CURRENTTIME'),

(182,'Arrah','Bihar','India','$CURRENTTIME'),

(183,'Asarganj','Bihar','India','$CURRENTTIME'),

(184,'Aurangabad','Bihar','India','$CURRENTTIME'),

(185,'Bagaha','Bihar','India','$CURRENTTIME'),

(186,'Bahadurganj','Bihar','India','$CURRENTTIME'),

(187,'Bairgania','Bihar','India','$CURRENTTIME'),

(188,'Bakhtiarpur','Bihar','India','$CURRENTTIME'),

(189,'Banka','Bihar','India','$CURRENTTIME'),

(190,'Banmankhi Bazar','Bihar','India','$CURRENTTIME'),

(191,'Barahiya','Bihar','India','$CURRENTTIME'),

(192,'Barauli','Bihar','India','$CURRENTTIME'),

(193,'Barbigha','Bihar','India','$CURRENTTIME'),

(194,'Barh','Bihar','India','$CURRENTTIME'),

(195,'Begusarai','Bihar','India','$CURRENTTIME'),

(196,'Behea','Bihar','India','$CURRENTTIME'),

(197,'Bettiah','Bihar','India','$CURRENTTIME'),

(198,'Bhabua','Bihar','India','$CURRENTTIME'),

(199,'Bhagalpur','Bihar','India','$CURRENTTIME'),

(200,'Bihar Sharif','Bihar','India','$CURRENTTIME'),

(201,'Bikramganj','Bihar','India','$CURRENTTIME'),

(202,'Bodh Gaya','Bihar','India','$CURRENTTIME'),

(203,'Buxar','Bihar','India','$CURRENTTIME'),

(204,'Chandan Bara','Bihar','India','$CURRENTTIME'),

(205,'Chanpatia','Bihar','India','$CURRENTTIME'),

(206,'Chhapra','Bihar','India','$CURRENTTIME'),

(207,'Colgong','Bihar','India','$CURRENTTIME'),

(208,'Dalsinghsarai','Bihar','India','$CURRENTTIME'),

(209,'Darbhanga','Bihar','India','$CURRENTTIME'),

(210,'Daudnagar','Bihar','India','$CURRENTTIME'),

(211,'Dehri-on-Sone','Bihar','India','$CURRENTTIME'),

(212,'Dhaka','Bihar','India','$CURRENTTIME'),

(213,'Dighwara','Bihar','India','$CURRENTTIME'),

(214,'Dumraon','Bihar','India','$CURRENTTIME'),

(215,'Fatwah','Bihar','India','$CURRENTTIME'),

(216,'Forbesganj','Bihar','India','$CURRENTTIME'),

(217,'Gaya','Bihar','India','$CURRENTTIME'),

(218,'Gogri Jamalpur','Bihar','India','$CURRENTTIME'),

(219,'Gopalganj','Bihar','India','$CURRENTTIME'),

(220,'Hajipur','Bihar','India','$CURRENTTIME'),

(221,'Hilsa','Bihar','India','$CURRENTTIME'),

(222,'Hisua','Bihar','India','$CURRENTTIME'),

(223,'Islampur','Bihar','India','$CURRENTTIME'),

(224,'Jagdispur','Bihar','India','$CURRENTTIME'),

(225,'Jamalpur','Bihar','India','$CURRENTTIME'),

(226,'Jamui','Bihar','India','$CURRENTTIME'),

(227,'Jehanabad','Bihar','India','$CURRENTTIME'),

(228,'Jhajha','Bihar','India','$CURRENTTIME'),

(229,'Jhanjharpur','Bihar','India','$CURRENTTIME'),

(230,'Jogabani','Bihar','India','$CURRENTTIME'),

(231,'Kanti','Bihar','India','$CURRENTTIME'),

(232,'Katihar','Bihar','India','$CURRENTTIME'),

(233,'Khagaria','Bihar','India','$CURRENTTIME'),

(234,'Kharagpur','Bihar','India','$CURRENTTIME'),

(235,'Kishanganj','Bihar','India','$CURRENTTIME'),

(236,'Lakhisarai','Bihar','India','$CURRENTTIME'),

(237,'Lalganj','Bihar','India','$CURRENTTIME'),

(238,'Madhepura','Bihar','India','$CURRENTTIME'),

(239,'Madhubani','Bihar','India','$CURRENTTIME'),

(240,'Maharajganj','Bihar','India','$CURRENTTIME'),

(241,'Mahnar Bazar','Bihar','India','$CURRENTTIME'),

(242,'Makhdumpur','Bihar','India','$CURRENTTIME'),

(243,'Maner','Bihar','India','$CURRENTTIME'),

(244,'Manihari','Bihar','India','$CURRENTTIME'),

(245,'Marhaura','Bihar','India','$CURRENTTIME'),

(246,'Masaurhi','Bihar','India','$CURRENTTIME'),

(247,'Mirganj','Bihar','India','$CURRENTTIME'),

(248,'Mokameh','Bihar','India','$CURRENTTIME'),

(249,'Motihari','Bihar','India','$CURRENTTIME'),

(250,'Motipur','Bihar','India','$CURRENTTIME'),

(251,'Munger','Bihar','India','$CURRENTTIME'),

(252,'Murliganj','Bihar','India','$CURRENTTIME'),

(253,'Muzaffarpur','Bihar','India','$CURRENTTIME'),

(254,'Narkatiaganj','Bihar','India','$CURRENTTIME'),

(255,'Naugachhia','Bihar','India','$CURRENTTIME'),

(256,'Nawada','Bihar','India','$CURRENTTIME'),

(257,'Nokha','Bihar','India','$CURRENTTIME'),

(258,'Patna','Bihar','India','$CURRENTTIME'),

(259,'Piro','Bihar','India','$CURRENTTIME'),

(260,'Purnia','Bihar','India','$CURRENTTIME'),

(261,'Rafiganj','Bihar','India','$CURRENTTIME'),

(262,'Rajgir','Bihar','India','$CURRENTTIME'),

(263,'Ramnagar','Bihar','India','$CURRENTTIME'),

(264,'Raxaul Bazar','Bihar','India','$CURRENTTIME'),

(265,'Revelganj','Bihar','India','$CURRENTTIME'),

(266,'Rosera','Bihar','India','$CURRENTTIME'),

(267,'Saharsa','Bihar','India','$CURRENTTIME'),

(268,'Samastipur','Bihar','India','$CURRENTTIME'),

(269,'Sasaram','Bihar','India','$CURRENTTIME'),

(270,'Sheikhpura','Bihar','India','$CURRENTTIME'),

(271,'Sheohar','Bihar','India','$CURRENTTIME'),

(272,'Sherghati','Bihar','India','$CURRENTTIME'),

(273,'Silao','Bihar','India','$CURRENTTIME'),

(274,'Sitamarhi','Bihar','India','$CURRENTTIME'),

(275,'Siwan','Bihar','India','$CURRENTTIME'),

(276,'Sonepur','Bihar','India','$CURRENTTIME'),

(277,'Sugauli','Bihar','India','$CURRENTTIME'),

(278,'Sultanganj','Bihar','India','$CURRENTTIME'),

(279,'Supaul','Bihar','India','$CURRENTTIME'),

(280,'Warisaliganj','Bihar','India','$CURRENTTIME'),

(281,'Ahiwara','Chhattisgarh','India','$CURRENTTIME'),

(282,'Akaltara','Chhattisgarh','India','$CURRENTTIME'),

(283,'Ambagarh Chowki','Chhattisgarh','India','$CURRENTTIME'),

(284,'Ambikapur','Chhattisgarh','India','$CURRENTTIME'),

(285,'Arang','Chhattisgarh','India','$CURRENTTIME'),

(286,'Bade Bacheli','Chhattisgarh','India','$CURRENTTIME'),

(287,'Balod','Chhattisgarh','India','$CURRENTTIME'),

(288,'Baloda Bazar','Chhattisgarh','India','$CURRENTTIME'),

(289,'Bemetra','Chhattisgarh','India','$CURRENTTIME'),

(290,'Bhatapara','Chhattisgarh','India','$CURRENTTIME'),

(291,'Bilaspur','Chhattisgarh','India','$CURRENTTIME'),

(292,'Birgaon','Chhattisgarh','India','$CURRENTTIME'),

(293,'Champa','Chhattisgarh','India','$CURRENTTIME'),

(294,'Chirmiri','Chhattisgarh','India','$CURRENTTIME'),

(295,'Dalli-Rajhara','Chhattisgarh','India','$CURRENTTIME'),

(296,'Dhamtari','Chhattisgarh','India','$CURRENTTIME'),

(297,'Dipka','Chhattisgarh','India','$CURRENTTIME'),

(298,'Dongargarh','Chhattisgarh','India','$CURRENTTIME'),

(299,'Durg-Bhilai Nagar','Chhattisgarh','India','$CURRENTTIME'),

(300,'Gobranawapara','Chhattisgarh','India','$CURRENTTIME'),

(301,'Jagdalpur','Chhattisgarh','India','$CURRENTTIME'),

(302,'Janjgir','Chhattisgarh','India','$CURRENTTIME'),

(303,'Jashpurnagar','Chhattisgarh','India','$CURRENTTIME'),

(304,'Kanker','Chhattisgarh','India','$CURRENTTIME'),

(305,'Kawardha','Chhattisgarh','India','$CURRENTTIME'),

(306,'Kondagaon','Chhattisgarh','India','$CURRENTTIME'),

(307,'Korba','Chhattisgarh','India','$CURRENTTIME'),

(308,'Mahasamund','Chhattisgarh','India','$CURRENTTIME'),

(309,'Mahendragarh','Chhattisgarh','India','$CURRENTTIME'),

(310,'Mungeli','Chhattisgarh','India','$CURRENTTIME'),

(311,'Naila Janjgir','Chhattisgarh','India','$CURRENTTIME'),

(312,'Raigarh','Chhattisgarh','India','$CURRENTTIME'),

(313,'Raipur','Chhattisgarh','India','$CURRENTTIME'),

(314,'Rajnandgaon','Chhattisgarh','India','$CURRENTTIME'),

(315,'Sakti','Chhattisgarh','India','$CURRENTTIME'),

(316,'Tilda Newra','Chhattisgarh','India','$CURRENTTIME'),

(317,'Amli','Dadra & Nagar Haveli','India','$CURRENTTIME'),

(318,'Silvassa','Dadra and Nagar Haveli','India','$CURRENTTIME'),

(319,'Daman and Diu','Daman & Diu','India','$CURRENTTIME'),

(320,'Daman and Diu','Daman & Diu','India','$CURRENTTIME'),

(321,'Asola','Delhi','India','$CURRENTTIME'),

(322,'Delhi','Delhi','India','$CURRENTTIME'),

(323,'Aldona','Goa','India','$CURRENTTIME'),

(324,'Curchorem Cacora','Goa','India','$CURRENTTIME'),

(325,'Madgaon','Goa','India','$CURRENTTIME'),

(326,'Mapusa','Goa','India','$CURRENTTIME'),

(327,'Margao','Goa','India','$CURRENTTIME'),

(328,'Marmagao','Goa','India','$CURRENTTIME'),

(329,'Panaji','Goa','India','$CURRENTTIME'),

(330,'Ahmedabad','Gujarat','India','$CURRENTTIME'),

(331,'Amreli','Gujarat','India','$CURRENTTIME'),

(332,'Anand','Gujarat','India','$CURRENTTIME'),

(333,'Ankleshwar','Gujarat','India','$CURRENTTIME'),

(334,'Bharuch','Gujarat','India','$CURRENTTIME'),

(335,'Bhavnagar','Gujarat','India','$CURRENTTIME'),

(336,'Bhuj','Gujarat','India','$CURRENTTIME'),

(337,'Cambay','Gujarat','India','$CURRENTTIME'),

(338,'Dahod','Gujarat','India','$CURRENTTIME'),

(339,'Deesa','Gujarat','India','$CURRENTTIME'),

(340,'Dharampur, India','Gujarat','India','$CURRENTTIME'),

(341,'Dholka','Gujarat','India','$CURRENTTIME'),

(342,'Gandhinagar','Gujarat','India','$CURRENTTIME'),

(343,'Godhra','Gujarat','India','$CURRENTTIME'),

(344,'Himatnagar','Gujarat','India','$CURRENTTIME'),

(345,'Idar','Gujarat','India','$CURRENTTIME'),

(346,'Jamnagar','Gujarat','India','$CURRENTTIME'),

(347,'Junagadh','Gujarat','India','$CURRENTTIME'),

(348,'Kadi','Gujarat','India','$CURRENTTIME'),

(349,'Kalavad','Gujarat','India','$CURRENTTIME'),

(350,'Kalol','Gujarat','India','$CURRENTTIME'),

(351,'Kapadvanj','Gujarat','India','$CURRENTTIME'),

(352,'Karjan','Gujarat','India','$CURRENTTIME'),

(353,'Keshod','Gujarat','India','$CURRENTTIME'),

(354,'Khambhalia','Gujarat','India','$CURRENTTIME'),

(355,'Khambhat','Gujarat','India','$CURRENTTIME'),

(356,'Kheda','Gujarat','India','$CURRENTTIME'),

(357,'Khedbrahma','Gujarat','India','$CURRENTTIME'),

(358,'Kheralu','Gujarat','India','$CURRENTTIME'),

(359,'Kodinar','Gujarat','India','$CURRENTTIME'),

(360,'Lathi','Gujarat','India','$CURRENTTIME'),

(361,'Limbdi','Gujarat','India','$CURRENTTIME'),

(362,'Lunawada','Gujarat','India','$CURRENTTIME'),

(363,'Mahesana','Gujarat','India','$CURRENTTIME'),

(364,'Mahuva','Gujarat','India','$CURRENTTIME'),

(365,'Manavadar','Gujarat','India','$CURRENTTIME'),

(366,'Mandvi','Gujarat','India','$CURRENTTIME'),

(367,'Mangrol','Gujarat','India','$CURRENTTIME'),

(368,'Mansa','Gujarat','India','$CURRENTTIME'),

(369,'Mehmedabad','Gujarat','India','$CURRENTTIME'),

(370,'Modasa','Gujarat','India','$CURRENTTIME'),

(371,'Morvi','Gujarat','India','$CURRENTTIME'),

(372,'Nadiad','Gujarat','India','$CURRENTTIME'),

(373,'Navsari','Gujarat','India','$CURRENTTIME'),

(374,'Padra','Gujarat','India','$CURRENTTIME'),

(375,'Palanpur','Gujarat','India','$CURRENTTIME'),

(376,'Palitana','Gujarat','India','$CURRENTTIME'),

(377,'Pardi','Gujarat','India','$CURRENTTIME'),

(378,'Patan','Gujarat','India','$CURRENTTIME'),

(379,'Petlad','Gujarat','India','$CURRENTTIME'),

(380,'Porbandar','Gujarat','India','$CURRENTTIME'),

(381,'Radhanpur','Gujarat','India','$CURRENTTIME'),

(382,'Rajkot','Gujarat','India','$CURRENTTIME'),

(383,'Rajpipla','Gujarat','India','$CURRENTTIME'),

(384,'Rajula','Gujarat','India','$CURRENTTIME'),

(385,'Ranavav','Gujarat','India','$CURRENTTIME'),

(386,'Rapar','Gujarat','India','$CURRENTTIME'),

(387,'Salaya','Gujarat','India','$CURRENTTIME'),

(388,'Sanand','Gujarat','India','$CURRENTTIME'),

(389,'Savarkundla','Gujarat','India','$CURRENTTIME'),

(390,'Sidhpur','Gujarat','India','$CURRENTTIME'),

(391,'Sihor','Gujarat','India','$CURRENTTIME'),

(392,'Songadh','Gujarat','India','$CURRENTTIME'),

(393,'Surat','Gujarat','India','$CURRENTTIME'),

(394,'Talaja','Gujarat','India','$CURRENTTIME'),

(395,'Thangadh','Gujarat','India','$CURRENTTIME'),

(396,'Tharad','Gujarat','India','$CURRENTTIME'),

(397,'Umbergaon','Gujarat','India','$CURRENTTIME'),

(398,'Umreth','Gujarat','India','$CURRENTTIME'),

(399,'Una','Gujarat','India','$CURRENTTIME'),

(400,'Unjha','Gujarat','India','$CURRENTTIME'),

(401,'Upleta','Gujarat','India','$CURRENTTIME'),

(402,'Vadnagar','Gujarat','India','$CURRENTTIME'),

(403,'Vadodara','Gujarat','India','$CURRENTTIME'),

(404,'Valsad','Gujarat','India','$CURRENTTIME'),

(405,'Vapi','Gujarat','India','$CURRENTTIME'),

(406,'Vapi','Gujarat','India','$CURRENTTIME'),

(407,'Veraval','Gujarat','India','$CURRENTTIME'),

(408,'Vijapur','Gujarat','India','$CURRENTTIME'),

(409,'Viramgam','Gujarat','India','$CURRENTTIME'),

(410,'Visnagar','Gujarat','India','$CURRENTTIME'),

(411,'Vyara','Gujarat','India','$CURRENTTIME'),

(412,'Wadhwan','Gujarat','India','$CURRENTTIME'),

(413,'Wankaner','Gujarat','India','$CURRENTTIME'),

(414,'Adalaj','Gujarat','India','$CURRENTTIME'),

(415,'Adityana','Gujarat','India','$CURRENTTIME'),

(416,'Alang','Gujarat','India','$CURRENTTIME'),

(417,'Ambaji','Gujarat','India','$CURRENTTIME'),

(418,'Ambaliyasan','Gujarat','India','$CURRENTTIME'),

(419,'Andada','Gujarat','India','$CURRENTTIME'),

(420,'Anjar','Gujarat','India','$CURRENTTIME'),

(421,'Anklav','Gujarat','India','$CURRENTTIME'),

(422,'Antaliya','Gujarat','India','$CURRENTTIME'),

(423,'Arambhada','Gujarat','India','$CURRENTTIME'),

(424,'Atul','Gujarat','India','$CURRENTTIME'),

(425,'Ballabhgarh','Hariyana','India','$CURRENTTIME'),

(426,'Ambala','Haryana','India','$CURRENTTIME'),

(427,'Ambala','Haryana','India','$CURRENTTIME'),

(428,'Asankhurd','Haryana','India','$CURRENTTIME'),

(429,'Assandh','Haryana','India','$CURRENTTIME'),

(430,'Ateli','Haryana','India','$CURRENTTIME'),

(431,'Babiyal','Haryana','India','$CURRENTTIME'),

(432,'Bahadurgarh','Haryana','India','$CURRENTTIME'),

(433,'Barwala','Haryana','India','$CURRENTTIME'),

(434,'Bhiwani','Haryana','India','$CURRENTTIME'),

(435,'Charkhi Dadri','Haryana','India','$CURRENTTIME'),

(436,'Cheeka','Haryana','India','$CURRENTTIME'),

(437,'Ellenabad 2','Haryana','India','$CURRENTTIME'),

(438,'Faridabad','Haryana','India','$CURRENTTIME'),

(439,'Fatehabad','Haryana','India','$CURRENTTIME'),

(440,'Ganaur','Haryana','India','$CURRENTTIME'),

(441,'Gharaunda','Haryana','India','$CURRENTTIME'),

(442,'Gohana','Haryana','India','$CURRENTTIME'),

(443,'Gurgaon','Haryana','India','$CURRENTTIME'),

(444,'Haibat(Yamuna Nagar)','Haryana','India','$CURRENTTIME'),

(445,'Hansi','Haryana','India','$CURRENTTIME'),

(446,'Hisar','Haryana','India','$CURRENTTIME'),

(447,'Hodal','Haryana','India','$CURRENTTIME'),

(448,'Jhajjar','Haryana','India','$CURRENTTIME'),

(449,'Jind','Haryana','India','$CURRENTTIME'),

(450,'Kaithal','Haryana','India','$CURRENTTIME'),

(451,'Kalan Wali','Haryana','India','$CURRENTTIME'),

(452,'Kalka','Haryana','India','$CURRENTTIME'),

(453,'Karnal','Haryana','India','$CURRENTTIME'),

(454,'Ladwa','Haryana','India','$CURRENTTIME'),

(455,'Mahendragarh','Haryana','India','$CURRENTTIME'),

(456,'Mandi Dabwali','Haryana','India','$CURRENTTIME'),

(457,'Narnaul','Haryana','India','$CURRENTTIME'),

(458,'Narwana','Haryana','India','$CURRENTTIME'),

(459,'Palwal','Haryana','India','$CURRENTTIME'),

(460,'Panchkula','Haryana','India','$CURRENTTIME'),

(461,'Panipat','Haryana','India','$CURRENTTIME'),

(462,'Pehowa','Haryana','India','$CURRENTTIME'),

(463,'Pinjore','Haryana','India','$CURRENTTIME'),

(464,'Rania','Haryana','India','$CURRENTTIME'),

(465,'Ratia','Haryana','India','$CURRENTTIME'),

(466,'Rewari','Haryana','India','$CURRENTTIME'),

(467,'Rohtak','Haryana','India','$CURRENTTIME'),

(468,'Safidon','Haryana','India','$CURRENTTIME'),

(469,'Samalkha','Haryana','India','$CURRENTTIME'),

(470,'Shahbad','Haryana','India','$CURRENTTIME'),

(471,'Sirsa','Haryana','India','$CURRENTTIME'),

(472,'Sohna','Haryana','India','$CURRENTTIME'),

(473,'Sonipat','Haryana','India','$CURRENTTIME'),

(474,'Taraori','Haryana','India','$CURRENTTIME'),

(475,'Thanesar','Haryana','India','$CURRENTTIME'),

(476,'Tohana','Haryana','India','$CURRENTTIME'),

(477,'Yamunanagar','Haryana','India','$CURRENTTIME'),

(478,'Arki','Himachal Pradesh','India','$CURRENTTIME'),

(479,'Baddi','Himachal Pradesh','India','$CURRENTTIME'),

(480,'Bilaspur','Himachal Pradesh','India','$CURRENTTIME'),

(481,'Chamba','Himachal Pradesh','India','$CURRENTTIME'),

(482,'Dalhousie','Himachal Pradesh','India','$CURRENTTIME'),

(483,'Dharamsala','Himachal Pradesh','India','$CURRENTTIME'),

(484,'Hamirpur','Himachal Pradesh','India','$CURRENTTIME'),

(485,'Mandi','Himachal Pradesh','India','$CURRENTTIME'),

(486,'Nahan','Himachal Pradesh','India','$CURRENTTIME'),

(487,'Shimla','Himachal Pradesh','India','$CURRENTTIME'),

(488,'Solan','Himachal Pradesh','India','$CURRENTTIME'),

(489,'Sundarnagar','Himachal Pradesh','India','$CURRENTTIME'),

(490,'Jammu','Jammu & Kashmir','India','$CURRENTTIME'),

(491,'Achabbal','Jammu and Kashmir','India','$CURRENTTIME'),

(492,'Akhnoor','Jammu and Kashmir','India','$CURRENTTIME'),

(493,'Anantnag','Jammu and Kashmir','India','$CURRENTTIME'),

(494,'Arnia','Jammu and Kashmir','India','$CURRENTTIME'),

(495,'Awantipora','Jammu and Kashmir','India','$CURRENTTIME'),

(496,'Bandipore','Jammu and Kashmir','India','$CURRENTTIME'),

(497,'Baramula','Jammu and Kashmir','India','$CURRENTTIME'),

(498,'Kathua','Jammu and Kashmir','India','$CURRENTTIME'),

(499,'Leh','Jammu and Kashmir','India','$CURRENTTIME'),

(500,'Punch','Jammu and Kashmir','India','$CURRENTTIME'),

(501,'Rajauri','Jammu and Kashmir','India','$CURRENTTIME'),

(502,'Sopore','Jammu and Kashmir','India','$CURRENTTIME'),

(503,'Srinagar','Jammu and Kashmir','India','$CURRENTTIME'),

(504,'Udhampur','Jammu and Kashmir','India','$CURRENTTIME'),

(505,'Amlabad','Jharkhand','India','$CURRENTTIME'),

(506,'Ara','Jharkhand','India','$CURRENTTIME'),

(507,'Barughutu','Jharkhand','India','$CURRENTTIME'),

(508,'Bokaro Steel City','Jharkhand','India','$CURRENTTIME'),

(509,'Chaibasa','Jharkhand','India','$CURRENTTIME'),

(510,'Chakradharpur','Jharkhand','India','$CURRENTTIME'),

(511,'Chandrapura','Jharkhand','India','$CURRENTTIME'),

(512,'Chatra','Jharkhand','India','$CURRENTTIME'),

(513,'Chirkunda','Jharkhand','India','$CURRENTTIME'),

(514,'Churi','Jharkhand','India','$CURRENTTIME'),

(515,'Daltonganj','Jharkhand','India','$CURRENTTIME'),

(516,'Deoghar','Jharkhand','India','$CURRENTTIME'),

(517,'Dhanbad','Jharkhand','India','$CURRENTTIME'),

(518,'Dumka','Jharkhand','India','$CURRENTTIME'),

(519,'Garhwa','Jharkhand','India','$CURRENTTIME'),

(520,'Ghatshila','Jharkhand','India','$CURRENTTIME'),

(521,'Giridih','Jharkhand','India','$CURRENTTIME'),

(522,'Godda','Jharkhand','India','$CURRENTTIME'),

(523,'Gomoh','Jharkhand','India','$CURRENTTIME'),

(524,'Gumia','Jharkhand','India','$CURRENTTIME'),

(525,'Gumla','Jharkhand','India','$CURRENTTIME'),

(526,'Hazaribag','Jharkhand','India','$CURRENTTIME'),

(527,'Hussainabad','Jharkhand','India','$CURRENTTIME'),

(528,'Jamshedpur','Jharkhand','India','$CURRENTTIME'),

(529,'Jamtara','Jharkhand','India','$CURRENTTIME'),

(530,'Jhumri Tilaiya','Jharkhand','India','$CURRENTTIME'),

(531,'Khunti','Jharkhand','India','$CURRENTTIME'),

(532,'Lohardaga','Jharkhand','India','$CURRENTTIME'),

(533,'Madhupur','Jharkhand','India','$CURRENTTIME'),

(534,'Mihijam','Jharkhand','India','$CURRENTTIME'),

(535,'Musabani','Jharkhand','India','$CURRENTTIME'),

(536,'Pakaur','Jharkhand','India','$CURRENTTIME'),

(537,'Patratu','Jharkhand','India','$CURRENTTIME'),

(538,'Phusro','Jharkhand','India','$CURRENTTIME'),

(539,'Ramngarh','Jharkhand','India','$CURRENTTIME'),

(540,'Ranchi','Jharkhand','India','$CURRENTTIME'),

(541,'Sahibganj','Jharkhand','India','$CURRENTTIME'),

(542,'Saunda','Jharkhand','India','$CURRENTTIME'),

(543,'Simdega','Jharkhand','India','$CURRENTTIME'),

(544,'Tenu Dam-cum- Kathhara','Jharkhand','India','$CURRENTTIME'),

(545,'Arasikere','Karnataka','India','$CURRENTTIME'),

(546,'Bangalore','Karnataka','India','$CURRENTTIME'),

(547,'Belgaum','Karnataka','India','$CURRENTTIME'),

(548,'Bellary','Karnataka','India','$CURRENTTIME'),

(549,'Chamrajnagar','Karnataka','India','$CURRENTTIME'),

(550,'Chikkaballapur','Karnataka','India','$CURRENTTIME'),

(551,'Chintamani','Karnataka','India','$CURRENTTIME'),

(552,'Chitradurga','Karnataka','India','$CURRENTTIME'),

(553,'Gulbarga','Karnataka','India','$CURRENTTIME'),

(554,'Gundlupet','Karnataka','India','$CURRENTTIME'),

(555,'Hassan','Karnataka','India','$CURRENTTIME'),

(556,'Hospet','Karnataka','India','$CURRENTTIME'),

(557,'Hubli','Karnataka','India','$CURRENTTIME'),

(558,'Karkala','Karnataka','India','$CURRENTTIME'),

(559,'Karwar','Karnataka','India','$CURRENTTIME'),

(560,'Kolar','Karnataka','India','$CURRENTTIME'),

(561,'Kota','Karnataka','India','$CURRENTTIME'),

(562,'Lakshmeshwar','Karnataka','India','$CURRENTTIME'),

(563,'Lingsugur','Karnataka','India','$CURRENTTIME'),

(564,'Maddur','Karnataka','India','$CURRENTTIME'),

(565,'Madhugiri','Karnataka','India','$CURRENTTIME'),

(566,'Madikeri','Karnataka','India','$CURRENTTIME'),

(567,'Magadi','Karnataka','India','$CURRENTTIME'),

(568,'Mahalingpur','Karnataka','India','$CURRENTTIME'),

(569,'Malavalli','Karnataka','India','$CURRENTTIME'),

(570,'Malur','Karnataka','India','$CURRENTTIME'),

(571,'Mandya','Karnataka','India','$CURRENTTIME'),

(572,'Mangalore','Karnataka','India','$CURRENTTIME'),

(573,'Manvi','Karnataka','India','$CURRENTTIME'),

(574,'Mudalgi','Karnataka','India','$CURRENTTIME'),

(575,'Mudbidri','Karnataka','India','$CURRENTTIME'),

(576,'Muddebihal','Karnataka','India','$CURRENTTIME'),

(577,'Mudhol','Karnataka','India','$CURRENTTIME'),

(578,'Mulbagal','Karnataka','India','$CURRENTTIME'),

(579,'Mundargi','Karnataka','India','$CURRENTTIME'),

(580,'Mysore','Karnataka','India','$CURRENTTIME'),

(581,'Nanjangud','Karnataka','India','$CURRENTTIME'),

(582,'Pavagada','Karnataka','India','$CURRENTTIME'),

(583,'Puttur','Karnataka','India','$CURRENTTIME'),

(584,'Rabkavi Banhatti','Karnataka','India','$CURRENTTIME'),

(585,'Raichur','Karnataka','India','$CURRENTTIME'),

(586,'Ramanagaram','Karnataka','India','$CURRENTTIME'),

(587,'Ramdurg','Karnataka','India','$CURRENTTIME'),

(588,'Ranibennur','Karnataka','India','$CURRENTTIME'),

(589,'Robertson Pet','Karnataka','India','$CURRENTTIME'),

(590,'Ron','Karnataka','India','$CURRENTTIME'),

(591,'Sadalgi','Karnataka','India','$CURRENTTIME'),

(592,'Sagar','Karnataka','India','$CURRENTTIME'),

(593,'Sakleshpur','Karnataka','India','$CURRENTTIME'),

(594,'Sandur','Karnataka','India','$CURRENTTIME'),

(595,'Sankeshwar','Karnataka','India','$CURRENTTIME'),

(596,'Saundatti-Yellamma','Karnataka','India','$CURRENTTIME'),

(597,'Savanur','Karnataka','India','$CURRENTTIME'),

(598,'Sedam','Karnataka','India','$CURRENTTIME'),

(599,'Shahabad','Karnataka','India','$CURRENTTIME'),

(600,'Shahpur','Karnataka','India','$CURRENTTIME'),

(601,'Shiggaon','Karnataka','India','$CURRENTTIME'),

(602,'Shikapur','Karnataka','India','$CURRENTTIME'),

(603,'Shimoga','Karnataka','India','$CURRENTTIME'),

(604,'Shorapur','Karnataka','India','$CURRENTTIME'),

(605,'Shrirangapattana','Karnataka','India','$CURRENTTIME'),

(606,'Sidlaghatta','Karnataka','India','$CURRENTTIME'),

(607,'Sindgi','Karnataka','India','$CURRENTTIME'),

(608,'Sindhnur','Karnataka','India','$CURRENTTIME'),

(609,'Sira','Karnataka','India','$CURRENTTIME'),

(610,'Sirsi','Karnataka','India','$CURRENTTIME'),

(611,'Siruguppa','Karnataka','India','$CURRENTTIME'),

(612,'Srinivaspur','Karnataka','India','$CURRENTTIME'),

(613,'Talikota','Karnataka','India','$CURRENTTIME'),

(614,'Tarikere','Karnataka','India','$CURRENTTIME'),

(615,'Tekkalakota','Karnataka','India','$CURRENTTIME'),

(616,'Terdal','Karnataka','India','$CURRENTTIME'),

(617,'Tiptur','Karnataka','India','$CURRENTTIME'),

(618,'Tumkur','Karnataka','India','$CURRENTTIME'),

(619,'Udupi','Karnataka','India','$CURRENTTIME'),

(620,'Vijayapura','Karnataka','India','$CURRENTTIME'),

(621,'Wadi','Karnataka','India','$CURRENTTIME'),

(622,'Yadgir','Karnataka','India','$CURRENTTIME'),

(623,'Adoor','Kerala','India','$CURRENTTIME'),

(624,'Akathiyoor','Kerala','India','$CURRENTTIME'),

(625,'Alappuzha','Kerala','India','$CURRENTTIME'),

(626,'Ancharakandy','Kerala','India','$CURRENTTIME'),

(627,'Aroor','Kerala','India','$CURRENTTIME'),

(628,'Ashtamichira','Kerala','India','$CURRENTTIME'),

(629,'Attingal','Kerala','India','$CURRENTTIME'),

(630,'Avinissery','Kerala','India','$CURRENTTIME'),

(631,'Chalakudy','Kerala','India','$CURRENTTIME'),

(632,'Changanassery','Kerala','India','$CURRENTTIME'),

(633,'Chendamangalam','Kerala','India','$CURRENTTIME'),

(634,'Chengannur','Kerala','India','$CURRENTTIME'),

(635,'Cherthala','Kerala','India','$CURRENTTIME'),

(636,'Cheruthazham','Kerala','India','$CURRENTTIME'),

(637,'Chittur-Thathamangalam','Kerala','India','$CURRENTTIME'),

(638,'Chockli','Kerala','India','$CURRENTTIME'),

(639,'Erattupetta','Kerala','India','$CURRENTTIME'),

(640,'Guruvayoor','Kerala','India','$CURRENTTIME'),

(641,'Irinjalakuda','Kerala','India','$CURRENTTIME'),

(642,'Kadirur','Kerala','India','$CURRENTTIME'),

(643,'Kalliasseri','Kerala','India','$CURRENTTIME'),

(644,'Kalpetta','Kerala','India','$CURRENTTIME'),

(645,'Kanhangad','Kerala','India','$CURRENTTIME'),

(646,'Kanjikkuzhi','Kerala','India','$CURRENTTIME'),

(647,'Kannur','Kerala','India','$CURRENTTIME'),

(648,'Kasaragod','Kerala','India','$CURRENTTIME'),

(649,'Kayamkulam','Kerala','India','$CURRENTTIME'),

(650,'Kochi','Kerala','India','$CURRENTTIME'),

(651,'Kodungallur','Kerala','India','$CURRENTTIME'),

(652,'Kollam','Kerala','India','$CURRENTTIME'),

(653,'Koothuparamba','Kerala','India','$CURRENTTIME'),

(654,'Kothamangalam','Kerala','India','$CURRENTTIME'),

(655,'Kottayam','Kerala','India','$CURRENTTIME'),

(656,'Kozhikode','Kerala','India','$CURRENTTIME'),

(657,'Kunnamkulam','Kerala','India','$CURRENTTIME'),

(658,'Malappuram','Kerala','India','$CURRENTTIME'),

(659,'Mattannur','Kerala','India','$CURRENTTIME'),

(660,'Mavelikkara','Kerala','India','$CURRENTTIME'),

(661,'Mavoor','Kerala','India','$CURRENTTIME'),

(662,'Muvattupuzha','Kerala','India','$CURRENTTIME'),

(663,'Nedumangad','Kerala','India','$CURRENTTIME'),

(664,'Neyyattinkara','Kerala','India','$CURRENTTIME'),

(665,'Ottappalam','Kerala','India','$CURRENTTIME'),

(666,'Palai','Kerala','India','$CURRENTTIME'),

(667,'Palakkad','Kerala','India','$CURRENTTIME'),

(668,'Panniyannur','Kerala','India','$CURRENTTIME'),

(669,'Pappinisseri','Kerala','India','$CURRENTTIME'),

(670,'Paravoor','Kerala','India','$CURRENTTIME'),

(671,'Pathanamthitta','Kerala','India','$CURRENTTIME'),

(672,'Payyannur','Kerala','India','$CURRENTTIME'),

(673,'Peringathur','Kerala','India','$CURRENTTIME'),

(674,'Perinthalmanna','Kerala','India','$CURRENTTIME'),

(675,'Perumbavoor','Kerala','India','$CURRENTTIME'),

(676,'Ponnani','Kerala','India','$CURRENTTIME'),

(677,'Punalur','Kerala','India','$CURRENTTIME'),

(678,'Quilandy','Kerala','India','$CURRENTTIME'),

(679,'Shoranur','Kerala','India','$CURRENTTIME'),

(680,'Taliparamba','Kerala','India','$CURRENTTIME'),

(681,'Thiruvalla','Kerala','India','$CURRENTTIME'),

(682,'Thiruvananthapuram','Kerala','India','$CURRENTTIME'),

(683,'Thodupuzha','Kerala','India','$CURRENTTIME'),

(684,'Thrissur','Kerala','India','$CURRENTTIME'),

(685,'Tirur','Kerala','India','$CURRENTTIME'),

(686,'Vadakara','Kerala','India','$CURRENTTIME'),

(687,'Vaikom','Kerala','India','$CURRENTTIME'),

(688,'Varkala','Kerala','India','$CURRENTTIME'),

(689,'Kavaratti','Lakshadweep','India','$CURRENTTIME'),

(690,'Ashok Nagar','Madhya Pradesh','India','$CURRENTTIME'),

(691,'Balaghat','Madhya Pradesh','India','$CURRENTTIME'),

(692,'Betul','Madhya Pradesh','India','$CURRENTTIME'),

(693,'Bhopal','Madhya Pradesh','India','$CURRENTTIME'),

(694,'Burhanpur','Madhya Pradesh','India','$CURRENTTIME'),

(695,'Chhatarpur','Madhya Pradesh','India','$CURRENTTIME'),

(696,'Dabra','Madhya Pradesh','India','$CURRENTTIME'),

(697,'Datia','Madhya Pradesh','India','$CURRENTTIME'),

(698,'Dewas','Madhya Pradesh','India','$CURRENTTIME'),

(699,'Dhar','Madhya Pradesh','India','$CURRENTTIME'),

(700,'Fatehabad','Madhya Pradesh','India','$CURRENTTIME'),

(701,'Gwalior','Madhya Pradesh','India','$CURRENTTIME'),

(702,'Indore','Madhya Pradesh','India','$CURRENTTIME'),

(703,'Itarsi','Madhya Pradesh','India','$CURRENTTIME'),

(704,'Jabalpur','Madhya Pradesh','India','$CURRENTTIME'),

(705,'Katni','Madhya Pradesh','India','$CURRENTTIME'),

(706,'Kotma','Madhya Pradesh','India','$CURRENTTIME'),

(707,'Lahar','Madhya Pradesh','India','$CURRENTTIME'),

(708,'Lundi','Madhya Pradesh','India','$CURRENTTIME'),

(709,'Maharajpur','Madhya Pradesh','India','$CURRENTTIME'),

(710,'Mahidpur','Madhya Pradesh','India','$CURRENTTIME'),

(711,'Maihar','Madhya Pradesh','India','$CURRENTTIME'),

(712,'Malajkhand','Madhya Pradesh','India','$CURRENTTIME'),

(713,'Manasa','Madhya Pradesh','India','$CURRENTTIME'),

(714,'Manawar','Madhya Pradesh','India','$CURRENTTIME'),

(715,'Mandideep','Madhya Pradesh','India','$CURRENTTIME'),

(716,'Mandla','Madhya Pradesh','India','$CURRENTTIME'),

(717,'Mandsaur','Madhya Pradesh','India','$CURRENTTIME'),

(718,'Mauganj','Madhya Pradesh','India','$CURRENTTIME'),

(719,'Mhow Cantonment','Madhya Pradesh','India','$CURRENTTIME'),

(720,'Mhowgaon','Madhya Pradesh','India','$CURRENTTIME'),

(721,'Morena','Madhya Pradesh','India','$CURRENTTIME'),

(722,'Multai','Madhya Pradesh','India','$CURRENTTIME'),

(723,'Murwara','Madhya Pradesh','India','$CURRENTTIME'),

(724,'Nagda','Madhya Pradesh','India','$CURRENTTIME'),

(725,'Nainpur','Madhya Pradesh','India','$CURRENTTIME'),

(726,'Narsinghgarh','Madhya Pradesh','India','$CURRENTTIME'),

(727,'Narsinghgarh','Madhya Pradesh','India','$CURRENTTIME'),

(728,'Neemuch','Madhya Pradesh','India','$CURRENTTIME'),

(729,'Nepanagar','Madhya Pradesh','India','$CURRENTTIME'),

(730,'Niwari','Madhya Pradesh','India','$CURRENTTIME'),

(731,'Nowgong','Madhya Pradesh','India','$CURRENTTIME'),

(732,'Nowrozabad','Madhya Pradesh','India','$CURRENTTIME'),

(733,'Pachore','Madhya Pradesh','India','$CURRENTTIME'),

(734,'Pali','Madhya Pradesh','India','$CURRENTTIME'),

(735,'Panagar','Madhya Pradesh','India','$CURRENTTIME'),

(736,'Pandhurna','Madhya Pradesh','India','$CURRENTTIME'),

(737,'Panna','Madhya Pradesh','India','$CURRENTTIME'),

(738,'Pasan','Madhya Pradesh','India','$CURRENTTIME'),

(739,'Pipariya','Madhya Pradesh','India','$CURRENTTIME'),

(740,'Pithampur','Madhya Pradesh','India','$CURRENTTIME'),

(741,'Porsa','Madhya Pradesh','India','$CURRENTTIME'),

(742,'Prithvipur','Madhya Pradesh','India','$CURRENTTIME'),

(743,'Raghogarh-Vijaypur','Madhya Pradesh','India','$CURRENTTIME'),

(744,'Rahatgarh','Madhya Pradesh','India','$CURRENTTIME'),

(745,'Raisen','Madhya Pradesh','India','$CURRENTTIME'),

(746,'Rajgarh','Madhya Pradesh','India','$CURRENTTIME'),

(747,'Ratlam','Madhya Pradesh','India','$CURRENTTIME'),

(748,'Rau','Madhya Pradesh','India','$CURRENTTIME'),

(749,'Rehli','Madhya Pradesh','India','$CURRENTTIME'),

(750,'Rewa','Madhya Pradesh','India','$CURRENTTIME'),

(751,'Sabalgarh','Madhya Pradesh','India','$CURRENTTIME'),

(752,'Sagar','Madhya Pradesh','India','$CURRENTTIME'),

(753,'Sanawad','Madhya Pradesh','India','$CURRENTTIME'),

(754,'Sarangpur','Madhya Pradesh','India','$CURRENTTIME'),

(755,'Sarni','Madhya Pradesh','India','$CURRENTTIME'),

(756,'Satna','Madhya Pradesh','India','$CURRENTTIME'),

(757,'Sausar','Madhya Pradesh','India','$CURRENTTIME'),

(758,'Sehore','Madhya Pradesh','India','$CURRENTTIME'),

(759,'Sendhwa','Madhya Pradesh','India','$CURRENTTIME'),

(760,'Seoni','Madhya Pradesh','India','$CURRENTTIME'),

(761,'Seoni-Malwa','Madhya Pradesh','India','$CURRENTTIME'),

(762,'Shahdol','Madhya Pradesh','India','$CURRENTTIME'),

(763,'Shajapur','Madhya Pradesh','India','$CURRENTTIME'),

(764,'Shamgarh','Madhya Pradesh','India','$CURRENTTIME'),

(765,'Sheopur','Madhya Pradesh','India','$CURRENTTIME'),

(766,'Shivpuri','Madhya Pradesh','India','$CURRENTTIME'),

(767,'Shujalpur','Madhya Pradesh','India','$CURRENTTIME'),

(768,'Sidhi','Madhya Pradesh','India','$CURRENTTIME'),

(769,'Sihora','Madhya Pradesh','India','$CURRENTTIME'),

(770,'Singrauli','Madhya Pradesh','India','$CURRENTTIME'),

(771,'Sironj','Madhya Pradesh','India','$CURRENTTIME'),

(772,'Sohagpur','Madhya Pradesh','India','$CURRENTTIME'),

(773,'Tarana','Madhya Pradesh','India','$CURRENTTIME'),

(774,'Tikamgarh','Madhya Pradesh','India','$CURRENTTIME'),

(775,'Ujhani','Madhya Pradesh','India','$CURRENTTIME'),

(776,'Ujjain','Madhya Pradesh','India','$CURRENTTIME'),

(777,'Umaria','Madhya Pradesh','India','$CURRENTTIME'),

(778,'Vidisha','Madhya Pradesh','India','$CURRENTTIME'),

(779,'Wara Seoni','Madhya Pradesh','India','$CURRENTTIME'),

(780,'Kolhapur','Maharashtra','India','$CURRENTTIME'),

(781,'Ahmednagar','Maharashtra','India','$CURRENTTIME'),

(782,'Akola','Maharashtra','India','$CURRENTTIME'),

(783,'Amravati','Maharashtra','India','$CURRENTTIME'),

(784,'Aurangabad','Maharashtra','India','$CURRENTTIME'),

(785,'Baramati','Maharashtra','India','$CURRENTTIME'),

(786,'Chalisgaon','Maharashtra','India','$CURRENTTIME'),

(787,'Chinchani','Maharashtra','India','$CURRENTTIME'),

(788,'Devgarh','Maharashtra','India','$CURRENTTIME'),

(789,'Dhule','Maharashtra','India','$CURRENTTIME'),

(790,'Dombivli','Maharashtra','India','$CURRENTTIME'),

(791,'Durgapur','Maharashtra','India','$CURRENTTIME'),

(792,'Ichalkaranji','Maharashtra','India','$CURRENTTIME'),

(793,'Jalna','Maharashtra','India','$CURRENTTIME'),

(794,'Kalyan','Maharashtra','India','$CURRENTTIME'),

(795,'Latur','Maharashtra','India','$CURRENTTIME'),

(796,'Loha','Maharashtra','India','$CURRENTTIME'),

(797,'Lonar','Maharashtra','India','$CURRENTTIME'),

(798,'Lonavla','Maharashtra','India','$CURRENTTIME'),

(799,'Mahad','Maharashtra','India','$CURRENTTIME'),

(800,'Mahuli','Maharashtra','India','$CURRENTTIME'),

(801,'Malegaon','Maharashtra','India','$CURRENTTIME'),

(802,'Malkapur','Maharashtra','India','$CURRENTTIME'),

(803,'Manchar','Maharashtra','India','$CURRENTTIME'),

(804,'Mangalvedhe','Maharashtra','India','$CURRENTTIME'),

(805,'Mangrulpir','Maharashtra','India','$CURRENTTIME'),

(806,'Manjlegaon','Maharashtra','India','$CURRENTTIME'),

(807,'Manmad','Maharashtra','India','$CURRENTTIME'),

(808,'Manwath','Maharashtra','India','$CURRENTTIME'),

(809,'Mehkar','Maharashtra','India','$CURRENTTIME'),

(810,'Mhaswad','Maharashtra','India','$CURRENTTIME'),

(811,'Miraj','Maharashtra','India','$CURRENTTIME'),

(812,'Morshi','Maharashtra','India','$CURRENTTIME'),

(813,'Mukhed','Maharashtra','India','$CURRENTTIME'),

(814,'Mul','Maharashtra','India','$CURRENTTIME'),

(815,'Mumbai','Maharashtra','India','$CURRENTTIME'),

(816,'Murtijapur','Maharashtra','India','$CURRENTTIME'),

(817,'Nagpur','Maharashtra','India','$CURRENTTIME'),

(818,'Nalasopara','Maharashtra','India','$CURRENTTIME'),

(819,'Nanded-Waghala','Maharashtra','India','$CURRENTTIME'),

(820,'Nandgaon','Maharashtra','India','$CURRENTTIME'),

(821,'Nandura','Maharashtra','India','$CURRENTTIME'),

(822,'Nandurbar','Maharashtra','India','$CURRENTTIME'),

(823,'Narkhed','Maharashtra','India','$CURRENTTIME'),

(824,'Nashik','Maharashtra','India','$CURRENTTIME'),

(825,'Navi Mumbai','Maharashtra','India','$CURRENTTIME'),

(826,'Nawapur','Maharashtra','India','$CURRENTTIME'),

(827,'Nilanga','Maharashtra','India','$CURRENTTIME'),

(828,'Osmanabad','Maharashtra','India','$CURRENTTIME'),

(829,'Ozar','Maharashtra','India','$CURRENTTIME'),

(830,'Pachora','Maharashtra','India','$CURRENTTIME'),

(831,'Paithan','Maharashtra','India','$CURRENTTIME'),

(832,'Palghar','Maharashtra','India','$CURRENTTIME'),

(833,'Pandharkaoda','Maharashtra','India','$CURRENTTIME'),

(834,'Pandharpur','Maharashtra','India','$CURRENTTIME'),

(835,'Panvel','Maharashtra','India','$CURRENTTIME'),

(836,'Parbhani','Maharashtra','India','$CURRENTTIME'),

(837,'Parli','Maharashtra','India','$CURRENTTIME'),

(838,'Parola','Maharashtra','India','$CURRENTTIME'),

(839,'Partur','Maharashtra','India','$CURRENTTIME'),

(840,'Pathardi','Maharashtra','India','$CURRENTTIME'),

(841,'Pathri','Maharashtra','India','$CURRENTTIME'),

(842,'Patur','Maharashtra','India','$CURRENTTIME'),

(843,'Pauni','Maharashtra','India','$CURRENTTIME'),

(844,'Pen','Maharashtra','India','$CURRENTTIME'),

(845,'Phaltan','Maharashtra','India','$CURRENTTIME'),

(846,'Pulgaon','Maharashtra','India','$CURRENTTIME'),

(847,'Pune','Maharashtra','India','$CURRENTTIME'),

(848,'Purna','Maharashtra','India','$CURRENTTIME'),

(849,'Pusad','Maharashtra','India','$CURRENTTIME'),

(850,'Rahuri','Maharashtra','India','$CURRENTTIME'),

(851,'Rajura','Maharashtra','India','$CURRENTTIME'),

(852,'Ramtek','Maharashtra','India','$CURRENTTIME'),

(853,'Ratnagiri','Maharashtra','India','$CURRENTTIME'),

(854,'Raver','Maharashtra','India','$CURRENTTIME'),

(855,'Risod','Maharashtra','India','$CURRENTTIME'),

(856,'Sailu','Maharashtra','India','$CURRENTTIME'),

(857,'Sangamner','Maharashtra','India','$CURRENTTIME'),

(858,'Sangli','Maharashtra','India','$CURRENTTIME'),

(859,'Sangole','Maharashtra','India','$CURRENTTIME'),

(860,'Sasvad','Maharashtra','India','$CURRENTTIME'),

(861,'Satana','Maharashtra','India','$CURRENTTIME'),

(862,'Satara','Maharashtra','India','$CURRENTTIME'),

(863,'Savner','Maharashtra','India','$CURRENTTIME'),

(864,'Sawantwadi','Maharashtra','India','$CURRENTTIME'),

(865,'Shahade','Maharashtra','India','$CURRENTTIME'),

(866,'Shegaon','Maharashtra','India','$CURRENTTIME'),

(867,'Shendurjana','Maharashtra','India','$CURRENTTIME'),

(868,'Shirdi','Maharashtra','India','$CURRENTTIME'),

(869,'Shirpur-Warwade','Maharashtra','India','$CURRENTTIME'),

(870,'Shirur','Maharashtra','India','$CURRENTTIME'),

(871,'Shrigonda','Maharashtra','India','$CURRENTTIME'),

(872,'Shrirampur','Maharashtra','India','$CURRENTTIME'),

(873,'Sillod','Maharashtra','India','$CURRENTTIME'),

(874,'Sinnar','Maharashtra','India','$CURRENTTIME'),

(875,'Solapur','Maharashtra','India','$CURRENTTIME'),

(876,'Soyagaon','Maharashtra','India','$CURRENTTIME'),

(877,'Talegaon Dabhade','Maharashtra','India','$CURRENTTIME'),

(878,'Talode','Maharashtra','India','$CURRENTTIME'),

(879,'Tasgaon','Maharashtra','India','$CURRENTTIME'),

(880,'Tirora','Maharashtra','India','$CURRENTTIME'),

(881,'Tuljapur','Maharashtra','India','$CURRENTTIME'),

(882,'Tumsar','Maharashtra','India','$CURRENTTIME'),

(883,'Uran','Maharashtra','India','$CURRENTTIME'),

(884,'Uran Islampur','Maharashtra','India','$CURRENTTIME'),

(885,'Wadgaon Road','Maharashtra','India','$CURRENTTIME'),

(886,'Wai','Maharashtra','India','$CURRENTTIME'),

(887,'Wani','Maharashtra','India','$CURRENTTIME'),

(888,'Wardha','Maharashtra','India','$CURRENTTIME'),

(889,'Warora','Maharashtra','India','$CURRENTTIME'),

(890,'Warud','Maharashtra','India','$CURRENTTIME'),

(891,'Washim','Maharashtra','India','$CURRENTTIME'),

(892,'Yevla','Maharashtra','India','$CURRENTTIME'),

(893,'Uchgaon','Maharastra','India','$CURRENTTIME'),

(894,'Udgir','Maharastra','India','$CURRENTTIME'),

(895,'Umarga','Maharastra','India','$CURRENTTIME'),

(896,'Umarkhed','Maharastra','India','$CURRENTTIME'),

(897,'Umred','Maharastra','India','$CURRENTTIME'),

(898,'Vadgaon Kasba','Maharastra','India','$CURRENTTIME'),

(899,'Vaijapur','Maharastra','India','$CURRENTTIME'),

(900,'Vasai','Maharastra','India','$CURRENTTIME'),

(901,'Virar','Maharastra','India','$CURRENTTIME'),

(902,'Vita','Maharastra','India','$CURRENTTIME'),

(903,'Yavatmal','Maharastra','India','$CURRENTTIME'),

(904,'Yawal','Maharastra','India','$CURRENTTIME'),

(905,'Imphal','Manipur','India','$CURRENTTIME'),

(906,'Kakching','Manipur','India','$CURRENTTIME'),

(907,'Lilong','Manipur','India','$CURRENTTIME'),

(908,'Mayang Imphal','Manipur','India','$CURRENTTIME'),

(909,'Thoubal','Manipur','India','$CURRENTTIME'),

(910,'Jowai','Meghalaya','India','$CURRENTTIME'),

(911,'Nongstoin','Meghalaya','India','$CURRENTTIME'),

(912,'Shillong','Meghalaya','India','$CURRENTTIME'),

(913,'Tura','Meghalaya','India','$CURRENTTIME'),

(914,'Aizawl','Mizoram','India','$CURRENTTIME'),

(915,'Champhai','Mizoram','India','$CURRENTTIME'),

(916,'Lunglei','Mizoram','India','$CURRENTTIME'),

(917,'Saiha','Mizoram','India','$CURRENTTIME'),

(918,'Dimapur','Nagaland','India','$CURRENTTIME'),

(919,'Kohima','Nagaland','India','$CURRENTTIME'),

(920,'Mokokchung','Nagaland','India','$CURRENTTIME'),

(921,'Tuensang','Nagaland','India','$CURRENTTIME'),

(922,'Wokha','Nagaland','India','$CURRENTTIME'),

(923,'Zunheboto','Nagaland','India','$CURRENTTIME'),

(924,'Anandapur','Orissa','India','$CURRENTTIME'),

(925,'Anugul','Orissa','India','$CURRENTTIME'),

(926,'Asika','Orissa','India','$CURRENTTIME'),

(927,'Balangir','Orissa','India','$CURRENTTIME'),

(928,'Balasore','Orissa','India','$CURRENTTIME'),

(929,'Baleshwar','Orissa','India','$CURRENTTIME'),

(930,'Bamra','Orissa','India','$CURRENTTIME'),

(931,'Barbil','Orissa','India','$CURRENTTIME'),

(932,'Bargarh','Orissa','India','$CURRENTTIME'),

(933,'Bargarh','Orissa','India','$CURRENTTIME'),

(934,'Baripada','Orissa','India','$CURRENTTIME'),

(935,'Basudebpur','Orissa','India','$CURRENTTIME'),

(936,'Belpahar','Orissa','India','$CURRENTTIME'),

(937,'Bhadrak','Orissa','India','$CURRENTTIME'),

(938,'Bhawanipatna','Orissa','India','$CURRENTTIME'),

(939,'Bhuban','Orissa','India','$CURRENTTIME'),

(940,'Bhubaneswar','Orissa','India','$CURRENTTIME'),

(941,'Biramitrapur','Orissa','India','$CURRENTTIME'),

(942,'Brahmapur','Orissa','India','$CURRENTTIME'),

(943,'Brajrajnagar','Orissa','India','$CURRENTTIME'),

(944,'Byasanagar','Orissa','India','$CURRENTTIME'),

(945,'Cuttack','Orissa','India','$CURRENTTIME'),

(946,'Debagarh','Orissa','India','$CURRENTTIME'),

(947,'Dhenkanal','Orissa','India','$CURRENTTIME'),

(948,'Gunupur','Orissa','India','$CURRENTTIME'),

(949,'Hinjilicut','Orissa','India','$CURRENTTIME'),

(950,'Jagatsinghapur','Orissa','India','$CURRENTTIME'),

(951,'Jajapur','Orissa','India','$CURRENTTIME'),

(952,'Jaleswar','Orissa','India','$CURRENTTIME'),

(953,'Jatani','Orissa','India','$CURRENTTIME'),

(954,'Jeypur','Orissa','India','$CURRENTTIME'),

(955,'Jharsuguda','Orissa','India','$CURRENTTIME'),

(956,'Joda','Orissa','India','$CURRENTTIME'),

(957,'Kantabanji','Orissa','India','$CURRENTTIME'),

(958,'Karanjia','Orissa','India','$CURRENTTIME'),

(959,'Kendrapara','Orissa','India','$CURRENTTIME'),

(960,'Kendujhar','Orissa','India','$CURRENTTIME'),

(961,'Khordha','Orissa','India','$CURRENTTIME'),

(962,'Koraput','Orissa','India','$CURRENTTIME'),

(963,'Malkangiri','Orissa','India','$CURRENTTIME'),

(964,'Nabarangapur','Orissa','India','$CURRENTTIME'),

(965,'Paradip','Orissa','India','$CURRENTTIME'),

(966,'Parlakhemundi','Orissa','India','$CURRENTTIME'),

(967,'Pattamundai','Orissa','India','$CURRENTTIME'),

(968,'Phulabani','Orissa','India','$CURRENTTIME'),

(969,'Puri','Orissa','India','$CURRENTTIME'),

(970,'Rairangpur','Orissa','India','$CURRENTTIME'),

(971,'Rajagangapur','Orissa','India','$CURRENTTIME'),

(972,'Raurkela','Orissa','India','$CURRENTTIME'),

(973,'Rayagada','Orissa','India','$CURRENTTIME'),

(974,'Sambalpur','Orissa','India','$CURRENTTIME'),

(975,'Soro','Orissa','India','$CURRENTTIME'),

(976,'Sunabeda','Orissa','India','$CURRENTTIME'),

(977,'Sundargarh','Orissa','India','$CURRENTTIME'),

(978,'Talcher','Orissa','India','$CURRENTTIME'),

(979,'Titlagarh','Orissa','India','$CURRENTTIME'),

(980,'Umarkote','Orissa','India','$CURRENTTIME'),

(981,'Karaikal','Pondicherry','India','$CURRENTTIME'),

(982,'Mahe','Pondicherry','India','$CURRENTTIME'),

(983,'Pondicherry','Pondicherry','India','$CURRENTTIME'),

(984,'Yanam','Pondicherry','India','$CURRENTTIME'),

(985,'Ahmedgarh','Punjab','India','$CURRENTTIME'),

(986,'Amritsar','Punjab','India','$CURRENTTIME'),

(987,'Barnala','Punjab','India','$CURRENTTIME'),

(988,'Batala','Punjab','India','$CURRENTTIME'),

(989,'Bathinda','Punjab','India','$CURRENTTIME'),

(990,'Bhagha Purana','Punjab','India','$CURRENTTIME'),

(991,'Budhlada','Punjab','India','$CURRENTTIME'),

(992,'Chandigarh','Punjab','India','$CURRENTTIME'),

(993,'Dasua','Punjab','India','$CURRENTTIME'),

(994,'Dhuri','Punjab','India','$CURRENTTIME'),

(995,'Dinanagar','Punjab','India','$CURRENTTIME'),

(996,'Faridkot','Punjab','India','$CURRENTTIME'),

(997,'Fazilka','Punjab','India','$CURRENTTIME'),

(998,'Firozpur','Punjab','India','$CURRENTTIME'),

(999,'Firozpur Cantt.','Punjab','India','$CURRENTTIME'),

(1000,'Giddarbaha','Punjab','India','$CURRENTTIME'),

(1001,'Gobindgarh','Punjab','India','$CURRENTTIME'),

(1002,'Gurdaspur','Punjab','India','$CURRENTTIME'),

(1003,'Hoshiarpur','Punjab','India','$CURRENTTIME'),

(1004,'Jagraon','Punjab','India','$CURRENTTIME'),

(1005,'Jaitu','Punjab','India','$CURRENTTIME'),

(1006,'Jalalabad','Punjab','India','$CURRENTTIME'),

(1007,'Jalandhar','Punjab','India','$CURRENTTIME'),

(1008,'Jalandhar Cantt.','Punjab','India','$CURRENTTIME'),

(1009,'Jandiala','Punjab','India','$CURRENTTIME'),

(1010,'Kapurthala','Punjab','India','$CURRENTTIME'),

(1011,'Karoran','Punjab','India','$CURRENTTIME'),

(1012,'Kartarpur','Punjab','India','$CURRENTTIME'),

(1013,'Khanna','Punjab','India','$CURRENTTIME'),

(1014,'Kharar','Punjab','India','$CURRENTTIME'),

(1015,'Kot Kapura','Punjab','India','$CURRENTTIME'),

(1016,'Kurali','Punjab','India','$CURRENTTIME'),

(1017,'Longowal','Punjab','India','$CURRENTTIME'),

(1018,'Ludhiana','Punjab','India','$CURRENTTIME'),

(1019,'Malerkotla','Punjab','India','$CURRENTTIME'),

(1020,'Malout','Punjab','India','$CURRENTTIME'),

(1021,'Mansa','Punjab','India','$CURRENTTIME'),

(1022,'Maur','Punjab','India','$CURRENTTIME'),

(1023,'Moga','Punjab','India','$CURRENTTIME'),

(1024,'Mohali','Punjab','India','$CURRENTTIME'),

(1025,'Morinda','Punjab','India','$CURRENTTIME'),

(1026,'Mukerian','Punjab','India','$CURRENTTIME'),

(1027,'Muktsar','Punjab','India','$CURRENTTIME'),

(1028,'Nabha','Punjab','India','$CURRENTTIME'),

(1029,'Nakodar','Punjab','India','$CURRENTTIME'),

(1030,'Nangal','Punjab','India','$CURRENTTIME'),

(1031,'Nawanshahr','Punjab','India','$CURRENTTIME'),

(1032,'Pathankot','Punjab','India','$CURRENTTIME'),

(1033,'Patiala','Punjab','India','$CURRENTTIME'),

(1034,'Patran','Punjab','India','$CURRENTTIME'),

(1035,'Patti','Punjab','India','$CURRENTTIME'),

(1036,'Phagwara','Punjab','India','$CURRENTTIME'),

(1037,'Phillaur','Punjab','India','$CURRENTTIME'),

(1038,'Qadian','Punjab','India','$CURRENTTIME'),

(1039,'Raikot','Punjab','India','$CURRENTTIME'),

(1040,'Rajpura','Punjab','India','$CURRENTTIME'),

(1041,'Rampura Phul','Punjab','India','$CURRENTTIME'),

(1042,'Rupnagar','Punjab','India','$CURRENTTIME'),

(1043,'Samana','Punjab','India','$CURRENTTIME'),

(1044,'Sangrur','Punjab','India','$CURRENTTIME'),

(1045,'Sirhind Fatehgarh Sahib','Punjab','India','$CURRENTTIME'),

(1046,'Sujanpur','Punjab','India','$CURRENTTIME'),

(1047,'Sunam','Punjab','India','$CURRENTTIME'),

(1048,'Talwara','Punjab','India','$CURRENTTIME'),

(1049,'Tarn Taran','Punjab','India','$CURRENTTIME'),

(1050,'Urmar Tanda','Punjab','India','$CURRENTTIME'),

(1051,'Zira','Punjab','India','$CURRENTTIME'),

(1052,'Zirakpur','Punjab','India','$CURRENTTIME'),

(1053,'Bali','Rajastan','India','$CURRENTTIME'),

(1054,'Banswara','Rajastan','India','$CURRENTTIME'),

(1055,'Ajmer','Rajasthan','India','$CURRENTTIME'),

(1056,'Alwar','Rajasthan','India','$CURRENTTIME'),

(1057,'Bandikui','Rajasthan','India','$CURRENTTIME'),

(1058,'Baran','Rajasthan','India','$CURRENTTIME'),

(1059,'Barmer','Rajasthan','India','$CURRENTTIME'),

(1060,'Bikaner','Rajasthan','India','$CURRENTTIME'),

(1061,'Fatehpur','Rajasthan','India','$CURRENTTIME'),

(1062,'Jaipur','Rajasthan','India','$CURRENTTIME'),

(1063,'Jaisalmer','Rajasthan','India','$CURRENTTIME'),

(1064,'Jodhpur','Rajasthan','India','$CURRENTTIME'),

(1065,'Kota','Rajasthan','India','$CURRENTTIME'),

(1066,'Lachhmangarh','Rajasthan','India','$CURRENTTIME'),

(1067,'Ladnu','Rajasthan','India','$CURRENTTIME'),

(1068,'Lakheri','Rajasthan','India','$CURRENTTIME'),

(1069,'Lalsot','Rajasthan','India','$CURRENTTIME'),

(1070,'Losal','Rajasthan','India','$CURRENTTIME'),

(1071,'Makrana','Rajasthan','India','$CURRENTTIME'),

(1072,'Malpura','Rajasthan','India','$CURRENTTIME'),

(1073,'Mandalgarh','Rajasthan','India','$CURRENTTIME'),

(1074,'Mandawa','Rajasthan','India','$CURRENTTIME'),

(1075,'Mangrol','Rajasthan','India','$CURRENTTIME'),

(1076,'Merta City','Rajasthan','India','$CURRENTTIME'),

(1077,'Mount Abu','Rajasthan','India','$CURRENTTIME'),

(1078,'Nadbai','Rajasthan','India','$CURRENTTIME'),

(1079,'Nagar','Rajasthan','India','$CURRENTTIME'),

(1080,'Nagaur','Rajasthan','India','$CURRENTTIME'),

(1081,'Nargund','Rajasthan','India','$CURRENTTIME'),

(1082,'Nasirabad','Rajasthan','India','$CURRENTTIME'),

(1083,'Nathdwara','Rajasthan','India','$CURRENTTIME'),

(1084,'Navalgund','Rajasthan','India','$CURRENTTIME'),

(1085,'Nawalgarh','Rajasthan','India','$CURRENTTIME'),

(1086,'Neem-Ka-Thana','Rajasthan','India','$CURRENTTIME'),

(1087,'Nelamangala','Rajasthan','India','$CURRENTTIME'),

(1088,'Nimbahera','Rajasthan','India','$CURRENTTIME'),

(1089,'Nipani','Rajasthan','India','$CURRENTTIME'),

(1090,'Niwai','Rajasthan','India','$CURRENTTIME'),

(1091,'Nohar','Rajasthan','India','$CURRENTTIME'),

(1092,'Nokha','Rajasthan','India','$CURRENTTIME'),

(1093,'Pali','Rajasthan','India','$CURRENTTIME'),

(1094,'Phalodi','Rajasthan','India','$CURRENTTIME'),

(1095,'Phulera','Rajasthan','India','$CURRENTTIME'),

(1096,'Pilani','Rajasthan','India','$CURRENTTIME'),

(1097,'Pilibanga','Rajasthan','India','$CURRENTTIME'),

(1098,'Pindwara','Rajasthan','India','$CURRENTTIME'),

(1099,'Pipar City','Rajasthan','India','$CURRENTTIME'),

(1100,'Prantij','Rajasthan','India','$CURRENTTIME'),

(1101,'Pratapgarh','Rajasthan','India','$CURRENTTIME'),

(1102,'Raisinghnagar','Rajasthan','India','$CURRENTTIME'),

(1103,'Rajakhera','Rajasthan','India','$CURRENTTIME'),

(1104,'Rajaldesar','Rajasthan','India','$CURRENTTIME'),

(1105,'Rajgarh (Alwar)','Rajasthan','India','$CURRENTTIME'),

(1106,'Rajgarh (Churu','Rajasthan','India','$CURRENTTIME'),

(1107,'Rajsamand','Rajasthan','India','$CURRENTTIME'),

(1108,'Ramganj Mandi','Rajasthan','India','$CURRENTTIME'),

(1109,'Ramngarh','Rajasthan','India','$CURRENTTIME'),

(1110,'Ratangarh','Rajasthan','India','$CURRENTTIME'),

(1111,'Rawatbhata','Rajasthan','India','$CURRENTTIME'),

(1112,'Rawatsar','Rajasthan','India','$CURRENTTIME'),

(1113,'Reengus','Rajasthan','India','$CURRENTTIME'),

(1114,'Sadri','Rajasthan','India','$CURRENTTIME'),

(1115,'Sadulshahar','Rajasthan','India','$CURRENTTIME'),

(1116,'Sagwara','Rajasthan','India','$CURRENTTIME'),

(1117,'Sambhar','Rajasthan','India','$CURRENTTIME'),

(1118,'Sanchore','Rajasthan','India','$CURRENTTIME'),

(1119,'Sangaria','Rajasthan','India','$CURRENTTIME'),

(1120,'Sardarshahar','Rajasthan','India','$CURRENTTIME'),

(1121,'Sawai Madhopur','Rajasthan','India','$CURRENTTIME'),

(1122,'Shahpura','Rajasthan','India','$CURRENTTIME'),

(1123,'Shahpura','Rajasthan','India','$CURRENTTIME'),

(1124,'Sheoganj','Rajasthan','India','$CURRENTTIME'),

(1125,'Sikar','Rajasthan','India','$CURRENTTIME'),

(1126,'Sirohi','Rajasthan','India','$CURRENTTIME'),

(1127,'Sojat','Rajasthan','India','$CURRENTTIME'),

(1128,'Sri Madhopur','Rajasthan','India','$CURRENTTIME'),

(1129,'Sujangarh','Rajasthan','India','$CURRENTTIME'),

(1130,'Sumerpur','Rajasthan','India','$CURRENTTIME'),

(1131,'Suratgarh','Rajasthan','India','$CURRENTTIME'),

(1132,'Taranagar','Rajasthan','India','$CURRENTTIME'),

(1133,'Todabhim','Rajasthan','India','$CURRENTTIME'),

(1134,'Todaraisingh','Rajasthan','India','$CURRENTTIME'),

(1135,'Tonk','Rajasthan','India','$CURRENTTIME'),

(1136,'Udaipur','Rajasthan','India','$CURRENTTIME'),

(1137,'Udaipurwati','Rajasthan','India','$CURRENTTIME'),

(1138,'Vijainagar','Rajasthan','India','$CURRENTTIME'),

(1139,'Gangtok','Sikkim','India','$CURRENTTIME'),

(1140,'Calcutta','West Bengal','India','$CURRENTTIME'),

(1141,'Arakkonam','Tamil Nadu','India','$CURRENTTIME'),

(1142,'Arcot','Tamil Nadu','India','$CURRENTTIME'),

(1143,'Aruppukkottai','Tamil Nadu','India','$CURRENTTIME'),

(1144,'Bhavani','Tamil Nadu','India','$CURRENTTIME'),

(1145,'Chengalpattu','Tamil Nadu','India','$CURRENTTIME'),

(1146,'Chennai','Tamil Nadu','India','$CURRENTTIME'),

(1147,'Chinna salem','Tamil nadu','India','$CURRENTTIME'),

(1148,'Coimbatore','Tamil Nadu','India','$CURRENTTIME'),

(1149,'Coonoor','Tamil Nadu','India','$CURRENTTIME'),

(1150,'Cuddalore','Tamil Nadu','India','$CURRENTTIME'),

(1151,'Dharmapuri','Tamil Nadu','India','$CURRENTTIME'),

(1152,'Dindigul','Tamil Nadu','India','$CURRENTTIME'),

(1153,'Erode','Tamil Nadu','India','$CURRENTTIME'),

(1154,'Gudalur','Tamil Nadu','India','$CURRENTTIME'),

(1155,'Gudalur','Tamil Nadu','India','$CURRENTTIME'),

(1156,'Gudalur','Tamil Nadu','India','$CURRENTTIME'),

(1157,'Kanchipuram','Tamil Nadu','India','$CURRENTTIME'),

(1158,'Karaikudi','Tamil Nadu','India','$CURRENTTIME'),

(1159,'Karungal','Tamil Nadu','India','$CURRENTTIME'),

(1160,'Karur','Tamil Nadu','India','$CURRENTTIME'),

(1161,'Kollankodu','Tamil Nadu','India','$CURRENTTIME'),

(1162,'Lalgudi','Tamil Nadu','India','$CURRENTTIME'),

(1163,'Madurai','Tamil Nadu','India','$CURRENTTIME'),

(1164,'Nagapattinam','Tamil Nadu','India','$CURRENTTIME'),

(1165,'Nagercoil','Tamil Nadu','India','$CURRENTTIME'),

(1166,'Namagiripettai','Tamil Nadu','India','$CURRENTTIME'),

(1167,'Namakkal','Tamil Nadu','India','$CURRENTTIME'),

(1168,'Nandivaram-Guduvancheri','Tamil Nadu','India','$CURRENTTIME'),

(1169,'Nanjikottai','Tamil Nadu','India','$CURRENTTIME'),

(1170,'Natham','Tamil Nadu','India','$CURRENTTIME'),

(1171,'Nellikuppam','Tamil Nadu','India','$CURRENTTIME'),

(1172,'Neyveli','Tamil Nadu','India','$CURRENTTIME'),

(1173,'O\' Valley','Tamil Nadu','India','$CURRENTTIME'),

(1174,'Oddanchatram','Tamil Nadu','India','$CURRENTTIME'),

(1175,'P.N.Patti','Tamil Nadu','India','$CURRENTTIME'),

(1176,'Pacode','Tamil Nadu','India','$CURRENTTIME'),

(1177,'Padmanabhapuram','Tamil Nadu','India','$CURRENTTIME'),

(1178,'Palani','Tamil Nadu','India','$CURRENTTIME'),

(1179,'Palladam','Tamil Nadu','India','$CURRENTTIME'),

(1180,'Pallapatti','Tamil Nadu','India','$CURRENTTIME'),

(1181,'Pallikonda','Tamil Nadu','India','$CURRENTTIME'),

(1182,'Panagudi','Tamil Nadu','India','$CURRENTTIME'),

(1183,'Panruti','Tamil Nadu','India','$CURRENTTIME'),

(1184,'Paramakudi','Tamil Nadu','India','$CURRENTTIME'),

(1185,'Parangipettai','Tamil Nadu','India','$CURRENTTIME'),

(1186,'Pattukkottai','Tamil Nadu','India','$CURRENTTIME'),

(1187,'Perambalur','Tamil Nadu','India','$CURRENTTIME'),

(1188,'Peravurani','Tamil Nadu','India','$CURRENTTIME'),

(1189,'Periyakulam','Tamil Nadu','India','$CURRENTTIME'),

(1190,'Periyasemur','Tamil Nadu','India','$CURRENTTIME'),

(1191,'Pernampattu','Tamil Nadu','India','$CURRENTTIME'),

(1192,'Pollachi','Tamil Nadu','India','$CURRENTTIME'),

(1193,'Polur','Tamil Nadu','India','$CURRENTTIME'),

(1194,'Ponneri','Tamil Nadu','India','$CURRENTTIME'),

(1195,'Pudukkottai','Tamil Nadu','India','$CURRENTTIME'),

(1196,'Pudupattinam','Tamil Nadu','India','$CURRENTTIME'),

(1197,'Puliyankudi','Tamil Nadu','India','$CURRENTTIME'),

(1198,'Punjaipugalur','Tamil Nadu','India','$CURRENTTIME'),

(1199,'Rajapalayam','Tamil Nadu','India','$CURRENTTIME'),

(1200,'Ramanathapuram','Tamil Nadu','India','$CURRENTTIME'),

(1201,'Rameshwaram','Tamil Nadu','India','$CURRENTTIME'),

(1202,'Rasipuram','Tamil Nadu','India','$CURRENTTIME'),

(1203,'Salem','Tamil Nadu','India','$CURRENTTIME'),

(1204,'Sankarankoil','Tamil Nadu','India','$CURRENTTIME'),

(1205,'Sankari','Tamil Nadu','India','$CURRENTTIME'),

(1206,'Sathyamangalam','Tamil Nadu','India','$CURRENTTIME'),

(1207,'Sattur','Tamil Nadu','India','$CURRENTTIME'),

(1208,'Shenkottai','Tamil Nadu','India','$CURRENTTIME'),

(1209,'Sholavandan','Tamil Nadu','India','$CURRENTTIME'),

(1210,'Sholingur','Tamil Nadu','India','$CURRENTTIME'),

(1211,'Sirkali','Tamil Nadu','India','$CURRENTTIME'),

(1212,'Sivaganga','Tamil Nadu','India','$CURRENTTIME'),

(1213,'Sivagiri','Tamil Nadu','India','$CURRENTTIME'),

(1214,'Sivakasi','Tamil Nadu','India','$CURRENTTIME'),

(1215,'Srivilliputhur','Tamil Nadu','India','$CURRENTTIME'),

(1216,'Surandai','Tamil Nadu','India','$CURRENTTIME'),

(1217,'Suriyampalayam','Tamil Nadu','India','$CURRENTTIME'),

(1218,'Tenkasi','Tamil Nadu','India','$CURRENTTIME'),

(1219,'Thammampatti','Tamil Nadu','India','$CURRENTTIME'),

(1220,'Thanjavur','Tamil Nadu','India','$CURRENTTIME'),

(1221,'Tharamangalam','Tamil Nadu','India','$CURRENTTIME'),

(1222,'Tharangambadi','Tamil Nadu','India','$CURRENTTIME'),

(1223,'Theni Allinagaram','Tamil Nadu','India','$CURRENTTIME'),

(1224,'Thirumangalam','Tamil Nadu','India','$CURRENTTIME'),

(1225,'Thirunindravur','Tamil Nadu','India','$CURRENTTIME'),

(1226,'Thiruparappu','Tamil Nadu','India','$CURRENTTIME'),

(1227,'Thirupuvanam','Tamil Nadu','India','$CURRENTTIME'),

(1228,'Thiruthuraipoondi','Tamil Nadu','India','$CURRENTTIME'),

(1229,'Thiruvallur','Tamil Nadu','India','$CURRENTTIME'),

(1230,'Thiruvarur','Tamil Nadu','India','$CURRENTTIME'),

(1231,'Thoothukudi','Tamil Nadu','India','$CURRENTTIME'),

(1232,'Thuraiyur','Tamil Nadu','India','$CURRENTTIME'),

(1233,'Tindivanam','Tamil Nadu','India','$CURRENTTIME'),

(1234,'Tiruchendur','Tamil Nadu','India','$CURRENTTIME'),

(1235,'Tiruchengode','Tamil Nadu','India','$CURRENTTIME'),

(1236,'Tiruchirappalli','Tamil Nadu','India','$CURRENTTIME'),

(1237,'Tirukalukundram','Tamil Nadu','India','$CURRENTTIME'),

(1238,'Tirukkoyilur','Tamil Nadu','India','$CURRENTTIME'),

(1239,'Tirunelveli','Tamil Nadu','India','$CURRENTTIME'),

(1240,'Tirupathur','Tamil Nadu','India','$CURRENTTIME'),

(1241,'Tirupathur','Tamil Nadu','India','$CURRENTTIME'),

(1242,'Tiruppur','Tamil Nadu','India','$CURRENTTIME'),

(1243,'Tiruttani','Tamil Nadu','India','$CURRENTTIME'),

(1244,'Tiruvannamalai','Tamil Nadu','India','$CURRENTTIME'),

(1245,'Tiruvethipuram','Tamil Nadu','India','$CURRENTTIME'),

(1246,'Tittakudi','Tamil Nadu','India','$CURRENTTIME'),

(1247,'Udhagamandalam','Tamil Nadu','India','$CURRENTTIME'),

(1248,'Udumalaipettai','Tamil Nadu','India','$CURRENTTIME'),

(1249,'Unnamalaikadai','Tamil Nadu','India','$CURRENTTIME'),

(1250,'Usilampatti','Tamil Nadu','India','$CURRENTTIME'),

(1251,'Uthamapalayam','Tamil Nadu','India','$CURRENTTIME'),

(1252,'Uthiramerur','Tamil Nadu','India','$CURRENTTIME'),

(1253,'Vadakkuvalliyur','Tamil Nadu','India','$CURRENTTIME'),

(1254,'Vadalur','Tamil Nadu','India','$CURRENTTIME'),

(1255,'Vadipatti','Tamil Nadu','India','$CURRENTTIME'),

(1256,'Valparai','Tamil Nadu','India','$CURRENTTIME'),

(1257,'Vandavasi','Tamil Nadu','India','$CURRENTTIME'),

(1258,'Vaniyambadi','Tamil Nadu','India','$CURRENTTIME'),

(1259,'Vedaranyam','Tamil Nadu','India','$CURRENTTIME'),

(1260,'Vellakoil','Tamil Nadu','India','$CURRENTTIME'),

(1261,'Vellore','Tamil Nadu','India','$CURRENTTIME'),

(1262,'Vikramasingapuram','Tamil Nadu','India','$CURRENTTIME'),

(1263,'Viluppuram','Tamil Nadu','India','$CURRENTTIME'),

(1264,'Virudhachalam','Tamil Nadu','India','$CURRENTTIME'),

(1265,'Virudhunagar','Tamil Nadu','India','$CURRENTTIME'),

(1266,'Viswanatham','Tamil Nadu','India','$CURRENTTIME'),

(1267,'Agartala','Tripura','India','$CURRENTTIME'),

(1268,'Badharghat','Tripura','India','$CURRENTTIME'),

(1269,'Dharmanagar','Tripura','India','$CURRENTTIME'),

(1270,'Indranagar','Tripura','India','$CURRENTTIME'),

(1271,'Jogendranagar','Tripura','India','$CURRENTTIME'),

(1272,'Kailasahar','Tripura','India','$CURRENTTIME'),

(1273,'Khowai','Tripura','India','$CURRENTTIME'),

(1274,'Pratapgarh','Tripura','India','$CURRENTTIME'),

(1275,'Udaipur','Tripura','India','$CURRENTTIME'),

(1276,'Achhnera','Uttar Pradesh','India','$CURRENTTIME'),

(1277,'Adari','Uttar Pradesh','India','$CURRENTTIME'),

(1278,'Agra','Uttar Pradesh','India','$CURRENTTIME'),

(1279,'Aligarh','Uttar Pradesh','India','$CURRENTTIME'),

(1280,'Allahabad','Uttar Pradesh','India','$CURRENTTIME'),

(1281,'Amroha','Uttar Pradesh','India','$CURRENTTIME'),

(1282,'Azamgarh','Uttar Pradesh','India','$CURRENTTIME'),

(1283,'Bahraich','Uttar Pradesh','India','$CURRENTTIME'),

(1284,'Ballia','Uttar Pradesh','India','$CURRENTTIME'),

(1285,'Balrampur','Uttar Pradesh','India','$CURRENTTIME'),

(1286,'Banda','Uttar Pradesh','India','$CURRENTTIME'),

(1287,'Bareilly','Uttar Pradesh','India','$CURRENTTIME'),

(1288,'Chandausi','Uttar Pradesh','India','$CURRENTTIME'),

(1289,'Dadri','Uttar Pradesh','India','$CURRENTTIME'),

(1290,'Deoria','Uttar Pradesh','India','$CURRENTTIME'),

(1291,'Etawah','Uttar Pradesh','India','$CURRENTTIME'),

(1292,'Fatehabad','Uttar Pradesh','India','$CURRENTTIME'),

(1293,'Fatehpur','Uttar Pradesh','India','$CURRENTTIME'),

(1294,'Fatehpur','Uttar Pradesh','India','$CURRENTTIME'),

(1295,'Greater Noida','Uttar Pradesh','India','$CURRENTTIME'),

(1296,'Hamirpur','Uttar Pradesh','India','$CURRENTTIME'),

(1297,'Hardoi','Uttar Pradesh','India','$CURRENTTIME'),

(1298,'Jajmau','Uttar Pradesh','India','$CURRENTTIME'),

(1299,'Jaunpur','Uttar Pradesh','India','$CURRENTTIME'),

(1300,'Jhansi','Uttar Pradesh','India','$CURRENTTIME'),

(1301,'Kalpi','Uttar Pradesh','India','$CURRENTTIME'),

(1302,'Kanpur','Uttar Pradesh','India','$CURRENTTIME'),

(1303,'Kota','Uttar Pradesh','India','$CURRENTTIME'),

(1304,'Laharpur','Uttar Pradesh','India','$CURRENTTIME'),

(1305,'Lakhimpur','Uttar Pradesh','India','$CURRENTTIME'),

(1306,'Lal Gopalganj Nindaura','Uttar Pradesh','India','$CURRENTTIME'),

(1307,'Lalganj','Uttar Pradesh','India','$CURRENTTIME'),

(1308,'Lalitpur','Uttar Pradesh','India','$CURRENTTIME'),

(1309,'Lar','Uttar Pradesh','India','$CURRENTTIME'),

(1310,'Loni','Uttar Pradesh','India','$CURRENTTIME'),

(1311,'Lucknow','Uttar Pradesh','India','$CURRENTTIME'),

(1312,'Mathura','Uttar Pradesh','India','$CURRENTTIME'),

(1313,'Meerut','Uttar Pradesh','India','$CURRENTTIME'),

(1314,'Modinagar','Uttar Pradesh','India','$CURRENTTIME'),

(1315,'Muradnagar','Uttar Pradesh','India','$CURRENTTIME'),

(1316,'Nagina','Uttar Pradesh','India','$CURRENTTIME'),

(1317,'Najibabad','Uttar Pradesh','India','$CURRENTTIME'),

(1318,'Nakur','Uttar Pradesh','India','$CURRENTTIME'),

(1319,'Nanpara','Uttar Pradesh','India','$CURRENTTIME'),

(1320,'Naraura','Uttar Pradesh','India','$CURRENTTIME'),

(1321,'Naugawan Sadat','Uttar Pradesh','India','$CURRENTTIME'),

(1322,'Nautanwa','Uttar Pradesh','India','$CURRENTTIME'),

(1323,'Nawabganj','Uttar Pradesh','India','$CURRENTTIME'),

(1324,'Nehtaur','Uttar Pradesh','India','$CURRENTTIME'),

(1325,'NOIDA','Uttar Pradesh','India','$CURRENTTIME'),

(1326,'Noorpur','Uttar Pradesh','India','$CURRENTTIME'),

(1327,'Obra','Uttar Pradesh','India','$CURRENTTIME'),

(1328,'Orai','Uttar Pradesh','India','$CURRENTTIME'),

(1329,'Padrauna','Uttar Pradesh','India','$CURRENTTIME'),

(1330,'Palia Kalan','Uttar Pradesh','India','$CURRENTTIME'),

(1331,'Parasi','Uttar Pradesh','India','$CURRENTTIME'),

(1332,'Phulpur','Uttar Pradesh','India','$CURRENTTIME'),

(1333,'Pihani','Uttar Pradesh','India','$CURRENTTIME'),

(1334,'Pilibhit','Uttar Pradesh','India','$CURRENTTIME'),

(1335,'Pilkhuwa','Uttar Pradesh','India','$CURRENTTIME'),

(1336,'Powayan','Uttar Pradesh','India','$CURRENTTIME'),

(1337,'Pukhrayan','Uttar Pradesh','India','$CURRENTTIME'),

(1338,'Puranpur','Uttar Pradesh','India','$CURRENTTIME'),

(1339,'Purquazi','Uttar Pradesh','India','$CURRENTTIME'),

(1340,'Purwa','Uttar Pradesh','India','$CURRENTTIME'),

(1341,'Rae Bareli','Uttar Pradesh','India','$CURRENTTIME'),

(1342,'Rampur','Uttar Pradesh','India','$CURRENTTIME'),

(1343,'Rampur Maniharan','Uttar Pradesh','India','$CURRENTTIME'),

(1344,'Rasra','Uttar Pradesh','India','$CURRENTTIME'),

(1345,'Rath','Uttar Pradesh','India','$CURRENTTIME'),

(1346,'Renukoot','Uttar Pradesh','India','$CURRENTTIME'),

(1347,'Reoti','Uttar Pradesh','India','$CURRENTTIME'),

(1348,'Robertsganj','Uttar Pradesh','India','$CURRENTTIME'),

(1349,'Rudauli','Uttar Pradesh','India','$CURRENTTIME'),

(1350,'Rudrapur','Uttar Pradesh','India','$CURRENTTIME'),

(1351,'Sadabad','Uttar Pradesh','India','$CURRENTTIME'),

(1352,'Safipur','Uttar Pradesh','India','$CURRENTTIME'),

(1353,'Saharanpur','Uttar Pradesh','India','$CURRENTTIME'),

(1354,'Sahaspur','Uttar Pradesh','India','$CURRENTTIME'),

(1355,'Sahaswan','Uttar Pradesh','India','$CURRENTTIME'),

(1356,'Sahawar','Uttar Pradesh','India','$CURRENTTIME'),

(1357,'Sahjanwa','Uttar Pradesh','India','$CURRENTTIME'),

(1358,'Saidpur, Ghazipur','Uttar Pradesh','India','$CURRENTTIME'),

(1359,'Sambhal','Uttar Pradesh','India','$CURRENTTIME'),

(1360,'Samdhan','Uttar Pradesh','India','$CURRENTTIME'),

(1361,'Samthar','Uttar Pradesh','India','$CURRENTTIME'),

(1362,'Sandi','Uttar Pradesh','India','$CURRENTTIME'),

(1363,'Sandila','Uttar Pradesh','India','$CURRENTTIME'),

(1364,'Sardhana','Uttar Pradesh','India','$CURRENTTIME'),

(1365,'Seohara','Uttar Pradesh','India','$CURRENTTIME'),

(1366,'Shahabad, Hardoi','Uttar Pradesh','India','$CURRENTTIME'),

(1367,'Shahabad, Rampur','Uttar Pradesh','India','$CURRENTTIME'),

(1368,'Shahganj','Uttar Pradesh','India','$CURRENTTIME'),

(1369,'Shahjahanpur','Uttar Pradesh','India','$CURRENTTIME'),

(1370,'Shamli','Uttar Pradesh','India','$CURRENTTIME'),

(1371,'Shamsabad, Agra','Uttar Pradesh','India','$CURRENTTIME'),

(1372,'Shamsabad, Farrukhabad','Uttar Pradesh','India','$CURRENTTIME'),

(1373,'Sherkot','Uttar Pradesh','India','$CURRENTTIME'),

(1374,'Shikarpur, Bulandshahr','Uttar Pradesh','India','$CURRENTTIME'),

(1375,'Shikohabad','Uttar Pradesh','India','$CURRENTTIME'),

(1376,'Shishgarh','Uttar Pradesh','India','$CURRENTTIME'),

(1377,'Siana','Uttar Pradesh','India','$CURRENTTIME'),

(1378,'Sikanderpur','Uttar Pradesh','India','$CURRENTTIME'),

(1379,'Sikandra Rao','Uttar Pradesh','India','$CURRENTTIME'),

(1380,'Sikandrabad','Uttar Pradesh','India','$CURRENTTIME'),

(1381,'Sirsaganj','Uttar Pradesh','India','$CURRENTTIME'),

(1382,'Sirsi','Uttar Pradesh','India','$CURRENTTIME'),

(1383,'Sitapur','Uttar Pradesh','India','$CURRENTTIME'),

(1384,'Soron','Uttar Pradesh','India','$CURRENTTIME'),

(1385,'Suar','Uttar Pradesh','India','$CURRENTTIME'),

(1386,'Sultanpur','Uttar Pradesh','India','$CURRENTTIME'),

(1387,'Sumerpur','Uttar Pradesh','India','$CURRENTTIME'),

(1388,'Tanda','Uttar Pradesh','India','$CURRENTTIME'),

(1389,'Tanda','Uttar Pradesh','India','$CURRENTTIME'),

(1390,'Tetri Bazar','Uttar Pradesh','India','$CURRENTTIME'),

(1391,'Thakurdwara','Uttar Pradesh','India','$CURRENTTIME'),

(1392,'Thana Bhawan','Uttar Pradesh','India','$CURRENTTIME'),

(1393,'Tilhar','Uttar Pradesh','India','$CURRENTTIME'),

(1394,'Tirwaganj','Uttar Pradesh','India','$CURRENTTIME'),

(1395,'Tulsipur','Uttar Pradesh','India','$CURRENTTIME'),

(1396,'Tundla','Uttar Pradesh','India','$CURRENTTIME'),

(1397,'Unnao','Uttar Pradesh','India','$CURRENTTIME'),

(1398,'Utraula','Uttar Pradesh','India','$CURRENTTIME'),

(1399,'Varanasi','Uttar Pradesh','India','$CURRENTTIME'),

(1400,'Vrindavan','Uttar Pradesh','India','$CURRENTTIME'),

(1401,'Warhapur','Uttar Pradesh','India','$CURRENTTIME'),

(1402,'Zaidpur','Uttar Pradesh','India','$CURRENTTIME'),

(1403,'Zamania','Uttar Pradesh','India','$CURRENTTIME'),

(1404,'Almora','Uttarakhand','India','$CURRENTTIME'),

(1405,'Bazpur','Uttarakhand','India','$CURRENTTIME'),

(1406,'Chamba','Uttarakhand','India','$CURRENTTIME'),

(1407,'Dehradun','Uttarakhand','India','$CURRENTTIME'),

(1408,'Haldwani','Uttarakhand','India','$CURRENTTIME'),

(1409,'Haridwar','Uttarakhand','India','$CURRENTTIME'),

(1410,'Jaspur','Uttarakhand','India','$CURRENTTIME'),

(1411,'Kashipur','Uttarakhand','India','$CURRENTTIME'),

(1412,'kichha','Uttarakhand','India','$CURRENTTIME'),

(1413,'Kotdwara','Uttarakhand','India','$CURRENTTIME'),

(1414,'Manglaur','Uttarakhand','India','$CURRENTTIME'),

(1415,'Mussoorie','Uttarakhand','India','$CURRENTTIME'),

(1416,'Nagla','Uttarakhand','India','$CURRENTTIME'),

(1417,'Nainital','Uttarakhand','India','$CURRENTTIME'),

(1418,'Pauri','Uttarakhand','India','$CURRENTTIME'),

(1419,'Pithoragarh','Uttarakhand','India','$CURRENTTIME'),

(1420,'Ramnagar','Uttarakhand','India','$CURRENTTIME'),

(1421,'Rishikesh','Uttarakhand','India','$CURRENTTIME'),

(1422,'Roorkee','Uttarakhand','India','$CURRENTTIME'),

(1423,'Rudrapur','Uttarakhand','India','$CURRENTTIME'),

(1424,'Sitarganj','Uttarakhand','India','$CURRENTTIME'),

(1425,'Tehri','Uttarakhand','India','$CURRENTTIME'),

(1426,'Muzaffarnagar','Uttarpradesh','India','$CURRENTTIME'),

(1427,'Adra, Purulia','West Bengal','India','$CURRENTTIME'),

(1428,'Alipurduar','West Bengal','India','$CURRENTTIME'),

(1429,'Arambagh','West Bengal','India','$CURRENTTIME'),

(1430,'Asansol','West Bengal','India','$CURRENTTIME'),

(1431,'Baharampur','West Bengal','India','$CURRENTTIME'),

(1432,'Bally','West Bengal','India','$CURRENTTIME'),

(1433,'Balurghat','West Bengal','India','$CURRENTTIME'),

(1434,'Bankura','West Bengal','India','$CURRENTTIME'),

(1435,'Barakar','West Bengal','India','$CURRENTTIME'),

(1436,'Barasat','West Bengal','India','$CURRENTTIME'),

(1437,'Bardhaman','West Bengal','India','$CURRENTTIME'),

(1438,'Bidhan Nagar','West Bengal','India','$CURRENTTIME'),

(1439,'Chinsura','West Bengal','India','$CURRENTTIME'),

(1440,'Contai','West Bengal','India','$CURRENTTIME'),

(1441,'Cooch Behar','West Bengal','India','$CURRENTTIME'),

(1442,'Darjeeling','West Bengal','India','$CURRENTTIME'),

(1443,'Durgapur','West Bengal','India','$CURRENTTIME'),

(1444,'Haldia','West Bengal','India','$CURRENTTIME'),

(1445,'Howrah','West Bengal','India','$CURRENTTIME'),

(1446,'Islampur','West Bengal','India','$CURRENTTIME'),

(1447,'Jhargram','West Bengal','India','$CURRENTTIME'),

(1448,'Kharagpur','West Bengal','India','$CURRENTTIME'),

(1449,'Kolkata','West Bengal','India','$CURRENTTIME'),

(1450,'Mainaguri','West Bengal','India','$CURRENTTIME'),

(1451,'Mal','West Bengal','India','$CURRENTTIME'),

(1452,'Mathabhanga','West Bengal','India','$CURRENTTIME'),

(1453,'Medinipur','West Bengal','India','$CURRENTTIME'),

(1454,'Memari','West Bengal','India','$CURRENTTIME'),

(1455,'Monoharpur','West Bengal','India','$CURRENTTIME'),

(1456,'Murshidabad','West Bengal','India','$CURRENTTIME'),

(1457,'Nabadwip','West Bengal','India','$CURRENTTIME'),

(1458,'Naihati','West Bengal','India','$CURRENTTIME'),

(1459,'Panchla','West Bengal','India','$CURRENTTIME'),

(1460,'Pandua','West Bengal','India','$CURRENTTIME'),

(1461,'Paschim Punropara','West Bengal','India','$CURRENTTIME'),

(1462,'Purulia','West Bengal','India','$CURRENTTIME'),

(1463,'Raghunathpur','West Bengal','India','$CURRENTTIME'),

(1464,'Raiganj','West Bengal','India','$CURRENTTIME'),

(1465,'Rampurhat','West Bengal','India','$CURRENTTIME'),

(1466,'Ranaghat','West Bengal','India','$CURRENTTIME'),

(1467,'Sainthia','West Bengal','India','$CURRENTTIME'),

(1468,'Santipur','West Bengal','India','$CURRENTTIME'),

(1469,'Siliguri','West Bengal','India','$CURRENTTIME'),

(1470,'Sonamukhi','West Bengal','India','$CURRENTTIME'),

(1471,'Srirampore','West Bengal','India','$CURRENTTIME'),

(1472,'Suri','West Bengal','India','$CURRENTTIME'),

(1473,'Taki','West Bengal','India','$CURRENTTIME'),

(1474,'Tamluk','West Bengal','India','$CURRENTTIME'),

(1475,'Tarakeswar','West Bengal','India','$CURRENTTIME'),

(1476,'Chikmagalur','Karnataka','India','$CURRENTTIME'),

(1477,'Davanagere','Karnataka','India','$CURRENTTIME'),

(1478,'Dharwad','Karnataka','India','$CURRENTTIME'),

(1479,'Gadag','Karnataka','India','$CURRENTTIME'),

(1480,'Chennai','Tamil Nadu','India','$CURRENTTIME'),

(1481,'Coimbatore','Tamil Nadu','India','$CURRENTTIME'),

(1482,'Barrackpur','unknown','India','$CURRENTTIME'),

(1483,'Barwani','unknown','India','$CURRENTTIME'),

(1484,'Basna','unknown','India','$CURRENTTIME'),

(1485,'Bawal','unknown','India','$CURRENTTIME'),

(1486,'Beawar','unknown','India','$CURRENTTIME'),

(1487,'Berhampur','unknown','India','$CURRENTTIME'),

(1488,'Bhajanpura','unknown','India','$CURRENTTIME'),

(1489,'Bhandara','unknown','India','$CURRENTTIME'),

(1490,'Bharatpur','unknown','India','$CURRENTTIME'),

(1491,'Bharthana','unknown','India','$CURRENTTIME'),

(1492,'Bhilai','unknown','India','$CURRENTTIME'),

(1493,'Bhilwara','unknown','India','$CURRENTTIME'),

(1494,'Bhinmal','unknown','India','$CURRENTTIME'),

(1495,'Bhiwandi','unknown','India','$CURRENTTIME'),

(1496,'Bhusawal','unknown','India','$CURRENTTIME'),

(1497,'Bidar','unknown','India','$CURRENTTIME'),

(1498,'Bijnaur','unknown','India','$CURRENTTIME'),

(1499,'Bilara','unknown','India','$CURRENTTIME'),

(1500,'Budaun','unknown','India','$CURRENTTIME'),

(1501,'Bulandshahr','unknown','India','$CURRENTTIME'),

(1502,'Burla','unknown','India','$CURRENTTIME'),

(1503,'Chakeri','unknown','India','$CURRENTTIME'),

(1504,'Champawat','unknown','India','$CURRENTTIME'),

(1505,'Chandil','unknown','India','$CURRENTTIME'),

(1506,'Chandrapur','unknown','India','$CURRENTTIME'),

(1507,'Chapirevula','unknown','India','$CURRENTTIME'),

(1508,'Charkhari','unknown','India','$CURRENTTIME'),

(1509,'Charkhi Dadri','unknown','India','$CURRENTTIME'),

(1510,'Chhindwara','unknown','India','$CURRENTTIME'),

(1511,'Chiplun','unknown','India','$CURRENTTIME'),

(1512,'Chitrakoot','unknown','India','$CURRENTTIME'),

(1513,'Churu','unknown','India','$CURRENTTIME'),

(1514,'Dalkhola','unknown','India','$CURRENTTIME'),

(1515,'Damoh','unknown','India','$CURRENTTIME'),

(1516,'Daund','unknown','India','$CURRENTTIME'),

(1517,'Dehgam','unknown','India','$CURRENTTIME'),

(1518,'Devgarh','unknown','India','$CURRENTTIME'),

(1519,'Dhulian','unknown','India','$CURRENTTIME'),

(1520,'Dumdum','unknown','India','$CURRENTTIME'),

(1521,'Dwarka1','unknown','India','$CURRENTTIME'),

(1522,'Etah','unknown','India','$CURRENTTIME'),

(1523,'Faizabad','unknown','India','$CURRENTTIME'),

(1524,'Falna','unknown','India','$CURRENTTIME'),

(1525,'Farrukhabad','unknown','India','$CURRENTTIME'),

(1526,'Fatehgarh','unknown','India','$CURRENTTIME'),

(1527,'Fatehpur Chaurasi','unknown','India','$CURRENTTIME'),

(1528,'Fatehpur Sikri','unknown','India','$CURRENTTIME'),

(1529,'Firozabad','unknown','India','$CURRENTTIME'),

(1530,'Gadchiroli','unknown','India','$CURRENTTIME'),

(1531,'Gandhidham','unknown','India','$CURRENTTIME'),

(1532,'Ganjam','unknown','India','$CURRENTTIME'),

(1533,'Ghatampur','unknown','India','$CURRENTTIME'),

(1534,'Ghatanji','unknown','India','$CURRENTTIME'),

(1535,'Ghaziabad','unknown','India','$CURRENTTIME'),

(1536,'Ghazipur','unknown','India','$CURRENTTIME'),

(1537,'Goa Velha','unknown','India','$CURRENTTIME'),

(1538,'Gokak','unknown','India','$CURRENTTIME'),

(1539,'Gondiya','unknown','India','$CURRENTTIME'),

(1540,'Gorakhpur','unknown','India','$CURRENTTIME'),

(1541,'Guna','unknown','India','$CURRENTTIME'),

(1542,'Hanumangarh','unknown','India','$CURRENTTIME'),

(1543,'Harda','unknown','India','$CURRENTTIME'),

(1544,'Harsawa','unknown','India','$CURRENTTIME'),

(1545,'Hastinapur','unknown','India','$CURRENTTIME'),

(1546,'Hathras','unknown','India','$CURRENTTIME'),

(1547,'Jagadhri','unknown','India','$CURRENTTIME'),

(1548,'Jais','unknown','India','$CURRENTTIME'),

(1549,'Jaitaran','unknown','India','$CURRENTTIME'),

(1550,'Jalgaon','unknown','India','$CURRENTTIME'),

(1551,'Jalore','unknown','India','$CURRENTTIME'),

(1552,'Jhabua','unknown','India','$CURRENTTIME'),

(1553,'Jhalawar','unknown','India','$CURRENTTIME'),

(1554,'Jhunjhunu','unknown','India','$CURRENTTIME'),

(1555,'Junnar','unknown','India','$CURRENTTIME'),

(1556,'Kailaras','unknown','India','$CURRENTTIME'),

(1557,'Kalburgi','unknown','India','$CURRENTTIME'),

(1558,'Kalimpong','unknown','India','$CURRENTTIME'),

(1559,'Kamthi','unknown','India','$CURRENTTIME'),

(1560,'Kanpur','unknown','India','$CURRENTTIME'),

(1561,'Karad','unknown','India','$CURRENTTIME'),

(1562,'Keylong','unknown','India','$CURRENTTIME'),

(1563,'Kheri','unknown','India','$CURRENTTIME'),

(1564,'Khurai','unknown','India','$CURRENTTIME'),

(1565,'Kodad','unknown','India','$CURRENTTIME'),

(1566,'Konnagar','unknown','India','$CURRENTTIME'),

(1567,'Krishnanagar','unknown','India','$CURRENTTIME'),

(1568,'Kuchinda','unknown','India','$CURRENTTIME'),

(1569,'Madhyamgram','unknown','India','$CURRENTTIME'),

(1570,'Mahabaleswar','unknown','India','$CURRENTTIME'),

(1571,'Mahoba','unknown','India','$CURRENTTIME'),

(1572,'Mahwa','unknown','India','$CURRENTTIME'),

(1573,'Manesar','unknown','India','$CURRENTTIME'),

(1574,'Mangalagiri','unknown','India','$CURRENTTIME'),

(1575,'Mira-Bhayandar','unknown','India','$CURRENTTIME'),

(1576,'Mirzapur','unknown','India','$CURRENTTIME'),

(1577,'Mithapur','unknown','India','$CURRENTTIME'),

(1578,'Mohania','unknown','India','$CURRENTTIME'),

(1579,'Mokama','unknown','India','$CURRENTTIME'),

(1580,'Moradabad','unknown','India','$CURRENTTIME'),

(1581,'Mukatsar','unknown','India','$CURRENTTIME'),

(1582,'Nagalapuram','unknown','India','$CURRENTTIME');

/*--------------------------------------START SMS SQL-------------------------------------------------------------*/

/*Table structure for table `sms_auth` */

DROP TABLE IF EXISTS `sms_auth`;

CREATE TABLE `sms_auth` (
  `SmsAuthID` int(11) NOT NULL AUTO_INCREMENT,
  `ExecuteBy` varchar(100) DEFAULT NULL,
  `ExecutorID` int(11) DEFAULT NULL,
  `Accounts` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SmsAuthID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `sms_auth` */

insert  into `sms_auth`(`SmsAuthID`,`ExecuteBy`,`ExecutorID`,`Accounts`) values 

(1,'Administrator',1,'1,2');

/*Table structure for table `sms_debuglog` */

DROP TABLE IF EXISTS `sms_debuglog`;

CREATE TABLE `sms_debuglog` (
  `SmsDebugLogID` int(11) NOT NULL AUTO_INCREMENT,
  `LogDateTime` datetime DEFAULT NULL,
  `Number` varchar(20) DEFAULT NULL,
  `Message` mediumtext,
  `Context` varchar(255) DEFAULT NULL,
  `LogText` longtext,
  PRIMARY KEY (`SmsDebugLogID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sms_debuglog` */

/*Table structure for table `sms_gatewayaccounts` */

DROP TABLE IF EXISTS `sms_gatewayaccounts`;

CREATE TABLE `sms_gatewayaccounts` (
  `AccountID` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) DEFAULT NULL,
  `AccountType` smallint(6) DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `ProviderName` varchar(255) DEFAULT NULL,
  `Website` varchar(255) DEFAULT NULL,
  `ContactPerson` varchar(255) DEFAULT NULL,
  `HelpNumbers` varchar(255) DEFAULT NULL,
  `UserID` varchar(255) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL,
  `BalanceCheckURL` varchar(255) DEFAULT NULL,
  `BalanceCheckFormat` varchar(255) DEFAULT NULL,
  `BalanceCheckUserIDParam` varchar(255) DEFAULT NULL,
  `BalanceCheckPasswordParam` varchar(255) DEFAULT NULL,
  `BalanceCheckOtherParam` varchar(255) DEFAULT NULL,
  `BalanceCheckOtherValue` varchar(255) DEFAULT NULL,
  `PingURL` varchar(255) DEFAULT NULL,
  `PingResponse` varchar(255) DEFAULT NULL,
  `SMSSendURL` varchar(255) DEFAULT NULL,
  `SMSSendResponse` varchar(255) DEFAULT NULL,
  `BatchSize` smallint(6) DEFAULT NULL,
  `NumberDelimiter` varchar(4) DEFAULT NULL,
  `ResponseDelimiter` varchar(4) DEFAULT NULL,
  `MobileNumberParam` varchar(255) DEFAULT NULL,
  `SMSTextParam` varchar(255) DEFAULT NULL,
  `SendSMSUserIDParam` varchar(255) DEFAULT NULL,
  `SendSMSPasswordParam` varchar(255) DEFAULT NULL,
  `SenderIDParam` varchar(255) DEFAULT NULL,
  `SenderIDValue` varchar(255) DEFAULT NULL,
  `OtherParam1` varchar(255) DEFAULT NULL,
  `OtherValue1` varchar(255) DEFAULT NULL,
  `OtherParam2` varchar(255) DEFAULT NULL,
  `OtherValue2` varchar(255) DEFAULT NULL,
  `LastSMSBalance` int(11) DEFAULT NULL,
  `BalanceCheckTime` datetime DEFAULT NULL,
  `UpdateDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`AccountID`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Data for the table `sms_gatewayaccounts` */

insert  into `sms_gatewayaccounts`(`AccountID`,`Title`,`AccountType`,`StartDate`,`EndDate`,`ProviderName`,`Website`,`ContactPerson`,`HelpNumbers`,`UserID`,`Password`,`BalanceCheckURL`,`BalanceCheckFormat`,`BalanceCheckUserIDParam`,`BalanceCheckPasswordParam`,`BalanceCheckOtherParam`,`BalanceCheckOtherValue`,`PingURL`,`PingResponse`,`SMSSendURL`,`SMSSendResponse`,`BatchSize`,`NumberDelimiter`,`ResponseDelimiter`,`MobileNumberParam`,`SMSTextParam`,`SendSMSUserIDParam`,`SendSMSPasswordParam`,`SenderIDParam`,`SenderIDValue`,`OtherParam1`,`OtherValue1`,`OtherParam2`,`OtherValue2`,`LastSMSBalance`,`BalanceCheckTime`,`UpdateDateTime`) values 

(1,'Test Account-01',1,'2012-01-01','2013-12-31','FAKE-Service','http://localhost/debug/aboutdebug.jsp','Fake','Fake','smstest','smstest','http://localhost/debug/balance.jsp','','ID','pw','a','b','http://localhost/debug/chk.jsp','Server Connected','http://localhost/debug/trace.jsp','',10,',','|','PhoneNumber','Text','UserID','UserPassWord','GSM','WEB-SMS','CDMA','919898251863','','',292,'2016-11-15 14:56:59','$CURRENTTIME'),

(2,'SHREE SMS',1,'2013-05-01','2015-05-01','Shree SMS','http://www.shreesms.net/','Mr.Aalap Shah','+91 9327374743','VRCOMP','blackbelt','http://ip.shreesms.net/SMSServer/SMSCnt.asp','','ID','pw','','','http://ip.shreesms.net/smsserver/smsserverchk.asp','Server Connected','http://ip.shreesms.net/smsserver/sms10n.aspx','Ok|',10,',','|','PhoneNumber','Text','UserID','UserPassWord','GSM','VRCOMP','CDMA','919898251863','','',-1,'2016-10-26 14:44:05','$CURRENTTIME');

/*Table structure for table `sms_handler` */

DROP TABLE IF EXISTS `sms_handler`;

CREATE TABLE `sms_handler` (
  `AccountID` int(11) DEFAULT NULL,
  `HandlerClass` varchar(500) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sms_handler` */

/*Table structure for table `sms_joblog` */

DROP TABLE IF EXISTS `sms_joblog`;

CREATE TABLE `sms_joblog` (
  `SmsJobLogID` int(11) NOT NULL AUTO_INCREMENT,
  `SmsJobID` int(11) DEFAULT NULL,
  `DispatchDateTime` datetime DEFAULT NULL,
  `RefNo` varchar(255) DEFAULT NULL,
  `Target` varchar(255) DEFAULT NULL,
  `MobileNumber` varchar(20) DEFAULT NULL,
  `SMSText` mediumtext,
  `MobileNumberStatus` smallint(6) DEFAULT NULL,
  `SmsJobLogFlag` smallint(6) DEFAULT NULL,
  `Response` mediumtext,
  PRIMARY KEY (`SmsJobLogID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sms_joblog` */

/*Table structure for table `sms_jobs` */

DROP TABLE IF EXISTS `sms_jobs`;

CREATE TABLE `sms_jobs` (
  `SmsJobID` int(11) NOT NULL AUTO_INCREMENT,
  `ExecuteBy` varchar(50) DEFAULT NULL,
  `ExecutorID` int(11) DEFAULT NULL,
  `JobDateTime` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `Target` varchar(100) DEFAULT NULL,
  `SqlQuery` mediumtext,
  `WhereClause` mediumtext,
  `OrderByClause` varchar(250) DEFAULT NULL,
  `CustomText` smallint(6) DEFAULT NULL,
  `SMSText` mediumtext,
  `JobCount` int(11) DEFAULT NULL,
  `Success` int(11) DEFAULT NULL,
  `Failure` int(11) DEFAULT NULL,
  `Invalid` int(11) DEFAULT NULL,
  `Blank` int(11) DEFAULT NULL,
  `SmsJobFlag` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`SmsJobID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sms_jobs` */

/*Table structure for table `sms_settings` */

DROP TABLE IF EXISTS `sms_settings`;

CREATE TABLE `sms_settings` (
  `SmsSettingID` int(11) NOT NULL AUTO_INCREMENT,
  `Type` smallint(6) DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Description` mediumtext,
  `Value` varchar(255) DEFAULT NULL,
  `URL` mediumtext,
  `UpdateDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`SmsSettingID`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

/*Data for the table `sms_settings` */

insert  into `sms_settings`(`SmsSettingID`,`Type`,`Name`,`Description`,`Value`,`URL`,`UpdateDateTime`) values 

(1,2,'CONNECTION-TIMEOUT','Timeout in seconds for HTTP Connection','15','','$CURRENTTIME'),

(2,1,'PROXY-SERVER','User proxy server or not? URL contains proxy details. server:port','NO','','$CURRENTTIME'),

(3,6,'PROXY-AUTH','Authorization Scheme: BASIC/DIGEST/NTLM. The URL contains credentials','','','$CURRENTTIME'),

(4,6,'NUMBER-CHECK-REGEXP','Regular expression (Java style) to check valid mobile number','[789]\\d{9}','starting with 7, 8, or 9. Do not prepend 0 or +91','$CURRENTTIME'),

(5,1,'START-SMS-SERVICE','Flag which controls availability of SMS Service ( On / Off status )','YES','','$CURRENTTIME'),

(6,1,'START-SCHEDULED-SMS-DISPATCH','Status flag that controls scheduled sms dispatch service ( ON/OFF)','YES','','$CURRENTTIME'),

(7,2,'SMS-CHARACTER-LIMIT','Sms character limit','160','','$CURRENTTIME');

/*Table structure for table `sms_singlelog` */

DROP TABLE IF EXISTS `sms_singlelog`;

CREATE TABLE `sms_singlelog` (
  `SmsSingleLogID` int(11) NOT NULL AUTO_INCREMENT,
  `ExecuteBy` varchar(100) DEFAULT NULL,
  `ExecutorID` int(11) DEFAULT NULL,
  `DispatchDateTime` datetime DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `MobileNumber` varchar(20) DEFAULT NULL,
  `SMSText` mediumtext,
  `SmsSingleLogFlag` smallint(6) DEFAULT NULL,
  `Response` varchar(750) DEFAULT NULL,
  PRIMARY KEY (`SmsSingleLogID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `sms_singlelog` */

/*Table structure for table `sms_template` */

DROP TABLE IF EXISTS `sms_template`;

CREATE TABLE `sms_template` (
  `TemplateID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(500) DEFAULT NULL,
  `Text` mediumtext,
  PRIMARY KEY (`TemplateID`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Data for the table `sms_template` */

insert  into `sms_template`(`TemplateID`,`Name`,`Text`) values 

(1,'BirthDay','Happy Birthday ! '),

(2,'Anniversary','Happy Anniversary day !');

/*===========================START MAIL SQL==========================================*/

/*Table structure for table `mail_bulkattachments` */

DROP TABLE IF EXISTS `mail_bulkattachments`;

CREATE TABLE `mail_bulkattachments` (
  `MailBulkAttachmentsID` INT(11) NOT NULL AUTO_INCREMENT,
  `MailBulkJobID` INT(11) DEFAULT NULL,
  `MailSingleLogID` INT(11) DEFAULT NULL,
  `FileName` VARCHAR(750) DEFAULT NULL,
  `FileSize` INT(11) DEFAULT NULL,
  `MimeType` VARCHAR(200) DEFAULT NULL,
  `ContentID` VARCHAR(100) DEFAULT NULL,
  `FileData` LONGBLOB,
  PRIMARY KEY (`MailBulkAttachmentsID`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;

/*Data for the table `mail_bulkattachments` */

/*Table structure for table `mail_bulkjob` */

DROP TABLE IF EXISTS `mail_bulkjob`;

CREATE TABLE `mail_bulkjob` (
  `MailBulkJobID` INT(11) NOT NULL AUTO_INCREMENT,
  `ExecuteBy` VARCHAR(100) DEFAULT NULL,
  `ExecutorID` INT(11) DEFAULT NULL,
  `JobDateTime` DATETIME DEFAULT NULL,
  `Target` VARCHAR(100) DEFAULT NULL,
  `SqlQuery` MEDIUMTEXT,
  `WhereClause` MEDIUMTEXT,
  `OrderByClause` VARCHAR(250) DEFAULT NULL,
  `MailFrom` VARCHAR(100) DEFAULT NULL,
  `MailSubject` VARCHAR(750) DEFAULT NULL,
  `CustomText` SMALLINT(6) DEFAULT NULL,
  `CustomAttach` SMALLINT(6) DEFAULT NULL,
  `MailText` LONGTEXT,
  `JobCount` INT(11) DEFAULT NULL,
  `Success` INT(11) DEFAULT NULL,
  `Failure` INT(11) DEFAULT NULL,
  `Invalid` INT(11) DEFAULT NULL,
  `Blank` INT(11) DEFAULT NULL,
  `BulkMailJobFlag` SMALLINT(6) DEFAULT NULL,
  PRIMARY KEY (`MailBulkJobID`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;

/*Data for the table `mail_bulkjob` */

/*Table structure for table `mail_bulkjoblog` */

DROP TABLE IF EXISTS `mail_bulkjoblog`;

CREATE TABLE `mail_bulkjoblog` (
  `MailBulkJobLogID` INT(11) NOT NULL AUTO_INCREMENT,
  `MailBulkJobID` INT(11) DEFAULT NULL,
  `MailDispatchDateTime` DATETIME DEFAULT NULL,
  `RefNo` INT(11) DEFAULT NULL,
  `MailTo` VARCHAR(100) DEFAULT NULL,
  `MailSubject` VARCHAR(750) DEFAULT NULL,
  `MailText` LONGTEXT,
  `MailBulkJobLogFlag` SMALLINT(6) DEFAULT NULL,
  `Response` VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY (`MailBulkJobLogID`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;

/*Data for the table `mail_bulkjoblog` */

/*Table structure for table `mail_debuglog` */

DROP TABLE IF EXISTS `mail_debuglog`;

CREATE TABLE `mail_debuglog` (
  `MailDebugLogID` INT(11) NOT NULL AUTO_INCREMENT,
  `LogDateTime` DATETIME DEFAULT NULL,
  `MailTo` VARCHAR(20) DEFAULT NULL,
  `Subject` VARCHAR(750) DEFAULT NULL,
  `Context` VARCHAR(200) DEFAULT NULL,
  `LogText` LONGTEXT,
  PRIMARY KEY (`MailDebugLogID`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;

/*Data for the table `mail_debuglog` */

/*Table structure for table `mail_settings` */

DROP TABLE IF EXISTS `mail_settings`;

CREATE TABLE `mail_settings` (
  `MailSettingID` INT(11) NOT NULL AUTO_INCREMENT,
  `Type` SMALLINT(6) DEFAULT NULL,
  `Name` VARCHAR(255) DEFAULT NULL,
  `Description` MEDIUMTEXT,
  `Value` VARCHAR(255) DEFAULT NULL,
  `URL` MEDIUMTEXT,
  PRIMARY KEY (`MailSettingID`)
) ENGINE=MYISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Data for the table `mail_settings` */

/*Table structure for table `mail_singleattachments` */

DROP TABLE IF EXISTS `mail_singleattachments`;

CREATE TABLE `mail_singleattachments` (
  `MailSingleAttachmentID` INT(11) NOT NULL AUTO_INCREMENT,
  `MailSingleLogID` INT(11) DEFAULT NULL,
  `FileName` VARCHAR(750) DEFAULT NULL,
  `FileSize` INT(11) DEFAULT NULL,
  `MimeType` VARCHAR(200) DEFAULT NULL,
  `ContentID` VARCHAR(100) DEFAULT NULL,
  `FileData` LONGBLOB,
  PRIMARY KEY (`MailSingleAttachmentID`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;

/*Data for the table `mail_singleattachments` */

/*Table structure for table `mail_singlelog` */

DROP TABLE IF EXISTS `mail_singlelog`;

CREATE TABLE `mail_singlelog` (
  `MailSingleLogID` INT(11) NOT NULL AUTO_INCREMENT,
  `MailDateTime` DATETIME DEFAULT NULL,
  `ExecuteBy` VARCHAR(100) DEFAULT NULL,
  `ExecutorID` INT(11) DEFAULT NULL,
  `MailFrom` VARCHAR(100) DEFAULT NULL,
  `MailTo` VARCHAR(100) DEFAULT NULL,
  `MailSubject` VARCHAR(255) DEFAULT NULL,
  `MailText` LONGTEXT,
  `MailSingleLogFlag` SMALLINT(6) DEFAULT NULL,
  `Response` VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY (`MailSingleLogID`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;

/*Data for the table `mail_singlelog` */


