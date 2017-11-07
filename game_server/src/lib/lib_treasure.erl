-module(lib_treasure).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

-record(cell, {
	index = 1,
	row = 1,
	col = 1,
	value = 0
    }).	

%% lib_treasure:bet(1).
bet(Level) ->
	if 
		Level == 1 ->
			BoundLimit = 4;
		Level == 2 ->
			BoundLimit = 5;
		Level == 3 ->
			BoundLimit = 6
	end,
	RandomList1 = random_many_num(BoundLimit * BoundLimit,[],1,5,BoundLimit),
	io:format("RandomList1 = ~p~n",[RandomList1]),
	Ret = make_all_clear(BoundLimit,RandomList1),
	Ret.

make_all_clear(BoundLimit,RandomList1)->
	% lists:foldl(fun(X, Sum) -> X + Sum end, 0, [1,2,3,4,5]).
	Ret = lists:foldl(
		fun(Cell,RetList) -> 
			List = make_clear_rule(Cell,Cell#cell.index,BoundLimit,RandomList1,RetList),
			if 
				length(RetList) == 0 ->
					if 
						length(List) >= 3 ->
							[List];
						true ->
							[]
					end;
				true ->
					if 
						length(List) >= 3 ->
							Element = lists:nth(1,RetList),
							if 
								is_list(Element) == true ->
									RetList ++ [List];
								true ->
									[RetList] ++ [List]
							end;
						true ->
							[]
					end
			end
		end,
			[],
			RandomList1
			),
	Ret.


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

random_many_num(Num,List,LowBound,HighBound,BoundLimit) ->
	% if 
	% 	Num rem BoundLimit == 0 ->
	% 		Row = Num div BoundLimit,
	% 		Col = BoundLimit;
	% 	true ->
	% 		Row = Num div BoundLimit + 1,
	% 		Col = Num rem BoundLimit
	% end,

	{Row,Col} = index_to_r_c(Num,BoundLimit),

	if
		Num == 1 ->
			RandomNum = util:rand(LowBound,HighBound),
			% RandomNum = 1,
			Cell = #cell{row = Row, col = Col, value = RandomNum, index = Num},
			Result = [Cell] ++ List;
		true ->
			RandomNum = util:rand(LowBound,HighBound),
			% RandomNum = 1,
			Cell = #cell{row = Row, col = Col, value = RandomNum, index = Num},
			NewList = [Cell] ++ List,
			NewNum = Num - 1,
			random_many_num(NewNum,NewList,LowBound,HighBound,BoundLimit)
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
make_clear_rule(Cell,Index,BoundLimit,RandomList1,LastRetList)->
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