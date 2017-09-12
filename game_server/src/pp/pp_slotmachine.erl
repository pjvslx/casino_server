-module(pp_slotmachine).
-export([handle/3]).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-compile(export_all).

handle(Cmd, Player, Data) ->
	handle_cmd(Cmd, Player, Data).

handle_cmd(13001, Player, [Line,Bet,Coin]) ->
	%发送到老虎机进程去进行处理

	Other = Player#player.other,
	GameType = Other#player_other.current_game,
	if 
		GameType == 1 ->
			NeedCoin = Bet*Line,
			if
				NeedCoin < Coin ->
					{ok,Data13001} = pt_13:write(13001,[1]),
					lib_send:send_to_sid(Player#player.other#player_other.pid_send, Data13001);
				true ->	
					SlotProcess = misc:create_process_name(slot_p,[]),
					SlotProcessId = misc:whereis_name({local,SlotProcess}),
					gen_server:cast(SlotProcessId,{bet,Player#player.id,Line,Bet,Player#player.coin})
			end;
		true ->
			io:format("GameType is not slot_machine ~n")
	end,
	{ok,Player};

handle_cmd(_Cmd, _Socket, _Data) ->
    {error, "pp_cmd handle_account no match"}.