%%%------------------------------------------------	
%%% File    : table_to_record.erl	
%%% Author  : smxx	
%%% Created : 2018-03-06 19:28:59	
%%% Description: 从mysql表生成的record	
%%% Warning:  由程序自动生成，请不要随意修改！	
%%%------------------------------------------------		
 	
	
%% 服务器列表	
%% server ==> server 	
-record(server, {	
      id = 0,                                 %% 编号Id	
      domain = 1,                             %% 分区号	
      ip = "",                                %% ip地址	
      port = 0,                               %% 端口号	
      node = "",                              %% 节点	
      num = 0,                                %% 节点用户数	
      stop_access = 0,                        %% 是否停止登陆该节点，0为可以登录，1为停止登陆	
      start_time = 0,                         %% 开服时间	
      state = 0                               %% 1-新开；2-火爆；3-良好；4-流畅；5-维护。	
    }).	
	
%% 服务器列表	
%% config_server ==> config_server 	
-record(config_server, {	
      id = 0,                                 %% 编号Id	
      name = ""                               %% 服务器名字	
    }).	
	
%% 服务器列表	
%% server_player ==> server_player 	
-record(server_player, {	
      uid = 0,                                %% 玩家ID，全平台唯一	
      accid = 0,                              %% 玩家Id	
      serv_id = 0,                            %% 服务器标识	
      domain = 0,                             %% 大区标识	
      acc_name = "",                          %% 账号名字	
      nick = "",                              %% 角色名字	
      sex = 0,                                %% 角色性别	
      career = 0,                             %% 角色职业	
      lv = 0,                                 %% 角色等级	
      icon = 0,                               %% 图标	
      last_login = 0                          %% 最后登录时间	
    }).	
	
%% 角色基本信息	
%% player ==> player 	
-record(player, {	
      id,                                     %% 用户ID	
      imei = "",                              %% imei号	
      third_token = "",                       %% 三方平台token	
      third_provider = 0,                     %% 三方平台类型	
      bind_phone = "",                        %% 绑定手机号	
      account_name = "",                      %% 平台账号	
      nick = "",                              %% 玩家名	
      reg_time = 0,                           %% 注册时间	
      logout_time = 0,                        %% 上次离线时间	
      last_login_time = 0,                    %% 最后登陆时间	
      last_login_ip = "",                     %% 最后登陆IP	
      status = 0,                             %% 玩家状态（0正常、1禁止、2战斗中、3死亡、4挂机、5打坐）	
      gender = 1,                             %% 性别 1男 2女	
      career = 0,                             %% 职业(0:未定义，1: 神 2:魔 3:妖)	
      gold = 0,                               %% 元宝	
      bgold = 0,                              %% 绑定元宝	
      coin = 0,                               %% 铜钱	
      bcoin = 0,                              %% 绑定铜钱	
      vip = 0,                                %% VIP类型，0不是VIP，其他参考common.hrl	
      vip_expire_time = 0,                    %% VIP过期时间(秒)	
      recharge,                               %% 	
      scene = 0,                              %% 场景ID	
      level = 1,                              %% 等级	
      exp = 0,                                %% 经验	
      x = 0,                                  %% 分辨率 X	
      y = 0,                                  %% 分辨率 Y	
      other = 0                               %% 其他信息	
    }).	
	
%% treasure_mission_config	
%% treasure_mission_config ==> treasure_mission_config 	
-record(treasure_mission_config, {	
      stone_id = 0,                           %% 石头ID	
      line_num = 10,                          %% 相连数	
      odds_factor = 0,                        %% 赔率	
      mission = 1,                            %% 关卡等级	
      is_crit = 0,                            %% 	
      cid                                     %% 	
    }).	
	
%% shop_config	
%% shop_config ==> shop_config 	
-record(shop_config, {	
      id,                                     %% 记录ID	
      provider,                               %% 	
      prop_id,                                %% 道具属性ID	
      shop_id,                                %% db	
      game_item_id,                           %% 内部用ID	
      item_name,                              %% 道具名字	
      price_value,                            %% 价格值	
      price_unit,                             %% 价格单位1：元 2：角 3：分	
      prop_quantity,                          %% 购买数量	
      prop_gift_quantity                      %% 赠送的数量	
    }).	
