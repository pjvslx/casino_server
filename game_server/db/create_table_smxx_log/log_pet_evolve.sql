-- ----------------------------
-- Table structure for `log_pet_evolve`
-- ----------------------------
DROP TABLE IF EXISTS `log_pet_evolve`;
CREATE TABLE `log_pet_evolve` (
`id`  bigint(20) NOT NULL AUTO_INCREMENT ,
`uid`  bigint(20) NOT NULL COMMENT '���id' ,
`old_growth_lv`  tinyint(4) NOT NULL COMMENT 'ԭ���ɳ�ֵ' ,
`new_growth_lv`  tinyint(4) NOT NULL COMMENT '�µĳɳ�ֵ' ,
`old_growth_progress`  smallint(6) NOT NULL COMMENT 'ԭ���ɳ�����' ,
`new_growth_progress`  smallint(6) NOT NULL COMMENT '�µĳɳ�����' ,
`gold`  smallint(6) NOT NULL DEFAULT 0 COMMENT '����Ԫ��' ,
`coin`  smallint(6) NOT NULL DEFAULT 0 COMMENT '����ͭǮ' ,
`cost_goods`  int(11) NOT NULL DEFAULT 0 COMMENT '������Ʒ' ,
`create_time`  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��' ,
PRIMARY KEY (`id`),
INDEX `uid` USING BTREE (`uid`) 
)
ENGINE=MyISAM
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
COMMENT='�������'
AUTO_INCREMENT=3258

;