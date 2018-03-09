-module(pp_treasure).
-export([handle/3]).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-compile(export_all).

handle(Cmd, Player, Data) ->
	handle_cmd(Cmd, Player, Data).

%%write(14001, [Level,LeftBrick,TotalCoins,GameCoins,PoolCoins,MinBet,MaxBet,LineList]) ->
handle_cmd(14001, Player, _) ->
	PlayerOther = Player#player.other,
	Mission1 = tpl_treasure_mission:get_by_mission(1),
	Mission2 = tpl_treasure_mission:get_by_mission(2),
	Mission3 = tpl_treasure_mission:get_by_mission(3),
	{ok,Data14000} = pt_14:write(14000,[Mission1,Mission2,Mission3]),
	lib_send:send_to_sid(Player#player.other#player_other.pid_send,Data14000),
	{ok,Data14001} = pt_14:write(14001,[PlayerOther#player_other.treasure_level,PlayerOther#player_other.treasure_left_brick,Player#player.coin,PlayerOther#player_other.treasure_score,9999999888888,20,200,[1,2,3,4,5]]),
	lib_send:send_to_sid(Player#player.other#player_other.pid_send, Data14001),
	{ok,Player};

% [{[{1,1,2},
%    {1,2,4},
%    {1,3,5},
%    {1,4,1},
%    {2,1,5},
%    {2,2,1},
%    {2,3,1},
%    {2,4,5},
%    {3,1,2},
%    {3,2,1},
%    {3,3,4},
%    {3,4,1},
%    {4,1,2},
%    {4,2,5},
%    {4,3,5},
%    {4,4,5}],
%   [{4,4},{4,3},{4,2}]}]

handle_cmd(14002, Player, [LineNum,BetNum]) ->
	PlayerOther = Player#player.other,
	CostCoin = LineNum * BetNum,
	PlayerCoins = Player#player.coin,
	TreasureCoins = PlayerOther#player_other.treasure_score,
	TotalCoins = PlayerCoins + TreasureCoins,
	if 
		TotalCoins >= CostCoin ->
			CanBet = true;
		true ->
			CanBet = false
	end,

	if 
		CanBet == true ->
			%%优先扣除夺宝金币
			if 
				CostCoin > TreasureCoins ->
					NewPlayer1 = lib_player:cost_treasure_coin(Player,CostCoin),
					% TC = NewPlayer1#player.other#player_other.treasure_score,
					{ok,Data12001_1} = pt_12:write(12001,[Player#player.id,100,-CostCoin,NewPlayer1#player.other#player_other.treasure_score,1]),
					lib_send:send_to_sid(Player#player.other#player_other.pid_send, Data12001_1),
					NewPlayer2 = lib_player:cost_coin(NewPlayer1, CostCoin - TreasureCoins ),
					{ok,Data12001_2} = pt_12:write(12001,[Player#player.id,1,-(CostCoin - TreasureCoins),NewPlayer2#player.coin,1]),
					lib_send:send_to_sid(Player#player.other#player_other.pid_send, Data12001_2);
				true ->
					NewPlayer2 = lib_player:cost_treasure_coin(Player,CostCoin),
					{ok,Data12001_1} = pt_12:write(12001,[Player#player.id,100,-CostCoin,NewPlayer2#player.other#player_other.treasure_score,1]),
					lib_send:send_to_sid(Player#player.other#player_other.pid_send, Data12001_1)
			end,
			DataList = lib_treasure:bet(NewPlayer2,BetNum),
			{ok,Data14002} = pt_14:write(14002,DataList),
			AllReward = lists:foldl(
							fun({_,ClearInfoList},Sum)->
								lists:foldl(
									fun(ClearInfo,SubSum)->
										{_,ClearReward} = ClearInfo,
										SubSum + tool:floor(ClearReward)
									end,
									Sum,
									ClearInfoList
									)
							end,
							0,
							DataList
							),
			RewardPlayer = lib_player:add_treasure_coin(NewPlayer2,AllReward),
			if 
				AllReward > 0 ->
					{ok,Data12001_3} = pt_12:write(12001,[Player#player.id,100,AllReward,RewardPlayer#player.other#player_other.treasure_score,2]),
					lib_send:send_to_sid(Player#player.other#player_other.pid_send, Data12001_3);
				true ->
					pass
			end,
			%%判断有没有消除钻头 如果有就过关
			HasDrill = lists:any(
				fun({_,ClearInfoList})-> 
					lists:any(
						fun({ClearCellList,SubSum})->
							length(ClearCellList) == 1 
						end,
						ClearInfoList
						)
				end,
				DataList
				),

			if 
				HasDrill == true ->
					{Full,FinalPlayer} = lib_treasure:add_level(RewardPlayer),
					{ok,Data14007} = pt_14:write(14007,[FinalPlayer#player.other#player_other.treasure_level,FinalPlayer#player.other#player_other.treasure_left_brick]),
					lib_send:send_to_sid(Player#player.other#player_other.pid_send, Data14007);
				true ->
					FinalPlayer = RewardPlayer
			end;
		true ->
			FinalPlayer = Player,
			{ok,Data14002} = pt_14:write(14002,[])
	end,
	lib_send:send_to_sid(Player#player.other#player_other.pid_send, Data14002),
	{ok,FinalPlayer};

handle_cmd(14005, Player, _) ->
	NewPlayer = lib_treasure:reset_level(Player),
	{ok,NewPlayer};

handle_cmd(14006, Player, _) ->
	Level1 = 1,
	tpl_treasure_mission:get_by_mission(Level1),
	Level2 = 2,
	tpl_treasure_mission:get_by_mission(Level2),
	Level3 = 3,
	tpl_treasure_mission:get_by_mission(Level3),
	{ok,Player};

handle_cmd(_Cmd, _Socket, _Data) ->
    {error, "pp_cmd handle_account no match"}.