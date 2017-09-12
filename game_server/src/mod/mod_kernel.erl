%%%------------------------------------
%%% @Module  : mod_kernel
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description: 核心服务
%%%------------------------------------
-module(mod_kernel).
-behaviour(gen_server).
-export([   start_link/0,
			load_base_data/0,
			load_base_data/1
        ]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("record.hrl").
-include("goods.hrl").

-define(AUTO_LOAD_GOODS, 10*60*1000).  %%每10分钟加载一次数据(正式上线后，去掉)


start_link() ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).

init([]) -> 
	%eprof:start(), %性能测试开关，非请勿用
	misc:write_monitor_pid(self(),?MODULE, {0}),
	%%初始ets表
    init_ets(),
	%%初始数据库  
	main:init_db(server),
	%%加载需要做压缩的协议号  
	load_compress_proto(?ZIP_PROTO),
	{ok, 1}.

handle_cast({set_load, Load_value}, Status) ->
	misc:write_monitor_pid(self(),?MODULE, {Load_value}),
	{noreply, Status};

handle_cast(_R , Status) ->
    {noreply, Status}.

handle_call(_R , _FROM, Status) ->
    {reply, ok, Status}.

handle_info({event, load_data}, Status) ->
	%% 加载基础数据
	erlang:send_after(?AUTO_LOAD_GOODS, self(), {event, load_data}),  %% 重复加载一次数据
	{noreply, Status};

handle_info(_Reason, Status) ->
    {noreply, Status}.

terminate(normal, Status) ->
	misc:delete_monitor_pid(self()),
    {ok, Status}.

code_change(_OldVsn, Status, _Extra)->
    {ok, Status}.

%% ================== 私有函数 =================
%% 加载基础数据
load_base_data() ->
	load_base_data(scene),				%%加载场景模板
	load_base_data(task),				%%加载任务数据
	load_base_data(npc),				%%加载场景模板
	load_base_data(npc_layout),			%%加载场景模板
	load_base_data(mon_layout),			%%加载场景模板
	load_base_data(physique) , 
	load_base_data(map_info),			%%加载地图信息
    load_base_data(temp_guild_level),   %%加载帮派等级配置
	ok .

%%加载压缩协议列表
load_compress_proto([Proto|Rest])->
	ets:insert(?ETS_ZIP_PROTO, {Proto,true}),
	load_compress_proto(Rest);
load_compress_proto([])->
	ok.

	 %%@spec 加载场景模板
load_base_data(scene) ->
	lib_scene:load_temp_scene() ,
	lib_scene:create_scene_online() ,
	lib_scene:create_scene_slice(),
	ok ;

%%@spec 加载NPC模板
load_base_data(npc) ->
	lib_scene:load_temp_npc() ,
	ok ;

%%@spec 加载NPC布局模板
load_base_data(npc_layout) ->
	lib_scene:load_temp_npc_layout() ,
	ok ;

%%@spec 加载怪物
load_base_data(mon_layout) ->
	lib_scene:load_temp_mon_layout() ,
	ok ;
 
%%@spec 加载任务
load_base_data(task) ->
%%   	ok = lib_task:init_base_task(),  
%% 	ok = lib_task:init_base_task_detail(), 
	ok;

%%@spec 加载经脉
load_base_data(physique) ->
%% 	lib_physique:init_tpl_physique(),
	ok;

load_base_data(map_info) ->
	lib_scene:load_scene_map_info(),
	ok;

load_base_data(temp_guild_level) ->
	lib_guild:load_temp_guild_level(),
	ok;

load_base_data(_) ->  
	ok.

%%初始ETS表
init_ets() ->
	ets:new(mysql_stat, [named_table, public, set,{read_concurrency,true},{write_concurrency,true}]),%%数据库表操作统计 性能测试用,非请勿用
	%ets:new(proto_stat, [set, public, named_table,{read_concurrency,true},{write_concurrency,true}]),	%协议统计 性能测试用,非请勿用
	ets:new(?ETS_ONLINE, [{keypos,#player.id}, named_table, public, set,{read_concurrency,true},{write_concurrency,true}]),  %%本节点在线用户列表
	ets:new(?ETS_ZIP_PROTO, [named_table, public, set,{read_concurrency,true}]),		%%压缩协议ets表
	ok . 