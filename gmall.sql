/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 5.6.38 : Database - gmall
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`gmall` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `gmall`;

/*Table structure for table `ad_banner` */

DROP TABLE IF EXISTS `ad_banner`;

CREATE TABLE `ad_banner` (
  `Id` bigint(11) NOT NULL AUTO_INCREMENT,
  `ad_desc` varchar(500) DEFAULT NULL,
  `file_name` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `ad_banner` */

/*Table structure for table `base_attr_info` */

DROP TABLE IF EXISTS `base_attr_info`;

CREATE TABLE `base_attr_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `attr_name` varchar(100) NOT NULL COMMENT '属性名称',
  `catalog3_id` bigint(20) DEFAULT NULL,
  `is_enabled` varchar(1) DEFAULT NULL COMMENT '启用：1 停用：0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='属性表';

/*Data for the table `base_attr_info` */

insert  into `base_attr_info`(`id`,`attr_name`,`catalog3_id`,`is_enabled`) values (1,'品牌',5,'1'),(2,'价格',5,'1'),(3,'屏幕尺寸',5,'1'),(4,'分辨率',5,'1'),(5,'观看距离',5,'1'),(6,'能效等级',5,'1'),(7,'品牌类型',5,'1'),(8,'大家说',5,'1'),(9,'选购指数',5,'1'),(10,'功率',5,NULL);

/*Table structure for table `base_attr_value` */

DROP TABLE IF EXISTS `base_attr_value`;

CREATE TABLE `base_attr_value` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `value_name` varchar(100) NOT NULL COMMENT '属性值名称',
  `attr_id` bigint(20) DEFAULT NULL COMMENT '属性id',
  `is_enabled` varchar(1) DEFAULT NULL COMMENT '启用：1 停用：0 1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8 COMMENT='属性值表';

/*Data for the table `base_attr_value` */

insert  into `base_attr_value`(`id`,`value_name`,`attr_id`,`is_enabled`) values (10,'1000W',10,''),(26,'2000W',10,NULL),(27,'3000W',10,NULL),(28,'三星',1,NULL),(29,'创维',1,NULL),(30,'5000以上',2,NULL),(31,'5000以下',2,NULL),(32,'55寸',3,NULL),(33,'70寸',3,NULL),(34,'1080P',4,NULL),(35,'4K',4,NULL),(36,'3M-5M',5,NULL),(37,'5M以上',5,NULL),(38,'3级',6,NULL),(39,'4级',6,NULL),(40,'5级',6,NULL),(41,'高级',7,NULL),(42,'中级',7,NULL),(43,'经济型',7,NULL),(44,'屏幕好',8,NULL),(45,'尺寸大',8,NULL),(46,'五星',9,NULL),(47,'四星',9,NULL);

/*Table structure for table `base_catalog1` */

DROP TABLE IF EXISTS `base_catalog1`;

CREATE TABLE `base_catalog1` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(200) NOT NULL COMMENT '分类名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='一级分类表';

/*Data for the table `base_catalog1` */

insert  into `base_catalog1`(`id`,`name`) values (1,'家用电器'),(2,'手机、运营商、数码'),(3,'电脑、办公'),(4,'家居、家具、家装、厨具'),(5,'男装、女装、童装、内衣'),(6,'美妆、个护清洁、宠物'),(7,'女鞋、箱包、钟表、珠宝'),(8,'男鞋、运动、户外'),(9,'房产、汽车、汽车用品'),(10,'母婴、玩具乐器'),(11,'食品、酒类、生鲜、特产'),(12,'艺术、礼品鲜花、农资绿植'),(13,'医药保健、计生情趣'),(14,'图书、文娱、电子书'),(15,'机票、酒店、旅游、生活'),(16,'理财、众筹、白条、保险'),(17,'安装、维修、清洗、二手'),(18,'工业品');

/*Table structure for table `base_catalog1_tm` */

DROP TABLE IF EXISTS `base_catalog1_tm`;

CREATE TABLE `base_catalog1_tm` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `tm_id` bigint(20) DEFAULT NULL COMMENT '品牌id',
  `catalog1_id` varchar(4000) DEFAULT NULL COMMENT '一级分类id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='分类与品牌关联表';

/*Data for the table `base_catalog1_tm` */

/*Table structure for table `base_catalog2` */

DROP TABLE IF EXISTS `base_catalog2`;

CREATE TABLE `base_catalog2` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(200) NOT NULL COMMENT '二级分类名称',
  `catalog1_id` int(11) DEFAULT NULL COMMENT '一级分类编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

/*Data for the table `base_catalog2` */

insert  into `base_catalog2`(`id`,`name`,`catalog1_id`) values (1,'家电馆',1),(2,'电视',1),(3,'空调',1),(4,'洗衣机',1),(5,'冰箱',1),(6,'厨卫大电',1),(7,'厨房小电',1),(8,'生活电器',1),(9,'个护健康',1),(10,'视听影音',1),(11,'玩3C',2),(12,'手机通讯',2),(13,'运营商',2),(14,'手机配件',2),(15,'摄影摄像',2),(16,'数码配件',2),(17,'影音娱乐',2),(18,'智能设备',2),(19,'电子教育',2);

/*Table structure for table `base_catalog3` */

DROP TABLE IF EXISTS `base_catalog3`;

CREATE TABLE `base_catalog3` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(200) NOT NULL COMMENT '三级分类名称',
  `catalog2_id` bigint(20) DEFAULT NULL COMMENT '二级分类编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8;

/*Data for the table `base_catalog3` */

insert  into `base_catalog3`(`id`,`name`,`catalog2_id`) values (1,'家电专卖店',1),(2,'家电服务',1),(3,'企业采购',1),(4,'商用电器',1),(5,'超薄电视',2),(6,'全面屏电视',2),(7,'智能电视',2),(8,'OLED电视',2),(9,'曲面电视',2),(10,'4K超清电视',2),(11,'55英寸',2),(12,'65英寸',2),(13,'空调挂机',3),(14,'空调柜机',3),(15,'精选推荐',3),(16,'中央空调',3),(17,'移动空调',3),(18,'省电空调',3),(19,'变频空调',3),(20,'以旧换新',3),(21,'滚筒洗衣机',4),(22,'洗烘一体机',4),(23,'波轮洗衣机',4),(24,'迷你洗衣机',4),(25,'烘干机',4),(26,'洗衣机配件',4),(27,'多门',5),(28,'对开门',5),(29,'三门',5),(30,'双门',5),(31,'冷柜、冰吧',5),(32,'酒柜',5),(33,'冰箱配件',5),(34,'油烟机',6),(35,'燃气灶',6),(36,'烟灶套装',6),(37,'集成灶',6),(38,'消毒柜',6),(39,'洗碗机',6),(40,'电热水器',6),(41,'燃气热水器',6),(42,'空气热水器',6),(43,'嵌入式厨电',6),(44,'烟机灶具配件',6),(45,'破壁机',7),(46,'电烤箱',7),(47,'电饭煲',7),(48,'电压力锅',7),(49,'电炖锅',7),(50,'豆浆机',7),(51,'料理机',7),(52,'咖啡机',7),(53,'电饼铛',7),(54,'榨汁机',7),(55,'电水壶',7),(56,'微波炉',7),(57,'多用途锅',7),(58,'养生壶',7),(59,'电磁炉',7),(60,'面包机',7),(61,'空气炸锅',7),(62,'面条机',7),(63,'电陶炉',7),(64,'电烧烤炉',7),(65,'电风扇',8),(66,'冷风扇',8),(67,'空气净化器',8),(68,'吸尘器',8),(69,'除螨仪',8),(70,'扫地机器人',8),(71,'除湿机',8),(72,'干衣机',8),(73,'加湿器',8),(74,'挂烫机、熨斗',8),(75,'电话机',8),(76,'饮水机',8),(77,'净水器',8),(78,'取暖电器',8),(79,'毛球修剪器',8),(80,'生活电器配件',8),(81,'剃须刀',9),(82,'电动牙刷',9),(83,'电吹风',9),(84,'美容器',9),(85,'洁面仪',9),(86,'按摩器',9),(87,'健康秤',9),(88,'卷、直发器',9),(89,'剃、脱毛器',9),(90,'足疗机',9),(91,'按摩椅',9),(92,'家庭影院',10),(93,'KTV音响',10),(94,'迷你音响',10),(95,'DVD',10),(96,'功放',10),(97,'回音壁',10),(98,'麦克风',10),(99,'手机频道',11),(100,'网上营业厅',11),(101,'配件选购中心',11),(102,'智能数码',11),(103,'影响Club',11),(104,'手机',12),(105,'游戏手机',12),(106,'老人机',12),(107,'对讲机',12),(108,'以旧换新',12),(109,'手机维修',12);

/*Table structure for table `base_dict` */

DROP TABLE IF EXISTS `base_dict`;

CREATE TABLE `base_dict` (
  `id` varchar(200) NOT NULL COMMENT '编号',
  `parent_id` varchar(200) DEFAULT NULL COMMENT '父id',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='字典表';

/*Data for the table `base_dict` */

/*Table structure for table `base_sale_attr` */

DROP TABLE IF EXISTS `base_sale_attr`;

CREATE TABLE `base_sale_attr` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(100) NOT NULL COMMENT '销售属性名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Data for the table `base_sale_attr` */

insert  into `base_sale_attr`(`id`,`name`) values (1,'颜色'),(2,'尺寸'),(3,'版本'),(4,'容量');

/*Table structure for table `base_trademark` */

DROP TABLE IF EXISTS `base_trademark`;

CREATE TABLE `base_trademark` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `tm_name` varchar(100) NOT NULL COMMENT '属性值',
  `logo_url` varchar(200) DEFAULT NULL COMMENT '品牌logo的图片路径',
  `is_enable` varchar(1) DEFAULT NULL COMMENT '是否启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='品牌表';

/*Data for the table `base_trademark` */

/*Table structure for table `cart_info` */

DROP TABLE IF EXISTS `cart_info`;

CREATE TABLE `cart_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  `sku_id` bigint(20) DEFAULT NULL COMMENT 'skuid',
  `cart_price` decimal(10,2) DEFAULT NULL COMMENT '放入购物车时价格',
  `quantity` int(11) DEFAULT NULL COMMENT '数量',
  `img_url` varchar(200) DEFAULT NULL COMMENT '图片文件名称',
  `is_checked` varchar(1) DEFAULT NULL COMMENT '是否选中',
  `sku_price` decimal(10,2) DEFAULT NULL COMMENT 'sku单价（冗余需要同步)',
  `sku_num` decimal(10,0) DEFAULT NULL,
  `sku_name` varchar(200) DEFAULT NULL COMMENT 'sku名称 (冗余)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='购物车表 用户登录系统时更新冗余';

/*Data for the table `cart_info` */

/*Table structure for table `order_detail` */

DROP TABLE IF EXISTS `order_detail`;

CREATE TABLE `order_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `order_id` bigint(20) DEFAULT NULL COMMENT '订单编号',
  `sku_id` bigint(20) DEFAULT NULL COMMENT 'sku_id',
  `sku_name` varchar(200) DEFAULT NULL COMMENT 'sku名称（冗余)',
  `img_file_name` varchar(200) DEFAULT NULL COMMENT '图片名称（冗余)',
  `order_price` decimal(10,0) DEFAULT NULL COMMENT '购买价格(下单时sku价格）',
  `sku_nums` varchar(200) DEFAULT NULL COMMENT '购买个数',
  `logistics_id` bigint(20) DEFAULT NULL COMMENT '物流包裹id',
  `img_url` varchar(200) DEFAULT NULL,
  `sku_num` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

/*Data for the table `order_detail` */

insert  into `order_detail`(`id`,`order_id`,`sku_id`,`sku_name`,`img_file_name`,`order_price`,`sku_nums`,`logistics_id`,`img_url`,`sku_num`) values (1,1,3,'创维电视test001-sku02',NULL,'9105',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWECAeksVAAbIYscxeNI211.jpg','3'),(2,1,2,'创维电视test001-sku01',NULL,'45248',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','8'),(3,1,1,'电视1版本',NULL,'3000',NULL,NULL,NULL,'1'),(4,2,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1'),(5,3,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1'),(6,4,2,'创维电视test001-sku01',NULL,'11312',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','2'),(7,5,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1'),(8,6,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1'),(9,7,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1'),(10,8,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1'),(11,9,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1'),(12,10,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1'),(13,11,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1'),(14,12,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1'),(15,13,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1'),(16,14,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1'),(17,15,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1'),(18,16,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1'),(19,17,2,'创维电视test001-sku01',NULL,'5656',NULL,NULL,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg','1');

/*Table structure for table `order_info` */

DROP TABLE IF EXISTS `order_info`;

CREATE TABLE `order_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `consignee` varchar(100) DEFAULT NULL COMMENT '收货人',
  `total_amount` decimal(10,2) DEFAULT NULL COMMENT '总金额',
  `order_status` varchar(100) DEFAULT NULL COMMENT '订单状态',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  `payment_way` varchar(20) DEFAULT NULL COMMENT '付款方式',
  `expect_delivery_time` datetime DEFAULT NULL COMMENT '预计送达时间',
  `delivery_address` varchar(1000) DEFAULT NULL COMMENT '送货地址',
  `order_comment` varchar(400) DEFAULT NULL,
  `out_trade_no` varchar(50) DEFAULT NULL,
  `trade_body` varchar(200) DEFAULT NULL COMMENT '订单描述(第三方支付用)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `expire_time` datetime DEFAULT NULL COMMENT '失效时间',
  `ware_status` varchar(2) DEFAULT NULL,
  `parent_order_id` bigint(20) DEFAULT NULL,
  `process_status` varchar(100) DEFAULT NULL,
  `tracking_no` varchar(100) DEFAULT NULL,
  `consignee_tel` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

/*Data for the table `order_info` */

insert  into `order_info`(`id`,`consignee`,`total_amount`,`order_status`,`user_id`,`payment_way`,`expect_delivery_time`,`delivery_address`,`order_comment`,`out_trade_no`,`trade_body`,`create_time`,`expire_time`,`ware_status`,`parent_order_id`,`process_status`,`tracking_no`,`consignee_tel`) values (1,'测试收件人','57353.00','未支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907131959151563019155481',NULL,'2019-07-13 19:59:15','2019-07-14 19:59:15',NULL,NULL,'订单未支付',NULL,'13123123123123'),(2,'测试收件人','5656.00','未支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907132127011563024421278',NULL,'2019-07-13 21:27:01','2019-07-14 21:27:01',NULL,NULL,'订单未支付',NULL,'13123123123123'),(3,'测试收件人','5656.00','未支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907132128371563024517665',NULL,'2019-07-13 21:28:38','2019-07-14 21:28:38',NULL,NULL,'订单未支付',NULL,'13123123123123'),(4,'测试收件人','11312.00','未支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907132203081563026588493',NULL,'2019-07-13 22:03:08','2019-07-14 22:03:08',NULL,NULL,'订单未支付',NULL,'13123123123123'),(5,'测试收件人','5656.00','未支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907132204411563026681300',NULL,'2019-07-13 22:04:41','2019-07-14 22:04:41',NULL,NULL,'订单未支付',NULL,'13123123123123'),(6,'测试收件人','5656.00','未支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907132206051563026765263',NULL,'2019-07-13 22:06:05','2019-07-14 22:06:05',NULL,NULL,'订单未支付',NULL,'13123123123123'),(7,'测试收件人','5656.00','未支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907151117201563160640404',NULL,'2019-07-15 11:17:20','2019-07-16 11:17:20',NULL,NULL,'订单未支付',NULL,'13123123123123'),(8,'测试收件人','5656.00','未支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907151121361563160896572',NULL,'2019-07-15 11:21:37','2019-07-16 11:21:37',NULL,NULL,'订单未支付',NULL,'13123123123123'),(9,'测试收件人','5656.00','未支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907151139071563161947931',NULL,'2019-07-15 11:39:08','2019-07-16 11:39:08',NULL,NULL,'订单未支付',NULL,'13123123123123'),(10,'测试收件人','5656.00','未支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907151142151563162135001',NULL,'2019-07-15 11:42:15','2019-07-16 11:42:15',NULL,NULL,'订单未支付',NULL,'13123123123123'),(11,'测试收件人','5656.00','未支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907151524511563175491089',NULL,'2019-07-15 15:24:51','2019-07-16 15:24:51',NULL,NULL,'订单未支付',NULL,'13123123123123'),(12,'测试收件人','5656.00','订单已支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907151526481563175608002',NULL,'2019-07-15 15:26:48','2019-07-16 15:26:48',NULL,NULL,'准备出库','aliNo0001','13123123123123'),(13,'测试收件人','5656.00','订单已支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907151756491563184609573',NULL,'2019-07-15 17:56:50','2019-07-16 17:56:50',NULL,NULL,'准备出库','aliNo0001','13123123123123'),(14,'测试收件人','5656.00','订单已支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907171912321563361952119',NULL,'2019-07-17 19:12:32','2019-07-18 19:12:32',NULL,NULL,'准备出库','aliNo0001','13123123123123'),(15,'测试收件人','5656.00','订单已支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907171920191563362419018',NULL,'2019-07-17 19:20:19','2019-07-18 19:20:19',NULL,NULL,'准备出库','aliNo0001','13123123123123'),(16,'测试收件人','5656.00','订单已支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907171926511563362811898',NULL,'2019-07-17 19:26:52','2019-07-18 19:26:52',NULL,NULL,'准备出库','aliNo0001','13123123123123'),(17,'测试收件人','5656.00','订单已支付',4,NULL,NULL,'测试收件地址','硅谷订单','ATGUIGU201907171940051563363605922',NULL,'2019-07-17 19:40:06','2019-07-18 19:40:06',NULL,NULL,'准备出库','aliNo0001','13123123123123');

/*Table structure for table `order_log` */

DROP TABLE IF EXISTS `order_log`;

CREATE TABLE `order_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `order_id` bigint(20) DEFAULT NULL COMMENT '订单编号',
  `operate_date` datetime DEFAULT NULL COMMENT '发生时间',
  `log_comment` varchar(200) DEFAULT NULL COMMENT '状态描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `order_log` */

/*Table structure for table `order_logistics` */

DROP TABLE IF EXISTS `order_logistics`;

CREATE TABLE `order_logistics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `order_id` bigint(20) DEFAULT NULL COMMENT '订单id',
  `logistics_status` varchar(2) DEFAULT NULL COMMENT '物流状态',
  `logistics_no` varchar(100) DEFAULT NULL COMMENT '物流单号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='物流表';

/*Data for the table `order_logistics` */

/*Table structure for table `payment_info` */

DROP TABLE IF EXISTS `payment_info`;

CREATE TABLE `payment_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `out_trade_no` varchar(50) DEFAULT NULL COMMENT '对外业务编号',
  `order_id` varchar(50) DEFAULT NULL COMMENT '订单编号',
  `alipay_trade_no` varchar(50) DEFAULT NULL COMMENT '支付宝交易编号',
  `total_amount` decimal(10,2) DEFAULT NULL COMMENT '支付金额',
  `subject` varchar(200) DEFAULT NULL COMMENT '交易内容',
  `payment_status` varchar(20) DEFAULT NULL COMMENT '支付状态',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `confirm_time` datetime DEFAULT NULL COMMENT '创建时间',
  `callback_content` varchar(1000) DEFAULT NULL COMMENT '回调信息',
  `callback_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='支付信息表';

/*Data for the table `payment_info` */

insert  into `payment_info`(`id`,`out_trade_no`,`order_id`,`alipay_trade_no`,`total_amount`,`subject`,`payment_status`,`create_time`,`confirm_time`,`callback_content`,`callback_time`) values (1,'ATGUIGU201907151139071563161947931','9',NULL,'5656.00','创维电视test001-sku01','未支付','2019-07-15 11:39:12',NULL,NULL,NULL),(2,'ATGUIGU201907151142151563162135001','10','aliNo0001','5656.00','创维电视test001-sku01','已支付','2019-07-15 11:42:19',NULL,'trade_no=aliNo0001&out_trade_no=ATGUIGU201907151142151563162135001&trade_status=SUCCESS','2019-07-15 11:42:19'),(3,'ATGUIGU201907151524511563175491089','11','aliNo0001','5656.00','创维电视test001-sku01','已支付','2019-07-15 15:24:55',NULL,'trade_no=aliNo0001&out_trade_no=ATGUIGU201907151524511563175491089&trade_status=SUCCESS','2019-07-15 15:24:56'),(4,'ATGUIGU201907151526481563175608002','12','aliNo0001','5656.00','创维电视test001-sku01','已支付','2019-07-15 15:26:51',NULL,'trade_no=aliNo0001&out_trade_no=ATGUIGU201907151526481563175608002&trade_status=SUCCESS','2019-07-15 15:26:51'),(5,'ATGUIGU201907151756491563184609573','13','aliNo0001','5656.00','创维电视test001-sku01','已支付','2019-07-15 17:56:53',NULL,'trade_no=aliNo0001&out_trade_no=ATGUIGU201907151756491563184609573&trade_status=SUCCESS','2019-07-15 17:56:54'),(6,'ATGUIGU201907171912321563361952119','14','aliNo0001','5656.00','创维电视test001-sku01','已支付','2019-07-17 19:12:36',NULL,'trade_no=aliNo0001&out_trade_no=ATGUIGU201907171912321563361952119&trade_status=SUCCESS','2019-07-17 19:12:36'),(7,'ATGUIGU201907171920191563362419018','15','aliNo0001','5656.00','创维电视test001-sku01','已支付','2019-07-17 19:20:21',NULL,'trade_no=aliNo0001&out_trade_no=ATGUIGU201907171920191563362419018&trade_status=SUCCESS','2019-07-17 19:20:22'),(8,'ATGUIGU201907171926511563362811898','16','aliNo0001','5656.00','创维电视test001-sku01','已支付','2019-07-17 19:26:54',NULL,'trade_no=aliNo0001&out_trade_no=ATGUIGU201907171926511563362811898&trade_status=SUCCESS','2019-07-17 19:26:54'),(9,'ATGUIGU201907171940051563363605922','17','aliNo0001','5656.00','创维电视test001-sku01','已支付','2019-07-17 19:40:08',NULL,'trade_no=aliNo0001&out_trade_no=ATGUIGU201907171940051563363605922&trade_status=SUCCESS','2019-07-17 19:40:09');

/*Table structure for table `sku_attr_value` */

DROP TABLE IF EXISTS `sku_attr_value`;

CREATE TABLE `sku_attr_value` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `attr_id` bigint(20) DEFAULT NULL COMMENT '属性id（冗余)',
  `value_id` bigint(20) DEFAULT NULL COMMENT '属性值id',
  `sku_id` bigint(20) DEFAULT NULL COMMENT 'skuid',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COMMENT='sku平台属性值关联表';

/*Data for the table `sku_attr_value` */

insert  into `sku_attr_value`(`id`,`attr_id`,`value_id`,`sku_id`) values (1,1,29,2),(2,2,30,2),(3,3,32,2),(4,4,34,2),(5,5,36,2),(6,6,40,2),(7,7,42,2),(8,8,45,2),(9,9,47,2),(10,10,27,2),(11,1,29,3),(12,2,31,3),(13,3,33,3),(14,4,35,3),(15,5,37,3),(16,6,40,3),(17,7,43,3),(18,8,44,3),(19,9,46,3),(20,10,26,3);

/*Table structure for table `sku_image` */

DROP TABLE IF EXISTS `sku_image`;

CREATE TABLE `sku_image` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `sku_id` bigint(20) DEFAULT NULL COMMENT '商品id',
  `img_name` varchar(200) DEFAULT NULL COMMENT '图片名称（冗余）',
  `img_url` varchar(200) DEFAULT NULL COMMENT '图片路径(冗余)',
  `spu_img_id` bigint(20) DEFAULT NULL COMMENT '商品图片id',
  `is_default` varchar(4000) DEFAULT NULL COMMENT '是否默认',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='库存单元图片表';

/*Data for the table `sku_image` */

insert  into `sku_image`(`id`,`sku_id`,`img_name`,`img_url`,`spu_img_id`,`is_default`) values (1,2,'14f137f059a3d619675995bf8dc2b391e40a17f3dcdc3c93f6d3d2df7f9597c9.jpg','http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAdZshAAcJ0rsVBLk251.jpg',2,'0'),(2,2,'6445e151fb1c30435b54397eaf3255a8f621e778c63b75659b8e5dbdc6d6e9e2.jpg','http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg',3,'1'),(3,3,'3db25041dae7f7c824ccb688529e679b91eb650817f1dc9b13bb035499b25651.jpg','http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWECAeksVAAbIYscxeNI211.jpg',1,'1'),(4,3,'14f137f059a3d619675995bf8dc2b391e40a17f3dcdc3c93f6d3d2df7f9597c9.jpg','http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAdZshAAcJ0rsVBLk251.jpg',2,'0'),(5,3,'6445e151fb1c30435b54397eaf3255a8f621e778c63b75659b8e5dbdc6d6e9e2.jpg','http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg',3,'0');

/*Table structure for table `sku_info` */

DROP TABLE IF EXISTS `sku_info`;

CREATE TABLE `sku_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '库存id(itemID)',
  `spu_id` bigint(20) DEFAULT NULL COMMENT '商品id',
  `price` double DEFAULT NULL COMMENT '价格',
  `sku_name` varchar(200) DEFAULT NULL COMMENT 'sku名称',
  `sku_desc` varchar(2000) DEFAULT NULL COMMENT '商品规格描述',
  `weight` double DEFAULT NULL,
  `tm_id` bigint(20) DEFAULT NULL COMMENT '品牌(冗余)',
  `catalog3_id` bigint(20) DEFAULT NULL COMMENT '三级分类id（冗余)',
  `sku_default_img` varchar(200) DEFAULT NULL COMMENT '默认显示图片(冗余)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='库存单元表';

/*Data for the table `sku_info` */

insert  into `sku_info`(`id`,`spu_id`,`price`,`sku_name`,`sku_desc`,`weight`,`tm_id`,`catalog3_id`,`sku_default_img`) values (1,2,3000,'电视1版本','电视1版本',3.25,NULL,5,NULL),(2,2,5656,'创维电视test001-sku01','创维电视test001-sku01创维电视test001-sku01',13.7,NULL,5,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg'),(3,2,3035,'创维电视test001-sku02','创维电视test001-sku02创维电视test001-sku02',17,NULL,5,'http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWECAeksVAAbIYscxeNI211.jpg');

/*Table structure for table `sku_sale_attr_value` */

DROP TABLE IF EXISTS `sku_sale_attr_value`;

CREATE TABLE `sku_sale_attr_value` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `sku_id` bigint(20) DEFAULT NULL COMMENT '库存单元id',
  `sale_attr_id` bigint(20) DEFAULT NULL COMMENT '销售属性id（冗余)',
  `sale_attr_value_id` bigint(20) DEFAULT NULL COMMENT '销售属性值id',
  `sale_attr_name` varchar(20) DEFAULT NULL COMMENT '销售属性名称(冗余)',
  `sale_attr_value_name` varchar(20) DEFAULT NULL COMMENT '销售属性值名称(冗余)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='sku销售属性值';

/*Data for the table `sku_sale_attr_value` */

insert  into `sku_sale_attr_value`(`id`,`sku_id`,`sale_attr_id`,`sale_attr_value_id`,`sale_attr_name`,`sale_attr_value_name`) values (1,2,1,2,'颜色','红色'),(2,2,2,3,'尺寸','50寸'),(3,3,1,2,'颜色','红色'),(4,3,2,4,'尺寸','70寸');

/*Table structure for table `spu_color` */

DROP TABLE IF EXISTS `spu_color`;

CREATE TABLE `spu_color` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `spu_id` bigint(20) DEFAULT NULL COMMENT '商品id',
  `color` varchar(100) DEFAULT NULL COMMENT '商品颜色',
  `file_name` varchar(100) DEFAULT NULL COMMENT '文件名',
  `is_enabled` varchar(1) DEFAULT NULL COMMENT '是否启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品颜色表';

/*Data for the table `spu_color` */

/*Table structure for table `spu_image` */

DROP TABLE IF EXISTS `spu_image`;

CREATE TABLE `spu_image` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `spu_id` bigint(20) DEFAULT NULL COMMENT '商品id',
  `img_name` varchar(200) DEFAULT NULL COMMENT '图片名称',
  `img_url` varchar(200) DEFAULT NULL COMMENT '图片路径',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='商品图片表';

/*Data for the table `spu_image` */

insert  into `spu_image`(`id`,`spu_id`,`img_name`,`img_url`) values (1,2,'3db25041dae7f7c824ccb688529e679b91eb650817f1dc9b13bb035499b25651.jpg','http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWECAeksVAAbIYscxeNI211.jpg'),(2,2,'14f137f059a3d619675995bf8dc2b391e40a17f3dcdc3c93f6d3d2df7f9597c9.jpg','http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAdZshAAcJ0rsVBLk251.jpg'),(3,2,'6445e151fb1c30435b54397eaf3255a8f621e778c63b75659b8e5dbdc6d6e9e2.jpg','http://192.168.32.63:8888/group1/M00/00/00/wKggP10fWEGAUj1mAAaxLEvPfSU117.jpg'),(4,3,'a611ac8754ea012d408b8b59cd0a2b78.jpg','http://192.168.32.63:8888/group1/M00/00/00/wKggP10mUqiAEQW1AAGPyjK_NgM088.jpg'),(5,3,'878d184ff86288e487fc60aa44211117.jpg','http://192.168.32.63:8888/group1/M00/00/00/wKggP10mUqiACN7UAAdjjnBLXjQ326.jpg'),(6,3,'cba5a5a986a305ce00f0981aebb75ef0.jpg','http://192.168.32.63:8888/group1/M00/00/00/wKggP10mUqiAZxsMAANTeOT4yy8692.jpg'),(7,3,'35a2be726a4631ede623fd5264b9f0e8751d4bbe50ea20862a4dd918ba48df48.jpg','http://192.168.32.63:8888/group1/M00/00/00/wKggP10mUqiAHTYqAAPCUl3D4Yo727.jpg');

/*Table structure for table `spu_info` */

DROP TABLE IF EXISTS `spu_info`;

CREATE TABLE `spu_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `spu_name` varchar(200) DEFAULT NULL COMMENT '商品名称',
  `description` varchar(1000) DEFAULT NULL COMMENT '商品描述(后台简述）',
  `catalog3_id` bigint(20) DEFAULT NULL COMMENT '三级分类id',
  `tm_id` bigint(20) DEFAULT NULL COMMENT '品牌id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Data for the table `spu_info` */

insert  into `spu_info`(`id`,`spu_name`,`description`,`catalog3_id`,`tm_id`) values (1,'创维液晶电视01','超薄超快的电视',5,NULL),(2,'创维电视test001','创维电视test001创维电视test001创维电视test001',5,NULL);

/*Table structure for table `spu_poster` */

DROP TABLE IF EXISTS `spu_poster`;

CREATE TABLE `spu_poster` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `spu_id` bigint(20) DEFAULT NULL COMMENT '商品id',
  `file_name` varchar(200) DEFAULT NULL COMMENT '文件名称',
  `file_type` varchar(200) DEFAULT NULL COMMENT '文件类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品海报表';

/*Data for the table `spu_poster` */

/*Table structure for table `spu_sale_attr` */

DROP TABLE IF EXISTS `spu_sale_attr`;

CREATE TABLE `spu_sale_attr` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `spu_id` bigint(20) DEFAULT NULL COMMENT '商品id',
  `sale_attr_id` bigint(20) DEFAULT NULL COMMENT '销售属性id',
  `sale_attr_name` varchar(20) DEFAULT NULL COMMENT '销售属性名称(冗余)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Data for the table `spu_sale_attr` */

insert  into `spu_sale_attr`(`id`,`spu_id`,`sale_attr_id`,`sale_attr_name`) values (1,2,1,'颜色'),(2,2,2,'尺寸'),(3,3,1,'颜色'),(4,3,3,'版本');

/*Table structure for table `spu_sale_attr_value` */

DROP TABLE IF EXISTS `spu_sale_attr_value`;

CREATE TABLE `spu_sale_attr_value` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `spu_id` bigint(20) DEFAULT NULL COMMENT '商品id',
  `sale_attr_id` bigint(20) DEFAULT NULL COMMENT '销售属性id',
  `sale_attr_value_name` varchar(20) DEFAULT NULL COMMENT '销售属性值名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='spu销售属性值';

/*Data for the table `spu_sale_attr_value` */

insert  into `spu_sale_attr_value`(`id`,`spu_id`,`sale_attr_id`,`sale_attr_value_name`) values (1,2,1,'黑色'),(2,2,1,'红色'),(3,2,2,'50寸'),(4,2,2,'70寸'),(5,3,1,'绿色'),(6,3,3,'美版'),(7,3,3,'国行'),(8,3,3,'日版');

/*Table structure for table `spu_size` */

DROP TABLE IF EXISTS `spu_size`;

CREATE TABLE `spu_size` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `spu_id` bigint(20) DEFAULT NULL COMMENT '商品id',
  `spu_size` varchar(100) DEFAULT NULL COMMENT '商品尺寸',
  `is_enabled` varchar(1) DEFAULT NULL COMMENT '是否启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品尺寸表';

/*Data for the table `spu_size` */

/*Table structure for table `spu_version` */

DROP TABLE IF EXISTS `spu_version`;

CREATE TABLE `spu_version` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `spu_id` bigint(20) DEFAULT NULL COMMENT '商品id',
  `spu_version` varchar(100) DEFAULT NULL COMMENT '商品版本',
  `is_enabled` varchar(1) DEFAULT NULL COMMENT '是否启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品版本表';

/*Data for the table `spu_version` */

/*Table structure for table `user_address` */

DROP TABLE IF EXISTS `user_address`;

CREATE TABLE `user_address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_address` varchar(500) DEFAULT NULL COMMENT '用户地址',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  `consignee` varchar(40) DEFAULT NULL COMMENT '收件人',
  `phone_num` varchar(40) DEFAULT NULL COMMENT '联系方式',
  `is_default` varchar(1) DEFAULT NULL COMMENT '是否是默认',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='用户地址表';

/*Data for the table `user_address` */

insert  into `user_address`(`id`,`user_address`,`user_id`,`consignee`,`phone_num`,`is_default`) values (1,'北京市',4,'张无忌','18888888888','1');

/*Table structure for table `user_details` */

DROP TABLE IF EXISTS `user_details`;

CREATE TABLE `user_details` (
  `id` bigint(20) NOT NULL COMMENT '编号',
  `id_card` bigint(20) DEFAULT NULL COMMENT '身份证编号',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户',
  `user_phone` varchar(100) DEFAULT NULL COMMENT '用户手机号',
  `hometown` varchar(200) DEFAULT NULL COMMENT '用户籍贯',
  `address_id` bigint(20) DEFAULT NULL COMMENT '用户住址',
  `sex` varchar(1) DEFAULT NULL COMMENT '0女1男',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户帐户信息表';

/*Data for the table `user_details` */

/*Table structure for table `user_info` */

DROP TABLE IF EXISTS `user_info`;

CREATE TABLE `user_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `login_name` varchar(200) DEFAULT NULL COMMENT '用户名称',
  `nick_name` varchar(200) DEFAULT NULL COMMENT '用户昵称',
  `passwd` varchar(200) DEFAULT NULL COMMENT '用户密码',
  `name` varchar(200) DEFAULT NULL COMMENT '用户姓名',
  `phone_num` varchar(200) DEFAULT NULL COMMENT '手机号',
  `email` varchar(200) DEFAULT NULL COMMENT '邮箱',
  `head_img` varchar(200) DEFAULT NULL COMMENT '头像',
  `user_level` varchar(200) DEFAULT '''1''' COMMENT '用户级别',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='用户表';

/*Data for the table `user_info` */

insert  into `user_info`(`id`,`login_name`,`nick_name`,`passwd`,`name`,`phone_num`,`email`,`head_img`,`user_level`) values (4,'zhangwuji','无忌','123123','张无忌','18888888888','aa@123.com',NULL,'\'1\''),(5,'linghuchong','冲冲','453453','令狐冲','17777777777','bb@123.com',NULL,'\'1\'');

/*Table structure for table `ware_info` */

DROP TABLE IF EXISTS `ware_info`;

CREATE TABLE `ware_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `areacode` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Data for the table `ware_info` */

insert  into `ware_info`(`id`,`name`,`address`,`areacode`) values (1,'北京朝阳仓库1','朝阳区','001'),(2,'北京大兴仓库2','大兴','002');

/*Table structure for table `ware_order_task` */

DROP TABLE IF EXISTS `ware_order_task`;

CREATE TABLE `ware_order_task` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `order_id` bigint(20) DEFAULT NULL COMMENT '订单编号',
  `consignee` varchar(100) DEFAULT NULL COMMENT '收货人',
  `consignee_tel` varchar(20) DEFAULT NULL COMMENT '收货人电话',
  `delivery_address` varchar(1000) DEFAULT NULL COMMENT '送货地址',
  `order_comment` varchar(200) DEFAULT NULL COMMENT '订单备注',
  `payment_way` varchar(2) DEFAULT NULL COMMENT '付款方式 1:在线付款 2:货到付款',
  `task_status` varchar(20) DEFAULT NULL,
  `order_body` varchar(200) DEFAULT NULL COMMENT '订单描述',
  `tracking_no` varchar(200) DEFAULT NULL COMMENT '物流单号',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `ware_id` bigint(20) DEFAULT NULL COMMENT '仓库编号',
  `task_comment` varchar(500) DEFAULT NULL COMMENT '工作单备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='库存工作单表 库存工作单表';

/*Data for the table `ware_order_task` */

insert  into `ware_order_task`(`id`,`order_id`,`consignee`,`consignee_tel`,`delivery_address`,`order_comment`,`payment_way`,`task_status`,`order_body`,`tracking_no`,`create_time`,`ware_id`,`task_comment`) values (1,15,'测试收件人','13123123123123','测试收件地址',NULL,NULL,'PAID',NULL,NULL,'2019-07-17 19:20:22',NULL,NULL),(2,16,'测试收件人','13123123123123','测试收件地址',NULL,NULL,'PAID',NULL,NULL,'2019-07-17 19:26:54',NULL,NULL),(3,17,'测试收件人','13123123123123','测试收件地址',NULL,NULL,'DEDUCTED',NULL,NULL,'2019-07-17 19:40:09',NULL,NULL);

/*Table structure for table `ware_order_task_detail` */

DROP TABLE IF EXISTS `ware_order_task_detail`;

CREATE TABLE `ware_order_task_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `sku_id` bigint(20) DEFAULT NULL COMMENT 'sku_id',
  `sku_name` varchar(200) DEFAULT NULL COMMENT 'sku名称',
  `sku_nums` int(11) DEFAULT NULL COMMENT '购买个数',
  `task_id` bigint(20) DEFAULT NULL COMMENT '工作单编号',
  `sku_num` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `ware_order_task_detail` */

insert  into `ware_order_task_detail`(`id`,`sku_id`,`sku_name`,`sku_nums`,`task_id`,`sku_num`) values (1,2,'创维电视test001-sku01',NULL,1,1),(2,2,'创维电视test001-sku01',NULL,2,1),(3,2,'创维电视test001-sku01',NULL,3,1);

/*Table structure for table `ware_sku` */

DROP TABLE IF EXISTS `ware_sku`;

CREATE TABLE `ware_sku` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `sku_id` bigint(20) DEFAULT NULL COMMENT 'skuid',
  `warehouse_id` bigint(20) DEFAULT NULL COMMENT '仓库id',
  `stock` int(11) DEFAULT NULL COMMENT '库存数',
  `stock_name` varchar(200) DEFAULT NULL COMMENT '存货名称',
  `stock_locked` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_skuid` (`sku_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Data for the table `ware_sku` */

insert  into `ware_sku`(`id`,`sku_id`,`warehouse_id`,`stock`,`stock_name`,`stock_locked`) values (1,2,1,100,'创维test01-sku001',1),(2,3,2,200,'创维电视test001-sku02',NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
