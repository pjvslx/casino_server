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
DROP TABLE IF EXISTS `treasure`;
CREATE TABLE `treasure_stone_config` (
  `id`  bigint(20) UNSIGNED NOT NULL COMMENT '用户ID' ,
  `level` tinyint(1) NOT NULL DEFAULT '1' COMMENT '关卡',
  `left_brick` tinyint(1) NOT NULL COMMENT '剩余金砖',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
