-module(pt_14).
-export([read/2, write/2]).
-include("common.hrl").

read(14001, _) ->
    {ok, []};

read(14002, <<BetLineNum:8, Bet:64>>) ->
	{ok, [BetLineNum,Bet]};

read(14003, _) ->
	{ok, []};

read(14005, _) ->
	{ok, []};

read(_Cmd, _R) ->
    {error, no_match}.


% write(13001, [CurrentCoin,WinCoin,DataList,LineList]) ->
%     {ok, pt:pack(12001, <<CurrentCoin,WinCoin>>)};

%% -----------------------------------------------------------------
%% 错误处理
%% -----------------------------------------------------------------
write(14001, [Level,LeftBrick,TotalCoins,GameCoins,PoolCoins,MinBet,MaxBet,LineList]) ->
	Length = length(LineList),
	F = fun(Line) ->
		<<Line:8>>
	end,
	ListBin = list_to_binary(lists:map(F,LineList)),
	{ok, pt:pack(14001,<<Level:8,LeftBrick:8,TotalCoins:64,GameCoins:64,PoolCoins:64,MinBet:32,MaxBet:32,Length:16,ListBin/binary>>)};

write(14002,Data) ->
	Length = length(Data),
	F = fun(RoundUnit)->
		{AllInfoList,ClearInfoList} = RoundUnit,
		AllLength = length(AllInfoList),
		ClearLength = length(ClearInfoList),
		AllListBin = list_to_binary(lists:map(
			fun(AllCellUnit)->
				{Row,Col,Value} = AllCellUnit,
				<<Row:8,Col:8,Value:8>>
			end,
			AllInfoList
			)),
		ClearListBin = list_to_binary(lists:map(
			fun(ClearCellUnit)->
				{Row,Col,Value} = ClearCellUnit,
				<<Row:8,Col:8,Value:8>>
			end,
			ClearInfoList
			)),
		<<AllLength:16,AllListBin/binary,ClearLength:16,ClearListBin/binary>>
	end,
	ListBin = list_to_binary(lists:map(F,Data)),
	if 
		Length /= 0 ->
			{ok, pt:pack(14002,<<0:8,Length:16,ListBin/binary>>)};
		true ->
			{ok, pt:pack(14002,<<1:8,Length:16>>)}
	end;

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
