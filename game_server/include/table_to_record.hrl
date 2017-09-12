%%%------------------------------------------------	
%%% File    : table_to_record.erl	
%%% Author  : smxx	
%%% Created : 2014-05-08 13:44:06	
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
      icon = 0,                               %% 图标	
      last_login = 0                          %% 最后登录时间	
    }).	
	
%% 角色基本信息	
%% player ==> player 	
-record(player, {	
      id,                                     %% 用户ID	
      account_id = 0,                         %% 平台账号ID	
      account_name = "",                      %% 平台账号	
      nick = "",                              %% 玩家名	
      reg_time = 0,                           %% 注册时间	
      logout_time = 0,                        %% 上次离线时间	
      last_login_time = 0,                    %% 最后登陆时间	
      last_login_ip = "",                     %% 最后登陆IP	
      gender = 1,                             %% 性别 1男 2女	
      gold = 0,                               %% 元宝	
      coin = 0,                               %% 铜钱	
      vip = 0,                                %% VIP类型，0不是VIP，其他参考common.hrl	
      vip_expire_time = 0,                    %% VIP过期时间(秒)	
      other = 0                               %% 其他信息	
    }).	
	
%% temp_slotmachine_reward	
%% temp_slotmachine_reward ==> temp_slotmachine_reward 	
-record(temp_slotmachine_reward, {	
      id,                                     %% 老虎机奖励配置表	
      fruit_type,                             %% 	
      num,                                    %% 	
      reward                                  %% 	
    }).	