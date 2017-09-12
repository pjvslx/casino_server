-module(pt_12).
-export([read/2, write/2]).
-include("common.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%

%%进入或切换场景
read(12001, << Type:8 >>) ->
    {ok, [Type]};

read(_Cmd, _R) ->
    {error, no_match}.


write(12001, [Result,SceneId,X,Y]) ->
    {ok, pt:pack(12001, <<Result:8, SceneId:8 , X:8 , Y:8 >>)};

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
