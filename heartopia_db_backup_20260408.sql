-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: heartopia_db
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `animal_collections`
--

DROP TABLE IF EXISTS `animal_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `animal_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `favorite_food` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `favorite_weather` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_animal_name` (`name`),
  KEY `idx_animal_location` (`location`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `animal_collections`
--

LOCK TABLES `animal_collections` WRITE;
/*!40000 ALTER TABLE `animal_collections` DISABLE KEYS */;
INSERT INTO `animal_collections` VALUES (1,'판다','세갈래길 주변','대나무, 사과, 옥수수','비','/images/collections/animals/판다.png','세갈래길 근처',NULL),(2,'카피바라','유적 주변','토마토, 포도, 라즈베리','비','/images/collections/animals/카피바라.png','유적 오른쪽',NULL),(3,'토끼','버스 정류장 주변','잡초, 딸기, 당근','맑음','/images/collections/animals/토끼.png','2번 ~ 3번 홈 주변 버스 오른쪽 길',NULL),(4,'여우','초원 호수 주변','고기, 민물배스, 큰입배스','무지개','/images/collections/animals/여우.png','9시 방향 초원 호수 아래 꽃밭 가는 길',NULL),(5,'해달','어촌 주변','홍합, 바다새우, 왕새우','비','/images/collections/animals/해달.png','6시 방향 잔잔한 바다, 바위 위 (지도 확대 시 어촌 광장 텍스트 아래)',NULL),(6,'담비','홈 4 주변','계란, 망둥어, 배스','무지개','/images/collections/animals/담비.png','4번 홈 위쪽',NULL),(7,'꽃사슴','숲 주변','상추, 관목가지, 베지샐러드','맑음','/images/collections/animals/꽃사슴.png','3시 방향 숲 버스 위쪽',NULL),(8,'알파카','등대 주변','블루베리, 파인애플, 밀','맑음','/images/collections/animals/알파카.png','보라빛 해변에서 등대로 가는 다리 주변',NULL);
/*!40000 ALTER TABLE `animal_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bird_collections`
--

DROP TABLE IF EXISTS `bird_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bird_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `location` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` int DEFAULT NULL,
  `weather` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_1` int DEFAULT NULL,
  `price_2` int DEFAULT NULL,
  `price_3` int DEFAULT NULL,
  `price_4` int DEFAULT NULL,
  `price_5` int DEFAULT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_bird_name` (`name`),
  KEY `idx_bird_location` (`location`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bird_collections`
--

