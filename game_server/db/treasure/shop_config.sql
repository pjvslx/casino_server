/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50557
Source Host           : localhost:3306
Source Database       : game

Target Server Type    : MYSQL
Target Server Version : 50557
File Encoding         : 65001

Date: 2018-02-05 21:27:18
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for shop_config
-- ----------------------------
DROP TABLE IF EXISTS `shop_config`;
CREATE TABLE `shop_config` (
  `id` int(10) unsigned NOT NULL COMMENT '记录ID',
  `provider` varchar(20) NOT NULL,
  `prop_id` int(3) unsigned NOT NULL COMMENT '道具属性ID',
  `shop_id` varchar(20) NOT NULL COMMENT 'db',
  `game_item_id` varchar(50) NOT NULL COMMENT '内部用ID',
  `item_name` varchar(50) NOT NULL COMMENT '道具名字',
  `price_value` int(10) unsigned NOT NULL COMMENT '价格值',
  `price_unit` int(1) unsigned NOT NULL COMMENT '价格单位1：元 2：角 3：分',
  `prop_quantity` int(10) unsigned NOT NULL COMMENT '购买数量',
  `prop_gift_quantity` int(10) unsigned NOT NULL COMMENT '赠送的数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of shop_config
-- ----------------------------
INSERT INTO `shop_config` VALUES ('1', '1', '1', 'db', 'db.alipay.gold.01', '6元礼包', '6', '1', '6000', '0');
INSERT INTO `shop_config` VALUES ('2', '1', '1', 'db', 'db.alipay.gold.02', '12元礼包', '12', '1', '12000', '0');
INSERT INTO `shop_config` VALUES ('3', '1', '1', 'db', 'db.alipay.gold.03', '30元礼包', '30', '1', '30000', '0');
INSERT INTO `shop_config` VALUES ('4', '1', '1', 'db', 'db.alipay.gold.04', '98元礼包', '98', '1', '98000', '0');
INSERT INTO `shop_config` VALUES ('5', '1', '1', 'db', 'db.alipay.gold.05', '298元礼包', '298', '1', '298000', '0');
INSERT INTO `shop_config` VALUES ('6', '1', '1', 'db', 'db.alipay.gold06', '998元礼包', '998', '1', '998000', '0');
