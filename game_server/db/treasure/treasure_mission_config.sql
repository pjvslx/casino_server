/*
Navicat MySQL Data Transfer

Source Server         : ly
Source Server Version : 50557
Source Host           : localhost:3306
Source Database       : game

Target Server Type    : MYSQL
Target Server Version : 50557
File Encoding         : 65001

Date: 2017-09-17 16:43:06
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for treasure_mission_config
-- ----------------------------
DROP TABLE IF EXISTS `treasure_mission_config`;
CREATE TABLE `treasure_mission_config` (
  `stone_id` tinyint(1) NOT NULL DEFAULT '0' COMMENT '石头ID',
  `line_num` tinyint(1) NOT NULL DEFAULT '10' COMMENT '相连数',
  `odds_factor` float NOT NULL DEFAULT '0' COMMENT '赔率',
  `mission` tinyint(1) NOT NULL DEFAULT '1' COMMENT '关卡等级',
  `is_crit` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of treasure_mission_config  level1
-- ----------------------------
INSERT INTO `treasure_mission_config` VALUES ('1', '4', '0.2', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('1', '5', '0.4', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('1', '6', '0.5', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('1', '7', '0.8', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('1', '8', '1', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('1', '9', '2', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('1', '10', '3', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('1', '11', '5', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('1', '12', '10', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('1', '13', '20', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('1', '14', '40', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('1', '15', '40', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('1', '16', '0', '1', '1');

INSERT INTO `treasure_mission_config` VALUES ('2', '4', '0.4', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('2', '5', '0.5', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('2', '6', '1', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('2', '7', '2', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('2', '8', '3', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('2', '9', '5', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('2', '10', '10', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('2', '11', '25', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('2', '12', '50', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('2', '13', '75', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('2', '14', '80', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('2', '15', '80', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('2', '16', '0', '1', '1');

INSERT INTO `treasure_mission_config` VALUES ('3', '4', '0.5', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('3', '5', '1', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('3', '6', '2', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('3', '7', '4', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('3', '8', '8', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('3', '9', '16', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('3', '10', '50', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('3', '11', '100', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('3', '12', '200', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('3', '13', '500', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('3', '14', '600', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('3', '15', '600', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('3', '16', '0', '1', '1');

INSERT INTO `treasure_mission_config` VALUES ('4', '4', '1', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('4', '5', '3', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('4', '6', '5', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('4', '7', '6', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('4', '8', '10', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('4', '9', '75', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('4', '10', '100', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('4', '11', '1000', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('4', '12', '2000', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('4', '13', '5000', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('4', '14', '6000', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('4', '15', '6000', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('4', '16', '0', '1', '1');

INSERT INTO `treasure_mission_config` VALUES ('5', '4', '2', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('5', '5', '5', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('5', '6', '10', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('5', '7', '50', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('5', '8', '100', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('5', '9', '200', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('5', '10', '500', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('5', '11', '2000', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('5', '12', '5000', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('5', '13', '6000', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('5', '14', '8000', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('5', '15', '8000', '1', '0');
INSERT INTO `treasure_mission_config` VALUES ('5', '16', '0', '1', '1');

-- ----------------------------
-- Records of treasure_mission_config  level2
-- ----------------------------
INSERT INTO `treasure_mission_config` VALUES ('6', '5', '0.2', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '6', '0.4', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '7', '0.5', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '8', '0.8', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '9', '1', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '10', '2', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '11', '3', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '12', '5', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '13', '10', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '14', '20', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '15', '45', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '16', '45', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '17', '45', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '18', '45', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '19', '45', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('6', '20', '0', '2', '1');

INSERT INTO `treasure_mission_config` VALUES ('7', '5', '0.4', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '6', '0.5', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '7', '1', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '8', '2', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '9', '3', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '10', '5', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '11', '10', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '12', '25', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '13', '50', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '14', '75', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '15', '100', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '16', '100', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '17', '100', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '18', '100', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '19', '100', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('7', '20', '0', '2', '1');

INSERT INTO `treasure_mission_config` VALUES ('8', '5', '0.5', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '6', '1', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '7', '2', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '8', '4', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '9', '8', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '10', '16', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '11', '50', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '12', '100', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '13', '200', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '14', '500', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '15', '700', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '16', '700', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '17', '700', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '18', '700', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '19', '700', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('8', '20', '0', '2', '1');

INSERT INTO `treasure_mission_config` VALUES ('9', '5', '1', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '6', '3', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '7', '5', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '8', '6', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '9', '10', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '10', '75', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '11', '100', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '12', '1000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '13', '2000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '14', '5000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '15', '7000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '16', '7000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '17', '7000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '18', '7000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '19', '7000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('9', '20', '0', '2', '1');

INSERT INTO `treasure_mission_config` VALUES ('10', '5', '2', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '6', '5', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '7', '10', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '8', '50', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '9', '100', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '10', '200', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '11', '500', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '12', '2000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '13', '5000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '14', '8000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '15', '10000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '16', '10000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '17', '10000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '18', '10000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '19', '10000', '2', '0');
INSERT INTO `treasure_mission_config` VALUES ('10', '20', '0', '2', '1');

-- ----------------------------
-- Records of treasure_mission_config  level3
-- ----------------------------
INSERT INTO `treasure_mission_config` VALUES ('11', '6', '0.2', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '7', '0.4', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '8', '0.5', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '9', '0.8', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '10', '1', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '11', '2', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '12', '3', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '13', '5', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '14', '10', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '15', '20', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '16', '50', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '17', '50', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '18', '50', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '19', '50', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '20', '50', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '21', '50', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '22', '50', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '23', '50', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('11', '24', '0', '3', '1');

INSERT INTO `treasure_mission_config` VALUES ('12', '6', '0.4', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '7', '0.5', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '8', '1', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '9', '2', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '10', '3', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '11', '5', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '12', '10', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '13', '25', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '14', '50', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '15', '75', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '16', '120', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '17', '120', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '18', '120', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '19', '120', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '20', '120', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '21', '120', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '22', '120', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '23', '120', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('12', '24', '0', '3', '1');

INSERT INTO `treasure_mission_config` VALUES ('13', '6', '0.5', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '7', '1', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '8', '2', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '9', '4', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '10', '8', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '11', '16', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '12', '50', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '13', '100', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '14', '200', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '15', '500', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '16', '800', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '17', '800', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '18', '800', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '19', '800', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '20', '800', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '21', '800', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '22', '800', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '23', '800', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('13', '24', '0', '3', '1');

INSERT INTO `treasure_mission_config` VALUES ('14', '6', '1', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '7', '3', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '8', '5', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '9', '6', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '10', '10', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '11', '75', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '12', '100', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '13', '1000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '14', '2000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '15', '5000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '16', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '17', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '18', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '19', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '20', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '21', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '22', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '23', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('14', '24', '0', '3', '1');

INSERT INTO `treasure_mission_config` VALUES ('15', '6', '1', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '7', '3', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '8', '5', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '9', '6', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '10', '10', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '11', '75', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '12', '100', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '13', '1000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '14', '2000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '15', '5000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '16', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '17', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '18', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '19', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '20', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '21', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '22', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '23', '8000', '3', '0');
INSERT INTO `treasure_mission_config` VALUES ('15', '24', '0', '3', '1');