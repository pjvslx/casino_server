-module(pt_12).
-export([read/2, write/2]).
-include("common.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%
read(_Cmd, _R) ->
    {error, no_match}.


write(12001, [PlayerId,PropId,ChangeValue,CurValue,Reason]) ->
	StrPlayerId = integer_to_list(PlayerId),
	BinPlayerId = pt:pack_string(StrPlayerId),

	StrChangeValue = integer_to_list(ChangeValue),
	BinChangeValue = pt:pack_string(StrChangeValue),

	StrCurValue = integer_to_list(CurValue),
	BinCurValue = pt:pack_string(StrCurValue),
    {ok, pt:pack(12001, <<BinPlayerId/binary, PropId:8, BinChangeValue/binary , BinCurValue/binary , Reason:8 >>)};

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
