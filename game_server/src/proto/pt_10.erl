%%%-----------------------------------
%%% @Module  : pt_10
%%% @Author  : smxx
%%% @Created : 2013.10.05
%%% @Description: 10帐户信息
%%%-----------------------------------
-module(pt_10).
-export([read/2, write/2]).
-include("common.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%

%%登陆
read(10000, <<_Sn:16, Accid:32, Tstamp:32, Bin/binary>>) ->
    {Accname, Bin1} = pt:read_string(Bin),
    {Ticket, _} = pt:read_string(Bin1),
    {ok, login, [Accid, Accname,Tstamp,Ticket]};

%%退出
read(10001, _) ->
    {ok, logout};

%%创建角色
read(10003, <<_Sn:16, Sex:8, NameBin/binary>>) -> 
    {Name,_} = pt:read_string(NameBin), 
    io:format("------10003 is read Name = [~p]~n",[Name]),
    {ok, create, [Sex, Name]};
 
%%选择角色进入游戏 
read(10004, <<_Sn:16, Id:64>>) -> 
    {ok, enter, [Id]};

%%心跳包
read(10006, _) ->
    {ok, heartbeat};

%% 创建角色后, 真正进入游戏
read(10011, <<Uid:32>>) ->
    {ok, real_play, [Uid]};

%%进入角色创建页面
read(10020, <<Accid:32>>) ->
    {ok, getin_createpage,[Accid]};

read(_Cmd, _R) ->
    ?ERROR_MSG("~s pt_10 reading cmd_[~p], Data:~p~n",[misc:time_format(game_timer:now()), _Cmd, _R]),
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%网关登陆
write(9999, [Host, Port]) ->
    HL = byte_size(Host),
    Data = <<HL:16, Host/binary, Port:16>>,
    {ok, pt:pack(9999, Data)};

%%登陆返回
write(10000, [Code, NewAcId, L]) ->
    case L of
        [] ->
            io:format("write(10000) L = <<>>"),
            LB = <<>>;            
        _ ->    
            [Uid, Status, Lv, Career,Sex, Name, Scene, X, Y, DramaList] = L,
            Fun = fun(DramaId) ->
                <<DramaId:16>>
            end,
            NameBin = pt:pack_string(Name),  
            NewDramaList = util:bitstring_to_term(DramaList),
            List_len = length(NewDramaList),
            Test = lists:map(Fun,NewDramaList),
            List_ABin = pt:any_to_binary(Test),
            List_ABinData = <<List_len:16,List_ABin/binary>>,
            io:format("Scene = ~p~n" ,[Scene]),
            LB = <<Uid:64, Status:8, Career:8, Sex:8, Lv:8, NameBin/binary, Scene:8 , X:8 , Y:8 , List_ABinData/binary>>
    end,
    Data = <<Code:8, NewAcId:32, LB/binary>>,
    {ok, pt:pack(10000, Data)};

%%退出登录
write(10001, _) ->
    {ok,  pt:pack(10001, <<>>)};

%%创建角色
write(10003, [Code, RoleId]) ->
    io:format("-------write 10003 Code[~p] RoleId[~p]~n",[Code,RoleId]),
    Data = <<Code:8, RoleId:64>>,
    {ok,  pt:pack(10003, Data)};

%%选择角色进入游戏
write(10004, Code) ->
    Data = <<Code:8>>,
    {ok, pt:pack(10004, Data)};

%%心跳包
write(10006, _) ->
    Data = <<>>,
    {ok, pt:pack(10006, Data)};

%%被下线通知
write(10007, Code) ->
    Data = <<Code:8>>,
    {ok, pt:pack(10007, Data)};

%%登陆过程监测
write(10009,[N])->
    Data = <<N:16>>,
    {ok,pt:pack(10009,Data)}; 

write(Cmd, _R) ->
    ?ERROR_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.
