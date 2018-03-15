%%%------------------------------------
%%% @Author  : 
%%% @Created : 2010.09.27
%%% @Description: 角色处理
%%%------------------------------------
-module(mod_player). 
-behaviour(gen_server).
-include("common.hrl").
-include("goods.hrl").
-include("record.hrl").  
-include("debug.hrl").
-include("guild.hrl").
-export([code_change/3, handle_call/3, handle_cast/2, handle_info/2, init/1,terminate/2]).
-compile(export_all).

% 每5分钟存一次数据库
-define(SAVE_DB_TICK, 300000).
-define(EXP_BUFF,499).%%特定buffid,待配置

update_pet_battle_attr(Pid, BattleAttr) ->
	gen_server:cast(Pid, {update_pet_battle_attr, BattleAttr}).
  
%%启动角色主进程
start(PlayerId, AccountId, Socket) ->
    gen_server:start(?MODULE, [PlayerId, AccountId, Socket], []).
 
%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([PlayerId, _AccountId, Socket]) ->
	%%net_kernel:monitor_nodes(true),
	%eprof:start_profiling([self()]), %性能测试开关，非请勿用
	PlayerProcessName = misc:player_process_name(PlayerId),  
	try_2_unregister_pid(PlayerProcessName),
	misc:register(local, PlayerProcessName, self()),
	delete_ets_when_init(PlayerId),

	%%加载玩家数据和各种逻辑
	Status = load_player_info(PlayerId,Socket),
    %%上传排行榜进程信息
    gen_server:cast(mod_rank:get_mod_rank_pid(),{new_player,PlayerId,Status#player.recharge,Status#player.coin,Status#player.nick,Status#player.head}),
	{ok, Status} .

%% 路由
%% cmd:命令号
%% Socket:socket id
%% data:消息体
-ifdef(debug).
	routing(Cmd, Status, Bin) -> 
%%     		 try
			routing2(Cmd, Status, Bin).
%% 		 catch
%% 		 	Err:Reason ->
%% 		 		?ERROR_MSG("处理消息[~p]出异常：~w", [Cmd, {Err, Reason, erlang:get_stacktrace()}]),
%% 		 		ErrMsg = io_lib:format("处理消息[~p]出异常：~p", [Cmd, {Err, Reason, erlang:get_stacktrace()}]),
%% 		 		{ok, BinData} = pt_11:write(11099, ErrMsg),
%% 		 		lib_send:send_one(Status#player.other#player_other.socket, BinData),
%% 		 		{error, "handle cmd error"}
%% 		 end.
-else.
	routing(Cmd, Status, Bin) -> 
		 try
			routing2(Cmd, Status, Bin)
		 catch
		 	Err:Reason ->
		 		io:format("处理消息[~p]出异常：~p", [Cmd, {Err, Reason, erlang:get_stacktrace()}]),
		 		{error, "handle cmd error"}
		 end.
-endif.

routing2(Cmd, Status, Bin) -> 
    io:format("routing2 Cmd = ~p ~n",[Cmd]),
	%case Cmd >= 15000 of
	%	true ->	?TRACE("Cmd:~p Bin:~p ~n", [Cmd, Bin]);
	%	false -> skip
	%end,
    %%取前面二位区分功能类型
    [H1, H2, _, _, _] = integer_to_list(Cmd), 
    case [H1, H2] of
        %%游戏基础功能处理  
        "10" -> skip;
        "11" -> pp_chat:handle(Cmd,Status,Bin);
        "14" -> pp_treasure:handle(Cmd,Status,Bin);
        "15" -> pp_rank:handle(Cmd,Status,Bin);
        "16" -> pp_shop:handle(Cmd,Status,Bin);
        _ -> %%错误处理
            ?ERROR_MSG("Routing Error [~w].", [Cmd]),
            {error, "Routing failure"}
    end.  

%%处理socket协议 (cmd：命令号; data：协议数据)

%% 统一模块+过程调用(call)
handle_call({apply_call, Module, Method, Args}, _From, Status) -> 
	Reply  = ?APPLY(Module, Method, Args,[]),
    {reply, Reply, Status};

handle_call({'SOCKET_EVENT', Cmd, Bin}, _From, Status) ->  
	io:format("handle_call SOCKET_EVENT Cmd = ~p~n",[Cmd]),
	case routing(Cmd, Status, Bin) of
		{ok, Status1} ->                           %% 修改ets和status  
			save_online(Status1), 
			%%save_online_diff(Status,Status1),
			{reply, ok, Status1};
		{ok, change_ets_table, Status1} ->         %% 修改ets、status和table
			save_online_diff(Status,Status1),            
			save_player_table(Status1),
			{reply, ok, Status1};
		{ok, change_status, Status2} ->            %% 修改status
			{reply, ok, Status2};
		{ok,change_online,Status3} ->
			ets:insert(?ETS_ONLINE, Status3) ,
			{reply, ok, Status3};
		_ -> 
			{reply, ok, Status}
	end; 

%% 统一模块+过程调用(call)
handle_call({apply_call, Module, Method, Args}, _From, Status) -> 
	Reply  = ?APPLY(Module, Method, Args,[]),
    {reply, Reply, Status};

	
%%获取用户信息
handle_call('PLAYER', _from, Status) ->
    {reply, Status, Status};

%%获取用户信息(按字段需求)
handle_call({'PLAYER', List}, _from, Status) ->
    Reply = lib_player_rw:get_player_info_fields(Status, List),
    {reply, Reply, Status};
%%收花通知
handle_call({get_flower, FriendId, FlowerNum},_from,Status)->
	NewFlower = lib_relation:do_receive_flower(FriendId,FlowerNum,Status),
	 {reply, NewFlower, Status};

handle_call(Event, From, Status) ->
   ?ERROR_MSG("mod_player_call: /~p/~n",[[Event, From, Status]]),
   {reply, ok, Status}.

%%非法上线的玩家重新上线时重新加载上次的玩家信息
handle_cast({reload_player_data,PlayerId, _, Socket},Status)->  
	if Status#player.id =/= PlayerId ->
		   {stop, normal, Status};
	   true ->
		   cancel_player_timer(),
		   [PidSend] = Status#player.other#player_other.pid_send,
		   gen_server:cast(PidSend, {reset_socket,Socket}), 
		   NewPlayerOther =  Status#player.other#player_other{socket = Socket},
		   {noreply, Status#player{
								   other = NewPlayerOther 
								  }}
	end;

% %%停止角色进程(Reason 为停止原因)
% handle_cast({stop, Reason}, Status) ->
% 	io:format("mod_player handle_cast ~n"), 
%     if Reason =:= ?PLAYER_EXIT_UNORMAL andalso Status#player.status =:= ?PLAYER_BATTLE_STATE->
%             NewStatus = do_unnormal_offline(Status),
%             {noreply, NewStatus};
%         true->
%             {ok, BinData} = pt_10:write(10007, 0), %%Reason
%             lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
%             {stop, normal, Status}
%     end;
%%主动退出
handle_cast(stop, Status) ->
	io:format("------------handle_cast stop~n"),
    {stop, normal, Status};

%%充值
handle_cast(charge, Status) ->
    ?TRACE("mod_player handle_cast charge ~n"),
    NewStatus = lib_player:handle_charge_order(Status),
    save_online(NewStatus),
    {noreply, NewStatus};

handle_cast(Event, Status) ->
   ?ERROR_MSG("mod_player_cast: /~p/~n",[[Event, Status]]),
   {noreply, Status}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% 发送信息到socket端口
handle_info({send_to_sid, Bin}, Status) ->
   lib_send:send_to_sid(Status#player.other#player_other.pid_send, Bin),
   {noreply, Status};

handle_info(stop,Status)-> 
	{stop, normal, Status};

handle_info(Info, Status) ->
   ?ERROR_MSG("Mod_player_info: /~p/~n",[[Info]]),
   {noreply, Status}.
%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, Status) ->   
	io:format("============mod_player terminate ~n"),
    %% 卸载角色数据  
	NewStatus = unload_player_info(Status),    
	mod_disperse:sync_player_to_gateway(NewStatus) ,
    misc:delete_monitor_pid(self()),  
	Now = util:unixtime(), 
	%db_agent_log:insert_log_quit(NewStatus),
    ok.

try_2_unregister_pid(PidName) ->     
	case misc:whereis_name({local, PidName}) of
		Pid when is_pid(Pid) ->  
			misc:delete_monitor_pid(Pid),
			erlang:unregister(PidName);
		_ ->
			skip
	end . 

%%非正常下线逻辑
do_unnormal_offline(Status)-> 
	[PidSend] = Status#player.other#player_other.pid_send,
	gen_server:cast(PidSend, 'remove_socket'),
	NewPlayerOther = Status#player.other#player_other{socket = undefined},
	NewStatus = Status#player{other = NewPlayerOther},
	save_online(NewStatus),
	CloseTimer = erlang:send_after(10*1000, self(), stop),
	put(close_timer,CloseTimer),
	NewStatus.
%%关闭下线定时器（不关闭的话玩家非正常下线后10就断线）
cancel_player_timer()->
	case get(close_timer) of
		undefined ->
			skip;
		Timer ->
			erlang:cancel_timer(Timer)
	end.
%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_oldvsn, Status, _extra) ->
    {ok, Status}.

%%----------------------------------------------
%%更新上次登录IP及时间
%%----------------------------------------------
update_last_login(Player, Scoket) ->
    %%最后登录时间和IP
    LastLoginIP = misc:get_ip(Scoket) , 
    db_agent_player:update_last_login(Player#player.last_login_time, LastLoginIP, Player#player.id) .

%% 加载玩家成就系统
%%----------------------------------------------
%% @spec 加载角色数据
%%    input: PlayerId -- 玩家ID Os,OsVersion,Device,DeviceType,Screen,Mno,Nm, 
%%         Socket   -- 
%%----------------------------------------------
load_player_info(PlayerId,Socket) ->
    io:format("load_player_info PlayerId = ~p~n",[PlayerId]),
    NowTime = util:unixtime() ,
    LastLoginTime = NowTime + 5 ,
    put(player_id,PlayerId),
    
    %%获取玩家结构 record
    Player = load_player_table(PlayerId),
    %%更新最近登录时间
    update_last_login(Player, Socket),
    
    PidSendList = lists:map(fun(N)-> 
                                    {ok, PidSend} = mod_pid_send:start(Socket, N),
                                    PidSend
                            end, lists:seq(1, ?SEND_MSG)),

    case db_agent_treasure:get_treasure(PlayerId) of
        [] ->
            %%为空 说明没有记录
            TreasureLevel = 1,
            TreasureLeftBrick = 15,
            TreasureScore = 0,
            db_agent_treasure:create_treasure_table([uid,level,left_brick,score],[PlayerId,TreasureLevel,TreasureLeftBrick,TreasureScore]);
        Ret ->
            [TreasureLevel,TreasureLeftBrick,TreasureScore] = Ret
    end,
    Other = #player_other{
                            socket = Socket, 
                            pid_send = PidSendList, 
                            current_game = 0,
                            treasure_level = TreasureLevel, 
                            treasure_left_brick = TreasureLeftBrick, 
                            treasure_score = TreasureScore,
                            pid = self()
                            },
    NewPlayer = Player#player{other = Other},
    update(NewPlayer),
    NewPlayer.

%% 卸载角色数据
unload_player_info(Status) ->   
	%% 保存状态数据
	Now = util:unixtime(),
    save_online(Status),
    gen_server:call({leave_treasure,Status#player.id}),
	%%删除玩家节点ETS相关信息
	delete_player_ets(Status#player.id), 
	Status.

delete_ets_when_init(PlayerId)->
    ets:delete(?ETS_ONLINE, PlayerId).

%%停止本游戏进程
stop(Pid, Reason) when is_pid(Pid) ->
    gen_server:cast(Pid, {stop, Reason}).

%% 设置副本
set_dungeon(Pid, PidDungeon) ->
    case misc:is_process_alive(Pid) of
        false -> false;
        true -> gen_server:cast(Pid, {'SET_PLAYER', [{pid_dungeon, PidDungeon}]})
    end.

%% 设置禁言 或 解除禁言
set_donttalk(PlayerId, {BeginTime, DurationSeconds}) ->
      gen_server:cast({local, misc:player_process_name(PlayerId)}, {set_donttalk, BeginTime, DurationSeconds}).

%%回写禁言时间.
%%有必要时才回写
writeback_donttalk(Id, Now) ->
     case get(donttalk) of
        [BeginTime, Duration] ->
            case (BeginTime + Duration) > (Now + 5) of
                true ->
                    db_agent:update_donttalk(Id, BeginTime, Duration);
                false ->
                    skip
            end;
        _Other ->   
            skip
     end.

%% 同步更新ETS中的角色数据
save_online(PlayerStatus) ->   
    %% 更新本地ets里的用户信息
    save_player_table(PlayerStatus),
    save_treasure_table(PlayerStatus),
    ok.

%% 差异同步更新ETS中的角色数据
save_online_diff(OldPlayer,NewPlayer) ->
    if
        is_record(OldPlayer,player) andalso is_record(NewPlayer,player) ->
            Plist = record_info(fields,player),
            Olist = record_info(fields,player_other),
			AList = record_info(fields,battle_attr) ,
            Fields = Plist ++ Olist ++ AList ,
            OvalList = lib_player_rw:get_player_info_fields(OldPlayer,Fields),
            NvalList = lib_player_rw:get_player_info_fields(NewPlayer,Fields),
            KeyValue = get_diff_val(OvalList,NvalList,Fields),
            if
                length(KeyValue) > 0 ->
                    ets:insert(?ETS_ONLINE, NewPlayer),
                    mod_scene:update_player_info_fields(NewPlayer,KeyValue) ;
                true ->
                    skip
            end;
        true ->
            ?ERROR_MSG("badrecord in save_online_diff:~p~n", [[OldPlayer,NewPlayer]])
    end,
    ok.

get_diff_val(Ol,Nl,Fs)->
    get_diff_val_loop(Ol,Nl,Fs,[]).

get_diff_val_loop([],_,_,DiffList) ->
    DiffList;
get_diff_val_loop(_,[],_,DiffList) ->
    DiffList;
get_diff_val_loop(_,_,[],DiffList) ->
    DiffList;
get_diff_val_loop([V1|Ol],[V2|Nl],[K|Fs],DiffList) ->
    if
        K /= other andalso K /= battle_attr andalso V1 /= V2 ->
            get_diff_val_loop(Ol,Nl,Fs,[{K,V2}|DiffList]);
        true ->
            get_diff_val_loop(Ol,Nl,Fs,DiffList)
    end.
    
%%从玩家表读取基本信息, 转换成玩家Record
%%登录时使用
load_player_table(PlayerId) -> 
    PlayerInfo = lib_account:get_info_by_id(PlayerId),
    NewPlayerInfo1 = list_to_tuple([player|PlayerInfo]).

%%保存基本信息
%%这里主要统一更新一些相对次要的数据。
%%当玩家退出的时候也会执行一次这边的信息 
save_player_table(Status) -> 
    FieldList = [   coin, 
                    vip,                                 %% VIP等级
                    vip_expire_time,                     %% VIP失效时间 
                    logout_time,                         %%退出时间
                    gold,
                    recharge
                    ],
    ValueList = [   Status#player.coin,
                    Status#player.vip,                   %%VIP等级
                    Status#player.vip_expire_time,       %%VIP失效时间
                    util:unixtime(),
                    Status#player.gold,
                    Status#player.recharge
                ] , 
                 db_agent_player:save_player_table(Status#player.id, FieldList, ValueList),
    Status.

save_treasure_table(Status) ->
    FieldList = [
                    level,
                    left_brick,
                    score
                ],

    PlayerOther = Status#player.other,
    ValueList = [
                    PlayerOther#player_other.treasure_level,
                    PlayerOther#player_other.treasure_left_brick,
                    PlayerOther#player_other.treasure_score
                ],
    db_agent_treasure:save_treasure_table(Status#player.id,FieldList,ValueList).
 
%%下线删除定时器
logout_cancel_timer() ->
    misc:cancel_timer(check_heart_timer),
    misc:cancel_timer(antirevel_act_timer),
    misc:cancel_timer(antirevel_warn_timer1),
    misc:cancel_timer(antirevel_warn_timer2),
    misc:cancel_timer(antirevel_warn_timer3),    
    ok.

%% 下线删除节点ETS表相关数据
delete_player_ets(PlayerId) ->
    %%清除玩家ets数据
    ets:delete(?ETS_ONLINE, PlayerId),
    %%清除任务模块及回存任务数据
    %lib_task:offline(PlayerId),
    %%删除在线玩家的ets物品表
    %goods_util:goods_offline(PlayerId, 1),
    ok.

%% --------------------------------------------------------------------
%% @spec 登陆的防沉迷处理
%%    input: acctount id
%% --------------------------------------------------------------------
online_antirevel(AcctId) ->
    case config:get_infant_ctrl(server) of
        1 -> %%防沉迷开启
            case db_agent:get_idcard_status(AcctId) of
                1 -> 
                    ok; %%成年人
                %未成年人或未填写
                _ ->
                    T_time = lib_antirevel:get_total_gametime(AcctId),
                    Alart_time_1h = data_antirevel:get_antirevel_con(warn_time1),    %%60*60 + 5,
                    Alart_time_2h = data_antirevel:get_antirevel_con(warn_time2),    %%120*60 + 5,
                    Alart_time = data_antirevel:get_antirevel_con(warn_time3),       %%(3*60-5)*60 + 5,
                    Force_out_time = data_antirevel:get_antirevel_con(act_time),     %%3*60*60 + 5,
                    if T_time >= Force_out_time ->  %%累计时间10秒后立刻退出，不开其他定时器了
                        ForceOutTimer = erlang:send_after(10*1000, self(), 'FORCE_OUT_REVEL'),
                        put(antirevel_act_timer, ForceOutTimer);
                    true ->
                        %%强制退出定时器
                        ForceOutTimer = erlang:send_after((Force_out_time - T_time + 10)*1000, self(), 'FORCE_OUT_REVEL'),
                        put(antirevel_act_timer, ForceOutTimer),
                        %%1小时通知
                        if T_time < Alart_time_1h ->
                           Timer_1h = erlang:send_after((Alart_time_1h - T_time) * 1000, self(), {'ALART_REVEL', 60}),
                           put(antirevel_warn_timer1, Timer_1h);
                        true -> ok
                        end,

                        %%两小时通知
                        if T_time < Alart_time_2h ->
                            Timer_2h = erlang:send_after((Alart_time_2h - T_time) * 1000, self(), {'ALART_REVEL', 120}),
                            put(antirevel_warn_timer2, Timer_2h);
                        true -> ok
                        end,

                        %%两小时55分钟能知
                        if T_time < Alart_time ->
                            Alart_timer = erlang:send_after((Alart_time - T_time) * 1000, self(), {'ALART_REVEL', 180}),
                            put(antirevel_warn_timer3, Alart_timer);
                        true -> ok
                        end
                    end
            end;
        _ -> 
            ok
    end .

%% 下线防沉迷处理
handle_offline_antirevel(Status, Now_time) ->
    case config:get_infant_ctrl(server) of
        1 -> %%防沉迷开启
            Accid = Status#player.id,
            case db_agent:get_idcard_status(Accid) of
                1 -> ok; %%成年人 
                _ ->
                    {TodayMidnight, _NextDayMidnight} = util:get_midnight_seconds(Now_time),
                     TotalTime = lib_antirevel:get_total_gametime(Accid), %%如果没有记录，这个函数会建立一条
                     case Status#player.last_login_time > TodayMidnight of
                         %今天登录的
                         true ->
                             NewTotalTime = TotalTime + tool:int_format(Now_time - Status#player.last_login_time);
                         %昨天登录 只记今天时间
                         false -> 
                             NewTotalTime = tool:int_format(Now_time - TodayMidnight)
                     end,
                     lib_antirevel:set_total_gametime(Accid, NewTotalTime),
                     lib_antirevel:set_logout_time(Accid, Now_time)
            end;
        _ -> ok
    end.

%% 更新本节点信息
update(PlayerStatus) ->
	ets:insert(?ETS_ONLINE, PlayerStatus).

%%协议测试函数
pp_test(PlayerId, Cmd, Data) ->
     case lib_player:get_player_pid(PlayerId) of 
         Pid when is_pid(Pid) ->  %%在线
             gen_server:call(Pid, {'SOCKET_EVENT', Cmd, Data});
         _Other ->  
             io:format("PlayerId: ~p is not online~n", [PlayerId])
     end.

%%处理玩家首次登陆游戏vip相关事务
check_vip(PlayerStatus) ->
    NowTime = util:unixtime(),
    if
        PlayerStatus#player.vip > 0 andalso PlayerStatus#player.vip_expire_time > NowTime ->
        NewPlayerStatus = lib_vip:check_vip_date_gift(PlayerStatus);%%处理VIP玩家首次登陆游戏事件
    true ->
        NewPlayerStatus = PlayerStatus
    end.
