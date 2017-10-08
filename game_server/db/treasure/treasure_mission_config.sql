/*
Navicat MySQL Data Transfer

Source Server         : ly
Source Server Version : 50557
Source Host           : localhost:3306
Source Database       : game

Target Server Type    : MYSQL
Target Server Version : 50557
File Encoding         : 65001

Date: 2017-09-20 21:32:22
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
  `is_crit` tinyint(1) NOT NULL DEFAULT '0',
  `cid` int(1) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB AUTO_INCREMENT=241 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of treasure_mission_config
-- ----------------------------
INSERT INTO `treasure_mission_config` VALUES ('1', '4', '20', '1', '0', '1');
INSERT INTO `treasure_mission_config` VALUES ('1', '5', '40', '1', '0', '2');
INSERT INTO `treasure_mission_config` VALUES ('1', '6', '50', '1', '0', '3');
INSERT INTO `treasure_mission_config` VALUES ('1', '7', '80', '1', '0', '4');
INSERT INTO `treasure_mission_config` VALUES ('1', '8', '100', '1', '0', '5');
INSERT INTO `treasure_mission_config` VALUES ('1', '9', '200', '1', '0', '6');
INSERT INTO `treasure_mission_config` VALUES ('1', '10', '300', '1', '0', '7');
INSERT INTO `treasure_mission_config` VALUES ('1', '11', '500', '1', '0', '8');
INSERT INTO `treasure_mission_config` VALUES ('1', '12', '1000', '1', '0', '9');
INSERT INTO `treasure_mission_config` VALUES ('1', '13', '2000', '1', '0', '10');
INSERT INTO `treasure_mission_config` VALUES ('1', '14', '4000', '1', '0', '11');
INSERT INTO `treasure_mission_config` VALUES ('1', '15', '4000', '1', '0', '12');
INSERT INTO `treasure_mission_config` VALUES ('1', '16', '0', '1', '1', '13');
INSERT INTO `treasure_mission_config` VALUES ('2', '4', '40', '1', '0', '14');
INSERT INTO `treasure_mission_config` VALUES ('2', '5', '50', '1', '0', '15');
INSERT INTO `treasure_mission_config` VALUES ('2', '6', '100', '1', '0', '16');
INSERT INTO `treasure_mission_config` VALUES ('2', '7', '200', '1', '0', '17');
INSERT INTO `treasure_mission_config` VALUES ('2', '8', '300', '1', '0', '18');
INSERT INTO `treasure_mission_config` VALUES ('2', '9', '500', '1', '0', '19');
INSERT INTO `treasure_mission_config` VALUES ('2', '10', '1000', '1', '0', '20');
INSERT INTO `treasure_mission_config` VALUES ('2', '11', '2500', '1', '0', '21');
INSERT INTO `treasure_mission_config` VALUES ('2', '12', '5000', '1', '0', '22');
INSERT INTO `treasure_mission_config` VALUES ('2', '13', '7500', '1', '0', '23');
INSERT INTO `treasure_mission_config` VALUES ('2', '14', '8000', '1', '0', '24');
INSERT INTO `treasure_mission_config` VALUES ('2', '15', '8000', '1', '0', '25');
INSERT INTO `treasure_mission_config` VALUES ('2', '16', '0', '1', '1', '26');
INSERT INTO `treasure_mission_config` VALUES ('3', '4', '50', '1', '0', '27');
INSERT INTO `treasure_mission_config` VALUES ('3', '5', '100', '1', '0', '28');
INSERT INTO `treasure_mission_config` VALUES ('3', '6', '200', '1', '0', '29');
INSERT INTO `treasure_mission_config` VALUES ('3', '7', '400', '1', '0', '30');
INSERT INTO `treasure_mission_config` VALUES ('3', '8', '800', '1', '0', '31');
INSERT INTO `treasure_mission_config` VALUES ('3', '9', '1600', '1', '0', '32');
INSERT INTO `treasure_mission_config` VALUES ('3', '10', '5000', '1', '0', '33');
INSERT INTO `treasure_mission_config` VALUES ('3', '11', '10000', '1', '0', '34');
INSERT INTO `treasure_mission_config` VALUES ('3', '12', '20000', '1', '0', '35');
INSERT INTO `treasure_mission_config` VALUES ('3', '13', '50000', '1', '0', '36');
INSERT INTO `treasure_mission_config` VALUES ('3', '14', '60000', '1', '0', '37');
INSERT INTO `treasure_mission_config` VALUES ('3', '15', '60000', '1', '0', '38');
INSERT INTO `treasure_mission_config` VALUES ('3', '16', '0', '1', '1', '39');
INSERT INTO `treasure_mission_config` VALUES ('4', '4', '100', '1', '0', '40');
INSERT INTO `treasure_mission_config` VALUES ('4', '5', '300', '1', '0', '41');
INSERT INTO `treasure_mission_config` VALUES ('4', '6', '500', '1', '0', '42');
INSERT INTO `treasure_mission_config` VALUES ('4', '7', '600', '1', '0', '43');
INSERT INTO `treasure_mission_config` VALUES ('4', '8', '1000', '1', '0', '44');
INSERT INTO `treasure_mission_config` VALUES ('4', '9', '7500', '1', '0', '45');
INSERT INTO `treasure_mission_config` VALUES ('4', '10', '10000', '1', '0', '46');
INSERT INTO `treasure_mission_config` VALUES ('4', '11', '100000', '1', '0', '47');
INSERT INTO `treasure_mission_config` VALUES ('4', '12', '200000', '1', '0', '48');
INSERT INTO `treasure_mission_config` VALUES ('4', '13', '500000', '1', '0', '49');
INSERT INTO `treasure_mission_config` VALUES ('4', '14', '600000', '1', '0', '50');
INSERT INTO `treasure_mission_config` VALUES ('4', '15', '600000', '1', '0', '51');
INSERT INTO `treasure_mission_config` VALUES ('4', '16', '0', '1', '1', '52');
INSERT INTO `treasure_mission_config` VALUES ('5', '4', '200', '1', '0', '53');
INSERT INTO `treasure_mission_config` VALUES ('5', '5', '500', '1', '0', '54');
INSERT INTO `treasure_mission_config` VALUES ('5', '6', '1000', '1', '0', '55');
INSERT INTO `treasure_mission_config` VALUES ('5', '7', '5000', '1', '0', '56');
INSERT INTO `treasure_mission_config` VALUES ('5', '8', '10000', '1', '0', '57');
INSERT INTO `treasure_mission_config` VALUES ('5', '9', '20000', '1', '0', '58');
INSERT INTO `treasure_mission_config` VALUES ('5', '10', '50000', '1', '0', '59');
INSERT INTO `treasure_mission_config` VALUES ('5', '11', '200000', '1', '0', '60');
INSERT INTO `treasure_mission_config` VALUES ('5', '12', '500000', '1', '0', '61');
INSERT INTO `treasure_mission_config` VALUES ('5', '13', '600000', '1', '0', '62');
INSERT INTO `treasure_mission_config` VALUES ('5', '14', '800000', '1', '0', '63');
INSERT INTO `treasure_mission_config` VALUES ('5', '15', '800000', '1', '0', '64');
INSERT INTO `treasure_mission_config` VALUES ('5', '16', '0', '1', '1', '65');
INSERT INTO `treasure_mission_config` VALUES ('6', '5', '20', '2', '0', '66');
INSERT INTO `treasure_mission_config` VALUES ('6', '6', '40', '2', '0', '67');
INSERT INTO `treasure_mission_config` VALUES ('6', '7', '50', '2', '0', '68');
INSERT INTO `treasure_mission_config` VALUES ('6', '8', '80', '2', '0', '69');
INSERT INTO `treasure_mission_config` VALUES ('6', '9', '100', '2', '0', '70');
INSERT INTO `treasure_mission_config` VALUES ('6', '10', '200', '2', '0', '71');
INSERT INTO `treasure_mission_config` VALUES ('6', '11', '300', '2', '0', '72');
INSERT INTO `treasure_mission_config` VALUES ('6', '12', '500', '2', '0', '73');
INSERT INTO `treasure_mission_config` VALUES ('6', '13', '1000', '2', '0', '74');
INSERT INTO `treasure_mission_config` VALUES ('6', '14', '2000', '2', '0', '75');
INSERT INTO `treasure_mission_config` VALUES ('6', '15', '4500', '2', '0', '76');
INSERT INTO `treasure_mission_config` VALUES ('6', '16', '4500', '2', '0', '77');
INSERT INTO `treasure_mission_config` VALUES ('6', '17', '4500', '2', '0', '78');
INSERT INTO `treasure_mission_config` VALUES ('6', '18', '4500', '2', '0', '79');
INSERT INTO `treasure_mission_config` VALUES ('6', '19', '4500', '2', '0', '80');
INSERT INTO `treasure_mission_config` VALUES ('6', '20', '0', '2', '1', '81');
INSERT INTO `treasure_mission_config` VALUES ('7', '5', '40', '2', '0', '82');
INSERT INTO `treasure_mission_config` VALUES ('7', '6', '50', '2', '0', '83');
INSERT INTO `treasure_mission_config` VALUES ('7', '7', '100', '2', '0', '84');
INSERT INTO `treasure_mission_config` VALUES ('7', '8', '200', '2', '0', '85');
INSERT INTO `treasure_mission_config` VALUES ('7', '9', '300', '2', '0', '86');
INSERT INTO `treasure_mission_config` VALUES ('7', '10', '500', '2', '0', '87');
INSERT INTO `treasure_mission_config` VALUES ('7', '11', '1000', '2', '0', '88');
INSERT INTO `treasure_mission_config` VALUES ('7', '12', '2500', '2', '0', '89');
INSERT INTO `treasure_mission_config` VALUES ('7', '13', '5000', '2', '0', '90');
INSERT INTO `treasure_mission_config` VALUES ('7', '14', '7500', '2', '0', '91');
INSERT INTO `treasure_mission_config` VALUES ('7', '15', '10000', '2', '0', '92');
INSERT INTO `treasure_mission_config` VALUES ('7', '16', '10000', '2', '0', '93');
INSERT INTO `treasure_mission_config` VALUES ('7', '17', '10000', '2', '0', '94');
INSERT INTO `treasure_mission_config` VALUES ('7', '18', '10000', '2', '0', '95');
INSERT INTO `treasure_mission_config` VALUES ('7', '19', '10000', '2', '0', '96');
INSERT INTO `treasure_mission_config` VALUES ('7', '20', '0', '2', '1', '97');
INSERT INTO `treasure_mission_config` VALUES ('8', '5', '50', '2', '0', '98');
INSERT INTO `treasure_mission_config` VALUES ('8', '6', '100', '2', '0', '99');
INSERT INTO `treasure_mission_config` VALUES ('8', '7', '200', '2', '0', '100');
INSERT INTO `treasure_mission_config` VALUES ('8', '8', '400', '2', '0', '101');
INSERT INTO `treasure_mission_config` VALUES ('8', '9', '800', '2', '0', '102');
INSERT INTO `treasure_mission_config` VALUES ('8', '10', '1600', '2', '0', '103');
INSERT INTO `treasure_mission_config` VALUES ('8', '11', '5000', '2', '0', '104');
INSERT INTO `treasure_mission_config` VALUES ('8', '12', '10000', '2', '0', '105');
INSERT INTO `treasure_mission_config` VALUES ('8', '13', '20000', '2', '0', '106');
INSERT INTO `treasure_mission_config` VALUES ('8', '14', '50000', '2', '0', '107');
INSERT INTO `treasure_mission_config` VALUES ('8', '15', '70000', '2', '0', '108');
INSERT INTO `treasure_mission_config` VALUES ('8', '16', '70000', '2', '0', '109');
INSERT INTO `treasure_mission_config` VALUES ('8', '17', '70000', '2', '0', '110');
INSERT INTO `treasure_mission_config` VALUES ('8', '18', '70000', '2', '0', '111');
INSERT INTO `treasure_mission_config` VALUES ('8', '19', '70000', '2', '0', '112');
INSERT INTO `treasure_mission_config` VALUES ('8', '20', '0', '2', '1', '113');
INSERT INTO `treasure_mission_config` VALUES ('9', '5', '100', '2', '0', '114');
INSERT INTO `treasure_mission_config` VALUES ('9', '6', '300', '2', '0', '115');
INSERT INTO `treasure_mission_config` VALUES ('9', '7', '500', '2', '0', '116');
INSERT INTO `treasure_mission_config` VALUES ('9', '8', '600', '2', '0', '117');
INSERT INTO `treasure_mission_config` VALUES ('9', '9', '1000', '2', '0', '118');
INSERT INTO `treasure_mission_config` VALUES ('9', '10', '7500', '2', '0', '119');
INSERT INTO `treasure_mission_config` VALUES ('9', '11', '10000', '2', '0', '120');
INSERT INTO `treasure_mission_config` VALUES ('9', '12', '100000', '2', '0', '121');
INSERT INTO `treasure_mission_config` VALUES ('9', '13', '200000', '2', '0', '122');
INSERT INTO `treasure_mission_config` VALUES ('9', '14', '500000', '2', '0', '123');
INSERT INTO `treasure_mission_config` VALUES ('9', '15', '700000', '2', '0', '124');
INSERT INTO `treasure_mission_config` VALUES ('9', '16', '700000', '2', '0', '125');
INSERT INTO `treasure_mission_config` VALUES ('9', '17', '700000', '2', '0', '126');
INSERT INTO `treasure_mission_config` VALUES ('9', '18', '700000', '2', '0', '127');
INSERT INTO `treasure_mission_config` VALUES ('9', '19', '700000', '2', '0', '128');
INSERT INTO `treasure_mission_config` VALUES ('9', '20', '0', '2', '1', '129');
INSERT INTO `treasure_mission_config` VALUES ('10', '5', '200', '2', '0', '130');
INSERT INTO `treasure_mission_config` VALUES ('10', '6', '500', '2', '0', '131');
INSERT INTO `treasure_mission_config` VALUES ('10', '7', '1000', '2', '0', '132');
INSERT INTO `treasure_mission_config` VALUES ('10', '8', '5000', '2', '0', '133');
INSERT INTO `treasure_mission_config` VALUES ('10', '9', '10000', '2', '0', '134');
INSERT INTO `treasure_mission_config` VALUES ('10', '10', '20000', '2', '0', '135');
INSERT INTO `treasure_mission_config` VALUES ('10', '11', '50000', '2', '0', '136');
INSERT INTO `treasure_mission_config` VALUES ('10', '12', '200000', '2', '0', '137');
INSERT INTO `treasure_mission_config` VALUES ('10', '13', '500000', '2', '0', '138');
INSERT INTO `treasure_mission_config` VALUES ('10', '14', '800000', '2', '0', '139');
INSERT INTO `treasure_mission_config` VALUES ('10', '15', '1000000', '2', '0', '140');
INSERT INTO `treasure_mission_config` VALUES ('10', '16', '1000000', '2', '0', '141');
INSERT INTO `treasure_mission_config` VALUES ('10', '17', '1000000', '2', '0', '142');
INSERT INTO `treasure_mission_config` VALUES ('10', '18', '1000000', '2', '0', '143');
INSERT INTO `treasure_mission_config` VALUES ('10', '19', '1000000', '2', '0', '144');
INSERT INTO `treasure_mission_config` VALUES ('10', '20', '0', '2', '1', '145');
INSERT INTO `treasure_mission_config` VALUES ('11', '6', '20', '3', '0', '146');
INSERT INTO `treasure_mission_config` VALUES ('11', '7', '40', '3', '0', '147');
INSERT INTO `treasure_mission_config` VALUES ('11', '8', '50', '3', '0', '148');
INSERT INTO `treasure_mission_config` VALUES ('11', '9', '80', '3', '0', '149');
INSERT INTO `treasure_mission_config` VALUES ('11', '10', '100', '3', '0', '150');
INSERT INTO `treasure_mission_config` VALUES ('11', '11', '200', '3', '0', '151');
INSERT INTO `treasure_mission_config` VALUES ('11', '12', '300', '3', '0', '152');
INSERT INTO `treasure_mission_config` VALUES ('11', '13', '500', '3', '0', '153');
INSERT INTO `treasure_mission_config` VALUES ('11', '14', '1000', '3', '0', '154');
INSERT INTO `treasure_mission_config` VALUES ('11', '15', '2000', '3', '0', '155');
INSERT INTO `treasure_mission_config` VALUES ('11', '16', '5000', '3', '0', '156');
INSERT INTO `treasure_mission_config` VALUES ('11', '17', '5000', '3', '0', '157');
INSERT INTO `treasure_mission_config` VALUES ('11', '18', '5000', '3', '0', '158');
INSERT INTO `treasure_mission_config` VALUES ('11', '19', '5000', '3', '0', '159');
INSERT INTO `treasure_mission_config` VALUES ('11', '20', '5000', '3', '0', '160');
INSERT INTO `treasure_mission_config` VALUES ('11', '21', '5000', '3', '0', '161');
INSERT INTO `treasure_mission_config` VALUES ('11', '22', '5000', '3', '0', '162');
INSERT INTO `treasure_mission_config` VALUES ('11', '23', '5000', '3', '0', '163');
INSERT INTO `treasure_mission_config` VALUES ('11', '24', '0', '3', '1', '164');
INSERT INTO `treasure_mission_config` VALUES ('12', '6', '40', '3', '0', '165');
INSERT INTO `treasure_mission_config` VALUES ('12', '7', '50', '3', '0', '166');
INSERT INTO `treasure_mission_config` VALUES ('12', '8', '100', '3', '0', '167');
INSERT INTO `treasure_mission_config` VALUES ('12', '9', '200', '3', '0', '168');
INSERT INTO `treasure_mission_config` VALUES ('12', '10', '300', '3', '0', '169');
INSERT INTO `treasure_mission_config` VALUES ('12', '11', '500', '3', '0', '170');
INSERT INTO `treasure_mission_config` VALUES ('12', '12', '1000', '3', '0', '171');
INSERT INTO `treasure_mission_config` VALUES ('12', '13', '2500', '3', '0', '172');
INSERT INTO `treasure_mission_config` VALUES ('12', '14', '5000', '3', '0', '173');
INSERT INTO `treasure_mission_config` VALUES ('12', '15', '7500', '3', '0', '174');
INSERT INTO `treasure_mission_config` VALUES ('12', '16', '12000', '3', '0', '175');
INSERT INTO `treasure_mission_config` VALUES ('12', '17', '12000', '3', '0', '176');
INSERT INTO `treasure_mission_config` VALUES ('12', '18', '12000', '3', '0', '177');
INSERT INTO `treasure_mission_config` VALUES ('12', '19', '12000', '3', '0', '178');
INSERT INTO `treasure_mission_config` VALUES ('12', '20', '12000', '3', '0', '179');
INSERT INTO `treasure_mission_config` VALUES ('12', '21', '12000', '3', '0', '180');
INSERT INTO `treasure_mission_config` VALUES ('12', '22', '12000', '3', '0', '181');
INSERT INTO `treasure_mission_config` VALUES ('12', '23', '12000', '3', '0', '182');
INSERT INTO `treasure_mission_config` VALUES ('12', '24', '0', '3', '1', '183');
INSERT INTO `treasure_mission_config` VALUES ('13', '6', '50', '3', '0', '184');
INSERT INTO `treasure_mission_config` VALUES ('13', '7', '100', '3', '0', '185');
INSERT INTO `treasure_mission_config` VALUES ('13', '8', '200', '3', '0', '186');
INSERT INTO `treasure_mission_config` VALUES ('13', '9', '400', '3', '0', '187');
INSERT INTO `treasure_mission_config` VALUES ('13', '10', '800', '3', '0', '188');
INSERT INTO `treasure_mission_config` VALUES ('13', '11', '1600', '3', '0', '189');
INSERT INTO `treasure_mission_config` VALUES ('13', '12', '5000', '3', '0', '190');
INSERT INTO `treasure_mission_config` VALUES ('13', '13', '10000', '3', '0', '191');
INSERT INTO `treasure_mission_config` VALUES ('13', '14', '20000', '3', '0', '192');
INSERT INTO `treasure_mission_config` VALUES ('13', '15', '50000', '3', '0', '193');
INSERT INTO `treasure_mission_config` VALUES ('13', '16', '80000', '3', '0', '194');
INSERT INTO `treasure_mission_config` VALUES ('13', '17', '80000', '3', '0', '195');
INSERT INTO `treasure_mission_config` VALUES ('13', '18', '80000', '3', '0', '196');
INSERT INTO `treasure_mission_config` VALUES ('13', '19', '80000', '3', '0', '197');
INSERT INTO `treasure_mission_config` VALUES ('13', '20', '80000', '3', '0', '198');
INSERT INTO `treasure_mission_config` VALUES ('13', '21', '80000', '3', '0', '199');
INSERT INTO `treasure_mission_config` VALUES ('13', '22', '80000', '3', '0', '200');
INSERT INTO `treasure_mission_config` VALUES ('13', '23', '80000', '3', '0', '201');
INSERT INTO `treasure_mission_config` VALUES ('13', '24', '0', '3', '1', '202');
INSERT INTO `treasure_mission_config` VALUES ('14', '6', '100', '3', '0', '203');
INSERT INTO `treasure_mission_config` VALUES ('14', '7', '300', '3', '0', '204');
INSERT INTO `treasure_mission_config` VALUES ('14', '8', '500', '3', '0', '205');
INSERT INTO `treasure_mission_config` VALUES ('14', '9', '600', '3', '0', '206');
INSERT INTO `treasure_mission_config` VALUES ('14', '10', '1000', '3', '0', '207');
INSERT INTO `treasure_mission_config` VALUES ('14', '11', '7500', '3', '0', '208');
INSERT INTO `treasure_mission_config` VALUES ('14', '12', '10000', '3', '0', '209');
INSERT INTO `treasure_mission_config` VALUES ('14', '13', '100000', '3', '0', '210');
INSERT INTO `treasure_mission_config` VALUES ('14', '14', '200000', '3', '0', '211');
INSERT INTO `treasure_mission_config` VALUES ('14', '15', '500000', '3', '0', '212');
INSERT INTO `treasure_mission_config` VALUES ('14', '16', '800000', '3', '0', '213');
INSERT INTO `treasure_mission_config` VALUES ('14', '17', '800000', '3', '0', '214');
INSERT INTO `treasure_mission_config` VALUES ('14', '18', '800000', '3', '0', '215');
INSERT INTO `treasure_mission_config` VALUES ('14', '19', '800000', '3', '0', '216');
INSERT INTO `treasure_mission_config` VALUES ('14', '20', '800000', '3', '0', '217');
INSERT INTO `treasure_mission_config` VALUES ('14', '21', '800000', '3', '0', '218');
INSERT INTO `treasure_mission_config` VALUES ('14', '22', '800000', '3', '0', '219');
INSERT INTO `treasure_mission_config` VALUES ('14', '23', '800000', '3', '0', '220');
INSERT INTO `treasure_mission_config` VALUES ('14', '24', '0', '3', '1', '221');
INSERT INTO `treasure_mission_config` VALUES ('15', '6', '100', '3', '0', '222');
INSERT INTO `treasure_mission_config` VALUES ('15', '7', '300', '3', '0', '223');
INSERT INTO `treasure_mission_config` VALUES ('15', '8', '500', '3', '0', '224');
INSERT INTO `treasure_mission_config` VALUES ('15', '9', '600', '3', '0', '225');
INSERT INTO `treasure_mission_config` VALUES ('15', '10', '1000', '3', '0', '226');
INSERT INTO `treasure_mission_config` VALUES ('15', '11', '7500', '3', '0', '227');
INSERT INTO `treasure_mission_config` VALUES ('15', '12', '10000', '3', '0', '228');
INSERT INTO `treasure_mission_config` VALUES ('15', '13', '100000', '3', '0', '229');
INSERT INTO `treasure_mission_config` VALUES ('15', '14', '200000', '3', '0', '230');
INSERT INTO `treasure_mission_config` VALUES ('15', '15', '500000', '3', '0', '231');
INSERT INTO `treasure_mission_config` VALUES ('15', '16', '800000', '3', '0', '232');
INSERT INTO `treasure_mission_config` VALUES ('15', '17', '800000', '3', '0', '233');
INSERT INTO `treasure_mission_config` VALUES ('15', '18', '800000', '3', '0', '234');
INSERT INTO `treasure_mission_config` VALUES ('15', '19', '800000', '3', '0', '235');
INSERT INTO `treasure_mission_config` VALUES ('15', '20', '800000', '3', '0', '236');
INSERT INTO `treasure_mission_config` VALUES ('15', '21', '800000', '3', '0', '237');
INSERT INTO `treasure_mission_config` VALUES ('15', '22', '800000', '3', '0', '238');
INSERT INTO `treasure_mission_config` VALUES ('15', '23', '800000', '3', '0', '239');
INSERT INTO `treasure_mission_config` VALUES ('15', '24', '0', '3', '1', '240');
