/*
Navicat MySQL Data Transfer

Source Server         : ly
Source Server Version : 50557
Source Host           : localhost:3306
Source Database       : game

Target Server Type    : MYSQL
Target Server Version : 50557
File Encoding         : 65001

Date: 2017-12-24 12:54:54
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for treasure
-- ----------------------------
DROP TABLE IF EXISTS `treasure`;
CREATE TABLE `treasure` (
  `uid` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `level` tinyint(1) NOT NULL DEFAULT '1' COMMENT '关卡',
  `left_brick` tinyint(1) NOT NULL COMMENT '剩余金砖',
  `score` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
