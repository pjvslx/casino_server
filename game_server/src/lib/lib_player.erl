%%%--------------------------------------
%%% @Module  : lib_player
%%% @Author  : 
%%% @Created : 2010.10.05
%%% @Description:角色相关处理
%%%--------------------------------------
-module(lib_player).
-compile(export_all).

-include("common.hrl").
-include("record.hrl"). 
-include("battle.hrl").
-include("log.hrl").
-include("goods.hrl").
-include("debug.hrl").
-include("leader.hrl").

-define(FIRST_PASSIVE_SKILL_LV,43).%%第一个被动技能点等级

%%获取在线玩家信息
get_player(PlayerId) ->
    case ets:lookup(?ETS_ONLINE, PlayerId) of
        [] ->
            {} ;
        [R] ->
            R
    end.

%%检测某个角色是否在线
is_online(PlayerId) ->
    case get_player_pid(PlayerId) of
        [] -> false;
        _Pid -> true
    end.

%%取得在线角色的进程PID
get_player_pid(PlayerId) ->
    PlayerProcessName = misc:player_process_name(PlayerId),
    case misc:whereis_name({local, PlayerProcessName}) of
        Pid when is_pid(Pid) ->  
            case misc:is_process_alive(Pid) of
                true -> Pid;
                _ ->
                    []
            end;
        _ -> []
    end.

%%根据ID调用异步调用玩家功能.
cast_player(PlayerId, Msg) ->
    PlayerProcessName = misc:player_process_name(PlayerId),
    case misc:whereis_name({local, PlayerProcessName}) of
        Pid when is_pid(Pid) ->
            case misc:is_process_alive(Pid) of
                true -> 
                    gen_server:cast(Pid, Msg),
                    true;
                _    ->
                    false 
            end;
        _ ->  false 
    end. 

%% 根据角色名称查找ID, 返回Id或[]
get_role_id_by_name(Name) ->
    db_agent_player:get_role_id_by_name(Name).

%%根据角色id查找名称, 返回<<"名字">>或[]
get_role_name_by_id(Id)->
    db_agent_player:get_role_name_by_id(Id).

%%获取模块开启状态, 返回数字或[]
get_switch_by_id(Id)->
    db_agent_player:get_switch_by_id(Id).

%%检测指定名称的角色是否已存在
is_accname_exists(AccName) ->
    case db_agent_player:is_accname_exists(AccName) of
        []     -> false;
        _Other -> true
    end.

%% 获取角色禁言信息
get_donttalk_status(PlayerId) ->
    case db_agent:get_donttalk(PlayerId) of
        [StopBeginTime, StopSeconds] ->
            [StopBeginTime, StopSeconds];
        _Other -> 
            db_agent:insert_donttalk(PlayerId),
            [0, 0]
    end.


%%检测指定名称的角色是否已存在
is_exists_name(Name) ->
    case get_role_id_by_name(Name) of
        []    -> false;
        _Other -> true
    end.

%%取得在线角色的角色状态
get_online_info(Id) ->
    case ets:lookup(?ETS_ONLINE, Id) of
        [] ->
            get_user_info_by_id(Id);
        [R] ->
            case misc:is_process_alive(R#player.other#player_other.pid) of
                true -> 
                    R;
                false ->
                    ets:delete(?ETS_ONLINE, Id),
                    []
            end
    end.

%%获取玩家信息
get_user_info_by_id(Id) ->
    case get_player_pid(Id) of
        []  -> [];
        Pid ->
            case catch gen:call(Pid, '$gen_call', 'PLAYER', 2000) of
                {'EXIT',_Reason} ->
                    [];
                {ok, Player} ->
                    Player
            end
    end.

%%获取用户信息(按字段需求)
get_online_info_fields(Id, L) when is_integer(Id) ->
    case get_player_pid(Id) of
        [] -> 
            [];
        Pid ->  
            get_online_info_fields(Pid, L)
    end;

get_online_info_fields(Pid, L) when is_pid(Pid) ->
    case catch gen:call(Pid, '$gen_call', {'PLAYER', L}, 2000) of
        {'EXIT',_Reason} ->
            [];
        {ok, PlayerFields} ->
            PlayerFields
    end.

%% 增加铜钱
add_coin(Status, 0) ->  
    Status;
add_coin(Status, Num) ->
    Coin = max(Status#player.coin + Num, 0),
    %%     db_agent_player:save_player_table(Status#player.id, [coin], [Coin]),
    Status#player{coin = Coin}.
%%消耗铜钱
cost_coin(Status, Num) ->
    Coin = max(Status#player.coin - Num, 0),
    %%     db_agent_player:save_player_table(Status#player.id, [coin], [Coin]),
    Status#player{coin = Coin}.

add_treasure_coin(Status, 0) ->
    Status;
add_treasure_coin(Status, Num) ->
    Coin = max(Status#player.other#player_other.treasure_score + Num, 0),
    NewOther = Status#player.other#player_other{treasure_score = Coin},
    Status#player{other = NewOther}.

cost_treasure_coin(Status, Num) ->
    Coin = max(Status#player.other#player_other.treasure_score - Num,0),
    NewOther = Status#player.other#player_other{treasure_score = Coin},
    Status#player{other = NewOther}.

handle_charge_order(Status) ->
    case db_agent_charge:get_all_no_handle_charge_order(Status#player.id) of
        [] -> Status;
        List -> 
        % id, order_id, game_id, server_id, account_id,pay_way, amount, gold, order_status, handle_status, create_time
            F = fun([Id, OrderId, GameId, ServerId,AccountId,Payway,Amount,Coin,OrderStatus,HandleStatus,CreateTime],Status1) ->
                    if OrderStatus =:= ?CHARGE_ORDER_STATUS_SUCCESSFUL -> 
                            NewStatus = add_coin(Status1,Coin);
                        true ->
                            NewStatus = Status1
                    end,
                    db_agent_charge:update_charge_handle_status(OrderId, ?HANDLE_CHARGE_ORDER),
                    {ok,BinData} = pt_12:write(12001,[Status#player.id,?PROP_COIN,Coin,NewStatus#player.coin,?REASON_CHARGE]),
                    lib_send:send_to_sid(Status#player.other#player_other.pid_send,BinData),
                    % lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData),
                    NewStatus
            end,
            lists:foldl(F, Status, List)
    end.
    %lib_vip:check_charge_vip(Status). %%检查通过充值获得VIP情况