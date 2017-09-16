-module(pp_treasure).
-export([handle/3]).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-compile(export_all).

handle(Cmd, Player, Data) ->
	handle_cmd(Cmd, Player, Data).

handle_cmd(14001, Player, [Test]) ->
	%发送到老虎机进程去进行处理
	io:format("handle_cmd 14001 Test = ~p~n",[Test]),
	{ok,Player};

handle_cmd(_Cmd, _Socket, _Data) ->
    {error, "pp_cmd handle_account no match"}.