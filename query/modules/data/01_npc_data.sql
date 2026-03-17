-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: heartopia_db
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Dumping data for table `villagers`
--

LOCK TABLES `villagers` WRITE;
/*!40000 ALTER TABLE `villagers` DISABLE KEYS */;
INSERT INTO `villagers` VALUES (1,'블랑코 (Blanc)','원예 멘토 & 상점 주인','/images/npc/NPC_icon_블랑코.png','원예 상점','튜토리얼 진행'),(2,'바냐 (Vanya)','낚시 멘토','/images/npc/vanya.png','가든 스트리트','튜토리얼 진행'),(3,'마시모 (Massimo)','요리 멘토','/images/npc/NPC_icon_마시모.png','카페','Lv.6 + 취미 티켓'),(4,'조안 여사 (Mrs. Joanne)','펫 멘토','/images/npc/NPC_icon_조안_여사.png','펫 하우스','Lv.12 + 취미 티켓'),(5,'베일리 (Bailey)','새 관찰 멘토','/images/npc/NPC_icon_베일리.png','펫 하우스 2층','Lv.6 + 취미 티켓'),(6,'나니와 (Naniwa)','곤충 채집 멘토','/images/npc/NPC_icon_나니와.png','가든 스트리트','Lv.6 + 취미 티켓'),(7,'앤드류 (Andrew)','탈것 상인','/images/npc/NPC_icon_앤드류.png','카 센터',NULL),(8,'알버트 2세 (Albert II)','골드 상인','/images/npc/NPC_icon_알버트_2세.png','교외에서 순회',NULL),(9,'밥 아저씨 (Uncle Bob)','인테리어 상인','/images/npc/NPC_icon_밥_아저씨.png','가구점',NULL),(10,'도로시 (Dorothy)','의상 디자이너','/images/npc/NPC_icon_도로시.png','옷 가게',NULL),(11,'애니 (Annie)','프렌즈 상점 주인','/images/npc/NPC_icon_애니.png','마을 중앙',NULL),(12,'카칭 (Kaching)','잡화 상인','/images/npc/NPC_icon_카칭.png','거주 거리 바깥','도시 방문'),(13,'아타라 (Atara)','퀘스트 매니저','/images/npc/NPC_icon_아타라.png','광장 게시판',NULL),(14,'애쥬어 (Azure)','트렌드 상인','/images/npc/NPC_icon_애쥬어.png','광장',NULL),(15,'에릭 (Eric)','주민','/images/npc/NPC_icon_에릭.png','마을',NULL),(16,'수집가 (Collector)','수집가','/images/npc/NPC_icon_수집가.png','커피마당',NULL),(17,'패티 (Patty)','주민','/images/npc/NPC_icon_패티.png','순록탑',NULL),(18,'버니 (Bunny)','주민','/images/npc/NPC_icon_버니.png','풍차 꽃밭',NULL),(19,'윌 (Will)','주민','/images/npc/NPC_icon_윌.png','마을',NULL),(20,'장난꾸러기 (Prankster)','주민','/images/npc/NPC_icon_장난꾸러기.png','마을 골목',NULL),(21,'해리 (Harry)','주민','/images/npc/NPC_icon_해리.png','마을',NULL),(22,'빌 (Bill)','이벤트 NPC','/images/npc/NPC_icon_빌.png','부두',NULL);
/*!40000 ALTER TABLE `villagers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `villager_roles`
--

LOCK TABLES `villager_roles` WRITE;
/*!40000 ALTER TABLE `villager_roles` DISABLE KEYS */;
INSERT INTO `villager_roles` VALUES (1,1,'GUIDE','원예','희귀 꽃, 씨앗, 작물, 곤충'),(2,1,'SHOP','원예 상점',NULL),(3,2,'GUIDE','낚시','모든 물고기, 해산물, 낚시 용품'),(4,2,'SHOP','낚시 상점',NULL),(5,2,'EVENT','얼음 낚시','이벤트 진행 가능'),(7,3,'GUIDE','요리','요리된 음식, 희귀 식재료'),(8,3,'SHOP','레스토랑 상점',NULL),(9,4,'GUIDE','펫 케어','해산물 부케'),(10,4,'SHOP','펫 샵',NULL),(11,5,'GUIDE','새 관찰','고품질 새 사진'),(12,5,'EVENT','새들의 복귀 사건','이벤트 무작위 발생'),(13,6,'GUIDE','곤충 채집',NULL),(14,6,'SHOP','곤충 상점',NULL),(15,6,'EVENT','곤충 떼 사건','이벤트 무작위 발생'),(16,7,'SHOP','탈것 상점',NULL),(17,8,'SHOP','판매 가능','아이템 판매 상점'),(18,9,'SHOP','인테리어 샵','판매 물품 변경 : 토요일 6시'),(19,10,'SHOP','부띠끄','판매 물품 변경 : 매일 6시'),(20,11,'SHOP','프렌즈 & 뮤직',NULL),(21,12,'SHOP','잡화점',NULL),(22,13,'QUEST','주간 퀘스트',NULL),(23,14,'SHOP','트렌드 상점',NULL),(24,14,'EVENT','트렌드 이벤트','시즌별 이벤트 진행'),(25,22,'EVENT','바다 낚시 사건','이벤트 진행');
/*!40000 ALTER TABLE `villager_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `role_items`
--

LOCK TABLES `role_items` WRITE;
/*!40000 ALTER TABLE `role_items` DISABLE KEYS */;
INSERT INTO `role_items` VALUES (1,2,'꽃 씨앗'),(2,2,'작물 씨앗'),(3,2,'재배 상자'),(4,2,'비료'),(5,2,'성장 촉진제'),(6,4,'낚시대'),(7,4,'미끼'),(8,4,'어항'),(9,4,'특수 아이템'),(10,8,'식재료'),(11,8,'레시피'),(12,8,'주방용품 도면'),(13,10,'펫'),(14,10,'펫 먹이'),(15,10,'펫 의상'),(16,10,'펫 용품'),(17,10,'자동 급식기'),(18,14,'채집통'),(19,14,'포충망'),(20,14,'특수 아이템'),(21,16,'자전거'),(22,16,'오토바이'),(23,16,'승용차'),(24,17,'골드 거래'),(25,17,'희귀 아이템'),(26,18,'가구'),(27,18,'카페트'),(28,18,'벽지'),(29,18,'건축 자재'),(30,19,'의류'),(31,19,'장신구'),(32,19,'메이크업'),(33,20,'이모티콘'),(34,20,'악기'),(35,20,'녹음기'),(36,21,'다양한 잡화'),(37,23,'눈조각'),(38,23,'계절 아이템');
/*!40000 ALTER TABLE `role_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `villager_gifts`
--

LOCK TABLES `villager_gifts` WRITE;
/*!40000 ALTER TABLE `villager_gifts` DISABLE KEYS */;
INSERT INTO `villager_gifts` VALUES (1,1,'희귀 꽃',1),(2,1,'씨앗',1),(3,1,'작물',1),(4,1,'곤충',1),(5,2,'모든 물고기',1),(6,2,'해산물',1),(7,2,'낚시 용품',1),(8,2,'쓰레기',0),(9,2,'광석',0),(10,3,'요리된 음식',1),(11,3,'희귀 식재료',1),(12,4,'해산물 부케',1),(13,4,'쓰레기',0),(14,5,'고품질 새 사진',1);
/*!40000 ALTER TABLE `villager_gifts` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-18  3:45:37
