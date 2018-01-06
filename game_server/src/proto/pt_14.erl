-module(pt_14).
-export([read/2, write/2]).
-include("common.hrl").
-include("record.hrl").

read(14001, _) ->
    {ok, []};

read(14002, <<BetLineNum:8, BetBin/binary>>) ->
	{Bet,_} = pt:read_string(BetBin),
	io:format("BetLineNum = ~p,Bet = ~p~n",[BetLineNum,Bet]),
	{ok, [BetLineNum,list_to_integer(Bet)]};

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
write(14000, [Mission1,Mission2,Mission3]) ->
	F = fun(Config) ->
		StoneId = Config#treasure_mission_config.stone_id,
		LineNum = Config#treasure_mission_config.line_num,
		OddFactor = Config#treasure_mission_config.odds_factor,
		<<StoneId:8,LineNum:8,OddFactor:32>> 
	end,
	Length1 = length(Mission1),
	ListBin1 = list_to_binary(lists:map(F,Mission1)),
	Length2 = length(Mission2),
	ListBin2 = list_to_binary(lists:map(F,Mission2)),
	Length3 = length(Mission3),
	ListBin3 = list_to_binary(lists:map(F,Mission3)),
	{ok,pt:pack(14000,<<Length1:16,ListBin1/binary,Length2:16,ListBin2/binary,Length3:16,ListBin3/binary>>)};

write(14001, [Level,LeftBrick,TotalCoins,GameCoins,PoolCoins,MinBet,MaxBet,LineList]) ->
	Length = length(LineList),
	F = fun(Line) ->
		<<Line:8>>
	end,
	ListBin = list_to_binary(lists:map(F,LineList)),
	StrTotalCoins = integer_to_list(TotalCoins),
	TotalCoinsBin = pt:pack_string(StrTotalCoins),

	StrGameCoins = integer_to_list(GameCoins),
	GameCoinsBin = pt:pack_string(StrGameCoins),

	StrPoolCoins = integer_to_list(PoolCoins),
	PoolCoinsBin = pt:pack_string(StrPoolCoins),
	{ok, pt:pack(14001,<<Level:8,LeftBrick:8,TotalCoinsBin/binary,GameCoinsBin/binary,PoolCoinsBin/binary,MinBet:32,MaxBet:32,Length:16,ListBin/binary>>)};

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
			fun(ClearData)->
				{ClearCellList,ClearReward} = ClearData,
				InnerLength = length(ClearCellList),
				ListBin = list_to_binary(lists:map(
					fun(Cell)->
						{cell,Index,Row,Col,Value} = Cell,
						<<Row:8,Col:8,Value:8>>
					end,
					ClearCellList
					)),
				Reward = tool:floor(ClearReward),
				StrReward = integer_to_list(Reward),
				RewardBin = pt:pack_string(StrReward),
				<<InnerLength:16,ListBin/binary,RewardBin/binary>>
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

write(14007, [Level,LeftBrick]) ->
	{ok, pt:pack(14007,<<Level:8,LeftBrick:8>>)};

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
