-module(lib_treasure).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-define(TREASURE_DRILL_ID,           16).  %% 钻头的ID
-define(MAX_BIG_LEVEL,				  3).
-define(MAX_LITTLE_LEVEL,			 15).

-record(cell, {
	index = 1,
	row = 1,
	col = 1,
	value = 0
    }).	

add_level(Player) ->
	PlayerOther = Player#player.other,
	if
		PlayerOther#player_other.treasure_left_brick > 1 ->
			Full = false,
			NewPlayerOther = PlayerOther#player_other{ treasure_left_brick = PlayerOther#player_other.treasure_left_brick - 1};
		true ->
			if 
				PlayerOther#player_other.treasure_level == 3 ->
					Full = true,
					NewPlayerOther = PlayerOther;
				true ->
					Full = false,
					NewPlayerOther = PlayerOther#player_other{ treasure_level = PlayerOther#player_other.treasure_level + 1,treasure_left_brick = ?MAX_LITTLE_LEVEL}
			end
	end,
	{Full,Player#player{other = NewPlayerOther}}.

get_odds(Level,StoneId,Length)->
	DataList = tpl_treasure_mission:get_by_mission_stone_id_line_num(Level,StoneId,Length),
	if 
		length(DataList) == 0 ->
			0;
		true ->
			[E|L] = DataList,
			E#treasure_mission_config.odds_factor / 100
	end.

%% lib_treasure:bet(1).
bet(Player,BetCoins) ->
	Level = Player#player.other#player_other.treasure_level,
	io:format("Level = ~p~n",[Level]),
	BoundLimit = get_boundlimit_by_level(Level),
	RandomList1 = random_many_num(BoundLimit * BoundLimit,[],1,5,BoundLimit,false),
	OutputList = deal_one_round(Level,RandomList1,[],BetCoins),
	io:format("OutputList = ~p~n",[OutputList]),
	OutputList.

deal_one_round(Level,List,OutputList,BetCoins) ->
	BoundLimit = get_boundlimit_by_level(Level),
	MyRet = make_all_clear(Level,List,BetCoins),
	%%有钻头筛选出钻头形成第一波RoundInfo 没有则用正常的RoundInfo
	NewMyRet = lists:filter(
		fun(EList) ->
			length(EList) == 1
		end,
		MyRet
		),
	if
		length(NewMyRet) == 0 ->
			Ret = MyRet;
		true ->
			Ret = NewMyRet
	end,

	% io:format("Ret = ~p~n",[Ret]),
	AllInfo = lists:flatmap(
		fun(Cell)->
			[{Cell#cell.row,Cell#cell.col,Cell#cell.value}]
		end,
		List),
	if 
		length(Ret) > 0 ->
			RetList = lists:foldl(
				fun(RetCell,Sum)->
					RetCell ++ Sum
				end,
				[],
				Ret
			),
			%%过滤出未消除的
			FilterRet = lists:filter(
			fun(E) ->
				%%删除掉存在于Ret中的元素
				not lists:any(
					fun(E2)->
						E2#cell.index == E#cell.index
					end,
					RetList
					)
			end,
			List
			),

			RetInfo = lists:flatmap(
				fun(RetCell)->
					[{RetCell#cell.row,RetCell#cell.col,RetCell#cell.value}]
				end,
				RetList
			),
			%%将FilterRet按照重力原理重新组装
			GravityCellList = gravity(BoundLimit,FilterRet),
			FlattenCellList = lists:foldl(
				fun(ColCellList,Sum)->
					Sum ++ ColCellList
				end, 
				[],
				GravityCellList
				),

			NewCellList = generate_cell(FlattenCellList,BoundLimit),
			MergeCellList = lists:merge(FlattenCellList,NewCellList),
			SortMergeCellList = lists:sort(
				fun(Cell1,Cell2)->
					Cell1#cell.index < Cell2#cell.index
				end,
				MergeCellList
				),
			FormatRet = lists:foldl(
				fun(RetElement,Sum)->
					[RetCell|L] = RetElement,
					Odds = get_odds(Level,RetCell#cell.value,length(RetElement)),
					io:format("Odds = ~p BetCoins = ~p~n",[Odds,BetCoins]),
					Sum ++ [{RetElement,Odds * BetCoins}]
				end,
				[],
				Ret
				),
			AllResultInfo = [{AllInfo,FormatRet}],
			NewOutputList = OutputList ++ AllResultInfo,
			deal_one_round(Level,SortMergeCellList,NewOutputList,BetCoins);
		true ->
			AllResultInfo = [{AllInfo,[]}],
			NewOutputList = OutputList ++ AllResultInfo,
			NewOutputList
	end.

get_boundlimit_by_level(Level) ->
	io:format("Level = ~p~n",[Level]),
	if 
		Level == 1 ->
			BoundLimit = 4;
		Level == 2 ->
			BoundLimit = 5;
		Level == 3 ->
			BoundLimit = 6
	end.

can_clear(Level,StoneId,Length) ->
	if 
		StoneId == ?TREASURE_DRILL_ID ->
			true;
		true ->
			DataList = tpl_treasure_mission:get_by_mission_stone_id_line_num(Level,StoneId,Length),
		if 
			length(DataList) == 0 ->
				false;
			true ->
				true
		end
	end.
	

make_all_clear(Level,RandomList1,BetCoins)->
	io:format("make_all_clear ~n"),
	io:format("RandomList1 = ~p~n",[RandomList1]),
	BoundLimit = get_boundlimit_by_level(Level),
	% lists:foldl(fun(X, Sum) -> X + Sum end, 0, [1,2,3,4,5]).
	Ret = lists:foldl(
		fun(Cell,RetList) -> 
			List = make_clear_rule(Cell,Cell#cell.index,BoundLimit,RandomList1,RetList,BetCoins),
			ListLen = length(List),
			CanClear = can_clear(Level,Cell#cell.value,ListLen),
			if 
				length(RetList) == 0 ->
					if 
						CanClear == true ->
							[List];
						true ->
							[]
					end;
				true ->
					if 
						CanClear == true ->
							Element = lists:nth(1,RetList),
							if 
								is_list(Element) == true ->
									RetList ++ [List];
								true ->
									[RetList] ++ [List]
							end;
						true ->
							RetList
					end
			end
		end,
			[],
			RandomList1
			),
	Ret.

%%
% X X O O X		  	X X X X X
% O O X X O         X X X X X
% X O O X X    ->   X X O X O
% X X X O O         O O O O O
% O X O X O         O O O O O

% 统计出每一列缺多少个门牙 
% lib_treasure:gravity_test(5,List).
gravity_test(BoundLimit,List) ->
	BoundList = lists:seq(1,BoundLimit),
	lists:map(
		fun(Col)->
			lists:filter(
				fun(E)->
					{R,C} = index_to_r_c(E,BoundLimit),
					C == Col
				end,
				List
				)
		end,
		BoundList
		).

gravity(BoundLimit,CellList)->
	BoundList = lists:seq(1,BoundLimit),
	%% 按照Col进行分类
	ClassListByCol = lists:map(
		fun(Col)->
			lists:filter(
				fun(Cell)->
					Col == Cell#cell.col
				end,
				CellList
				)
		end,
		BoundList
		),

	lists:map(
		fun(Col)->
			ColCellList = lists:nth(Col,ClassListByCol),
			Length = length(ColCellList),
			LengthList = lists:seq(1,Length),
			lists:map(
				fun(Row)->
					Cell = lists:nth(Row,ColCellList),
					NewIndex = r_c_to_index(Row,Col,BoundLimit),
					NewCell = #cell{row = Row, col = Col, value = Cell#cell.value, index = NewIndex}
				end,
				LengthList
				)
		end,
		BoundList
		).



rand_fill_list(Level,List,LowBound,HighBound,BoundLimit) ->
	if 
		Level == 1 ->
			AllIndexList = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
		Level == 2 ->
			AllIndexList = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25];
		Level == 3 ->
			AllIndexList = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36];
		true ->
			AllIndexList = []
	end,

	Ret = lists:foldl(
		fun(Index,CellList) ->
			IsContain = lists:any(
				fun(E)->
					E#cell.index == Index
				end,
				List
				),
			if 
				IsContain /= true ->
					CellList ++ [Index];
				true ->
					CellList
			end
		end,
		[],
		AllIndexList
		),
	Ret.

%% lib_treasure:rand_fill_list_test(1,[1,3,5,7,9,11],1,1,5).
rand_fill_list_test(Level,List,LowBound,HighBound,BoundLimit) ->
	if 
		Level == 1 ->
			AllIndexList = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
		Level == 2 ->
			AllIndexList = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25];
		Level == 3 ->
			AllIndexList = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36];
		true ->
			AllIndexList = []
	end,

	Ret = lists:foldl(
		fun(Index,CellList) ->
			IsContain = lists:any(
				fun(E)->
					E == Index
				end,
				List
				),
			if 
				IsContain /= true ->
					io:format("Index[~p] is not in the AllList~n",[Index]),
					CellList ++ [Index];
				true ->
					CellList
			end
		end,
		[],
		AllIndexList
		).

generate_cell(CellList,BoundLimit)->
	if 
		BoundLimit == 4 ->
			LowBound = 1,
			HighBound = 5;
		BoundLimit == 5 ->
			LowBound = 6,
			HighBound = 10;
		true ->
			LowBound = 11,
			HighBound = 15
	end,
	BoundList = lists:seq(1,BoundLimit * BoundLimit),
	lists:foldl(
		fun(Index,RetList)->
			Exist = lists:any(
				fun(Cell)->
					Cell#cell.index == Index
				end,
				CellList
				),
			if
				Exist == true ->
					RetList;
				true ->
					RandomNum = util:rand(LowBound,HighBound),
					{Row,Col} = index_to_r_c(Index,BoundLimit),
					NewCell = #cell{row = Row, col = Col, value = RandomNum, index = Index},
					RetList ++ [NewCell]
			end
		end,
		[],
		BoundList
		).

%% Fenzi 10 Fenmu 100 说明随机出钻头的概率是10/100
random_drill(Fenzi,Fenmu) ->
	RandomNum = util:rand(1,Fenmu),
	if 
		RandomNum =< Fenzi ->
			true;
		true ->
			false
	end.

%% Num要随机产生的Cell个数
%% List结果累计
%% LowBound随机出stone_id的最小值
%% HighBound随机出stone_id的最大值
%% BoundLimit 4*4 or 5*5 or 6*6
%% HasDrill是否已经随机出钻头 已随机出后续就不能再随机了

%% random_many_num只能用于第一次生成宝石 后续只能用generate_cell
random_many_num(Num,List,LowBound,HighBound,BoundLimit,HasDrill) ->
	{Row,Col} = index_to_r_c(Num,BoundLimit),
	if
		Num == 1 ->
			if 
				HasDrill == false ->
					IsDrill = random_drill(5,100),
					if 
						IsDrill == true ->
							RandomNum = ?TREASURE_DRILL_ID;
						true ->
							RandomNum = util:rand(LowBound,HighBound)
					end;
				true ->
					RandomNum = util:rand(LowBound,HighBound)
			end,
			Cell = #cell{row = Row, col = Col, value = RandomNum, index = Num},
			Result = [Cell] ++ List;
		true ->
			if 
				HasDrill == false ->
					IsDrill = random_drill(5,100),
					if  
						IsDrill == true ->
							RandomNum = ?TREASURE_DRILL_ID;
						true ->
							RandomNum = util:rand(LowBound,HighBound)
					end;
				true ->
					RandomNum = util:rand(LowBound,HighBound)
			end,
			Cell = #cell{row = Row, col = Col, value = RandomNum, index = Num},
			NewList = [Cell] ++ List,
			NewNum = Num - 1,
			if 
				HasDrill == true ->
					NewHasDrill = HasDrill;
				true ->
					if 
						RandomNum == ?TREASURE_DRILL_ID ->
							NewHasDrill = true;
						true ->
							NewHasDrill = false
					end
			end,
			random_many_num(NewNum,NewList,LowBound,HighBound,BoundLimit,NewHasDrill)
	end.

is_cell_in_list(Cell,CellList)->
	Length = length(CellList),
	if 
		Length == 0 ->
			false;
		true ->
			[E|NewCellList] = CellList,
			if 
				(E#cell.row == Cell#cell.row) and (E#cell.col == Cell#cell.col) ->
					true;
				true ->
					is_cell_in_list(Cell,NewCellList)
			end
	end.

%%Cell 当前search的Cell
%%Index 索引
%%BoundLimit边界 4*4 5*5 6*6
%%RandomList1 随机出的总的Cell列表
%%LastRetList 上一次make_clear_rule得到的结果
make_clear_rule(Cell,Index,BoundLimit,RandomList1,LastRetList,BetCoins)->
	LastLength = length(LastRetList),
	if
		LastLength == 0 ->
			NeedSearch = true;
		true ->
			LastRetElement = lists:nth(1,LastRetList),
			if 
				is_list(LastRetElement) == true ->
					Ret = lists:foldl(
						fun(X,IsCellInList)-> 
							Ret = is_cell_in_list(Cell,X),
							Ret or IsCellInList
						end,
						false,
						LastRetList
						),
					NeedSearch = not Ret;
				true ->
					%%LastRetList为一维列表 直接判断Cell存不存在与LastRetList
					IsCellInList = is_cell_in_list(Cell,LastRetList),
					NeedSearch = not IsCellInList
			end
	end,

	if 
		NeedSearch == true ->
			RetList = [],
			NewRetList = search_sub_node(Cell,Index,RetList,BoundLimit,RandomList1),
			NewRetList;
		true ->
			[]
	end.

is_cell_valid(Row,Col,RandomList1)->
	Length = length(RandomList1),
	if 
		Length == 0 ->
			false;
		true ->
			[E|NewRandomList] = RandomList1,
			if
				(E#cell.row == Row) and (E#cell.col == Col) ->
					true;
				true ->
					is_cell_valid(Row,Col,NewRandomList)
			end
	end.

search_sub_node(Cell,Index,RetList,BoundLimit,RandomList1)->
	IsCellInList = is_cell_in_list(Cell,RetList),
	%%找出Index对应的row和row
	if 
		IsCellInList == false ->
			NewRetList = RetList ++ [Cell],
			IsCellValid1 = is_cell_valid(Cell#cell.row, Cell#cell.col - 1,RandomList1),
			% NewIndex1 = (Cell#cell.row - 1) * BoundLimit + (Cell#cell.col - 1),
			NewIndex1 = r_c_to_index(Cell#cell.row,Cell#cell.col - 1,BoundLimit),
			if 
				IsCellValid1 == true ->
					NewCell1 = lists:nth(NewIndex1,RandomList1),
					if 
						NewCell1#cell.value == Cell#cell.value ->
							FinalList1 = search_sub_node(NewCell1,NewIndex1,NewRetList,BoundLimit,RandomList1);
						true->
							FinalList1 = NewRetList
					end;
				true ->
					FinalList1 = NewRetList
			end,

			IsCellValid2 = is_cell_valid(Cell#cell.row, Cell#cell.col + 1,RandomList1),
			% NewIndex2 = (Cell#cell.row - 1) * BoundLimit + (Cell#cell.col + 1),
			NewIndex2 = r_c_to_index(Cell#cell.row,Cell#cell.col + 1,BoundLimit),
			if 
				IsCellValid2 == true ->
					NewCell2 = lists:nth(NewIndex2,RandomList1),
					if 
						NewCell2#cell.value == Cell#cell.value ->
							FinalList2 = search_sub_node(NewCell2,NewIndex2,FinalList1,BoundLimit,RandomList1);
						true->
							FinalList2 = FinalList1
					end;
				true ->
					FinalList2 = FinalList1
			end,

			IsCellValid3 = is_cell_valid(Cell#cell.row - 1, Cell#cell.col,RandomList1),
			% NewIndex3 = (Cell#cell.row - 1 - 1) * BoundLimit + Cell#cell.col,
			NewIndex3 = r_c_to_index(Cell#cell.row - 1,Cell#cell.col,BoundLimit),
			if 
				IsCellValid3 == true ->
					NewCell3 = lists:nth(NewIndex3,RandomList1),
					if 
						NewCell3#cell.value == Cell#cell.value ->
							FinalList3 = search_sub_node(NewCell3,NewIndex3,FinalList2,BoundLimit,RandomList1);
						true->
							FinalList3 = FinalList2
					end;
				true ->
					FinalList3 = FinalList2
			end,

			IsCellValid4 = is_cell_valid(Cell#cell.row + 1, Cell#cell.col,RandomList1),
			% NewIndex4 = (Cell#cell.row - 1 + 1) * BoundLimit + Cell#cell.col,
			NewIndex4 = r_c_to_index(Cell#cell.row + 1,Cell#cell.col,BoundLimit),
			if 
				IsCellValid4 == true ->
					NewCell4 = lists:nth(NewIndex4,RandomList1),
					if 
						NewCell4#cell.value == Cell#cell.value ->
							FinalList4 = search_sub_node(NewCell4,NewIndex4,FinalList3,BoundLimit,RandomList1);
						true->
							FinalList4 = FinalList3
					end;
				true ->
					FinalList4 = FinalList3
			end,
			FinalList4;
		true ->
			RetList
	end.
	
%% 行列转索引
%% lib_treasure:r_c_to_index(2,5,5).
r_c_to_index(Row,Col,BoundLimit) ->
	Index = (Row - 1) * BoundLimit + Col.

%% 索引转行列
%% lib_treasure:index_to_r_c(10,5).
index_to_r_c(Index,BoundLimit) ->
	if 
		Index rem BoundLimit == 0 ->
			Row = Index div BoundLimit,
			Col = BoundLimit;
		true ->
			Row = Index div BoundLimit + 1,
			Col = Index rem BoundLimit
	end,
	{Row,Col}.