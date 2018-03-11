-module(pp_rank).
-export([handle/3]).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-compile(export_all).

handle(Cmd, Player, Data) ->
    handle_cmd(Cmd, Player, Data).

% 获取配置
handle_cmd(15000, Player, _) ->
    RankPid = mod_rank:get_mod_rank_pid(),
    RankList = gen_server:call(RankPid,{get_rank_by_coin}),
    {ok,Data15001} = pt_15:write(15001,RankList),
    lib_send:send_to_sid(Player#player.other#player_other.pid_send,Data15001),
    {ok,Player};
handle_cmd(_Cmd, _Socket, _Data) ->
    {error, "pp_shop handle_cmd no match"}.