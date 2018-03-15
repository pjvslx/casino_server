-module(pt_15).
-export([read/2, write/2]).
-include("common.hrl").
-include("table_to_record.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%
read(15000, _) ->
    {ok,[]};

read(_Cmd, _R) ->
    {error, no_match}.


write(15001, RankList) ->
    Length = length(RankList),
    F = fun({Uid,Recharge,Coin,Nick,Head}) ->
        StrUid = integer_to_list(Uid),
        BinUid = pt:pack_string(StrUid),
        BinNick = pt:pack_string(Nick),
        BinHead = pt:pack_string(Head),
        StrCoin = integer_to_list(Coin),
        BinCoin = pt:pack_string(StrCoin),
        <<BinUid/binary,BinNick/binary,BinHead/binary,BinCoin/binary,Recharge:32>>
    end,
    Bin = list_to_binary(lists:map(F,RankList)),
    if
        Length /= 0 ->
            {ok, pt:pack(15001,<<Length:16,Bin/binary>>)};
        true ->
            {ok, pt:pack(15001,<<Length:16>>)}
    end;

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
