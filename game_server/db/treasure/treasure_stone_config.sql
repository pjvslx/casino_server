/*
Navicat MySQL Data Transfer

Source Server         : ly
Source Server Version : 50557
Source Host           : localhost:3306
Source Database       : game

Target Server Type    : MYSQL
Target Server Version : 50557
File Encoding         : 65001

Date: 2017-09-17 14:42:42
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for treasure_stone_config
-- ----------------------------
DROP TABLE IF EXISTS `treasure_stone_config`;
CREATE TABLE `treasure_stone_config` (
  `stone_id` tinyint(1) NOT NULL DEFAULT '0' COMMENT '石头ID',
  `description` varchar(50) NOT NULL COMMENT '石头名字',
  PRIMARY KEY (`stone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of treasure_stone_config
-- ----------------------------
INSERT INTO `treasure_stone_config` VALUES ('1', '白玉');
INSERT INTO `treasure_stone_config` VALUES ('2', '碧玉');
INSERT INTO `treasure_stone_config` VALUES ('3', '墨玉');
INSERT INTO `treasure_stone_config` VALUES ('4', '玛瑙');
INSERT INTO `treasure_stone_config` VALUES ('5', '琥珀');
INSERT INTO `treasure_stone_config` VALUES ('6', '祖母绿');
INSERT INTO `treasure_stone_config` VALUES ('7', '猫眼石');
INSERT INTO `treasure_stone_config` VALUES ('8', '紫宝石');
INSERT INTO `treasure_stone_config` VALUES ('9', '翡翠');
INSERT INTO `treasure_stone_config` VALUES ('10', '珍珠');
INSERT INTO `treasure_stone_config` VALUES ('11', '红宝石');
INSERT INTO `treasure_stone_config` VALUES ('12', '绿宝石');
INSERT INTO `treasure_stone_config` VALUES ('13', '黄宝石');
INSERT INTO `treasure_stone_config` VALUES ('14', '蓝宝石');
INSERT INTO `treasure_stone_config` VALUES ('15', '钻石');