LOCK TABLES `bird_collections` WRITE;
/*!40000 ALTER TABLE `bird_collections` DISABLE KEYS */;
INSERT INTO `bird_collections` VALUES (1,'블랑코 머리 위',NULL,'오목눈이',1,NULL,NULL,2,8,16,32,64,'소형','/images/collections/bird/오목눈이.png',NULL),(2,'숲',NULL,'굴뚝새',1,NULL,NULL,7,30,60,120,240,'소형','/images/collections/bird/굴뚝새.png',NULL),(3,'도심',NULL,'꼬까울새',1,NULL,NULL,7,30,60,120,240,'소형','/images/collections/bird/꼬까울새.png',NULL),(4,'온천산',NULL,'노랑배박새',1,NULL,NULL,7,30,60,120,240,'소형','/images/collections/bird/노랑배박새.png',NULL),(5,'도시 근교',NULL,'멋쟁이새',1,NULL,NULL,7,30,60,120,240,'소형','/images/collections/bird/멋쟁이새.png',NULL),(6,'꽃밭',NULL,'푸른머리되새',1,NULL,NULL,7,30,60,120,240,'소형','/images/collections/bird/푸른머리되새.png',NULL),(7,'도심',NULL,'분홍가슴비둘기',1,NULL,NULL,10,40,80,160,320,'비둘기','/images/collections/bird/분홍가슴비둘기.png',NULL),(8,'어촌',NULL,'얼룩비둘기',1,NULL,NULL,10,40,80,160,320,'비둘기','/images/collections/bird/얼룩비둘기.png',NULL),(9,'홈 근처',NULL,'염주비둘기',1,NULL,NULL,10,40,80,160,320,'비둘기','/images/collections/bird/염주비둘기.png',NULL),(10,'새들의 복귀',NULL,'청금강앵무',1,NULL,NULL,7,30,60,120,240,'앵무','/images/collections/bird/청금강앵무.png',NULL),(11,'새들의 복귀',NULL,'청공작',1,NULL,NULL,10,40,80,160,320,'공작','/images/collections/bird/청공작.png',NULL),(12,'호수',NULL,'청둥오리',1,NULL,NULL,12,50,100,200,400,'오리','/images/collections/bird/청둥오리.png',NULL),(13,'물가',NULL,'큰홍학',1,NULL,NULL,15,60,120,240,480,'홍학','/images/collections/bird/큰홍학.png',NULL),(14,'어촌',NULL,'동고비',2,NULL,NULL,10,40,80,160,320,'소형','/images/collections/bird/동고비.png',NULL),(15,'도시 근교',NULL,'빨간머리때까치',2,NULL,NULL,10,40,80,160,320,'소형','/images/collections/bird/빨간머리때까치.png',NULL),(16,'온천산',NULL,'수염오목눈이',2,NULL,NULL,10,40,80,160,320,'소형','/images/collections/bird/수염오목눈이.png',NULL),(17,'꽃밭',NULL,'분홍목녹색비둘기',2,NULL,NULL,15,60,120,240,480,'비둘기','/images/collections/bird/분홍목녹색비둘기.png',NULL),(18,'숲',NULL,'웡가비둘기',2,NULL,NULL,15,60,120,240,480,'비둘기','/images/collections/bird/웡가비둘기.png',NULL),(19,'해변',NULL,'바다갈매기',2,NULL,NULL,17,70,140,280,560,'갈매기','/images/collections/bird/바다갈매기.png',NULL),(20,'강',NULL,'홍머리오리',2,NULL,NULL,17,70,140,280,560,'오리','/images/collections/bird/홍머리오리.png',NULL),(21,'숲','점핑 플랫폼','검은턱오목눈이',3,NULL,NULL,10,40,80,160,320,'소형','/images/collections/bird/검은턱오목눈이.png',NULL),(22,'어촌','등대','녹자작',3,NULL,NULL,10,40,80,160,320,'소형','/images/collections/bird/녹자작.png',NULL),(23,'홈 근처',NULL,'유럽꾀꼬리',3,NULL,NULL,15,60,120,240,480,'소형','/images/collections/bird/유럽꾀꼬리.png',NULL),(24,'새들의 복귀',NULL,'홍금강앵무',3,NULL,NULL,10,40,80,160,320,'앵무','/images/collections/bird/홍금강앵무.png',NULL),(25,'고래바다 해변',NULL,'오두앵갈매기',3,NULL,NULL,17,70,140,280,560,'갈매기','/images/collections/bird/오두앵갈매기.png',NULL),(26,'바다',NULL,'유럽가마우지',3,NULL,NULL,17,70,140,280,560,'가마우지','/images/collections/bird/유럽가마우지.png',NULL),(27,'강',NULL,'호사북방오리',3,NULL,NULL,17,70,140,280,560,'오리','/images/collections/bird/호사북방오리.png',NULL),(28,'근교 호수',NULL,'황오리',3,NULL,NULL,17,70,140,280,560,'오리','/images/collections/bird/황오리.png',NULL),(29,'숲','영혼의 참나무','노란머리바우어새',4,NULL,NULL,15,60,120,240,480,'소형','/images/collections/bird/노란머리바우어새.png',NULL),(30,'숲','숲속 섬','솔양진이',4,NULL,NULL,15,60,120,240,480,'소형','/images/collections/bird/솔양진이.png',NULL),(31,'꽃밭','보라빛 해변','알락할미새',4,NULL,NULL,15,60,120,240,480,'소형','/images/collections/bird/알락할미새.png',NULL),(32,'어촌','광장','회색머리붉은참새',4,'해/무지개',NULL,15,60,120,240,480,'소형','/images/collections/bird/회색머리붉은참새.png',NULL),(33,'꽃밭','풍차꽃밭','황금과일비둘기',4,NULL,NULL,17,70,140,280,560,'비둘기','/images/collections/bird/황금과일비둘기.png',NULL),(34,'온천산','유적','은계',4,NULL,NULL,17,70,140,280,560,'중형','/images/collections/bird/은계.png',NULL),(35,'숲','호수','흰비오리',4,NULL,NULL,22,90,180,360,720,'오리','/images/collections/bird/흰비오리.png',NULL),(36,'어촌','부두','노랑배딱새',5,NULL,NULL,15,60,120,240,480,'소형','/images/collections/bird/노랑배딱새.png',NULL),(37,'온천산','호숫가','유럽벌잡이새',5,'비/무지개',NULL,22,90,180,360,720,'소형','/images/collections/bird/유럽벌잡이새.png',NULL),(38,'온천산','온천','올리브비둘기',5,NULL,NULL,27,110,220,440,880,'비둘기','/images/collections/bird/올리브비둘기.png',NULL),(39,'새들의 복귀',NULL,'초록금강앵무',5,'해/무지개',NULL,15,60,120,240,480,'앵무','/images/collections/bird/초록금강앵무.png',NULL),(40,'구해','해변','검정제비갈매기',5,NULL,NULL,22,90,180,360,720,'갈매기','/images/collections/bird/검정제비갈매기.png',NULL),(41,'숲','호숫가','작은홍학',5,'비/무지개',NULL,27,110,220,440,880,'홍학','/images/collections/bird/작은홍학.png',NULL),(42,'온천산','화산 호수','콩새',6,NULL,NULL,15,60,120,240,480,'소형','/images/collections/bird/콩새.png',NULL),(43,'어촌','동쪽 부두','황금가슴비둘기',6,NULL,NULL,27,110,220,440,880,'비둘기','/images/collections/bird/황금가슴비둘기.png',NULL),(44,'구해, 고래바다',NULL,'붉은뺨가마우지',6,NULL,NULL,22,90,180,360,720,'가마우지','/images/collections/bird/붉은뺨가마우지.png',NULL),(45,'온천산','바위절벽','칡부엉이',6,'해/무지개',NULL,47,190,380,760,1520,'부엉이','/images/collections/bird/칡부엉이.png',NULL),(46,'꽃밭','풍차꽃밭','푸른박새',7,NULL,NULL,22,90,180,360,720,'소형','/images/collections/bird/푸른박새.png',NULL),(47,'도시 근교',NULL,'잠부과일비둘기',7,NULL,NULL,27,110,220,440,880,'비둘기','/images/collections/bird/잠부과일비둘기.png',NULL),(48,'동해','해변','제비갈매기',7,'무지개',NULL,35,140,280,560,1120,'갈매기','/images/collections/bird/제비갈매기.png',NULL),(49,'숲','순록탑','황조롱이',7,'해/무지개',NULL,47,190,380,760,1520,'매','/images/collections/bird/황조롱이.png',NULL),(50,'새들의 복귀',NULL,'히아신스금강앵무',7,'비/무지개',NULL,22,90,180,360,720,'앵무','/images/collections/bird/히아신스금강앵무.png',NULL),(51,'도시 근교',NULL,'동부 파랑새',8,'비/무지개',NULL,30,120,240,480,960,'소형','/images/collections/bird/동부 파랑새.png',NULL),(52,'숲','영혼의 참나무','홍방울새',8,NULL,NULL,22,90,180,360,720,'소형','/images/collections/bird/홍방울새.png',NULL),(53,'꽃밭','고래산','분홍비둘기',8,NULL,NULL,27,110,220,440,880,'비둘기','/images/collections/bird/분홍비둘기.png',NULL),(54,'온천산','온천','매',8,'비/무지개',NULL,65,260,520,1040,2080,'매','/images/collections/bird/매.png',NULL),(55,'도시 근교',NULL,'극락풍금조',9,'무지개',NULL,30,120,240,480,960,'소형','/images/collections/bird/극락풍금조.png',NULL),(56,'온천산','호수','흰머리오리',9,'비/무지개',NULL,45,180,360,720,1440,'오리','/images/collections/bird/흰머리오리.png',NULL),(57,'동해, 잔잔한 바다',NULL,'황제가마우지',9,NULL,NULL,45,180,360,720,1440,'가마우지','/images/collections/bird/황제가마우지.png',NULL),(58,'새들의 복귀','보너스 스테이지','녹공작',9,NULL,NULL,37,150,300,600,1200,'공작','/images/collections/bird/녹공작.png',NULL),(59,'꽃밭','보라빛 해변','아메리카홍학',9,'무지개',NULL,55,220,440,880,1760,'홍학','/images/collections/bird/아메리카홍학.png',NULL),(60,'어촌','등대','아조레스멋쟁이새',10,'무지개',NULL,30,120,240,480,960,'소형','/images/collections/bird/아조레스멋쟁이새.png',NULL),(61,'숲','점핑 플랫폼','파랑딱새',10,'무지개',NULL,30,120,240,480,960,'소형','/images/collections/bird/파랑딱새.png',NULL),(62,'온천산','유적','비둘기조롱이',10,NULL,NULL,65,260,520,1040,2080,'매','/images/collections/bird/비둘기조롱이.png',NULL),(63,'숲','순록탑','수리부엉이',10,'무지개',NULL,65,260,520,1040,2080,'부엉이','/images/collections/bird/수리부엉이.png',NULL),(64,'이벤트','배우 비둘기 사건','신사 무늬 비둘기',1,NULL,NULL,17,68,136,272,544,'비둘기','/images/collections/bird/신사 무늬 비둘기.png','배우 비둘기 사건'),(65,'숲','점핑 플랫폼','신사 초록 비둘기',1,NULL,NULL,15,60,120,240,480,'비둘기','/images/collections/bird/신사 초록 비둘기.png','배우 비둘기 사건'),(66,'숲','영혼의 참나무 숲','신사 파랑 비둘기',1,NULL,NULL,15,60,120,240,480,'비둘기','/images/collections/bird/신사 파랑 비둘기.png','배우 비둘기 사건'),(67,'숲','순록탑','신사 회색 비둘기',1,NULL,NULL,15,60,120,240,480,'비둘기','/images/collections/bird/신사 회색 비둘기.png','배우 비둘기 사건'),(68,'숲','숲속 섬','신사 빨강 비둘기',1,NULL,NULL,15,60,120,240,480,'비둘기','/images/collections/bird/신사 빨강 비둘기.png','배우 비둘기 사건');
/*!40000 ALTER TABLE `bird_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bug_collections`
--

DROP TABLE IF EXISTS `bug_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bug_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `location` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` int DEFAULT NULL,
  `weather` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_1` int DEFAULT NULL,
  `price_2` int DEFAULT NULL,
  `price_3` int DEFAULT NULL,
  `price_4` int DEFAULT NULL,
  `price_5` int DEFAULT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_bug_name` (`name`),
  KEY `idx_bug_location` (`location`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bug_collections`
--

LOCK TABLES `bug_collections` WRITE;
/*!40000 ALTER TABLE `bug_collections` DISABLE KEYS */;
INSERT INTO `bug_collections` VALUES (1,'숲','전체','호랑나비',1,NULL,NULL,30,45,60,120,240,'/images/collections/bug/호랑나비.png',NULL),(2,'도시','도심','유럽갈고리나비',1,NULL,NULL,30,45,60,120,240,'/images/collections/bug/유럽갈고리 나비.png',NULL),(3,'도시','근교','멧노랑나비',1,NULL,NULL,30,45,60,120,240,'/images/collections/bug/멧노랑나비.png',NULL),(4,'어촌','전체','배추흰나비',1,NULL,NULL,30,45,60,120,240,'/images/collections/bug/배추흰나비.png',NULL),(5,'아이템','곤충 유인사건','아폴로모시나비',1,NULL,NULL,45,67,90,180,360,'/images/collections/bug/아폴로모시나비.png',NULL),(6,'아이템','곤충 유인사건','붉은고리호랑나비',1,NULL,NULL,30,45,60,120,240,'/images/collections/bug/붉은고리호랑나비.png',NULL),(7,'에어 꿀벌 유인기 특산품',NULL,'슬코스키몰포나비',1,NULL,NULL,90,135,180,360,720,'/images/collections/bug/슬코스키몰포나비.png',NULL),(8,'꽃밭','전체','아스파라거스벌레',1,NULL,NULL,55,82,110,220,440,'/images/collections/bug/아스파라거스벌레.png',NULL),(9,'온천산','전체','오아시스 메뚜기',1,NULL,NULL,45,67,90,180,360,'/images/collections/bug/오아시스메뚜기.png',NULL),(10,'홈',NULL,'별노린재',1,NULL,NULL,35,52,70,140,280,'/images/collections/bug/별노린재.png',NULL),(11,'물가',NULL,'큰고추잠자리',1,NULL,NULL,35,52,70,140,280,'/images/collections/bug/큰고추잠자리.png',NULL),(12,'도시','전체','연푸른부전나비',2,NULL,NULL,105,157,210,420,840,'/images/collections/bug/연푸른부전나비.png',NULL),(13,'온천산','전체','녹색호랑풍뎅이',2,NULL,NULL,110,165,220,440,880,'/images/collections/bug/녹색호랑풍뎅이.png',NULL),(14,'숲','전체','말벌호랑하늘소',2,NULL,NULL,110,165,220,440,880,'/images/collections/bug/말벌호랑하늘소.png',NULL),(15,'홈',NULL,'파란꽃풍뎅이',2,'비/무지개',NULL,165,247,330,660,1320,'/images/collections/bug/파란꽃풍뎅이.png',NULL),(16,'어촌','전체','망치다리메뚜기',2,NULL,NULL,45,67,90,180,360,'/images/collections/bug/망치다리메뚜기.png',NULL),(17,'도시','근교','칠성 무당벌레',2,'비/무지개',NULL,110,165,220,440,880,'/images/collections/bug/칠성 무당벌레.png',NULL),(18,'도시','근교 호수','넉점박이잠자리',2,'비/무지개',NULL,75,112,150,300,600,'/images/collections/bug/넉점박이잠자리.png',NULL),(19,'꽃밭','전체','호박벌',2,NULL,NULL,110,165,220,440,880,'/images/collections/bug/호박벌.png',NULL),(20,'홈',NULL,'붉은목제비나비',3,NULL,'0~6 / 18~24',90,135,180,360,720,'/images/collections/bug/붉은목제비나비.png',NULL),(21,'온천산','온천','홍날개',3,NULL,NULL,110,165,220,440,880,'/images/collections/bug/홍날개.png',NULL),(22,'아이템','곤충 유인사건','분홍색 철써기',3,NULL,NULL,90,135,180,360,720,'/images/collections/bug/분홍색 철써기.png',NULL),(23,'꽃밭','보라빛 해변','여치',3,NULL,NULL,180,270,360,720,1440,'/images/collections/bug/여치.png',NULL),(24,'숲','순록탑','흰점꼬리털벌',3,NULL,'6~24',165,247,330,660,1320,'/images/collections/bug/흰점꼬리털벌.png',NULL),(25,'어촌','어촌 광장','개미',3,NULL,NULL,220,330,440,880,1760,'/images/collections/bug/개미.png',NULL),(26,'꽃밭','고래산','보라네발나비',3,'해/무지개','0~6 / 12~24',90,135,180,360,720,'/images/collections/bug/보라네발나비.png',NULL),(27,'도시','근교','긴꼬리산누에나방',3,'해/무지개','6~24',105,157,210,420,840,'/images/collections/bug/긴꼬리산누에나방.png',NULL),(28,'어촌','부두','표범무늬네발나비',4,'비/무지개','0~12 / 18~24',90,135,180,360,720,'/images/collections/bug/표범무늬네발나비.png',NULL),(29,'도시','근교','큰줄무늬메뚜기',4,'해/무지개','0~6 / 12~24',140,210,280,560,1120,'/images/collections/bug/큰줄무늬메뚜기.png',NULL),(30,'온천산','화산 호수','사성 무당벌레',4,'비/무지개',NULL,165,247,330,660,1320,'/images/collections/bug/사성 무당벌레.png',NULL),(31,'숲','영혼의 참나무 숲','매미',4,NULL,'0~6 / 12~24',220,330,440,880,1760,'/images/collections/bug/매미.png',NULL),(32,'강변',NULL,'밀잠자리',4,'비/무지개',NULL,75,112,150,300,600,'/images/collections/bug/밀잠자리.png',NULL),(33,'온천산','바위절벽','무지개사마귀',4,'해/무지개','0~6 / 12~24',195,292,390,780,1560,'/images/collections/bug/무지개사마귀.png',NULL),(34,'꽃밭','풍차꽃밭','공작나비',5,NULL,NULL,90,135,180,360,720,'/images/collections/bug/공작나비.png',NULL),(35,'온천산','온천','신선나비',5,'해/무지개','0~18',90,135,180,360,720,'/images/collections/bug/신선나비.png',NULL),(36,'아이템','곤충 유인사건','흰마녀밤나방',5,'해/무지개',NULL,90,135,180,360,720,'/images/collections/bug/흰마녀밤나방.png',NULL),(37,'숲','숲속 섬','고산수염하늘소',5,'무지개',NULL,165,247,330,660,1320,'/images/collections/bug/고산수염하늘소.png',NULL),(38,'숲','순록탑','이색무당벌레',5,'비/무지개','0~6 / 12~24',165,247,330,660,1320,'/images/collections/bug/이색무당벌레.png',NULL),(39,'온천산','유적','파푸아사마귀',5,'해/무지개',NULL,390,585,780,1560,3120,'/images/collections/bug/파푸아사마귀.png',NULL),(40,'꽃밭','고래산','보라벌',5,'해/무지개',NULL,165,247,330,660,1320,'/images/collections/bug/보라벌.png',NULL),(41,'도시','근교','녹색날개호랑나비',6,NULL,'0~6 / 18~24',150,225,300,600,1200,'/images/collections/bug/녹색날개호랑나비.png',NULL),(42,'숲','점핑 플랫폼','산악사슴벌레',6,'비/무지개','6~24',275,412,550,1100,2200,'/images/collections/bug/산악사슴벌레.png',NULL),(43,'온천산','바위절벽','은빛보석풍뎅이',6,'해/무지개','0~18',165,247,330,660,1320,'/images/collections/bug/은빛보석풍뎅이.png',NULL),(44,'어촌','등대','파란노린재',6,NULL,'6~18',110,165,220,440,880,'/images/collections/bug/파란노린재.png',NULL),(45,'숲','숲속 호수','물잠자리',6,'비/무지개',NULL,110,165,220,440,880,'/images/collections/bug/물잠자리.png',NULL),(46,'숲','영혼의 참나무 숲','메넬라우스나비',7,'해/무지개','6~24',150,225,300,600,1200,'/images/collections/bug/메넬라우스나비.png',NULL),(47,'아이템','곤충 유인사건','왕나비',7,'비/무지개',NULL,150,225,300,600,1200,'/images/collections/bug/왕나비.png',NULL),(48,'온천산','유적','티폰쇠똥구리',7,NULL,'0~18',275,412,550,1100,2200,'/images/collections/bug/티폰쇠똥구리.png',NULL),(49,'꽃밭','고래산','보석꽃풍뎅이',7,'비/무지개','6~18',275,412,550,1100,2200,'/images/collections/bug/보석꽃풍뎅이.png',NULL),(50,'숲','점핑 플랫폼','황금보석풍뎅이',7,'해/무지개','12~24',275,412,550,1100,2200,'/images/collections/bug/황금보석풍뎅이.png',NULL),(51,'온천산','온천산 호수','찔레잠자리',7,'무지개','0~6 / 12~24',185,277,370,740,1480,'/images/collections/bug/찔레잠자리.png',NULL),(52,'숲','영혼의 참나무 숲','이사벨라나방',8,'해/무지개','12~24',150,225,300,600,1200,'/images/collections/bug/이사벨라나방.png',NULL),(53,'도시','근교','혜성꼬리나방',8,'해/무지개','0~6 / 18~24',240,360,480,960,1920,'/images/collections/bug/혜성꼬리나방.png',NULL),(54,'어촌','동쪽 부두','장수풍뎅이',8,'해/무지개','0~6 / 18~24',275,412,550,1100,2200,'/images/collections/bug/장수풍뎅이.png',NULL),(55,'꽃밭','보라빛 해변','피카소노린재',8,'해/무지개','0~6 / 18~24',185,277,370,740,1480,'/images/collections/bug/피카소노린재.png',NULL),(56,'꽃밭','풍차꽃밭','진주네발나비',9,'비/무지개','0~12',240,360,480,960,1920,'/images/collections/bug/진주네발나비.png',NULL),(57,'숲','영혼의 참나무 숲','황금귀신사슴벌레',9,'비/무지개','0~6 / 18~24',440,660,880,1760,3520,'/images/collections/bug/황금귀신사슴벌레.png',NULL),(58,'아이템','곤충 유인사건','무지개사슴벌레',9,NULL,NULL,440,660,880,1760,3520,'/images/collections/bug/무지개사슴벌레.png',NULL),(59,'온천산','유적','악마꽃사마귀',9,'비/무지개','12~24',515,772,1030,2060,4120,'/images/collections/bug/악마꽃사마귀.png',NULL),(60,'어촌','어촌 광장','푸른목수벌',9,'무지개','0~6 / 18~24',440,660,880,1760,3520,'/images/collections/bug/푸른목수벌.png',NULL),(61,'꽃밭','보라빛 해변','헬레나몰포나비',10,'무지개','6~18',240,360,480,960,1920,'/images/collections/bug/헬레나몰포나비.png',NULL),(62,'숲','순록탑','헤쿠바몰포나비',10,'무지개','6~18',240,360,480,960,1920,'/images/collections/bug/헤쿠바몰포나비.png',NULL),(63,'온천산','화산 호수','헤라클레스풍뎅이',10,'해/무지개','12~24',660,990,1320,2640,5280,'/images/collections/bug/헤라클레스풍뎅이.png',NULL),(64,'숲','순록탑','사선주머니나방',10,'해/무지개','0~6 / 18~24',440,660,880,1760,3520,'/images/collections/bug/사선주머니나방.png',NULL),(69,'꽃밭','풍차꽃밭','스크립터 보라 호박벌',1,NULL,NULL,110,165,220,440,880,'/images/collections/bug/스크립터 보라 호박벌.png','꿈의 명암'),(70,'꽃밭','풍차꽃밭','스크립터 분홍 호박벌',1,NULL,NULL,110,165,220,440,880,'/images/collections/bug/스크립터 분홍 보학벌.png','꿈의 명암'),(71,'꽃밭','고래산','스크립터 빨강 호박벌',1,NULL,NULL,110,165,220,440,880,'/images/collections/bug/스크립터 빨강 호박벌.png','꿈의 명암'),(72,'꽃밭','보라빛 해변','스크립터 초록 호박벌',1,NULL,NULL,110,165,220,440,880,'/images/collections/bug/스크립터 초록 호박벌.png','꿈의 명암'),(73,'이벤트','스크립터 벌 사건','스크립터 금색 호박벌',1,NULL,NULL,165,247,370,555,832,'/images/collections/bug/스크립터 금색 호박벌.png','꿈의 명암');
/*!40000 ALTER TABLE `bug_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cooking_collections`
--

DROP TABLE IF EXISTS `cooking_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cooking_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` int DEFAULT NULL,
  `ingredients` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `buy_price` int DEFAULT NULL,
  `price_1` int DEFAULT NULL,
  `price_2` int DEFAULT NULL,
  `price_3` int DEFAULT NULL,
  `price_4` int DEFAULT NULL,
  `price_5` int DEFAULT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cooking_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cooking_collections`
--

LOCK TABLES `cooking_collections` WRITE;
/*!40000 ALTER TABLE `cooking_collections` DISABLE KEYS */;
INSERT INTO `cooking_collections` VALUES (1,'베지 샐러드',1,'아무 채소 (2)',NULL,90,135,180,360,720,'/images/collections/cook/베지 샐러드.png',NULL),(2,'믹스 잼',1,'혼합 과일 (4)',NULL,160,240,320,640,1280,'/images/collections/cook/믹스 잼.png',NULL),(3,'라즈베리 잼',1,'라즈베리 (4)',NULL,250,375,500,1000,2000,'/images/collections/cook/라즈베리 잼.png',NULL),(4,'케첩',1,'토마토 (4)',NULL,180,270,360,720,1440,'/images/collections/cook/케첩.png',NULL),(5,'블루베리 잼',1,'블루베리 (4)',NULL,170,255,340,680,1360,'/images/collections/cook/블루베리 잼.png',NULL),(6,'사과 잼',1,'사과 (4)',NULL,270,405,540,1080,2160,'/images/collections/cook/사과 잼.png',NULL),(7,'오렌지 잼',1,'오렌지 (4)',NULL,270,405,540,1080,2160,'/images/collections/cook/오렌지 잼.png',NULL),(8,'괴상한 음식',1,'아무 음식 (1)',NULL,30,NULL,NULL,NULL,NULL,'/images/collections/cook/괴상한 음식.png',NULL),(9,'괴상한 음료',1,'아무 음료 (1)',NULL,30,NULL,NULL,NULL,NULL,'/images/collections/cook/괴상한 음료.png',NULL),(10,'딸기 잼',1,'딸기 (4)',NULL,1580,2370,3160,6320,12640,'/images/collections/cook/딸기 잼.png',NULL),(11,'파인애플 잼',1,'파인애플 (4)',NULL,380,570,760,1520,3040,'/images/collections/cook/파인애플 잼.png',NULL),(12,'포도 잼',1,'포도 (4)',NULL,2020,3030,4040,8080,16160,'/images/collections/cook/포도 잼.png',NULL),(13,'초콜릿 소스',1,'코코아 (4)',NULL,NULL,NULL,NULL,NULL,NULL,'/images/collections/cook/초콜릿 소스.png',NULL),(14,'피시 앤 칩스',1,'아무 생선 (2), 감자 (2)',NULL,310,465,620,1240,2480,'/images/collections/cook/피시 앤 칩스.png',NULL),(15,'치즈케이크',1,'치즈 (1), 우유 (1), 밀 (1)',NULL,480,720,960,1920,3840,'/images/collections/cook/치즈케이크.png',NULL),(16,'오리지널 롤케이크',1,'달걀 (1), 우유 (1), 아무 설탕 (2)',NULL,NULL,NULL,NULL,NULL,NULL,'/images/collections/cook/오리지널 롤케이크.png',NULL),(17,'퍼플 롤케이크',1,'달걀 (1), 우유 (1), 보라 설탕 (2)',NULL,570,855,1140,2280,4560,'/images/collections/cook/퍼플 롤케이크.png',NULL),(18,'레드 롤케이크',1,'달걀 (1), 우유 (1), 빨간 설탕 (2)',NULL,570,855,1140,2280,4560,'/images/collections/cook/레드 롤케이크.png',NULL),(19,'오렌지 롤케이크',1,'달걀 (1), 우유 (1), 주황 설탕 (2)',NULL,570,855,1140,2280,4560,'/images/collections/cook/오렌지 롤케이크.png',NULL),(20,'옐로우 롤케이크',1,'달걀 (1), 우유 (1), 노란 설탕 (2)',NULL,570,855,1140,2280,4560,'/images/collections/cook/옐로우 롤케이크.png',NULL),(21,'그린 롤케이크',1,'달걀 (1), 우유 (1), 초록 설탕 (2)',NULL,570,855,1140,2280,4560,'/images/collections/cook/그린 롤케이크.png',NULL),(22,'스카이 롤케이크',1,'달걀 (1), 우유 (1), 파란 설탕 (2)',NULL,570,855,1140,2280,4560,'/images/collections/cook/스카이 롤케이크.png',NULL),(23,'블루 롤케이크',1,'달걀 (1), 우유 (1), 남색 설탕 (2)',NULL,570,855,1140,2280,4560,'/images/collections/cook/블루 롤케이크.png',NULL),(24,'버섯 파이',1,'아무 버섯 (2), 밀 (1), 달걀 (1)',NULL,500,750,1000,2000,4000,'/images/collections/cook/버섯 파이.png',NULL),(25,'느타리버섯 파이',1,'느타리버섯 (2), 밀 (1), 달걀 (1)',NULL,500,750,1000,2000,4000,'/images/collections/cook/느타리버섯 파이.png',NULL),(26,'표고버섯 파이',1,'표고버섯 (2), 밀 (1), 달걀 (1)',NULL,500,750,1000,2000,4000,'/images/collections/cook/표고버섯 파이.png',NULL),(27,'양송이버섯 파이',1,'양송이버섯 (2), 밀 (1), 달걀 (1)',NULL,500,750,1000,2000,4000,'/images/collections/cook/양송이버섯 파이.png',NULL),(28,'그물버섯 파이',1,'그물버섯 (2), 밀 (1), 달걀 (1)',NULL,500,750,1000,2000,4000,'/images/collections/cook/그물버섯 파이.png',NULL),(29,'검은 트러플 파이',1,'블랙 트러플 (2), 밀 (1), 달걀 (1)',NULL,830,1245,1660,3320,6640,'/images/collections/cook/검은 트러플 파이.png',NULL),(30,'구운 버섯',1,'아무 버섯 (4)',NULL,180,270,360,720,1440,'/images/collections/cook/구운 버섯.png',NULL),(31,'구운 느타리버섯',1,'느타리버섯 (4)',NULL,180,270,360,720,1440,'/images/collections/cook/구운 느타리버섯.png',NULL),(32,'구운 표고버섯',1,'표고버섯 (4)',NULL,180,270,360,720,1440,'/images/collections/cook/구운 표고버섯.png',NULL),(33,'구운 양송이버섯',1,'양송이버섯 (4)',NULL,180,270,360,720,1440,'/images/collections/cook/구운 양송이버섯.png',NULL),(34,'구운 그물버섯',1,'그물버섯 (4)',NULL,180,270,360,720,1440,'/images/collections/cook/구운 그물버섯.png',NULL),(35,'커피',2,'커피 콩 (4)',NULL,290,435,580,1160,2320,'/images/collections/cook/커피.png',NULL),(36,'카페라떼',2,'커피 콩 (2), 우유 (2)',NULL,300,450,600,1200,2400,'/images/collections/cook/카페라떼.png',NULL),(37,'훈제 연어 베이글',2,'아무 생선 (1), 치즈 (1), 아무 채소 (1), 밀 (1)',NULL,520,780,1040,2080,4160,'/images/collections/cook/훈제 연어 베이글.png',NULL),(38,'씨푸드 덮밥',3,'아무 조개류 (2), 밀 (1), 토마토 (1)',NULL,490,735,980,1960,3920,'/images/collections/cook/씨푸드 덮밥.png',NULL),(39,'컨트리 스튜',3,'토마토 (1), 감자 (1), 상추 (1)',NULL,640,960,1280,2560,5120,'/images/collections/cook/컨트리 스튜.png',NULL),(40,'검은 트러플 크림 파스타',3,'블랙 트러플 (1), 밀 (2), 우유 (1)',NULL,900,1350,1800,3600,7200,'/images/collections/cook/검은 트러플 크림 파스타.png',NULL),(41,'씨푸드 피자',4,'치즈 (1), 케첩 (1), 밀 (1), 아무 생선 (1)',NULL,780,1170,1560,3120,6240,'/images/collections/cook/씨푸드 피자.png',NULL),(42,'미트소스 파스타',4,'고기 (1), 밀 (1), 토마토 (1), 치즈 (1)',NULL,670,1005,1340,2680,5360,'/images/collections/cook/미트소스 파스타.png',NULL),(43,'애플파이',5,'사과 (1), 밀 (1), 달걀 (1), 버터 (1)',NULL,730,1095,1460,2920,5840,'/images/collections/cook/애플파이.png',NULL),(44,'당근 케이크',5,'달걀 (1), 밀 (1), 당근 (2)',NULL,840,1260,1680,3360,6720,'/images/collections/cook/당근 케이크.png',NULL),(45,'콘수프',5,'우유 (1), 버터 (1), 옥수수 (2)',NULL,1340,2010,2680,5360,10720,'/images/collections/cook/콘수프.png',NULL),(46,'럭셔리 씨푸드 플래터',6,'유럽민물가재 (2), 아무 생선 (2)',NULL,410,615,820,1640,3280,'/images/collections/cook/럭셔리 씨푸드 플래터.png',NULL),(47,'티라미수',6,'커피 원두 (1), 달걀 (1), 우유 (1), 치즈 (1)',NULL,530,795,1060,2120,4240,'/images/collections/cook/티라미수.png',NULL),(48,'캠핑 세트',7,'아무 커피 (1), 씨푸드 피자 (1), 애플파이 (1), 피시 앤 칩스 (1)',NULL,2260,3390,4520,9040,18080,'/images/collections/cook/캠핑 세트.png',NULL),(49,'잉글리시 애프터눈 티',7,'티라미수 (1), 아무 잼재료 (1)',NULL,710,1065,1420,2840,5680,'/images/collections/cook/잉글리시 애프터눈 티.png',NULL),(50,'미트버거',8,'밀 (1), 상추 (1), 고기 (1), 케첩 (1)',NULL,1350,2025,2700,5400,10800,'/images/collections/cook/미트버거.png',NULL),(51,'랍스터 냉채',8,'아무 랍스터 (3), 상추 (1)',NULL,850,1275,1700,3400,6800,'/images/collections/cook/랍스터 냉채.png',NULL),(52,'미트소스 가지 그라탱',9,'가지 (1), 고기 (1), 식용유 (1), (1) 케첩 (1)',NULL,1230,1845,2460,4920,9840,'/images/collections/cook/미트소스 가지 그라탱.png',NULL),(53,'캔들라이트 디너',9,'베지 샐러드 (1), 훈재 연어 베이글 (1), 씨푸드 덮밥 (1), 티라미수 (1)',NULL,1760,2640,3520,7040,14080,'/images/collections/cook/캔들라이트 디너.png',NULL),(54,'킹크랩 찜',10,'아무 킹크랩 (3), 버터 (1)',NULL,1987,2980,3974,7948,15896,'/images/collections/cook/킹크랩 찜.png',NULL),(92,'짭짤한 팝콘통',1,'옥수수 (1), 버섯 (1), 버터 (2)',NULL,900,1350,1800,3600,7200,'/images/items/cook/짭짤한 팝콘통.png','꿈의 명암'),(93,'캐러멜 팝콘통',1,'옥수수 (1), 봄날 카라멜 슈가 (2), 버터 (1)',NULL,820,1230,1640,3280,6560,'/images/items/cook/캐러멜 팝콘통.png','꿈의 명암'),(94,'살사 소스 웨이브 감자칩',1,'감자 (2), 살사 소스 (1)',NULL,280,420,560,1120,2240,'/images/items/cook/살사 소스 웨이브 감자칩.png','꿈의 명암'),(95,'짭조름한 더블 버킷',1,'짭짤한 팝콘통 (1), 살사 소스 웨이브 감자칩 (1)',NULL,1230,2965,3580,6040,10960,'/images/items/cook/짭조름한 더블 버킷.png','꿈의 명암'),(96,'달콤한 듀얼 팝콘통',1,'캐러멜 팝콘통 (1), 살사 소스 웨이브 감자칩 (1)',NULL,1150,1725,2300,4600,9200,'/images/items/cook/달콤한 듀얼 팝콘통.png','꿈의 명암'),(97,'로메인 타코',1,'로메인 (2), 살사 소스 (1), 달걀 (1)',NULL,260,390,520,1040,2080,'/images/items/cook/로메인 타코.png','꿈의 명암'),(98,'나물 로메인 타코',1,'나물 (2), 로메인 타코 (1)',NULL,330,495,660,1320,2640,'/images/items/cook/나물 로메인 타코.png','꿈의 명암'),(99,'야생 고사리 로메인 타코',1,'야생 고사리 (2), 로메인 타코 (1)',NULL,330,495,660,1320,2640,'/images/items/cook/야생 고사리 로메인 타코.png','꿈의 명암'),(100,'산마늘 로메인 타코',1,'산마늘 (2), 로메인 타코 (1)',NULL,330,495,660,1320,2640,'/images/items/cook/산마늘 로메인 타코.png','꿈의 명암'),(101,'산우엉 로메인 타코',1,'산우엉 (2), 로메인 타코 (1)',NULL,330,495,660,1320,2640,'/images/items/cook/산우엉 로메인 타코.png','꿈의 명암'),(102,'산겨자 로메인 타코',1,'산겨자 (2), 로메인 타코 (1)',NULL,330,495,660,1320,2640,'/images/items/cook/산겨자 로메인 타코.png','꿈의 명암'),(103,'봄날 과일 홍차',1,'홍차 (1), 과일 (1), 봄날 카라멜 슈가 (2)',NULL,460,690,920,1840,3680,'/images/items/cook/봄날 과일 홍차.png','꿈의 명암'),(104,'봄날 사과 홍차',1,'홍차 (1), 사과 (1), 봄날 카라멜 슈가 (2)',NULL,480,720,960,1920,3840,'/images/items/cook/봄날 사과 홍차.png','꿈의 명암'),(105,'봄날 오렌지 홍차',1,'홍차 (1), 오렌지 (1), 봄날 카라멜 슈가 (2)',NULL,480,720,960,1920,3840,'/images/items/cook/봄날 오렌지 홍차.png','꿈의 명암'),(106,'봄날 블루베리 홍차',1,'홍차 (1), 블루베리 (1), 봄날 카라멜 슈가 (2)',NULL,460,690,920,1840,3680,'/images/items/cook/봄날 블루베리 홍차.png','꿈의 명암'),(107,'봄날 라즈베리 홍차',1,'홍차 (1), 라즈베리 (1), 봄날 카라멜 슈가 (2)',NULL,480,720,960,1920,3840,'/images/items/cook/봄날 라즈베리 홍차.png','꿈의 명암'),(108,'봄날 딸기 홍차',1,'홍차 (1), 딸기 (1), 봄날 카라멜 슈가 (2)',NULL,800,1200,1600,3200,6400,'/images/items/cook/봄날 딸기 홍차.png','꿈의 명암'),(109,'봄날 포도 홍차',1,'홍차 (1), 포도 (1), 봄날 카라멜 슈가 (2)',NULL,910,1365,1820,3640,7280,'/images/items/cook/봄날 포도 홍차.png','꿈의 명암'),(110,'봄날 파인애플 홍차',1,'홍차 (1), 파인애플 (1), 봄날 카라멜 슈가 (2)',NULL,480,720,960,1920,3840,'/images/items/cook/봄날 파인애플 홍차.png','꿈의 명암'),(111,'화려한 관람 세트',1,'봄날 과일 홍차 (1), 달콤한 듀얼 팝콘통 (1), 나물 로메인 타코 (1)',NULL,1960,2940,3920,7840,15680,'/images/items/cook/화려한 관람 세트.png','꿈의 명암'),(112,'프리미엄 관람 세트',1,'봄날 과일 홍차 (1), 짭조름한 더블 버킷 (1), 나물 로메인 타코 (2)',NULL,2370,3555,4740,9480,18960,'/images/items/cook/프리미엄 관람 세트.png','꿈의 명암');
/*!40000 ALTER TABLE `cooking_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cooking_ingredients`
--

DROP TABLE IF EXISTS `cooking_ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cooking_ingredients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cooking_id` int NOT NULL,
  `ingredient_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `item_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ci_cooking` (`cooking_id`),
  KEY `idx_ingredient_cooking_id` (`cooking_id`),
  KEY `idx_ingredient_item_id` (`item_id`),
  CONSTRAINT `fk_ci_cooking` FOREIGN KEY (`cooking_id`) REFERENCES `cooking_collections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=238 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cooking_ingredients`
--

LOCK TABLES `cooking_ingredients` WRITE;
/*!40000 ALTER TABLE `cooking_ingredients` DISABLE KEYS */;
INSERT INTO `cooking_ingredients` VALUES (1,1,'아무 채소',2,NULL,NULL),(2,2,'혼합 과일',4,NULL,NULL),(3,3,'라즈베리',4,NULL,NULL),(4,4,'토마토',4,NULL,NULL),(5,5,'블루베리',4,NULL,NULL),(6,6,'사과',4,NULL,NULL),(7,7,'오렌지',4,NULL,NULL),(8,8,'아무 음식',1,NULL,NULL),(9,9,'아무 음료',1,NULL,NULL),(10,10,'딸기',4,NULL,NULL),(11,11,'파인애플',4,NULL,NULL),(12,12,'포도',4,NULL,NULL),(13,13,'코코아',4,NULL,NULL),(14,14,'아무 생선',2,NULL,NULL),(15,14,'감자',2,NULL,NULL),(16,15,'치즈',1,NULL,NULL),(17,15,'우유',1,NULL,NULL),(18,15,'밀',1,NULL,NULL),(19,16,'달걀',1,NULL,NULL),(20,16,'우유',1,NULL,NULL),(21,16,'아무 설탕',2,NULL,NULL),(22,17,'달걀',1,NULL,NULL),(23,17,'우유',1,NULL,NULL),(24,17,'보라 설탕',2,NULL,NULL),(25,18,'달걀',1,NULL,NULL),(26,18,'우유',1,NULL,NULL),(27,18,'빨간 설탕',2,NULL,NULL),(28,19,'달걀',1,NULL,NULL),(29,19,'우유',1,NULL,NULL),(30,19,'주황 설탕',2,NULL,NULL),(31,20,'달걀',1,NULL,NULL),(32,20,'우유',1,NULL,NULL),(33,20,'노란 설탕',2,NULL,NULL),(34,21,'달걀',1,NULL,NULL),(35,21,'우유',1,NULL,NULL),(36,21,'초록 설탕',2,NULL,NULL),(37,22,'달걀',1,NULL,NULL),(38,22,'우유',1,NULL,NULL),(39,22,'파란 설탕',2,NULL,NULL),(40,23,'달걀',1,NULL,NULL),(41,23,'우유',1,NULL,NULL),(42,23,'남색 설탕',2,NULL,NULL),(43,24,'아무 버섯',2,NULL,NULL),(44,24,'밀',1,NULL,NULL),(45,24,'달걀',1,NULL,NULL),(46,25,'느타리버섯',2,NULL,NULL),(47,25,'밀',1,NULL,NULL),(48,25,'달걀',1,NULL,NULL),(49,26,'표고버섯',2,NULL,NULL),(50,26,'밀',1,NULL,NULL),(51,26,'달걀',1,NULL,NULL),(52,27,'양송이버섯',2,NULL,NULL),(53,27,'밀',1,NULL,NULL),(54,27,'달걀',1,NULL,NULL),(55,28,'그물버섯',2,NULL,NULL),(56,28,'밀',1,NULL,NULL),(57,28,'달걀',1,NULL,NULL),(58,29,'블랙 트러플',2,NULL,NULL),(59,29,'밀',1,NULL,NULL),(60,29,'달걀',1,NULL,NULL),(61,30,'아무 버섯',4,NULL,NULL),(62,31,'느타리버섯',4,NULL,NULL),(63,32,'표고버섯',4,NULL,NULL),(64,33,'양송이버섯',4,NULL,NULL),(65,34,'그물버섯',4,NULL,NULL),(66,35,'커피 콩',4,NULL,NULL),(67,36,'커피 콩',2,NULL,NULL),(68,36,'우유',2,NULL,NULL),(69,37,'아무 생선',1,NULL,NULL),(70,37,'치즈',1,NULL,NULL),(71,37,'아무 채소',1,NULL,NULL),(72,37,'밀',1,NULL,NULL),(73,38,'아무 조개류',2,NULL,NULL),(74,38,'밀',1,NULL,NULL),(75,38,'토마토',1,NULL,NULL),(76,39,'토마토',1,NULL,NULL),(77,39,'감자',1,NULL,NULL),(78,39,'상추',1,NULL,NULL),(79,40,'블랙 트러플',1,NULL,NULL),(80,40,'밀',2,NULL,NULL),(81,40,'우유',1,NULL,NULL),(82,41,'치즈',1,NULL,NULL),(83,41,'케첩',1,NULL,NULL),(84,41,'밀',1,NULL,NULL),(85,41,'아무 생선',1,NULL,NULL),(86,42,'고기',1,NULL,NULL),(87,42,'밀',1,NULL,NULL),(88,42,'토마토',1,NULL,NULL),(89,42,'치즈',1,NULL,NULL),(90,43,'사과',1,NULL,NULL),(91,43,'밀',1,NULL,NULL),(92,43,'달걀',1,NULL,NULL),(93,43,'버터',1,NULL,NULL),(94,44,'달걀',1,NULL,NULL),(95,44,'밀',1,NULL,NULL),(96,44,'당근',2,NULL,NULL),(97,45,'우유',1,NULL,NULL),(98,45,'버터',1,NULL,NULL),(99,45,'옥수수',2,NULL,NULL),(100,46,'유럽민물가재',2,NULL,NULL),(101,46,'아무 생선',2,NULL,NULL),(102,47,'커피 원두',1,NULL,NULL),(103,47,'달걀',1,NULL,NULL),(104,47,'우유',1,NULL,NULL),(105,47,'치즈',1,NULL,NULL),(106,48,'아무 커피',1,NULL,NULL),(107,48,'씨푸드 피자',1,NULL,NULL),(108,48,'애플파이',1,NULL,NULL),(109,48,'피시 앤 칩스',1,NULL,NULL),(110,49,'티라미수',1,NULL,NULL),(111,49,'아무 잼재료',1,NULL,NULL),(112,50,'밀',1,NULL,NULL),(113,50,'상추',1,NULL,NULL),(114,50,'고기',1,NULL,NULL),(115,50,'케첩',1,NULL,NULL),(116,51,'아무 랍스터',3,NULL,NULL),(117,51,'상추',1,NULL,NULL),(118,52,'가지',1,NULL,NULL),(119,52,'고기',1,NULL,NULL),(120,52,'식용유',1,NULL,NULL),(121,52,'케첩',1,NULL,NULL),(122,53,'베지 샐러드',1,NULL,NULL),(123,53,'훈제 연어 베이글',1,NULL,NULL),(124,53,'씨푸드 덮밥',1,NULL,NULL),(125,53,'티라미수',1,NULL,NULL),(126,54,'아무 킹크랩',3,NULL,NULL),(127,54,'버터',1,NULL,NULL),(183,92,'옥수수',1,NULL,NULL),(184,92,'버섯',1,NULL,NULL),(185,92,'버터',2,NULL,NULL),(186,93,'옥수수',1,NULL,NULL),(187,93,'봄날 카라멜 슈가',2,NULL,NULL),(188,93,'버터',1,NULL,NULL),(189,94,'감자',2,NULL,NULL),(190,94,'살사 소스',1,NULL,NULL),(191,95,'짭짤한 팝콘통',1,NULL,NULL),(192,95,'살사 소스 웨이브 감자칩',1,NULL,NULL),(193,96,'캐러멜 팝콘통',1,NULL,NULL),(194,96,'살사 소스 웨이브 감자칩',1,NULL,NULL),(195,97,'로메인',2,NULL,NULL),(196,97,'살사 소스',1,NULL,NULL),(197,97,'달걀',1,NULL,NULL),(198,98,'나물',2,NULL,NULL),(199,98,'로메인 타코',1,NULL,NULL),(200,99,'야생 고사리',2,NULL,NULL),(201,99,'로메인 타코',1,NULL,NULL),(202,100,'산마늘',2,NULL,NULL),(203,100,'로메인 타코',1,NULL,NULL),(204,101,'산우엉',2,NULL,NULL),(205,101,'로메인 타코',1,NULL,NULL),(206,102,'산겨자',2,NULL,NULL),(207,102,'로메인 타코',1,NULL,NULL),(208,103,'홍차',1,NULL,NULL),(209,103,'과일',1,NULL,NULL),(210,103,'봄날 카라멜 슈가',2,NULL,NULL),(211,104,'홍차',1,NULL,NULL),(212,104,'사과',1,NULL,NULL),(213,104,'봄날 카라멜 슈가',2,NULL,NULL),(214,105,'홍차',1,NULL,NULL),(215,105,'오렌지',1,NULL,NULL),(216,105,'봄날 카라멜 슈가',2,NULL,NULL),(217,106,'홍차',1,NULL,NULL),(218,106,'블루베리',1,NULL,NULL),(219,106,'봄날 카라멜 슈가',2,NULL,NULL),(220,107,'홍차',1,NULL,NULL),(221,107,'라즈베리',1,NULL,NULL),(222,107,'봄날 카라멜 슈가',2,NULL,NULL),(223,108,'홍차',1,NULL,NULL),(224,108,'딸기',1,NULL,NULL),(225,108,'봄날 카라멜 슈가',2,NULL,NULL),(226,109,'홍차',1,NULL,NULL),(227,109,'포도',1,NULL,NULL),(228,109,'봄날 카라멜 슈가',2,NULL,NULL),(229,110,'홍차',1,NULL,NULL),(230,110,'파인애플',1,NULL,NULL),(231,110,'봄날 카라멜 슈가',2,NULL,NULL),(232,111,'봄날 과일 홍차',1,NULL,NULL),(233,111,'달콤한 듀얼 팝콘통',1,NULL,NULL),(234,111,'나물 로메인 타코',1,NULL,NULL),(235,112,'봄날 과일 홍차',1,NULL,NULL),(236,112,'짭조름한 더블 버킷',1,NULL,NULL),(237,112,'나물 로메인 타코',2,NULL,NULL);
/*!40000 ALTER TABLE `cooking_ingredients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crop_collections`
--

DROP TABLE IF EXISTS `crop_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crop_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_1` int DEFAULT NULL,
  `price_2` int DEFAULT NULL,
  `price_3` int DEFAULT NULL,
  `price_4` int DEFAULT NULL,
  `price_5` int DEFAULT NULL,
  `level` int DEFAULT NULL,
  `growth_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seed_buy_price` int DEFAULT NULL,
  `seed_sell_price` int DEFAULT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_crop_name` (`name`),
  KEY `idx_crop_location` (`location`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crop_collections`
--

LOCK TABLES `crop_collections` WRITE;
/*!40000 ALTER TABLE `crop_collections` DISABLE KEYS */;
INSERT INTO `crop_collections` VALUES (1,'토마토',NULL,30,40,50,60,90,1,'15 min',10,5,NULL,NULL),(2,'감자',NULL,90,120,150,180,270,1,'60 min',30,15,NULL,NULL),(3,'밀',NULL,285,381,475,570,855,2,'4 hours',95,47,NULL,NULL),(4,'상추',NULL,435,582,726,870,1305,3,'8 hours',145,72,NULL,NULL),(5,'파인애플',NULL,52,69,86,104,156,4,'30 min',15,7,NULL,NULL),(6,'당근',NULL,155,207,258,310,465,5,'2 hours',50,25,NULL,NULL),(7,'딸기',NULL,375,502,626,750,1125,6,'6 hours',125,NULL,NULL,NULL),(8,'옥수수',NULL,515,690,860,1030,1545,6,'12 hours',170,NULL,NULL,NULL),(9,'포도',NULL,480,643,801,960,1440,7,'10 hours',160,NULL,NULL,NULL),(10,'가지',NULL,406,544,678,812,1218,8,'7 hours',135,NULL,NULL,NULL),(11,'티트리',NULL,NULL,NULL,NULL,NULL,NULL,11,NULL,25,NULL,NULL,NULL),(12,'카카오 나무',NULL,NULL,NULL,NULL,NULL,NULL,12,NULL,110,NULL,NULL,NULL),(13,'아보카도',NULL,NULL,NULL,NULL,NULL,NULL,13,NULL,180,NULL,NULL,NULL),(14,'로메인',NULL,30,40,50,60,70,1,'15 min',10,5,'/images/collections/crop/로메인.png',NULL);
/*!40000 ALTER TABLE `crop_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fish_collections`
--

DROP TABLE IF EXISTS `fish_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fish_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `location` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` int DEFAULT NULL,
  `weather` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_1` int DEFAULT NULL,
  `price_2` int DEFAULT NULL,
  `price_3` int DEFAULT NULL,
  `price_4` int DEFAULT NULL,
  `price_5` int DEFAULT NULL,
  `size` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_fish_name` (`name`),
  KEY `idx_fish_location` (`location`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fish_collections`
--

LOCK TABLES `fish_collections` WRITE;
/*!40000 ALTER TABLE `fish_collections` DISABLE KEYS */;
INSERT INTO `fish_collections` VALUES (1,'강','강 전체','민물배스',1,NULL,NULL,75,112,150,300,600,'M','/images/collections/fish/민물배스.png',NULL),(2,'강','강 전체','왕새우',1,NULL,NULL,50,75,100,200,400,'S','/images/collections/fish/왕새우.png',NULL),(3,'강','강 전체','틸라피아',1,NULL,NULL,320,480,640,1280,2560,'Blue','/images/collections/fish/틸라피아.png',NULL),(4,'강','거목 강','하늘종개',1,NULL,NULL,50,75,100,200,400,'S','/images/collections/fish/하늘종개.png',NULL),(5,'강','거목 강','민물잰더',3,'해/무지개',NULL,230,345,460,920,1840,'M','/images/collections/fish/민물잰더.png',NULL),(6,'강','거목 강','레드벨리피라냐',4,NULL,NULL,230,345,460,920,1840,'M','/images/collections/fish/레드벨리피라냐.png',NULL),(7,'강','거목 강','후첸',9,'무지개','0~6 / 12~24',380,570,760,1520,3040,'M','/images/collections/fish/후첸.png',NULL),(8,'강','고요한 강','미노우',1,NULL,NULL,50,75,100,200,400,'S','/images/collections/fish/미노우.png',NULL),(9,'강','고요한 강','민물대구',4,NULL,'18~24 / 6~18',230,345,460,920,1840,'L','/images/collections/fish/민물대구.png',NULL),(10,'강','고요한 강','첨연어',6,'무지개',NULL,150,225,300,600,1200,'S','/images/collections/fish/첨연어.png',NULL),(11,'강','노을 강','큰얼룩배스',1,NULL,NULL,50,75,100,200,400,'S','/images/collections/fish/큰얼룩배스.png',NULL),(12,'강','노을 강','유럽잉어',4,'해/무지개','18~24 / 6~18',230,345,460,920,1840,'M','/images/collections/fish/유럽잉어.png',NULL),(13,'강','노을 강','민물베도라치',5,NULL,NULL,150,225,300,600,1200,'S','/images/collections/fish/민물베도라치.png',NULL),(14,'강','얕은 강','바벨',1,NULL,NULL,75,112,150,300,600,'M','/images/collections/fish/바벨.png',NULL),(15,'강','얕은 강','큰가시고기',7,'비/무지개',NULL,150,225,300,600,1200,'S','/images/collections/fish/큰가시고기.png',NULL),(16,'바다','고래 바다','전갱이',1,NULL,NULL,50,75,100,200,400,'S','/images/collections/fish/전갱이.png',NULL),(17,'바다','고래 바다','해마',3,NULL,'0~18',100,150,200,400,800,'S','/images/collections/fish/해마.png',NULL),(18,'바다','고래 바다','대서양연어',4,NULL,'0~6 / 12~24',155,232,310,620,1240,'M','/images/collections/fish/대서양연어.png',NULL),(19,'바다','고래 바다','대서양고등어',5,'해/무지개','18~24 / 6~18',150,225,300,600,1200,'S','/images/collections/fish/대서양고등어.png',NULL),(20,'바다','고래 바다','킹크랩',8,'무지개',NULL,535,802,1070,2140,4280,'L','/images/collections/fish/킹크랩.png',NULL),(21,'바다','고래 바다','황새치',10,'무지개','6~18',850,1275,1700,3400,6800,'L','/images/collections/fish/황새치.png',NULL),(22,'바다','구해','바다가시고기',2,NULL,NULL,50,75,100,200,400,'S','/images/collections/fish/바다가시고기.png',NULL),(23,'바다','구해','흰동가리',3,NULL,NULL,100,150,200,400,800,'S','/images/collections/fish/흰동가리.png',NULL),(24,'바다','구해','유럽가자미',4,NULL,'0~6 / 18~24',230,345,460,920,1840,'M','/images/collections/fish/유럽가자미.png',NULL),(25,'바다','구해','복어',6,NULL,'18~24 / 6~18',230,345,460,920,1840,'M','/images/collections/fish/복어.png',NULL),(26,'바다','구해','유럽장어',7,'무지개',NULL,380,570,760,1520,3040,'M','/images/collections/fish/유럽장어.png',NULL),(27,'바다','구해','귀상어',10,'무지개','0~6 / 18~24',850,1275,1700,3400,6800,'L','/images/collections/fish/귀상어.png',NULL),(28,'바다','동해','바다새우',1,NULL,NULL,50,75,100,200,400,'S','/images/collections/fish/바다새우.png',NULL),(29,'바다','동해','소라게',3,NULL,NULL,100,150,200,400,800,'S','/images/collections/fish/소라게.png',NULL),(30,'바다','동해','망둥어',4,NULL,'0~6 / 6~18',150,225,300,600,1200,'S','/images/collections/fish/망둥어.png',NULL),(31,'바다','동해','등불성대',6,'무지개',NULL,380,570,760,1520,3040,'M','/images/collections/fish/등불성대.png',NULL),(32,'바다','동해','해덕대구',8,'해/무지개','0~6 / 12~24',230,345,460,920,1840,'M','/images/collections/fish/해덕대구.png',NULL),(33,'바다','동해','개복치',9,NULL,'0~12',850,1275,1700,3400,6800,'L','/images/collections/fish/개복치.png',NULL),(34,'바다','바다 전체','정어리',1,NULL,NULL,50,75,100,200,400,'S','/images/collections/fish/정어리.png',NULL),(35,'바다','바다 전체','배스',1,NULL,NULL,75,112,150,300,600,'M','/images/collections/fish/배스.png',NULL),(36,'바다','바다 전체','가다랑어',1,NULL,NULL,210,315,420,840,1680,'L','/images/collections/fish/가다랑어.png',NULL),(37,'바다','바다 전체','대문짝넙치',4,NULL,NULL,320,480,640,1280,2560,'Blue','/images/collections/fish/대문짝넙치.png',NULL),(38,'바다','바다 전체','대서양은상어',2,NULL,NULL,320,480,640,1280,2560,'Blue','/images/collections/fish/대서양은상어.png',NULL),(39,'바다','바다낚시 사건','노랑촉수',2,NULL,NULL,320,480,640,1280,2560,'Golden','/images/collections/fish/노랑촉수.png',NULL),(40,'바다','바다낚시 사건','아귀',3,NULL,NULL,320,480,640,1280,2560,'Golden','/images/collections/fish/아귀.png',NULL),(41,'바다','바다낚시 사건','참문어',4,NULL,NULL,320,480,640,1280,2560,'M, Golden','/images/collections/fish/참문어.png',NULL),(42,'바다','바다낚시 사건','유럽날오징어',5,NULL,NULL,320,480,640,1280,2560,'Golden','/images/collections/fish/유럽날오징어.png',NULL),(43,'바다','바다낚시 사건','두툽상어',6,NULL,NULL,535,802,1070,2140,4280,NULL,'/images/collections/fish/두툽상어.png',NULL),(44,'바다','바다낚시 사건','산갈치',7,NULL,'6~18',535,802,1070,2140,4280,'Golden','/images/collections/fish/산갈치.png',NULL),(45,'바다','바다낚시 사건','황금 킹크랩',8,'무지개',NULL,850,1275,1700,3400,6800,'Golden','/images/collections/fish/황금킹크랩.png',NULL),(46,'바다','바다낚시 사건','붉은개복치',9,NULL,'0~6 / 18~24',850,1275,1700,3400,6800,'Golden','/images/collections/fish/붉은개복치.png',NULL),(47,'바다','바다낚시 사건','청상아리',10,'무지개','6~18',850,1275,1700,3400,6800,'L','/images/collections/fish/청상아리.png',NULL),(48,'바다','잔잔한 바다','갈치',1,NULL,NULL,105,157,210,420,840,'L','/images/collections/fish/갈치.png',NULL),(49,'바다','잔잔한 바다','대서양난쟁이문어',4,NULL,NULL,150,225,300,600,1200,'S','/images/collections/fish/대서양난쟁이문어.png',NULL),(50,'바다','잔잔한 바다','노란전갱이',3,NULL,NULL,155,232,310,620,1240,'M','/images/collections/fish/노란전갱이.png',NULL),(51,'바다','잔잔한 바다','유럽가재',5,NULL,'0~6 / 18~24',230,345,460,920,1840,'M','/images/collections/fish/유럽가재.png',NULL),(52,'바다','잔잔한 바다','검은점돔',7,'비/무지개','0~6 / 18~24',230,345,460,920,1840,'M','/images/collections/fish/검은점돔.png',NULL),(53,'바다','잔잔한 바다','참다랑어',9,'무지개','6~18',850,1275,1700,3400,6800,'L','/images/collections/fish/참다랑어.png',NULL),(54,'호수','근교 호수','붕어',1,NULL,NULL,75,112,150,300,600,'M','/images/collections/fish/붕어.png',NULL),(55,'호수','근교 호수','백조어',1,NULL,NULL,50,75,100,200,400,'S','/images/collections/fish/백조어.png',NULL),(56,'호수','근교 호수','돌마자',2,NULL,NULL,100,150,200,400,800,'S','/images/collections/fish/돌마자.png',NULL),(57,'호수','근교 호수','홍합',3,'비/무지개',NULL,100,150,200,400,800,'S','/images/collections/fish/홍합.png',NULL),(58,'호수','근교 호수','민물게',4,NULL,NULL,100,150,200,400,800,'S','/images/collections/fish/민물게.png',NULL),(59,'호수','근교 호수','루드',5,NULL,NULL,150,225,300,600,1200,'M','/images/collections/fish/루드.png',NULL),(60,'호수','근교 호수','사루기',6,NULL,NULL,230,345,460,920,1840,'S','/images/collections/fish/사루기.png',NULL),(61,'호수','근교 호수','줄무늬송사리',7,'해/무지개','0~6 / 12~24',150,225,300,600,1200,'S','/images/collections/fish/줄무늬송사리.png',NULL),(62,'호수','근교 호수','펄고기',8,'해/무지개','0~12',250,375,500,1000,2000,'S','/images/collections/fish/펄고기.png',NULL),(63,'호수','근교 호수','강꼬치고기',9,'비/무지개','0~6 / 18~24',610,915,1220,2440,4880,'M','/images/collections/fish/강꼬치고기.png',NULL),(64,'호수','숲속 호수','텐치',1,NULL,NULL,50,75,100,200,400,'S','/images/collections/fish/텐치.png',NULL),(65,'호수','숲속 호수','큰입배스',4,'해/무지개',NULL,230,345,460,920,1840,'M','/images/collections/fish/큰입배스.png',NULL),(66,'호수','숲속 호수','유럽민물가재',3,NULL,'0~12 / 18~24',100,150,200,400,800,'S','/images/collections/fish/유럽민물가재.png',NULL),(67,'호수','숲속 호수','머드개복치',2,NULL,'6~24',100,150,200,400,800,'S','/images/collections/fish/머드개복치.png',NULL),(68,'호수','숲속 호수','큰진주조개',6,'무지개',NULL,380,570,760,1520,3040,'M','/images/collections/fish/큰진주조개.png',NULL),(69,'호수','숲속 호수','북유럽파란가재',8,NULL,'0~6 / 18~24',250,375,500,1000,2000,'S','/images/collections/fish/북유럽파란가재.png',NULL),(70,'호수','숲속 호수','북극곤들매기',10,'비/무지개','12~24',610,915,1220,2440,4880,'M','/images/collections/fish/북극곤들매기.png',NULL),(71,'호수','온천산 호수','극지연어',1,NULL,NULL,105,157,210,420,840,'M','/images/collections/fish/극지연어.png',NULL),(72,'호수','온천산 호수','매화농어',2,NULL,'12~24',100,150,200,400,800,'S','/images/collections/fish/매화농어.png',NULL),(73,'호수','온천산 호수','올챙이',3,'비/무지개',NULL,100,150,200,400,800,'S','/images/collections/fish/올챙이.png',NULL),(74,'호수','온천산 호수','둑중개',7,'비/무지개','6~24',150,225,300,600,1200,'S','/images/collections/fish/둑중개.png',NULL),(75,'호수','온천산 호수','펌프킨시드',9,'해/무지개','6~24',250,375,500,1000,2000,'S','/images/collections/fish/펌프킨시드.png',NULL),(76,'호수','온천산 호수','블루길',10,'해/무지개','0~6 / 18~24',395,592,790,1580,3160,'S','/images/collections/fish/블루길.png',NULL),(77,'호수','초원 호수','바다빙어',2,NULL,NULL,100,150,200,400,800,'S','/images/collections/fish/바다빙어.png',NULL),(78,'호수','초원 호수','나비잉어',4,'비/무지개',NULL,320,480,640,1280,2560,'L','/images/collections/fish/나비잉어.png',NULL),(79,'호수','초원 호수','송어',5,'해/무지개','0~6 / 18~24',230,345,460,920,1840,'M','/images/collections/fish/송어.png',NULL),(80,'호수','초원 호수','금붕어',8,'비/무지개','6~24',250,375,500,1000,2000,'S','/images/collections/fish/금붕어.png',NULL),(81,'호수','초원 호수','유럽메기',10,'해/무지개','0~6 / 18~24',610,915,1220,2440,4880,'M','/images/collections/fish/유럽메기.png',NULL),(82,'호수','호수 전체','유럽백조어',1,NULL,NULL,50,75,100,200,400,NULL,'/images/collections/fish/유럽백조어.png',NULL),(83,'호수','호수 전체','유럽처브',1,NULL,NULL,75,112,150,300,600,'M','/images/collections/fish/유럽처브.png',NULL),(84,'호수','호수 전체','유럽참개구리',1,NULL,NULL,320,480,640,1280,2560,'Blue','/images/collections/fish/유럽참개구리.png',NULL),(89,'바다','고래 바다','감색 감독 난쟁이문어',1,NULL,NULL,100,150,200,400,800,'S','/images/collections/fish/감색 감독 난쟁이문어.png','꿈의 명암'),(90,'바다','고래 바다','감색 감독 참문어',1,NULL,NULL,215,322,430,860,1720,'M','/images/collections/fish/감색 감독 참문어.png','꿈의 명암'),(91,'바다','고래 바다','감청색 감독 난쟁이문어',1,NULL,NULL,100,150,200,400,800,'S','/images/collections/fish/감청색 감독 난쟁이문어.png','꿈의 명암'),(92,'바다','고래 바다','청록색 감독 난쟁이문어',1,NULL,NULL,100,150,200,400,800,'S','/images/collections/fish/청록색 감독 난쟁이문어.png','꿈의 명암');
/*!40000 ALTER TABLE `fish_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flower_collections`
--

DROP TABLE IF EXISTS `flower_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flower_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price_1` int DEFAULT NULL,
  `price_2` int DEFAULT NULL,
  `price_3` int DEFAULT NULL,
  `price_4` int DEFAULT NULL,
  `price_5` int DEFAULT NULL,
  `level` int DEFAULT NULL,
  `growth_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seed_buy_price` int DEFAULT NULL,
  `seed_sell_price` int DEFAULT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_flower_name` (`name`),
  KEY `idx_flower_location` (`location`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flower_collections`
--

LOCK TABLES `flower_collections` WRITE;
/*!40000 ALTER TABLE `flower_collections` DISABLE KEYS */;
INSERT INTO `flower_collections` VALUES (1,'데이지',NULL,100,150,200,400,800,3,'18 hours',30,15,NULL,NULL),(2,'팬지',NULL,100,150,200,400,800,4,'18 hours',30,15,NULL,NULL),(3,'안스리움',NULL,185,278,370,740,1480,5,'1 day',60,NULL,NULL,NULL),(4,'꽃양귀비',NULL,185,278,370,740,1480,5,'1 day',60,30,NULL,NULL),(5,'칼라',NULL,250,375,500,1000,2000,6,'1 day 6 hours',90,NULL,NULL,NULL),(6,'나팔꽃',NULL,250,375,500,1000,2000,6,'1 day 6 hours',90,NULL,NULL,NULL),(7,'카네이션',NULL,305,458,610,1220,2440,7,'1 day 6 hours',120,NULL,NULL,NULL),(8,'튤립',NULL,NULL,NULL,NULL,NULL,NULL,8,'2 days',150,NULL,NULL,NULL),(9,'백합',NULL,NULL,NULL,NULL,NULL,NULL,9,'2 days',200,NULL,NULL,NULL),(10,'장미',NULL,NULL,NULL,NULL,NULL,NULL,10,'3 days',300,NULL,NULL,NULL),(11,'히아신스',NULL,NULL,NULL,NULL,NULL,NULL,11,NULL,300,NULL,NULL,NULL),(12,'호접란',NULL,NULL,NULL,NULL,NULL,NULL,12,NULL,300,NULL,NULL,NULL),(13,'쥐손이풀',NULL,NULL,NULL,NULL,NULL,NULL,13,NULL,300,NULL,NULL,NULL);
/*!40000 ALTER TABLE `flower_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forageable_collections`
--

DROP TABLE IF EXISTS `forageable_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forageable_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` int DEFAULT '0',
  `energy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `show_on_map` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_forageable_name` (`name`),
  KEY `idx_forageable_location` (`location`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forageable_collections`
--

LOCK TABLES `forageable_collections` WRITE;
/*!40000 ALTER TABLE `forageable_collections` DISABLE KEYS */;
INSERT INTO `forageable_collections` VALUES (1,'송이버섯','숲',0,'+5',NULL,NULL,0),(2,'관목 가지','홈',5,NULL,'/images/collections/forage/관목 가지.png',NULL,0),(3,'목재','홈',6,NULL,'/images/collections/forage/목재.png',NULL,0),(4,'대나무','홈',7,NULL,'/images/collections/forage/대나무.png',NULL,1),(5,'돌','홈',8,NULL,'/images/collections/forage/돌.png',NULL,1),(6,'고급 목재','홈',12,NULL,'/images/collections/forage/고급 목재.png',NULL,0),(7,'광석','홈',14,NULL,'/images/collections/forage/광석.png',NULL,1),(8,'블루베리','홈',16,'+5','/images/collections/forage/블루베리.png',NULL,1),(9,'표고버섯','어촌',16,'+5','/images/collections/forage/표고버섯.png',NULL,1),(10,'이상한 표고버섯 (검정)','어촌',16,NULL,'/images/collections/forage/이상한 표고버섯(회색).png',NULL,0),(11,'이상한 표고버섯 (빨강)','어촌',16,NULL,'/images/collections/forage/이상한 표고버섯(빨강).png',NULL,0),(12,'이상한 표고버섯 (파랑)','어촌',16,NULL,'/images/collections/forage/이상한 표고버섯(하늘).png',NULL,0),(13,'양송이버섯','꽃밭',16,'+5','/images/collections/forage/양송이버섯.png',NULL,1),(14,'이상한 양송이버섯 (파랑)','꽃밭',16,NULL,'/images/collections/forage/이상한 양송이 버섯(파랑).png',NULL,0),(15,'이상한 양송이버섯 (핑크)','꽃밭',16,NULL,'/images/collections/forage/이상한 양송이 버섯(핑크).png',NULL,0),(16,'이상한 양송이버섯 (초록)','꽃밭',16,NULL,'/images/collections/forage/이상한 양송이 버섯(초록).png',NULL,0),(17,'그물버섯','숲',16,'+5','/images/collections/forage/그물버섯.png',NULL,1),(18,'이상한 그물버섯 (보라)','숲',16,NULL,'/images/collections/forage/이상한 그물버섯(파랑).png',NULL,0),(19,'이상한 그물버섯 (빨강)','숲',16,NULL,'/images/collections/forage/이상한 그물버섯(빨강).png',NULL,0),(20,'이상한 그물버섯 (핑크)','숲',16,NULL,'/images/collections/forage/이상한 그물버섯(핑크).png',NULL,0),(21,'느타리버섯','온천산',16,'+5','/images/collections/forage/느타리버섯.png',NULL,1),(22,'이상한 느타리버섯 (핑크)','온천산',16,NULL,'/images/collections/forage/이상한 느타리버섯(핑크).png',NULL,0),(23,'이상한 느타리버섯 (보라)','온천산',16,NULL,'/images/collections/forage/이상한 느타리버섯(파랑).png',NULL,0),(24,'이상한 느타리버섯 (주황)','온천산',16,NULL,'/images/collections/forage/이상한 느타리버섯(주황).png',NULL,0),(25,'라즈베리','홈',26,'+7','/images/collections/forage/라즈베리.png',NULL,1),(26,'사과','홈',28,'+8','/images/collections/forage/사과.png',NULL,1),(27,'귤 (오렌지)','홈',28,'+8','/images/collections/forage/오렌지.png',NULL,1),(28,'희귀 목재','도시 근교',50,NULL,'/images/collections/forage/희귀 목재.png',NULL,1),(29,'검은 트러플','숲',99,'+25','/images/collections/forage/검은 트러플.png',NULL,1),(30,'그 자리 참나무','방랑하는 오크오크',150,NULL,NULL,NULL,0),(31,'완벽한 형광석','형석 광산',150,NULL,NULL,NULL,0),(32,'별똥별 조각','운석우',150,NULL,NULL,NULL,0),(37,'야생 고사리','숲',5,NULL,'/images/collections/forage/야생 고사리.png','꿈의 명암',1),(38,'산마늘','온천산',5,NULL,'/images/collections/forage/산마늘.png','꿈의 명암',1),(39,'산우엉','꽃밭',5,NULL,'/images/collections/forage/산우엉.png','꿈의 명암',1),(40,'산겨자','어촌',5,NULL,'/images/collections/forage/산겨자.png','꿈의 명암',1);
/*!40000 ALTER TABLE `forageable_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gift_code`
--

DROP TABLE IF EXISTS `gift_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gift_code` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rewards` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVE',
  `expiration_date` date DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_name` (`code_name`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gift_code`
--

LOCK TABLES `gift_code` WRITE;
/*!40000 ALTER TABLE `gift_code` DISABLE KEYS */;
INSERT INTO `gift_code` VALUES (26,'r4p8n6m2q9','10x 소원별, 3x 인어 집어기, 10x 비료','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(27,'heartopia10m','10x 소원별','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(28,'lifewithline','10x 소원별','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(29,'happy2026','10x 달빛 크리스탈, 8888 골드','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(30,'k7m9q2a8l5','5x 소원별, 3x 인어 집어기, 10x 비료','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(31,'heartopia5m','10x 소원별','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(32,'top1thanks','5x 소원별, 2x 인어향수, 10x 오렌지','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(33,'r4a8x2n','5x 소원별, 10x 성장 촉진제, 10x 오렌지','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(34,'true5mthks','10x 고급목재, 2x 셰프 특선 샐러드, 20x 관목가지','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(35,'letsparty','15x 소원별, 5000 골드, 3x 수리도구','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(36,'b8n2k5l','2x 완벽한 형광석, 6x 희귀목재, 10x 돌','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(37,'dcthx4u','10x 소원별','ACTIVE','2026-06-30','2026-02-06 12:08:38','2026-02-06 12:08:38'),(38,'m7r9q4a','2x 인어향수, 10000 골드, 10x 달걀','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(39,'x2l8k6p','5x 소원별, 10x 비료, 10x 사과','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(40,'h9q3a7m5','2x 그 자리 참나무, 10x 우유, 10x 목재','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(41,'letsbuild','15x 소원별, 5000 골드, 10x 비료','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(42,'letsdressup','15x 소원별, 5000 골드, 10x 성장 촉진제','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(43,'a7k9m2q8l','5x 소원별, 3x 수리도구, 10x 블루베리','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(44,'z4p6n8r2','10x 고급목재, 2x 셰프 특선 샐러드, 20x 관목가지','ACTIVE','2026-03-31','2026-02-06 12:08:38','2026-02-06 12:08:38'),(45,'specialgift0103','100x 달빛 크리스탈','SOON','2026-02-07','2026-02-06 12:08:38','2026-02-06 12:08:38'),(46,'heartopia0108','100x 달빛 크리스탈','SOON','2026-02-07','2026-02-06 12:08:38','2026-02-06 12:08:38'),(47,'mylittlepony','100x 달빛 크리스탈','SOON','2026-02-07','2026-02-06 12:08:38','2026-02-06 12:08:38'),(48,'Crystals','100x 달빛 크리스탈','EXPIRED',NULL,'2026-02-06 12:08:42','2026-02-06 12:08:42'),(49,'officialstream','Unknown','EXPIRED',NULL,'2026-02-06 12:08:42','2026-02-06 12:08:42'),(50,'finaltest','Unknown','EXPIRED',NULL,'2026-02-06 12:08:42','2026-02-06 12:08:42'),(53,'a4k9m7q2r6','소원별 5개, 향수 3개, 비료 10개','SOON','2026-04-01','2026-03-25 18:46:39','2026-03-25 18:46:39'),(54,'tangyuan0303y','5x 소원별, 10x 비료, 10x 사과','ACTIVE','2026-05-01','2026-04-04 11:22:56','2026-04-04 11:22:56'),(55,'sweetgift314u','5x 스노우 로즈, 2x 무지개빛 요정의 지팡이, 1x 무지개빛 연기','ACTIVE','2026-05-01','2026-04-04 11:49:16','2026-04-04 11:49:16'),(56,'m5r9q2a7k8','3x 소원별, 5x 수리 키트, 10x 성장제','ACTIVE','2026-05-01','2026-04-04 11:50:12','2026-04-04 11:50:12'),(57,'38bloom2026','10x 달걀, 10,000x 골드, 2x 인어 향수','ACTIVE','2026-05-01','2026-04-04 11:51:49','2026-04-04 11:51:49'),(58,'keepsmiling2026','5x 소원별, 3x 인어 집어기, 10x 비료','ACTIVE',NULL,'2026-04-04 11:52:08','2026-04-04 11:52:08'),(59,'p6n4m9q3a2','3x 소원별 , 5x 수리 키트, 10x 작물 성장제 ','ACTIVE','2026-06-01','2026-04-06 17:39:20','2026-04-06 17:39:20');
/*!40000 ALTER TABLE `gift_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location_zones`
--

DROP TABLE IF EXISTS `location_zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location_zones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `zone_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ê³ ìœ  í‚¤ (ì˜ˆ: ê±°ëª©ê°•, ì˜¨ì²œì‚°)',
  `display_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'í‘œì‹œ ì´ë¦„ (ì˜ˆ: ê±°ëª© ê°•)',
  `polygon_points` json DEFAULT NULL COMMENT 'ë§µ í”½ì…€ ì¢Œí‘œ [[x1,y1],[x2,y2],...]',
  `map_x` int DEFAULT NULL COMMENT '위치 x좌표 (픽셀)',
  `map_y` int DEFAULT NULL COMMENT '위치 y좌표 (픽셀)',
  `color` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#4dabf7' COMMENT 'í´ë¦¬ê³¤ ìƒ‰ìƒ',
  `parent_zone_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ìƒìœ„ zone í‚¤ (NULLì´ë©´ ìµœìƒìœ„)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `zone_key` (`zone_key`)
) ENGINE=InnoDB AUTO_INCREMENT=260 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location_zones`
--

LOCK TABLES `location_zones` WRITE;
/*!40000 ALTER TABLE `location_zones` DISABLE KEYS */;
INSERT INTO `location_zones` VALUES (1,'강','강 전체',NULL,NULL,NULL,'#60a5fa',NULL),(2,'거목강','거목 강',NULL,1229,1339,'#3b82f6','강'),(3,'고요한강','고요한 강',NULL,694,1361,'#3b82f6','강'),(4,'노을강','노을 강',NULL,626,671,'#3b82f6','강'),(5,'얕은강','얕은 강',NULL,1308,679,'#3b82f6','강'),(6,'바다','바다 전체',NULL,NULL,NULL,'#0ea5e9',NULL),(7,'고래바다','고래바다',NULL,175,1064,'#0284c7','바다'),(8,'구해','구해',NULL,985,154,'#0284c7','바다'),(9,'동해','동해',NULL,1913,1062,'#0284c7','바다'),(10,'잔잔한바다','잔잔한 바다',NULL,941,1577,'0284c7','바다'),(11,'호수','호수 전체',NULL,NULL,NULL,'#38bdf8',NULL),(12,'근교호수','근교 호수',NULL,919,779,'#0ea5e9','호수'),(13,'숲속호수','숲속 호수',NULL,1484,1199,'#0ea5e9','호수'),(14,'온천산호수','온천산 호수',NULL,763,397,'0ea5e9','호수'),(15,'초원호수','초원 호수',NULL,452,1071,'#0ea5e9','호수'),(16,'근교도시호수','도시 근교 호수',NULL,NULL,NULL,'#0ea5e9','호수'),(17,'숲','숲 전체',NULL,NULL,NULL,'#4ade80',NULL),(18,'영혼참나무','영혼의 참나무 숲',NULL,1618,1075,'#16a34a','숲'),(19,'순록탑','순록탑',NULL,1594,753,'#16a34a','숲'),(20,'숲속섬','숲속 섬',NULL,1853,682,'#16a34a','숲'),(21,'점핑플랫폼','점핑 플랫폼',NULL,1561,1378,'#16a34a','숲'),(22,'숲호숫가','숲 호숫가',NULL,NULL,NULL,'#16a34a','숲'),(23,'꽃밭','꽃밭 전체',NULL,NULL,NULL,'#f472b6',NULL),(24,'고래산꽃밭','고래산 꽃밭',NULL,NULL,NULL,'#ec4899','꽃밭'),(25,'보라빛해변','보라빛 해변',NULL,403,1462,'#ec4899','꽃밭'),(26,'풍차꽃밭','풍차꽃밭',NULL,387,1228,'#ec4899','꽃밭'),(27,'어촌','어촌 전체',NULL,NULL,NULL,'#fb923c',NULL),(28,'어촌부두','부두',NULL,810,1359,'#ea580c','어촌'),(29,'동쪽부두','동쪽 부두',NULL,1189,1451,'#ea580c','어촌'),(30,'어촌등대','등대',NULL,NULL,NULL,'#ea580c','어촌'),(31,'어촌광장','어촌 광장',NULL,1018,1388,'#ea580c','어촌'),(32,'온천산','온천산 전체',NULL,NULL,NULL,'#fb7185',NULL),(33,'온천','온천',NULL,1019,476,'#f43f5e','온천산'),(34,'바위절벽','바위절벽',NULL,1250,468,'#f43f5e','온천산'),(35,'온천산유적','유적',NULL,NULL,NULL,'#f43f5e','온천산'),(36,'화산호수','화산 호수',NULL,764,343,'#f43f5e','온천산'),(37,'온천산호숫가','온천산 호숫가',NULL,NULL,NULL,'#f43f5e','온천산'),(38,'도시','도시 전체',NULL,NULL,NULL,'#a78bfa',NULL),(39,'도시근교','도시 근교',NULL,824,1172,'#7c3aed','도시'),(40,'도심','도심',NULL,976,971,'#7c3aed','도시'),(41,'해변','해변',NULL,NULL,NULL,'#fbbf24',NULL),(42,'물가','물가',NULL,NULL,NULL,'#34d399',NULL),(43,'강변','강변',NULL,NULL,NULL,'#60a5fa','강');
/*!40000 ALTER TABLE `location_zones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `map_pins`
--

DROP TABLE IF EXISTS `map_pins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `map_pins` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `map_x` int DEFAULT '0',
  `map_y` int DEFAULT '0',
  `link_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=541 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `map_pins`
--

LOCK TABLES `map_pins` WRITE;
/*!40000 ALTER TABLE `map_pins` DISABLE KEYS */;
INSERT INTO `map_pins` VALUES (24,'villager','앤드류','/images/npc/NPC_icon_앤드류.png',1178,794,'/wiki/others/villagers','공방 & 제작 멘토'),(25,'villager','에릭','/images/npc/NPC_icon_에릭.png',877,274,'/wiki/others/villagers','시청 직원'),(26,'villager','도로시','/images/npc/NPC_icon_도로시.png',975,939,'/wiki/others/villagers','패션 상점'),(27,'villager','카칭','/images/npc/NPC_icon_카칭.png',841,820,'/wiki/others/villagers','잡화점'),(28,'villager','수집가','/images/npc/NPC_icon_수집가.png',753,951,'/wiki/others/villagers','박물관'),(30,'villager','조안 여사','/images/npc/NPC_icon_조안_여사.png',1050,992,'/wiki/others/villagers','펫 멘토'),(31,'villager','베일리','/images/npc/NPC_icon_베일리.png',1055,1002,'/wiki/others/villagers','새 관찰 멘토'),(33,'villager','알버트 2세','/images/npc/NPC_icon_알버트_2세.png',676,920,'/wiki/others/villagers','골드 상인'),(34,'villager','밥 아저씨','/images/npc/NPC_icon_밥_아저씨.png',1001,941,'/wiki/others/villagers','인테리어 상인'),(38,'villager','패티','/images/npc/NPC_icon_패티.png',1611,715,'/wiki/others/villagers','순록탑 주변'),(39,'villager','버니','/images/npc/NPC_icon_버니.png',453,1303,'/wiki/others/villagers','풍차 꽃밭'),(40,'villager','윌','/images/npc/NPC_icon_윌.png',830,1611,'/wiki/others/villagers','마을'),(41,'villager','장난꾸러기','/images/npc/NPC_icon_장난꾸러기.png',3600,2600,'/wiki/others/villagers','마을 골목'),(42,'villager','해리','/images/npc/NPC_icon_해리.png',3700,2700,'/wiki/others/villagers','마을'),(43,'villager','빌','/images/npc/NPC_icon_빌.png',896,1458,'/wiki/others/villagers','부두 이벤트 NPC'),(46,'animal','토끼','/images/collections/animals/wild_animal_토끼.png',1500,5000,'/wiki/collections/animal','좋아하는 날씨: 맑음'),(66,'bus','마을 서쪽 교외','/images/map/bus_icon.png',683,1061,NULL,'정류장 위치 정보 준비 중'),(67,'bus','꽃밭','/images/map/bus_icon.png',431,1061,NULL,'정류장 위치 정보 준비 중'),(68,'bus','어촌','/images/map/bus_icon.png',959,1307,NULL,'정류장 위치 정보 준비 중'),(69,'bus','주앙 광장','/images/map/bus_icon.png',965,993,NULL,'정류장 위치 정보 준비 중'),(70,'bus','마을 동쪽 교외','/images/map/bus_icon.png',1276,1033,NULL,'정류장 위치 정보 준비 중'),(71,'bus','마을 북쪽 교외','/images/map/bus_icon.png',959,742,NULL,'정류장 위치 정보 준비 중'),(72,'bus','온천산','/images/map/bus_icon.png',1023,445,NULL,'정류장 위치 정보 준비 중'),(73,'bus','숲','/images/map/bus_icon.png',1597,996,NULL,'정류장 위치 정보 준비 중'),(74,'animal','알파카','/images/collections/animals/wild_animal_알파카.png',549,1400,'/wiki/collections/animal','좋아하는 날씨: 맑음'),(75,'animal','여우','/images/collections/animals/wild_animal_여우.png',381,1146,'/wiki/collections/animal','좋아하는 날씨: 무지개'),(77,'animal','해달','/images/collections/animals/wild_animal_해달.png',1024,1441,'/wiki/collections/animal','좋아하는 날씨: 비'),(78,'animal','판다','/images/collections/animals/wild_animal_판다.png',1521,1363,'/wiki/collections/animal','좋아하는 날씨: 비'),(79,'animal','꽃사슴','/images/collections/animals/wild_animal_꽃사슴.png',1587,1057,'/wiki/collections/animal','좋아하는 날씨: 맑음'),(80,'animal','카피바라','/images/collections/animals/wild_animal_카피바라.png',578,367,'/wiki/collections/animal','좋아하는 날씨: 비'),(82,'forageable','라즈베리','/images/collections/forage/라즈베리.png',699,1346,NULL,NULL),(83,'forageable','라즈베리','/images/collections/forage/라즈베리.png',661,1362,NULL,NULL),(84,'forageable','라즈베리','/images/collections/forage/라즈베리.png',533,1335,NULL,NULL),(85,'forageable','라즈베리','/images/collections/forage/라즈베리.png',578,1294,NULL,NULL),(86,'forageable','라즈베리','/images/collections/forage/라즈베리.png',642,1221,NULL,NULL),(87,'forageable','라즈베리','/images/collections/forage/라즈베리.png',542,1204,NULL,NULL),(88,'forageable','라즈베리','/images/collections/forage/라즈베리.png',424,1230,NULL,NULL),(89,'forageable','라즈베리','/images/collections/forage/라즈베리.png',507,1126,NULL,NULL),(90,'forageable','라즈베리','/images/collections/forage/라즈베리.png',414,1078,NULL,NULL),(91,'forageable','라즈베리','/images/collections/forage/라즈베리.png',500,1052,NULL,NULL),(92,'forageable','라즈베리','/images/collections/forage/라즈베리.png',587,1067,NULL,NULL),(94,'forageable','라즈베리','/images/collections/forage/라즈베리.png',490,1002,NULL,NULL),(95,'forageable','라즈베리','/images/collections/forage/라즈베리.png',442,986,NULL,NULL),(96,'forageable','라즈베리','/images/collections/forage/라즈베리.png',447,912,NULL,NULL),(97,'forageable','라즈베리','/images/collections/forage/라즈베리.png',490,884,NULL,NULL),(98,'forageable','라즈베리','/images/collections/forage/라즈베리.png',499,795,NULL,NULL),(99,'forageable','라즈베리','/images/collections/forage/라즈베리.png',543,775,NULL,NULL),(100,'forageable','블루베리','/images/collections/forage/블루베리.png',743,1280,NULL,NULL),(101,'forageable','블루베리','/images/collections/forage/블루베리.png',738,1259,NULL,NULL),(102,'forageable','블루베리','/images/collections/forage/블루베리.png',730,1251,NULL,NULL),(103,'forageable','블루베리','/images/collections/forage/블루베리.png',698,1210,NULL,NULL),(104,'forageable','블루베리','/images/collections/forage/블루베리.png',679,1204,NULL,NULL),(105,'forageable','블루베리','/images/collections/forage/블루베리.png',668,1182,NULL,NULL),(106,'forageable','블루베리','/images/collections/forage/블루베리.png',665,1154,NULL,NULL),(107,'forageable','블루베리','/images/collections/forage/블루베리.png',659,1122,NULL,NULL),(108,'forageable','블루베리','/images/collections/forage/블루베리.png',650,1084,NULL,NULL),(109,'forageable','블루베리','/images/collections/forage/블루베리.png',640,1033,NULL,NULL),(110,'forageable','블루베리','/images/collections/forage/블루베리.png',642,999,NULL,NULL),(111,'forageable','블루베리','/images/collections/forage/블루베리.png',661,959,NULL,NULL),(112,'forageable','블루베리','/images/collections/forage/블루베리.png',639,934,NULL,NULL),(113,'forageable','블루베리','/images/collections/forage/블루베리.png',627,869,NULL,NULL),(114,'forageable','블루베리','/images/collections/forage/블루베리.png',623,812,NULL,NULL),(115,'forageable','블루베리','/images/collections/forage/블루베리.png',624,793,NULL,NULL),(116,'forageable','블루베리','/images/collections/forage/블루베리.png',608,757,NULL,NULL),(117,'forageable','블루베리','/images/collections/forage/블루베리.png',681,625,NULL,NULL),(118,'forageable','블루베리','/images/collections/forage/블루베리.png',707,656,NULL,NULL),(119,'forageable','블루베리','/images/collections/forage/블루베리.png',748,658,NULL,NULL),(120,'forageable','블루베리','/images/collections/forage/블루베리.png',783,647,NULL,NULL),(122,'forageable','블루베리','/images/collections/forage/블루베리.png',825,640,NULL,NULL),(123,'forageable','블루베리','/images/collections/forage/블루베리.png',843,660,NULL,NULL),(124,'forageable','블루베리','/images/collections/forage/블루베리.png',897,668,NULL,NULL),(125,'forageable','블루베리','/images/collections/forage/블루베리.png',940,682,NULL,NULL),(126,'forageable','블루베리','/images/collections/forage/블루베리.png',966,598,NULL,NULL),(127,'forageable','블루베리','/images/collections/forage/블루베리.png',981,702,NULL,NULL),(128,'forageable','블루베리','/images/collections/forage/블루베리.png',1000,720,NULL,NULL),(129,'forageable','블루베리','/images/collections/forage/블루베리.png',1056,727,NULL,NULL),(130,'forageable','블루베리','/images/collections/forage/블루베리.png',1090,715,NULL,NULL),(131,'forageable','블루베리','/images/collections/forage/블루베리.png',1115,631,NULL,NULL),(132,'forageable','블루베리','/images/collections/forage/블루베리.png',1134,704,NULL,NULL),(133,'forageable','블루베리','/images/collections/forage/블루베리.png',1160,729,NULL,NULL),(134,'forageable','블루베리','/images/collections/forage/블루베리.png',1220,732,NULL,NULL),(135,'forageable','블루베리','/images/collections/forage/블루베리.png',1257,724,NULL,NULL),(136,'forageable','블루베리','/images/collections/forage/블루베리.png',1267,685,NULL,NULL),(137,'forageable','블루베리','/images/collections/forage/블루베리.png',1310,774,NULL,NULL),(138,'forageable','블루베리','/images/collections/forage/블루베리.png',1306,805,NULL,NULL),(139,'forageable','블루베리','/images/collections/forage/블루베리.png',1309,844,NULL,NULL),(140,'forageable','블루베리','/images/collections/forage/블루베리.png',1342,886,NULL,NULL),(141,'forageable','블루베리','/images/collections/forage/블루베리.png',1309,921,NULL,NULL),(142,'forageable','블루베리','/images/collections/forage/블루베리.png',1309,955,NULL,NULL),(143,'forageable','블루베리','/images/collections/forage/블루베리.png',1313,987,NULL,NULL),(144,'forageable','블루베리','/images/collections/forage/블루베리.png',1345,1013,NULL,NULL),(146,'forageable','블루베리','/images/collections/forage/블루베리.png',1298,1078,NULL,NULL),(147,'forageable','블루베리','/images/collections/forage/블루베리.png',1291,1126,NULL,NULL),(148,'forageable','블루베리','/images/collections/forage/블루베리.png',1303,1151,NULL,NULL),(150,'forageable','블루베리','/images/collections/forage/블루베리.png',1261,1222,NULL,NULL),(153,'forageable','블루베리','/images/collections/forage/블루베리.png',1299,1195,NULL,NULL),(154,'forageable','블루베리','/images/collections/forage/블루베리.png',1272,1200,NULL,NULL),(155,'forageable','블루베리','/images/collections/forage/블루베리.png',1248,1293,NULL,NULL),(156,'forageable','블루베리','/images/collections/forage/블루베리.png',1288,1336,NULL,NULL),(157,'forageable','블루베리','/images/collections/forage/블루베리.png',1354,1350,NULL,NULL),(158,'forageable','블루베리','/images/collections/forage/블루베리.png',1418,1269,NULL,NULL),(159,'forageable','블루베리','/images/collections/forage/블루베리.png',1363,1205,NULL,NULL),(160,'forageable','블루베리','/images/collections/forage/블루베리.png',1406,1200,NULL,NULL),(161,'forageable','블루베리','/images/collections/forage/블루베리.png',1370,1041,NULL,NULL),(162,'forageable','블루베리','/images/collections/forage/블루베리.png',1405,1030,NULL,NULL),(163,'forageable','블루베리','/images/collections/forage/블루베리.png',1454,982,NULL,NULL),(164,'forageable','블루베리','/images/collections/forage/블루베리.png',1447,936,NULL,NULL),(165,'forageable','블루베리','/images/collections/forage/블루베리.png',1404,883,NULL,NULL),(166,'forageable','블루베리','/images/collections/forage/블루베리.png',1456,820,NULL,NULL),(167,'forageable','블루베리','/images/collections/forage/블루베리.png',1424,763,NULL,NULL),(168,'forageable','블루베리','/images/collections/forage/블루베리.png',1397,754,NULL,NULL),(169,'forageable','블루베리','/images/collections/forage/블루베리.png',1256,612,NULL,NULL),(170,'forageable','블루베리','/images/collections/forage/블루베리.png',1154,589,NULL,NULL),(171,'forageable','블루베리','/images/collections/forage/블루베리.png',1095,584,NULL,NULL),(172,'forageable','블루베리','/images/collections/forage/블루베리.png',1044,578,NULL,NULL),(173,'forageable','블루베리','/images/collections/forage/블루베리.png',944,552,NULL,NULL),(174,'forageable','블루베리','/images/collections/forage/블루베리.png',886,521,NULL,NULL),(175,'forageable','블루베리','/images/collections/forage/블루베리.png',746,512,NULL,NULL),(176,'forageable','블루베리','/images/collections/forage/블루베리.png',772,517,NULL,NULL),(177,'forageable','블루베리','/images/collections/forage/블루베리.png',806,585,NULL,NULL),(178,'forageable','블루베리','/images/collections/forage/블루베리.png',674,566,NULL,NULL),(185,'forageable','검은 트러플','/images/collections/forage/검은 트러플.png',1920,727,NULL,NULL),(189,'forageable','검은 트러플','/images/collections/forage/검은 트러플.png',1832,691,NULL,NULL),(190,'forageable','검은 트러플','/images/collections/forage/검은 트러플.png',1867,663,NULL,NULL),(191,'forageable','검은 트러플','/images/collections/forage/검은 트러플.png',1908,649,NULL,NULL),(194,'forageable','희귀 목재','/images/collections/forage/희귀 목재.png',754,1255,NULL,NULL),(195,'forageable','희귀 목재','/images/collections/forage/희귀 목재.png',817,1230,NULL,NULL),(196,'forageable','희귀 목재','/images/collections/forage/희귀 목재.png',1198,1237,NULL,NULL),(197,'forageable','희귀 목재','/images/collections/forage/희귀 목재.png',1240,1319,NULL,NULL),(199,'forageable','희귀 목재','/images/collections/forage/희귀 목재.png',1192,786,NULL,NULL),(200,'forageable','희귀 목재','/images/collections/forage/희귀 목재.png',717,835,NULL,NULL),(201,'forageable','희귀 목재','/images/collections/forage/희귀 목재.png',676,703,NULL,NULL),(202,'forageable','희귀 목재','/images/collections/forage/희귀 목재.png',1247,752,NULL,NULL),(204,'forageable','돌','/images/collections/forage/돌.png',727,1253,NULL,NULL),(205,'forageable','돌','/images/collections/forage/돌.png',687,1202,NULL,NULL),(206,'forageable','돌','/images/collections/forage/돌.png',574,1293,NULL,NULL),(207,'forageable','돌','/images/collections/forage/돌.png',669,1141,NULL,NULL),(209,'forageable','돌','/images/collections/forage/돌.png',514,1159,NULL,NULL),(210,'forageable','돌','/images/collections/forage/돌.png',641,1045,NULL,NULL),(211,'forageable','돌','/images/collections/forage/돌.png',650,1002,NULL,NULL),(212,'forageable','돌','/images/collections/forage/돌.png',494,995,NULL,NULL),(213,'forageable','돌','/images/collections/forage/돌.png',632,888,NULL,NULL),(214,'forageable','돌','/images/collections/forage/돌.png',500,855,NULL,NULL),(215,'forageable','돌','/images/collections/forage/돌.png',620,803,NULL,NULL),(216,'forageable','돌','/images/collections/forage/돌.png',1257,1246,NULL,NULL),(217,'forageable','돌','/images/collections/forage/돌.png',1405,1315,NULL,NULL),(219,'forageable','돌','/images/collections/forage/돌.png',1455,1103,NULL,NULL),(220,'forageable','돌','/images/collections/forage/돌.png',1300,1117,NULL,NULL),(221,'forageable','돌','/images/collections/forage/돌.png',1306,1060,NULL,NULL),(222,'forageable','돌','/images/collections/forage/돌.png',1312,973,NULL,NULL),(223,'forageable','돌','/images/collections/forage/돌.png',1449,953,NULL,NULL),(224,'forageable','돌','/images/collections/forage/돌.png',1313,920,NULL,NULL),(225,'forageable','돌','/images/collections/forage/돌.png',1316,866,NULL,NULL),(226,'forageable','돌','/images/collections/forage/돌.png',1450,816,NULL,NULL),(227,'forageable','돌','/images/collections/forage/돌.png',1313,785,NULL,NULL),(228,'forageable','돌','/images/collections/forage/돌.png',726,659,NULL,NULL),(229,'forageable','돌','/images/collections/forage/돌.png',780,651,NULL,NULL),(230,'forageable','돌','/images/collections/forage/돌.png',870,658,NULL,NULL),(231,'forageable','돌','/images/collections/forage/돌.png',933,663,NULL,NULL),(232,'forageable','돌','/images/collections/forage/돌.png',984,675,NULL,NULL),(233,'forageable','돌','/images/collections/forage/돌.png',1072,714,NULL,NULL),(234,'forageable','돌','/images/collections/forage/돌.png',1072,581,NULL,NULL),(235,'forageable','돌','/images/collections/forage/돌.png',691,531,NULL,NULL),(236,'forageable','돌','/images/collections/forage/돌.png',871,522,NULL,NULL),(237,'forageable','돌','/images/collections/forage/돌.png',1173,731,NULL,NULL),(238,'forageable','돌','/images/collections/forage/돌.png',1223,593,NULL,NULL),(239,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',733,447,NULL,NULL),(240,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',708,407,NULL,NULL),(241,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',643,410,NULL,NULL),(242,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',617,394,NULL,NULL),(243,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',592,374,NULL,NULL),(244,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',596,322,NULL,NULL),(245,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',605,292,NULL,NULL),(246,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',683,277,NULL,NULL),(247,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',782,347,NULL,NULL),(248,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',809,357,NULL,NULL),(249,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',850,343,NULL,NULL),(250,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',857,387,NULL,NULL),(251,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',847,431,NULL,NULL),(252,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',954,405,NULL,NULL),(253,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',1000,479,NULL,NULL),(254,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',1025,459,NULL,NULL),(255,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',1033,413,NULL,NULL),(256,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',1053,381,NULL,NULL),(257,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',938,221,NULL,NULL),(258,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',966,282,NULL,NULL),(259,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',1018,328,NULL,NULL),(260,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',1069,341,NULL,NULL),(261,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',1087,376,NULL,NULL),(262,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',1110,380,NULL,NULL),(263,'forageable','느타리버섯','/images/collections/forage/느타리버섯.png',1225,415,NULL,NULL),(264,'forageable','표고버섯','/images/collections/forage/표고버섯.png',802,1577,NULL,NULL),(265,'forageable','표고버섯','/images/collections/forage/표고버섯.png',828,1564,NULL,NULL),(266,'forageable','표고버섯','/images/collections/forage/표고버섯.png',822,1539,NULL,NULL),(267,'forageable','표고버섯','/images/collections/forage/표고버섯.png',806,1509,NULL,NULL),(268,'forageable','표고버섯','/images/collections/forage/표고버섯.png',830,1480,NULL,NULL),(269,'forageable','표고버섯','/images/collections/forage/표고버섯.png',869,1433,NULL,NULL),(270,'forageable','표고버섯','/images/collections/forage/표고버섯.png',832,1412,NULL,NULL),(271,'forageable','표고버섯','/images/collections/forage/표고버섯.png',784,1422,NULL,NULL),(272,'forageable','표고버섯','/images/collections/forage/표고버섯.png',954,1391,NULL,NULL),(273,'forageable','표고버섯','/images/collections/forage/표고버섯.png',990,1389,NULL,NULL),(274,'forageable','표고버섯','/images/collections/forage/표고버섯.png',984,1365,NULL,NULL),(275,'forageable','표고버섯','/images/collections/forage/표고버섯.png',938,1319,NULL,NULL),(276,'forageable','표고버섯','/images/collections/forage/표고버섯.png',916,1297,NULL,NULL),(277,'forageable','표고버섯','/images/collections/forage/표고버섯.png',1003,1298,NULL,NULL),(278,'forageable','표고버섯','/images/collections/forage/표고버섯.png',1048,1418,NULL,NULL),(279,'forageable','표고버섯','/images/collections/forage/표고버섯.png',1078,1414,NULL,NULL),(280,'forageable','표고버섯','/images/collections/forage/표고버섯.png',1080,1436,NULL,NULL),(281,'forageable','표고버섯','/images/collections/forage/표고버섯.png',1105,1437,NULL,NULL),(282,'forageable','표고버섯','/images/collections/forage/표고버섯.png',1168,1400,NULL,NULL),(283,'forageable','표고버섯','/images/collections/forage/표고버섯.png',1190,1419,NULL,NULL),(284,'forageable','표고버섯','/images/collections/forage/표고버섯.png',1248,1390,NULL,NULL),(285,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',356,1367,NULL,NULL),(286,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',384,1381,NULL,NULL),(287,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',420,1395,NULL,NULL),(288,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',478,1399,NULL,NULL),(289,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',502,1424,NULL,NULL),(290,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',522,1381,NULL,NULL),(291,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',574,1400,NULL,NULL),(292,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',549,1346,NULL,NULL),(293,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',516,1337,NULL,NULL),(294,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',499,1285,NULL,NULL),(295,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',490,1259,NULL,NULL),(296,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',453,1198,NULL,NULL),(297,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',490,1192,NULL,NULL),(298,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',486,1104,NULL,NULL),(299,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',445,1040,NULL,NULL),(300,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',297,1015,NULL,NULL),(301,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',363,1015,NULL,NULL),(302,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',382,995,NULL,NULL),(303,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',334,925,NULL,NULL),(304,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',454,899,NULL,NULL),(305,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',473,848,NULL,NULL),(306,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',395,816,NULL,NULL),(307,'forageable','양송이버섯','/images/collections/forage/양송이버섯.png',362,815,NULL,NULL),(309,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1563,811,NULL,NULL),(318,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1636,966,NULL,NULL),(320,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1536,1055,NULL,NULL),(321,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1623,1055,NULL,NULL),(322,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1561,1084,NULL,NULL),(325,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1546,1247,NULL,NULL),(326,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1577,1243,NULL,NULL),(333,'forageable','광석','/images/collections/forage/광석.png',629,1232,NULL,NULL),(334,'forageable','광석','/images/collections/forage/광석.png',565,1284,NULL,NULL),(335,'forageable','광석','/images/collections/forage/광석.png',578,1060,NULL,NULL),(336,'forageable','광석','/images/collections/forage/광석.png',509,1114,NULL,NULL),(337,'forageable','광석','/images/collections/forage/광석.png',475,1000,NULL,NULL),(338,'forageable','광석','/images/collections/forage/광석.png',581,929,NULL,NULL),(339,'forageable','광석','/images/collections/forage/광석.png',480,781,NULL,NULL),(341,'forageable','광석','/images/collections/forage/광석.png',730,512,NULL,NULL),(342,'forageable','광석','/images/collections/forage/광석.png',803,572,NULL,NULL),(343,'forageable','광석','/images/collections/forage/광석.png',939,529,NULL,NULL),(344,'forageable','광석','/images/collections/forage/광석.png',957,612,NULL,NULL),(345,'forageable','광석','/images/collections/forage/광석.png',1082,576,NULL,NULL),(346,'forageable','광석','/images/collections/forage/광석.png',1147,625,NULL,NULL),(347,'forageable','광석','/images/collections/forage/광석.png',1245,595,NULL,NULL),(348,'forageable','광석','/images/collections/forage/광석.png',1448,755,NULL,NULL),(349,'forageable','광석','/images/collections/forage/광석.png',1382,882,NULL,NULL),(350,'forageable','광석','/images/collections/forage/광석.png',1461,939,NULL,NULL),(351,'forageable','광석','/images/collections/forage/광석.png',1419,1034,NULL,NULL),(352,'forageable','광석','/images/collections/forage/광석.png',1458,1149,NULL,NULL),(353,'forageable','광석','/images/collections/forage/광석.png',1354,1216,NULL,NULL),(354,'forageable','광석','/images/collections/forage/광석.png',1369,1355,NULL,NULL),(355,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1565,1296,NULL,NULL),(357,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1566,1223,NULL,NULL),(358,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1593,1223,NULL,NULL),(359,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1531,1214,NULL,NULL),(360,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1607,944,NULL,NULL),(361,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1570,959,NULL,NULL),(362,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1558,935,NULL,NULL),(363,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1581,877,NULL,NULL),(366,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1603,842,NULL,NULL),(367,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1590,794,NULL,NULL),(368,'forageable','그물버섯','/images/collections/forage/그물버섯.png',1634,1130,NULL,NULL),(369,'forageable','대나무','/images/collections/forage/대나무.png',1573,1258,NULL,NULL),(370,'forageable','대나무','/images/collections/forage/대나무.png',1599,1254,NULL,NULL),(371,'forageable','대나무','/images/collections/forage/대나무.png',1600,1268,NULL,NULL),(372,'forageable','대나무','/images/collections/forage/대나무.png',1597,1280,NULL,NULL),(373,'forageable','대나무','/images/collections/forage/대나무.png',1580,1278,NULL,NULL),(374,'forageable','대나무','/images/collections/forage/대나무.png',1558,1268,NULL,NULL),(375,'forageable','대나무','/images/collections/forage/대나무.png',1557,1280,NULL,NULL),(376,'forageable','대나무','/images/collections/forage/대나무.png',1548,1294,NULL,NULL),(377,'forageable','대나무','/images/collections/forage/대나무.png',1550,1308,NULL,NULL),(378,'forageable','대나무','/images/collections/forage/대나무.png',1578,1322,NULL,NULL),(379,'forageable','대나무','/images/collections/forage/대나무.png',1565,1330,NULL,NULL),(380,'forageable','대나무','/images/collections/forage/대나무.png',1554,1336,NULL,NULL),(381,'forageable','대나무','/images/collections/forage/대나무.png',1529,1350,NULL,NULL),(382,'forageable','대나무','/images/collections/forage/대나무.png',1529,1331,NULL,NULL),(383,'forageable','대나무','/images/collections/forage/대나무.png',1507,1330,NULL,NULL),(384,'forageable','대나무','/images/collections/forage/대나무.png',1511,1315,NULL,NULL),(385,'forageable','대나무','/images/collections/forage/대나무.png',1523,1312,NULL,NULL),(386,'forageable','대나무','/images/collections/forage/대나무.png',1500,1309,NULL,NULL),(387,'forageable','대나무','/images/collections/forage/대나무.png',1489,1310,NULL,NULL),(388,'forageable','대나무','/images/collections/forage/대나무.png',1475,1299,NULL,NULL),(389,'forageable','대나무','/images/collections/forage/대나무.png',1464,1302,NULL,NULL),(390,'forageable','대나무','/images/collections/forage/대나무.png',1455,1299,NULL,NULL),(391,'forageable','대나무','/images/collections/forage/대나무.png',1463,1319,NULL,NULL),(392,'forageable','대나무','/images/collections/forage/대나무.png',1462,1336,NULL,NULL),(393,'forageable','대나무','/images/collections/forage/대나무.png',1460,1351,NULL,NULL),(394,'forageable','대나무','/images/collections/forage/대나무.png',1474,1351,NULL,NULL),(395,'forageable','대나무','/images/collections/forage/대나무.png',1460,1370,NULL,NULL),(396,'forageable','대나무','/images/collections/forage/대나무.png',1489,1376,NULL,NULL),(397,'forageable','대나무','/images/collections/forage/대나무.png',1507,1365,NULL,NULL),(398,'forageable','대나무','/images/collections/forage/대나무.png',1549,1351,NULL,NULL),(399,'forageable','사과','/images/collections/forage/사과.png',1396,1296,NULL,NULL),(400,'forageable','사과','/images/collections/forage/사과.png',1250,1298,NULL,NULL),(401,'forageable','사과','/images/collections/forage/사과.png',1241,1234,NULL,NULL),(402,'forageable','사과','/images/collections/forage/사과.png',1284,1198,NULL,NULL),(403,'forageable','사과','/images/collections/forage/사과.png',1359,1178,NULL,NULL),(404,'forageable','사과','/images/collections/forage/사과.png',1298,1140,NULL,NULL),(405,'forageable','사과','/images/collections/forage/사과.png',1423,1144,NULL,NULL),(406,'forageable','사과','/images/collections/forage/사과.png',1296,1070,NULL,NULL),(407,'forageable','사과','/images/collections/forage/사과.png',1363,1044,NULL,NULL),(408,'forageable','사과','/images/collections/forage/사과.png',1347,1011,NULL,NULL),(409,'forageable','사과','/images/collections/forage/사과.png',1302,990,NULL,NULL),(410,'forageable','사과','/images/collections/forage/사과.png',1454,949,NULL,NULL),(411,'forageable','사과','/images/collections/forage/사과.png',1309,921,NULL,NULL),(412,'forageable','사과','/images/collections/forage/사과.png',1322,873,NULL,NULL),(413,'forageable','사과','/images/collections/forage/사과.png',1389,882,NULL,NULL),(414,'forageable','사과','/images/collections/forage/사과.png',1314,815,NULL,NULL),(415,'forageable','사과','/images/collections/forage/사과.png',1321,766,NULL,NULL),(416,'forageable','사과','/images/collections/forage/사과.png',1447,797,NULL,NULL),(417,'forageable','사과','/images/collections/forage/사과.png',1255,721,NULL,NULL),(418,'forageable','사과','/images/collections/forage/사과.png',1227,738,NULL,NULL),(419,'forageable','사과','/images/collections/forage/사과.png',1156,722,NULL,NULL),(420,'forageable','사과','/images/collections/forage/사과.png',1115,733,NULL,NULL),(421,'forageable','사과','/images/collections/forage/사과.png',1131,669,NULL,NULL),(422,'forageable','사과','/images/collections/forage/사과.png',1212,594,NULL,NULL),(423,'forageable','사과','/images/collections/forage/사과.png',1057,577,NULL,NULL),(424,'forageable','사과','/images/collections/forage/사과.png',1046,709,NULL,NULL),(425,'forageable','사과','/images/collections/forage/사과.png',969,695,NULL,NULL),(426,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',605,1315,NULL,NULL),(427,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',743,1298,NULL,NULL),(428,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',731,1268,NULL,NULL),(429,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',688,1208,NULL,NULL),(430,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',677,1173,NULL,NULL),(431,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',578,1209,NULL,NULL),(433,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',521,1207,NULL,NULL),(434,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',660,1087,NULL,NULL),(435,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',645,1062,NULL,NULL),(436,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',648,1023,NULL,NULL),(437,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',670,1010,NULL,NULL),(438,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',647,940,NULL,NULL),(439,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',498,973,NULL,NULL),(440,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',561,917,NULL,NULL),(441,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',481,888,NULL,NULL),(442,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',646,889,NULL,NULL),(443,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',626,793,NULL,NULL),(444,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',636,760,NULL,NULL),(445,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',643,625,NULL,NULL),(446,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',734,655,NULL,NULL),(447,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',775,657,NULL,NULL),(448,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',810,659,NULL,NULL),(449,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',857,662,NULL,NULL),(450,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',824,591,NULL,NULL),(451,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',771,514,NULL,NULL),(452,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',935,532,NULL,NULL),(453,'forageable','귤 (오렌지)','/images/collections/forage/오렌지.png',917,677,NULL,NULL),(454,'bus','겨울 놀이공원','/images/map/bus_icon.png',922,337,NULL,'겨울 놀이공원 정류장'),(455,'villager','바냐','/images/npc/vanya.png',1100,906,'/wiki/others/villagers','낚시 멘토'),(456,'villager','나니와','/images/npc/NPC_icon_나니와.png',1175,986,'/wiki/others/villagers','곤충 채집 멘토'),(457,'villager','블랑코','/images/npc/NPC_icon_블랑코.png',1127,1077,'/wiki/others/villagers','원예 멘토 & 상점 주인'),(458,'villager','아타라','/images/npc/NPC_icon_아타라.png',1024,1023,'/wiki/others/villagers','퀘스트 매니저'),(459,'villager','애니','/images/npc/NPC_icon_애니.png',990,999,'/wiki/others/villagers','프렌즈 상점 주인'),(460,'villager','애쥬어','/images/npc/NPC_icon_애쥬어.png',933,969,'/wiki/others/villagers','트렌드 상인'),(461,'villager','마시모','/images/npc/NPC_icon_마시모.png',988,881,'/wiki/others/villagers','요리 멘토'),(470,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1477,696,NULL,NULL),(471,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1493,719,NULL,NULL),(472,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1507,697,NULL,NULL),(473,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1558,725,NULL,NULL),(474,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1575,742,NULL,NULL),(475,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1573,767,NULL,NULL),(476,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1656,842,NULL,NULL),(477,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1672,846,NULL,NULL),(478,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1661,829,NULL,NULL),(479,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1560,858,NULL,NULL),(480,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1596,867,NULL,NULL),(481,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1579,886,NULL,NULL),(482,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1555,611,NULL,NULL),(483,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1580,617,NULL,NULL),(484,'forageable','야생 고사리','/images/collections/forage/야생 고사리.png',1592,588,NULL,NULL),(485,'forageable','산겨자','/images/collections/forage/산겨자.png',845,1572,NULL,NULL),(486,'forageable','산겨자','/images/collections/forage/산겨자.png',832,1564,NULL,NULL),(487,'forageable','산겨자','/images/collections/forage/산겨자.png',843,1560,NULL,NULL),(488,'forageable','산겨자','/images/collections/forage/산겨자.png',830,1506,NULL,NULL),(489,'forageable','산겨자','/images/collections/forage/산겨자.png',809,1508,NULL,NULL),(490,'forageable','산겨자','/images/collections/forage/산겨자.png',818,1491,NULL,NULL),(491,'forageable','산겨자','/images/collections/forage/산겨자.png',773,1543,NULL,NULL),(492,'forageable','산겨자','/images/collections/forage/산겨자.png',753,1542,NULL,NULL),(493,'forageable','산겨자','/images/collections/forage/산겨자.png',759,1569,NULL,NULL),(494,'forageable','산겨자','/images/collections/forage/산겨자.png',693,1571,NULL,NULL),(495,'forageable','산겨자','/images/collections/forage/산겨자.png',675,1564,NULL,NULL),(496,'forageable','산겨자','/images/collections/forage/산겨자.png',685,1548,NULL,NULL),(497,'forageable','산겨자','/images/collections/forage/산겨자.png',692,1504,NULL,NULL),(498,'forageable','산겨자','/images/collections/forage/산겨자.png',723,1503,NULL,NULL),(499,'forageable','산겨자','/images/collections/forage/산겨자.png',720,1476,NULL,NULL),(500,'forageable','산우엉','/images/collections/forage/산우엉.png',352,881,NULL,NULL),(502,'forageable','산우엉','/images/collections/forage/산우엉.png',369,867,NULL,NULL),(503,'forageable','산우엉','/images/collections/forage/산우엉.png',374,887,NULL,NULL),(504,'forageable','산우엉','/images/collections/forage/산우엉.png',423,898,NULL,NULL),(505,'forageable','산우엉','/images/collections/forage/산우엉.png',438,867,NULL,NULL),(506,'forageable','산우엉','/images/collections/forage/산우엉.png',452,878,NULL,NULL),(507,'forageable','산우엉','/images/collections/forage/산우엉.png',428,932,NULL,NULL),(508,'forageable','산우엉','/images/collections/forage/산우엉.png',442,942,NULL,NULL),(509,'forageable','산우엉','/images/collections/forage/산우엉.png',429,947,NULL,NULL),(510,'forageable','산우엉','/images/collections/forage/산우엉.png',386,817,NULL,NULL),(511,'forageable','산우엉','/images/collections/forage/산우엉.png',369,804,NULL,NULL),(512,'forageable','산우엉','/images/collections/forage/산우엉.png',395,802,NULL,NULL),(513,'forageable','산우엉','/images/collections/forage/산우엉.png',444,757,NULL,NULL),(514,'forageable','산우엉','/images/collections/forage/산우엉.png',473,745,NULL,NULL),(515,'forageable','산우엉','/images/collections/forage/산우엉.png',449,724,NULL,NULL),(518,'forageable','산마늘','/images/collections/forage/산마늘.png',632,156,NULL,NULL),(519,'forageable','산마늘','/images/collections/forage/산마늘.png',635,192,NULL,NULL),(520,'forageable','산마늘','/images/collections/forage/산마늘.png',593,171,NULL,NULL),(521,'forageable','산마늘','/images/collections/forage/산마늘.png',646,273,NULL,NULL),(522,'forageable','산마늘','/images/collections/forage/산마늘.png',655,287,NULL,NULL),(523,'forageable','산마늘','/images/collections/forage/산마늘.png',669,276,NULL,NULL),(524,'forageable','산마늘','/images/collections/forage/산마늘.png',591,335,NULL,NULL),(525,'forageable','산마늘','/images/collections/forage/산마늘.png',590,349,NULL,NULL),(526,'forageable','산마늘','/images/collections/forage/산마늘.png',594,377,NULL,NULL),(527,'forageable','산마늘','/images/collections/forage/산마늘.png',640,488,NULL,NULL),(528,'forageable','산마늘','/images/collections/forage/산마늘.png',624,505,NULL,NULL),(529,'forageable','산마늘','/images/collections/forage/산마늘.png',612,490,NULL,NULL),(530,'forageable','산마늘','/images/collections/forage/산마늘.png',524,479,NULL,NULL),(531,'forageable','산마늘','/images/collections/forage/산마늘.png',537,463,NULL,NULL),(532,'forageable','산마늘','/images/collections/forage/산마늘.png',546,482,NULL,NULL),(533,'forageable','검은 트러플','/images/collections/forage/검은 트러플.png',1811,733,NULL,NULL),(534,'forageable','검은 트러플','/images/collections/forage/검은 트러플.png',1827,733,NULL,NULL),(535,'forageable','검은 트러플','/images/collections/forage/검은 트러플.png',1778,722,NULL,NULL),(536,'forageable','검은 트러플','/images/collections/forage/검은 트러플.png',1801,697,NULL,NULL),(537,'forageable','검은 트러플','/images/collections/forage/검은 트러플.png',1900,696,NULL,NULL),(538,'forageable','검은 트러플','/images/collections/forage/검은 트러플.png',1951,764,NULL,NULL),(539,'forageable','검은 트러플','/images/collections/forage/검은 트러플.png',1925,591,NULL,NULL),(540,'animal','담비','/images/collections/animals/wild_animal_담비.png',616,713,'/wiki/collections/animal','좋아하는 날씨: 무지개');
/*!40000 ALTER TABLE `map_pins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notice`
--

DROP TABLE IF EXISTS `notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notice` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notice`
--

LOCK TABLES `notice` WRITE;
/*!40000 ALTER TABLE `notice` DISABLE KEYS */;
INSERT INTO `notice` VALUES (4,'꿈의 명암 요리 정보가 추가되었습니다','꿈의 명암 이벤트 요리 21종의 정보가 업데이트되었습니다.',1,'2026-03-25 18:46:39','2026-03-25 18:46:39'),(5,'꿈의 명암 2주차 정보가 추가되었습니다. ( 비둘기, 스크립터, 채집물 정보)','꿈의 명암 2주차 정보가 추가되었습니다. ( 비둘기, 스크립터, 채집물 정보)',1,'2026-03-29 11:23:59','2026-03-29 11:23:59');
/*!40000 ALTER TABLE `notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_items`
--

DROP TABLE IF EXISTS `role_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_id` bigint DEFAULT NULL,
  `item_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `role_items_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `villager_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_items`
--

LOCK TABLES `role_items` WRITE;
/*!40000 ALTER TABLE `role_items` DISABLE KEYS */;
INSERT INTO `role_items` VALUES (1,2,'꽃 씨앗'),(2,2,'작물 씨앗'),(3,2,'재배 상자'),(4,2,'비료'),(5,2,'성장 촉진제'),(6,4,'낚시대'),(7,4,'미끼'),(8,4,'어항'),(9,4,'특수 아이템'),(10,8,'식재료'),(11,8,'레시피'),(12,8,'주방용품 도면'),(13,10,'펫'),(14,10,'펫 먹이'),(15,10,'펫 의상'),(16,10,'펫 용품'),(17,10,'자동 급식기'),(18,14,'채집통'),(19,14,'포충망'),(20,14,'특수 아이템'),(21,16,'자전거'),(22,16,'오토바이'),(23,16,'승용차'),(24,17,'골드 거래'),(25,17,'희귀 아이템'),(26,18,'가구'),(27,18,'카페트'),(28,18,'벽지'),(29,18,'건축 자재'),(30,19,'의류'),(31,19,'장신구'),(32,19,'메이크업'),(33,20,'이모티콘'),(34,20,'악기'),(35,20,'녹음기'),(36,21,'다양한 잡화'),(37,23,'눈조각'),(38,23,'계절 아이템');
/*!40000 ALTER TABLE `role_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `villager_gifts`
--

DROP TABLE IF EXISTS `villager_gifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `villager_gifts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `villager_id` bigint DEFAULT NULL,
  `item_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_loved` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `villager_id` (`villager_id`),
  CONSTRAINT `villager_gifts_ibfk_1` FOREIGN KEY (`villager_id`) REFERENCES `villagers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `villager_gifts`
--

LOCK TABLES `villager_gifts` WRITE;
/*!40000 ALTER TABLE `villager_gifts` DISABLE KEYS */;
INSERT INTO `villager_gifts` VALUES (1,1,'희귀 꽃',1),(2,1,'씨앗',1),(3,1,'작물',1),(4,1,'곤충',1),(5,2,'모든 물고기',1),(6,2,'해산물',1),(7,2,'낚시 용품',1),(8,2,'쓰레기',0),(9,2,'광석',0),(10,3,'요리된 음식',1),(11,3,'희귀 식재료',1),(12,4,'해산물 부케',1),(13,4,'쓰레기',0),(14,5,'고품질 새 사진',1);
/*!40000 ALTER TABLE `villager_gifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `villager_roles`
--

DROP TABLE IF EXISTS `villager_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `villager_roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `villager_id` bigint DEFAULT NULL,
  `role_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `villager_id` (`villager_id`),
  CONSTRAINT `villager_roles_ibfk_1` FOREIGN KEY (`villager_id`) REFERENCES `villagers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `villager_roles`
--

LOCK TABLES `villager_roles` WRITE;
/*!40000 ALTER TABLE `villager_roles` DISABLE KEYS */;
INSERT INTO `villager_roles` VALUES (1,1,'GUIDE','원예','희귀 꽃, 씨앗, 작물, 곤충'),(2,1,'SHOP','원예 상점',NULL),(3,2,'GUIDE','낚시','모든 물고기, 해산물, 낚시 용품'),(4,2,'SHOP','낚시 상점',NULL),(5,2,'EVENT','얼음 낚시','이벤트 진행 가능'),(7,3,'GUIDE','요리','요리된 음식, 희귀 식재료'),(8,3,'SHOP','레스토랑 상점',NULL),(9,4,'GUIDE','펫 케어','해산물 부케'),(10,4,'SHOP','펫 샵',NULL),(11,5,'GUIDE','새 관찰','고품질 새 사진'),(12,5,'EVENT','새들의 복귀 사건','이벤트 무작위 발생'),(13,6,'GUIDE','곤충 채집',NULL),(14,6,'SHOP','곤충 상점',NULL),(15,6,'EVENT','곤충 떼 사건','이벤트 무작위 발생'),(16,7,'SHOP','탈것 상점',NULL),(17,8,'SHOP','판매 가능','아이템 판매 상점'),(18,9,'SHOP','인테리어 샵','판매 물품 변경 : 토요일 6시'),(19,10,'SHOP','부띠끄','판매 물품 변경 : 매일 6시'),(20,11,'SHOP','프렌즈 & 뮤직',NULL),(21,12,'SHOP','잡화점',NULL),(22,13,'QUEST','주간 퀘스트',NULL),(23,14,'SHOP','트렌드 상점',NULL),(24,14,'EVENT','트렌드 이벤트','시즌별 이벤트 진행'),(25,22,'EVENT','바다 낚시 사건','이벤트 진행');
/*!40000 ALTER TABLE `villager_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `villagers`
--

DROP TABLE IF EXISTS `villagers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `villagers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_title` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unlock_condition` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `villagers`
--

LOCK TABLES `villagers` WRITE;
/*!40000 ALTER TABLE `villagers` DISABLE KEYS */;
INSERT INTO `villagers` VALUES (1,'블랑코 (Blanc)','원예 멘토 & 상점 주인','/images/npc/NPC_icon_블랑코.png','원예 상점','튜토리얼 진행'),(2,'바냐 (Vanya)','낚시 멘토','/images/npc/vanya.png','가든 스트리트','튜토리얼 진행'),(3,'마시모 (Massimo)','요리 멘토','/images/npc/NPC_icon_마시모.png','카페','Lv.6 + 취미 티켓'),(4,'조안 여사 (Mrs. Joanne)','펫 멘토','/images/npc/NPC_icon_조안_여사.png','펫 하우스','Lv.12 + 취미 티켓'),(5,'베일리 (Bailey)','새 관찰 멘토','/images/npc/NPC_icon_베일리.png','펫 하우스 2층','Lv.6 + 취미 티켓'),(6,'나니와 (Naniwa)','곤충 채집 멘토','/images/npc/NPC_icon_나니와.png','가든 스트리트','Lv.6 + 취미 티켓'),(7,'앤드류 (Andrew)','탈것 상인','/images/npc/NPC_icon_앤드류.png','카 센터',NULL),(8,'알버트 2세 (Albert II)','골드 상인','/images/npc/NPC_icon_알버트_2세.png','교외에서 순회',NULL),(9,'밥 아저씨 (Uncle Bob)','인테리어 상인','/images/npc/NPC_icon_밥_아저씨.png','가구점',NULL),(10,'도로시 (Dorothy)','의상 디자이너','/images/npc/NPC_icon_도로시.png','옷 가게',NULL),(11,'애니 (Annie)','프렌즈 상점 주인','/images/npc/NPC_icon_애니.png','마을 중앙',NULL),(12,'카칭 (Kaching)','잡화 상인','/images/npc/NPC_icon_카칭.png','거주 거리 바깥','도시 방문'),(13,'아타라 (Atara)','퀘스트 매니저','/images/npc/NPC_icon_아타라.png','광장 게시판',NULL),(14,'애쥬어 (Azure)','트렌드 상인','/images/npc/NPC_icon_애쥬어.png','광장',NULL),(15,'에릭 (Eric)','주민','/images/npc/NPC_icon_에릭.png','마을',NULL),(16,'수집가 (Collector)','수집가','/images/npc/NPC_icon_수집가.png','커피마당',NULL),(17,'패티 (Patty)','주민','/images/npc/NPC_icon_패티.png','순록탑',NULL),(18,'버니 (Bunny)','주민','/images/npc/NPC_icon_버니.png','풍차 꽃밭',NULL),(19,'윌 (Will)','주민','/images/npc/NPC_icon_윌.png','마을',NULL),(20,'장난꾸러기 (Prankster)','주민','/images/npc/NPC_icon_장난꾸러기.png','마을 골목',NULL),(21,'해리 (Harry)','주민','/images/npc/NPC_icon_해리.png','마을',NULL),(22,'빌 (Bill)','이벤트 NPC','/images/npc/NPC_icon_빌.png','부두',NULL);
/*!40000 ALTER TABLE `villagers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visitor_stats`
--

DROP TABLE IF EXISTS `visitor_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visitor_stats` (
  `visit_date` date NOT NULL,
  `visit_count` int DEFAULT '0',
  PRIMARY KEY (`visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visitor_stats`
--

LOCK TABLES `visitor_stats` WRITE;
/*!40000 ALTER TABLE `visitor_stats` DISABLE KEYS */;
INSERT INTO `visitor_stats` VALUES ('2026-02-24',14),('2026-02-25',14),('2026-02-26',14),('2026-02-27',14),('2026-02-28',14),('2026-03-01',14),('2026-03-02',92),('2026-03-09',1),('2026-03-10',11),('2026-03-11',16),('2026-03-12',4),('2026-03-13',4),('2026-03-14',6),('2026-03-15',14),('2026-03-16',11),('2026-03-17',19),('2026-03-18',97),('2026-03-19',2),('2026-03-20',16),('2026-03-21',971),('2026-03-22',65),('2026-03-23',112),('2026-03-24',85),('2026-03-25',104),('2026-03-26',106),('2026-03-27',76),('2026-03-28',57),('2026-03-29',66),('2026-03-30',54),('2026-03-31',44),('2026-04-01',37),('2026-04-02',58),('2026-04-03',90),('2026-04-04',116),('2026-04-05',100),('2026-04-06',70),('2026-04-07',115);
/*!40000 ALTER TABLE `visitor_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_reports`
--

DROP TABLE IF EXISTS `wiki_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wiki_reports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `reporter_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `reporter_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_reports`
--

LOCK TABLES `wiki_reports` WRITE;
/*!40000 ALTER TABLE `wiki_reports` DISABLE KEYS */;
INSERT INTO `wiki_reports` VALUES (1,'CONTRIBUTION','aaa','kazan098@naver.com','이거 무거ㅔddd','/wiki/collections/fish/%EB%AF%BC%EB%AC%BC%EB%B0%B0%EC%8A%A4','민물배스','2026-03-10 12:52:31');
/*!40000 ALTER TABLE `wiki_reports` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-08  0:28:37
