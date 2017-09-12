-module(pt_13).
-export([read/2, write/2]).
-include("common.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%

%%进入或切换场景
read(13001, << Line:8 , Bet:32 >>) ->
    {ok, [Line,Bet]};

read(_Cmd, _R) ->
    {error, no_match}.


% write(13001, [CurrentCoin,WinCoin,DataList,LineList]) ->
%     {ok, pt:pack(12001, <<CurrentCoin,WinCoin>>)};

%% -----------------------------------------------------------------
%% 错误处理
%% -----------------------------------------------------------------
write(13001,[StCode]) ->
	{ok,pt:pack(13001,<< StCode:8 >>)};

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
