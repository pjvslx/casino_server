/*
Navicat MySQL Data Transfer

Source Server         : ly
Source Server Version : 50160
Source Host           : localhost:3306
Source Database       : rpggame

Target Server Type    : MYSQL
Target Server Version : 50160
File Encoding         : 65001

Date: 2014-02-24 22:31:10
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `ban_account_list`
-- ----------------------------
DROP TABLE IF EXISTS `ban_account_list`;
CREATE TABLE `ban_account_list` (
  `uid` bigint(20) NOT NULL COMMENT '角色ID',
  `nick` varchar(50) NOT NULL COMMENT '角色名',
  `account_name` varchar(50) NOT NULL COMMENT '账号',
  `end_time` int(10) NOT NULL COMMENT '封禁结束时间',
  `operator` varchar(50) DEFAULT '' COMMENT '操作员',
  `ban_reason` varchar(256) DEFAULT NULL COMMENT '封禁原因',
  `op_time` int(11) NOT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='已封禁帐号列表';

-- ----------------------------
-- Records of ban_account_list
-- ----------------------------

-- ----------------------------
-- Table structure for `ban_ip_list`
-- ----------------------------
DROP TABLE IF EXISTS `ban_ip_list`;
CREATE TABLE `ban_ip_list` (
  `ip` varchar(20) NOT NULL COMMENT 'IP',
  `end_time` int(11) NOT NULL COMMENT '封禁结束时间',
  `operator` varchar(50) DEFAULT '' COMMENT '操作员',
  `ban_reason` varchar(256) DEFAULT NULL COMMENT '封禁原因',
  `op_time` int(11) NOT NULL,
  PRIMARY KEY (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='已封禁IP列表';

-- ----------------------------
-- Records of ban_ip_list
-- ----------------------------

-- ----------------------------
-- Table structure for `bones`
-- ----------------------------
DROP TABLE IF EXISTS `bones`;
CREATE TABLE `bones` (
  `uid` bigint(20) NOT NULL DEFAULT '0',
  `bones_info` varchar(128) DEFAULT '[]' COMMENT '根骨状况[{根骨类型,根骨等级,成功率}...]',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='根骨';

-- ----------------------------
-- Records of bones
-- ----------------------------

-- ----------------------------
-- Table structure for `buff`
-- ----------------------------
DROP TABLE IF EXISTS `buff`;
CREATE TABLE `buff` (
  `uid` bigint(20) unsigned NOT NULL COMMENT '角色ID',
  `buff1` varchar(1024) COLLATE utf8_unicode_ci NOT NULL DEFAULT '[]' COMMENT 'BUFF记录[{BufId, ExpireTime}]参考buff_util.erl',
  `buff2` varchar(1024) COLLATE utf8_unicode_ci NOT NULL DEFAULT '[]' COMMENT 'BUFF记录[{BufId, Cd, RemTimes},...]参考buff_util.erl',
  `buff3` varchar(1024) COLLATE utf8_unicode_ci NOT NULL DEFAULT '[]' COMMENT 'BUFF记录[{BufId, Cd, RemNumer},...]参考buff_util.erl',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='物品buff记录表\r\n';

-- ----------------------------
-- Records of buff
-- ----------------------------

-- ----------------------------
-- Table structure for `buy_npc_shop_log`
-- ----------------------------
DROP TABLE IF EXISTS `buy_npc_shop_log`;
CREATE TABLE `buy_npc_shop_log` (
  `uid` bigint(20) NOT NULL,
  `shopid` int(11) NOT NULL,
  `gtid` int(11) NOT NULL,
  `buy_num` int(11) NOT NULL,
  `buy_time` int(11) NOT NULL,
  PRIMARY KEY (`uid`,`shopid`,`gtid`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='购买npc商店日志';

-- ----------------------------
-- Records of buy_npc_shop_log
-- ----------------------------

-- ----------------------------
-- Table structure for `buy_shop_log`
-- ----------------------------
DROP TABLE IF EXISTS `buy_shop_log`;
CREATE TABLE `buy_shop_log` (
  `uid` bigint(20) NOT NULL,
  `shoptabid` int(11) NOT NULL,
  `gtid` int(11) NOT NULL,
  `buy_num` int(11) NOT NULL,
  `buy_time` int(11) NOT NULL,
  PRIMARY KEY (`uid`,`shoptabid`,`gtid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='购买商城物品日志';

-- ----------------------------
-- Records of buy_shop_log
-- ----------------------------

-- ----------------------------
-- Table structure for `casting_polish`
-- ----------------------------
DROP TABLE IF EXISTS `casting_polish`;
CREATE TABLE `casting_polish` (
  `gid` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '装备ID',
  `uid` bigint(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家ID',
  `cur_attri` varchar(150) NOT NULL DEFAULT '[]' COMMENT '当前洗炼属性 {唯一ID，属性ID，星级，加成属性，锁定状态}',
  `new_attri` varchar(150) NOT NULL DEFAULT '[]' COMMENT '新洗炼属性 {唯一ID，属性ID，星级，加成属性，锁定状态}',
  PRIMARY KEY (`gid`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='洗炼属性表';

-- ----------------------------
-- Records of casting_polish
-- ----------------------------

-- ----------------------------
-- Table structure for `charge`
-- ----------------------------
DROP TABLE IF EXISTS `charge`;
CREATE TABLE `charge` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `order_id` varchar(30) NOT NULL COMMENT '充值订单号',
  `game_id` varchar(20) NOT NULL COMMENT '游戏编号',
  `server_id` int(10) NOT NULL COMMENT '服务器编号',
  `account_id` varchar(50) NOT NULL COMMENT '4399平台用户唯一标识',
  `pay_way` tinyint(4) NOT NULL COMMENT '1：手游币兑换2：神州行3：联通4：支付宝',
  `amount` int(10) NOT NULL COMMENT '支付金额',
  `gold` int(10) NOT NULL,
  `order_status` tinyint(3) NOT NULL COMMENT 'S-成功支付F-支付失败',
  `handle_status` tinyint(3) NOT NULL,
  `dim_lev` int(10) NOT NULL,
  `create_time` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='充值表';

-- ----------------------------
-- Records of charge
-- ----------------------------

-- ----------------------------
-- Table structure for `config_server`
-- ----------------------------
DROP TABLE IF EXISTS `config_server`;
CREATE TABLE `config_server` (
  `id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '编号Id',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '服务器名字',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='服务器列表';

-- ----------------------------
-- Records of config_server
-- ----------------------------

-- ----------------------------
-- Table structure for `cultivation`
-- ----------------------------
DROP TABLE IF EXISTS `cultivation`;
CREATE TABLE `cultivation` (
  `uid` bigint(20) NOT NULL COMMENT '玩家id',
  `lv` tinyint(4) NOT NULL COMMENT '修为等级',
  `property` varchar(256) NOT NULL DEFAULT '[]' COMMENT '修为属性[{属性类型,属性值}..]',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of cultivation
-- ----------------------------

-- ----------------------------
-- Table structure for `donttalk`
-- ----------------------------
DROP TABLE IF EXISTS `donttalk`;
CREATE TABLE `donttalk` (
  `uid` bigint(20) unsigned NOT NULL COMMENT '角色ID',
  `start_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '开始禁言时间(秒)',
  `duration` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '持续时间(秒)',
  `reason` varchar(100) NOT NULL DEFAULT '无理' COMMENT '理由说明',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色禁言表';

-- ----------------------------
-- Records of donttalk
-- ----------------------------

-- ----------------------------
-- Table structure for `feedback`
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '类型(1-Bug/2-投诉/3-建议/4-其它)',
  `state` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态(已回复1/未回复0)',
  `uid` bigint(20) NOT NULL DEFAULT '0' COMMENT '玩家ID',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '玩家名',
  `content` mediumtext NOT NULL COMMENT '内容',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'Unix时间戳',
  `ip` varchar(100) DEFAULT '' COMMENT '玩家IP',
  `server` varchar(100) DEFAULT '' COMMENT '服务器',
  `gm` varchar(100) DEFAULT '' COMMENT '游戏管理员',
  `reply` text COMMENT '回复内容[{Nick,Content}....]',
  `reply_time` int(11) DEFAULT '0' COMMENT '回复时间',
  PRIMARY KEY (`id`),
  KEY `player_id` (`uid`) USING BTREE,
  KEY `player_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家反馈';

-- ----------------------------
-- Records of feedback
-- ----------------------------

-- ----------------------------
-- Table structure for `infant_ctrl_byuser`
-- ----------------------------
DROP TABLE IF EXISTS `infant_ctrl_byuser`;
CREATE TABLE `infant_ctrl_byuser` (
  `account_id` int(11) NOT NULL DEFAULT '0' COMMENT '平台ID',
  `total_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '防沉迷累计登陆时间(unix time)',
  `last_login_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上次登陆时间(unix time)',
  PRIMARY KEY (`account_id`),
  KEY `accid` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of infant_ctrl_byuser
-- ----------------------------

-- ----------------------------
-- Table structure for `meridian`
-- ----------------------------
DROP TABLE IF EXISTS `meridian`;
CREATE TABLE `meridian` (
  `player_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '玩家Id',
  `mer_detail_1` varchar(256) NOT NULL COMMENT '玩家经脉1详细数据[{MerType,Merlv}...]',
  `mer_detail_2` varchar(256) NOT NULL COMMENT '玩家经脉2详细数据[{MerType,Merlv}...]',
  `mer_state` varchar(16) NOT NULL COMMENT '玩家修炼经脉阶段{state1, state2}',
  `cool_down` varchar(64) NOT NULL DEFAULT '{0,0}' COMMENT '剩余的冷却时间 {玩家开始修炼时间戳,剩余冷却时间，状态}',
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of meridian
-- ----------------------------

-- ----------------------------
-- Table structure for `opera`
-- ----------------------------
DROP TABLE IF EXISTS `opera`;
CREATE TABLE `opera` (
  `uid` bigint(20) unsigned NOT NULL COMMENT '角色ID',
  `operaDialogue` varchar(8000) NOT NULL DEFAULT '[]' COMMENT '已播放过的剧情对话',
  `operaAnimation` varchar(8000) NOT NULL DEFAULT '[]' COMMENT '已播放过的剧情动画',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色禁言表';

-- ----------------------------
-- Records of opera
-- ----------------------------

-- ----------------------------
-- Table structure for `player`
-- ----------------------------
DROP TABLE IF EXISTS `player`;
CREATE TABLE `player` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `account_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '平台账号ID',
  `account_name` varchar(50) NOT NULL DEFAULT '' COMMENT '平台账号',
  `nick` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家名',
  `reg_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `logout_time` int(11) NOT NULL DEFAULT '0' COMMENT '上次离线时间',
  `last_login_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后登陆时间',
  `last_login_ip` varchar(20) NOT NULL DEFAULT '' COMMENT '最后登陆IP',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '玩家状态（0正常、1禁止、2战斗中、3死亡、4挂机、5打坐）',
  `gender` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '性别 1男 2女',
  `career` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '职业(0:未定义，1: 神 2:魔 3:妖)',
  `gold` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '元宝',
  `bgold` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '绑定元宝',
  `coin` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '铜钱',
  `bcoin` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '绑定铜钱',
  `vip` int(11) NOT NULL DEFAULT '0' COMMENT 'VIP类型，0不是VIP，其他参考common.hrl',
  `vip_expire_time` int(11) NOT NULL DEFAULT '0' COMMENT 'VIP过期时间(秒)',
  `scene` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '场景ID',
  `level` smallint(5) unsigned NOT NULL DEFAULT '1' COMMENT '等级',
  `exp` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '经验',
  `x` int(8) NOT NULL DEFAULT '0' COMMENT '分辨率 X',
  `y` int(8) NOT NULL DEFAULT '0' COMMENT '分辨率 Y',
  `other` tinyint(4) NOT NULL DEFAULT '0' COMMENT '其他信息',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nick` (`nick`),
  KEY `level` (`level`) USING BTREE,
  KEY `account_name` (`account_name`) USING BTREE,
  KEY `last_login_time` (`last_login_time`) USING BTREE,
  KEY `reg_time` (`reg_time`) USING BTREE,
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1060000000003 DEFAULT CHARSET=utf8 COMMENT='角色基本信息';

-- ----------------------------
-- Records of player
-- ----------------------------
INSERT INTO `player` VALUES ('1060000000002', '0', 'luyang', 'luyang', '1392345685', '0', '1392345685', '192.168.1.96', '0', '1', '1', '0', '0', '0', '0', '0', '0', '3', '1', '0', '5', '5', '0');

-- ----------------------------
-- Table structure for `server`
-- ----------------------------
DROP TABLE IF EXISTS `server`;
CREATE TABLE `server` (
  `id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '编号Id',
  `domain` int(11) unsigned NOT NULL DEFAULT '1' COMMENT '分区号',
  `ip` varchar(50) NOT NULL DEFAULT '' COMMENT 'ip地址',
  `port` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '端口号',
  `node` varchar(50) NOT NULL DEFAULT '' COMMENT '节点',
  `num` int(11) DEFAULT '0' COMMENT '节点用户数',
  `stop_access` tinyint(5) NOT NULL DEFAULT '0' COMMENT '是否停止登陆该节点，0为可以登录，1为停止登陆',
  `start_time` int(11) NOT NULL DEFAULT '0' COMMENT '开服时间',
  `state` tinyint(11) NOT NULL DEFAULT '0' COMMENT '1-新开；2-火爆；3-良好；4-流畅；5-维护。',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='服务器列表';

-- ----------------------------
-- Records of server
-- ----------------------------

-- ----------------------------
-- Table structure for `server_player`
-- ----------------------------
DROP TABLE IF EXISTS `server_player`;
CREATE TABLE `server_player` (
  `uid` bigint(20) NOT NULL DEFAULT '0' COMMENT '玩家ID，全平台唯一',
  `accid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家Id',
  `serv_id` int(50) NOT NULL DEFAULT '0' COMMENT '服务器标识',
  `domain` smallint(4) NOT NULL DEFAULT '0' COMMENT '大区标识',
  `acc_name` varchar(50) NOT NULL DEFAULT '' COMMENT '账号名字',
  `nick` varchar(50) NOT NULL DEFAULT '' COMMENT '角色名字',
  `sex` smallint(2) NOT NULL DEFAULT '0' COMMENT '角色性别',
  `career` smallint(2) NOT NULL DEFAULT '0' COMMENT '角色职业',
  `lv` int(4) NOT NULL DEFAULT '0' COMMENT '角色等级',
  `icon` int(4) NOT NULL DEFAULT '0' COMMENT '图标',
  `last_login` int(11) NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='服务器列表';

-- ----------------------------
-- Records of server_player
-- ----------------------------
INSERT INTO `server_player` VALUES ('1060000000001', '0', '96', '1', 'luyang', 'luyang', '1', '1', '1', '0', '1392343591');
INSERT INTO `server_player` VALUES ('1060000000002', '0', '96', '1', 'luyang', 'luyang', '1', '1', '1', '0', '1392472752');
INSERT INTO `server_player` VALUES ('1060000000003', '0', '106', '1', 'luyang', 'luyang', '1', '1', '1', '0', '1392489335');

-- ----------------------------
-- Table structure for `skill`
-- ----------------------------
DROP TABLE IF EXISTS `skill`;
CREATE TABLE `skill` (
  `uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
  `skill_list` varchar(100) NOT NULL DEFAULT '[]' COMMENT '已学习的技能ID列表[{SkillId, Level}]',
  `cur_skill_list` varchar(100) NOT NULL DEFAULT '[]' COMMENT '当前正在使用的技能的ID[{SkillId, Level},...]',
  `skill_point` varchar(32) NOT NULL DEFAULT '{0,0}' COMMENT '技能点{已用点数,未用点数}',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='技能';

-- ----------------------------
-- Records of skill
-- ----------------------------

-- ----------------------------
-- Table structure for `system_config`
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config` (
  `uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '玩家Id',
  `shield_role` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '蔽屏附近玩家和宠物，0：不屏蔽；1：屏蔽',
  `shield_skill` tinyint(1) NOT NULL DEFAULT '0' COMMENT '屏蔽技能特效， 0：不屏蔽；1：屏蔽',
  `shield_rela` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '屏蔽好友请求，0：不屏蔽；1：屏蔽',
  `shield_team` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '屏蔽组队邀请，0：不屏蔽；1：屏蔽',
  `shield_chat` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '屏蔽聊天传闻，0：不屏蔽；1：屏蔽',
  `fasheffect` tinyint(1) NOT NULL DEFAULT '0' COMMENT '时装显示(0对别人显示，1对别人不显示)',
  `music` mediumint(8) unsigned NOT NULL DEFAULT '50' COMMENT '游戏音乐，默认值为50',
  `soundeffect` mediumint(8) NOT NULL DEFAULT '50' COMMENT '游戏音效，默认值为50',
  PRIMARY KEY (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='玩家系统设置';

-- ----------------------------
-- Records of system_config
-- ----------------------------

-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `account_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '平台账号id',
  `account_name` varchar(50) NOT NULL DEFAULT '' COMMENT '平台账号',
  `state` smallint(5) NOT NULL DEFAULT '0' COMMENT '账号状态(0正常；1被封)',
  `id_card_state` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '身份证验证状态，0表示没填身份证信息，1表示成年人，2表示未成年人，3表示暂时未填身份证信息',
  PRIMARY KEY (`account_id`),
  KEY `account_name` (`account_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='平台账号';

-- ----------------------------
-- Records of user
-- ----------------------------

-- ----------------------------
-- Table structure for `world_level`
-- ----------------------------
DROP TABLE IF EXISTS `world_level`;
CREATE TABLE `world_level` (
  `sid` int(11) NOT NULL DEFAULT '0' COMMENT '服务器编号',
  `state` tinyint(1) NOT NULL DEFAULT '0' COMMENT '世界等级开放状态0未开放，1开放',
  `world_level` smallint(6) NOT NULL DEFAULT '0' COMMENT '实际的世界等级',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT '开启时间点',
  PRIMARY KEY (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of world_level
-- ----------------------------
