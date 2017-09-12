-module(pt_20).
-export([read/2, write/2]).
-include("common.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%

%%进入或切换场景
read(20001, << PlayerId:64 >>) ->
    {ok, [PlayerId]};

read(20003, << PlayerId:64 >>) ->
	{ok, [PlayerId]};

read(20005, << PlayerId:64 >>) ->
	{ok, [PlayerId]};

read(20006, << PlayerId:64 >>) ->
	{ok, [PlayerId]};

read(20008, _ ) ->
	{ok,[]};

read(20009, _) ->
	{ok,[]};

read(_Cmd, _R) ->
    {error, no_match}.

write(20001, [Code] ) ->
	{ok, pt:pack(20001, << Code:8 >> )};

write(20002, [PlayerId] ) ->
	{ok, pt:pack(20002, << PlayerId:64 >> )};

write(20003, [Code]) ->
	{ok, pt:pack(20003, << Code:8 >>)};

write(20004, [PlayerId]) ->
	{ok, pt:pack(20004, << PlayerId:64 >>)};

write(20005, [PlayerId,Code]) ->
	{ok, pt:pack(20005, << PlayerId:64, Code:8 >>)};

write(20006, [Code]) ->
	{ok, pt:pack(20006, << Code:8 >>)};

write(20007, [PlayerId]) ->
	{ok, pt:pack(20007, << PlayerId:64 >>)};

write(20008, [PlayerId]) ->
	{ok, pt:pack(20008, << PlayerId:64 >>)};

write(20009,[]) ->
	{ok, pt:pack(20009, <<>>)};
%% -----------------------------------------------------------------
%% 错误处理
%% -----------------------------------------------------------------
write(Cmd, _R) ->
?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.

%%------------------------------------
%% internal function
%%------------------------------------
pack_string(Str) ->
    BinData = tool:to_binary(Str),
    Len = byte_size(BinData),
    <<Len:16, BinData/binary>>.

any_to_binary(Any) ->
    tool:to_binary(Any).
