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
	Ret = make_all_clear(BoundLimit,RandomList1),
	Ret.

make_all_clear(BoundLimit,RandomList1)->
	% lists:foldl(fun(X, Sum) -> X + Sum end, 0, [1,2,3,4,5]).
	Ret = lists:foldl(
		fun(Cell,RetList) -> 
			List = make_clear_rule(Cell,Cell#cell.index,BoundLimit,RandomList1),
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

random_many_num(Num,List,LowBound,HighBound,BoundLimit) ->
	if 
		Num rem BoundLimit == 0 ->
			Row = Num div BoundLimit,
			Col = BoundLimit;
		true ->
			Row = Num div BoundLimit + 1,
			Col = Num rem BoundLimit
	end,

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

make_clear_rule(Cell,Index,BoundLimit,RandomList1)->
	RetList = [],
	NewRetList = search_sub_node(Cell,Index,RetList,BoundLimit,RandomList1),
	NewRetList.

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
			NewIndex1 = (Cell#cell.row - 1) * BoundLimit + (Cell#cell.col - 1),
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
			NewIndex2 = (Cell#cell.row - 1) * BoundLimit + (Cell#cell.col + 1),
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
			NewIndex3 = (Cell#cell.row - 1 - 1) * BoundLimit + Cell#cell.col,
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
			NewIndex4 = (Cell#cell.row - 1 + 1) * BoundLimit + Cell#cell.col,
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
	