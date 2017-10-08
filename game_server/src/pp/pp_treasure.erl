-module(pp_treasure).
-export([handle/3]).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-compile(export_all).

handle(Cmd, Player, Data) ->
	handle_cmd(Cmd, Player, Data).

%%write(14001, [Level,LeftBrick,TotalCoins,GameCoins,PoolCoins,MinBet,MaxBet,LineList]) ->
handle_cmd(14001, Player, _) ->
	PlayerOther = Player#player.other,
	{ok,Data14001} = pt_14:write(14001,[PlayerOther#player_other.treasure_level,PlayerOther#player_other.treasure_left_brick,Player#player.coin,PlayerOther#player_other.treasure_score,9999999888888,20,200,[1,2,3,4,5]]),
	lib_send:send_to_sid(Player#player.other#player_other.pid_send, Data14001),
	{ok,Player};

handle_cmd(14006, Player, _) ->
	Level1 = 1,
	tpl_treasure_mission:get_by_mission(Level1),
	Level2 = 2,
	tpl_treasure_mission:get_by_mission(Level2),
	Level3 = 3,
	tpl_treasure_mission:get_by_mission(Level3),
	pass;

handle_cmd(_Cmd, _Socket, _Data) ->
    {error, "pp_cmd handle_account no match"}.