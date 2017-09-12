-module(pp_room).
-export([handle/3]).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-compile(export_all).

handle(Cmd, Player, Data) ->
	handle_cmd(Cmd, Player, Data).

handle_cmd(12001, Player, [Type]) ->
	%场景协议的东西 交给场景进程去处理
	SlotProcess = misc:create_process_name(slot_p,[]),
	SlotProcessId = misc:whereis_name({local,SlotProcess}),
	gen_server:cast(SlotProcessId,{add_player,Player#player.id}),
	%%更新当前游戏标识
	Other = Player#player.other,
	NewOther = Other#player_other{current_game = Type},
	NewPlayer = Player#player{other = NewOther},
	{ok, NewPlayer};

handle_cmd(_Cmd, _Socket, _Data) ->
    {error, "pp_room handle_cmd no match"}.