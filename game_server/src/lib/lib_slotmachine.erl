-module(lib_slotmachine).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

show_list() ->
	IdList = get(id_list),
	lists:foreach( 	fun(Id) ->
					io:format("Id = ~p~n",[Id])
					end,
					IdList).			

add_player({PlayerId},State) ->
	IdList = get(id_list),
	if
		IdList == undefined ->
			NewIdList1 = [PlayerId];
		true ->
			NewIdList = IdList ++ [PlayerId],
			NewIdList1 = lists:usort(NewIdList)
	end,
	put(id_list,NewIdList1),
	ok.

remove_player({PlayerId},State) ->
	IdList = get(id_list),
	NewIdList = lists:delete(PlayerId,IdList),
	put(id_list,NewIdList),
	ok.

bet({PlayerId,Line,Num,Coin},State) ->
	io:format("bet PlayerId = [~p],Line = [~p],Num = [~p],Coin = [~p]~n",[PlayerId,Line,Num,Coin]),
	%随机出15个数出来 总共有十中图标
	%util:random()
	RandomList1 = random_many_num(5,[]),
	RandomList2 = random_many_num(5,[]),
	RandomList3 = random_many_num(5,[]),
	if 
		Line == 1 ->
			Result1 = due_to_line_one(RandomList1,RandomList2,RandomList3),
			Result = Result1;
		Line == 2 ->
			Result1 = due_to_line_one(RandomList1,RandomList2,RandomList3),
			Result2 = due_to_line_two(RandomList1,RandomList2,RandomList3),
			Result = Result1 ++ Result2;
		Line == 3 ->
			Result1 = due_to_line_one(RandomList1,RandomList2,RandomList3),
			Result2 = due_to_line_two(RandomList1,RandomList2,RandomList3),
			Result3 = due_to_line_three(RandomList1,RandomList2,RandomList3),
			Result = Result1 ++ Result2 ++ Result3;
		Line == 4 ->
			Result1 = due_to_line_one(RandomList1,RandomList2,RandomList3),
			Result2 = due_to_line_two(RandomList1,RandomList2,RandomList3),
			Result3 = due_to_line_three(RandomList1,RandomList2,RandomList3),
			Result4 = due_to_line_four(RandomList1,RandomList2,RandomList3),
			Result = Result1 ++ Result2 ++ Result3 ++ Result4;
		Line == 5 ->
			Result1 = due_to_line_one(RandomList1,RandomList2,RandomList3),
			Result2 = due_to_line_two(RandomList1,RandomList2,RandomList3),
			Result3 = due_to_line_three(RandomList1,RandomList2,RandomList3),
			Result4 = due_to_line_four(RandomList1,RandomList2,RandomList3),
			Result5 = due_to_line_five(RandomList1,RandomList2,RandomList3),
			Result = Result1 ++ Result2 ++ Result3 ++ Result4 ++ Result5;
		Line == 6 ->
			Result1 = due_to_line_one(RandomList1,RandomList2,RandomList3),
			Result2 = due_to_line_two(RandomList1,RandomList2,RandomList3),
			Result3 = due_to_line_three(RandomList1,RandomList2,RandomList3),
			Result4 = due_to_line_four(RandomList1,RandomList2,RandomList3),
			Result5 = due_to_line_five(RandomList1,RandomList2,RandomList3),
			Result6 = due_to_line_six(RandomList1,RandomList2,RandomList3),
			Result = Result1 ++ Result2 ++ Result3 ++ Result4 ++ Result5 ++ Result6;
		Line == 7 ->
			Result1 = due_to_line_one(RandomList1,RandomList2,RandomList3),
			Result2 = due_to_line_two(RandomList1,RandomList2,RandomList3),
			Result3 = due_to_line_three(RandomList1,RandomList2,RandomList3),
			Result4 = due_to_line_four(RandomList1,RandomList2,RandomList3),
			Result5 = due_to_line_five(RandomList1,RandomList2,RandomList3),
			Result6 = due_to_line_six(RandomList1,RandomList2,RandomList3),
			Result7 = due_to_line_seven(RandomList1,RandomList2,RandomList3),
			Result = Result1 ++ Result2 ++ Result3 ++ Result4 ++ Result5 ++ Result6 ++ Result7;
		Line == 8 ->
			Result1 = due_to_line_one(RandomList1,RandomList2,RandomList3),
			Result2 = due_to_line_two(RandomList1,RandomList2,RandomList3),
			Result3 = due_to_line_three(RandomList1,RandomList2,RandomList3),
			Result4 = due_to_line_four(RandomList1,RandomList2,RandomList3),
			Result5 = due_to_line_five(RandomList1,RandomList2,RandomList3),
			Result6 = due_to_line_six(RandomList1,RandomList2,RandomList3),
			Result7 = due_to_line_seven(RandomList1,RandomList2,RandomList3),
			Result8 = due_to_line_eight(RandomList1,RandomList2,RandomList3),
			Result = Result1 ++ Result2 ++ Result3 ++ Result4 ++ Result5 ++ Result6 ++ Result7 ++ Result8;
		Line == 9 ->
			Result1 = due_to_line_one(RandomList1,RandomList2,RandomList3),
			Result2 = due_to_line_two(RandomList1,RandomList2,RandomList3),
			Result3 = due_to_line_three(RandomList1,RandomList2,RandomList3),
			Result4 = due_to_line_four(RandomList1,RandomList2,RandomList3),
			Result5 = due_to_line_five(RandomList1,RandomList2,RandomList3),
			Result6 = due_to_line_six(RandomList1,RandomList2,RandomList3),
			Result7 = due_to_line_seven(RandomList1,RandomList2,RandomList3),
			Result8 = due_to_line_eight(RandomList1,RandomList2,RandomList3),
			Result9 = due_to_line_nine(RandomList1,RandomList2,RandomList3),
			Result = Result1 ++ Result2 ++ Result3 ++ Result4 ++ Result5 ++ Result6 ++ Result7 ++ Result8 ++ Result9;
		true ->
			io:format("Line is not between 1-9 ~n"),
			Result = []
	end,


	MapFoldFun = fun({LineType,Num,Key,PointList},Sum)->
		RewardRecord = tpl_slotmachine:get(Key,Num),
		if
			RewardRecord == [] ->
				{[],0+Sum};
			true ->
				% {{LineType,PointList},RewardRecord#temp_slotmachine_reward.reward + Sum}
				pass
		end
	end,

	Length = length(Result),

	if 
		Length == 0 ->
			Reward = 0,
			RewardList = [];
		true ->
			{RewardList,Reward} = lists:foldl(MapFoldFun,0,Result)
	end,

	CurrentCoin = Coin - Line*Num + Reward,
	WinCoin = Reward,
	DataList = RandomList1 ++ RandomList2 ++ RandomList3,
	StCode = 0,
	{ok,Data13001} = pt_13:write(13001,[StCode,Line,Num,CurrentCoin,WinCoin,DataList,RewardList]),
	lib_send:send_to_uid(PlayerId,Data13001).

random_many_num(Num,List) ->
	if
		Num == 1 ->
			RandomNum = util:rand(1,10),
			Result = List ++ [RandomNum];
		true ->
			RandomNum = util:rand(1,10),
			NewList = List ++ [RandomNum],
			NewNum = Num - 1,
			random_many_num(NewNum,NewList)
	end.

%%判断连线中奖情况 返回值{LineNo,Num,Key,PointList }
%% 1, 2, 3, 4, 5
%% 6, 7, 8, 9, 10
%% 11,12,13,14,15
due_to_line_one(List1,List2,List3) ->
	[Col1,Col2,Col3,Col4,Col5] = List2,
	List = [{Col1,2,1},{Col2,2,2},{Col3,2,3},{Col4,2,4},{Col5,2,5}],
	{Num,Key,PointList} = get_reward_by_line(List,0,0,[]),
	[{1,Num,Key,PointList}].

due_to_line_two(List1,List2,List3) ->
	[Col1,Col2,Col3,Col4,Col5] = List1,
	List = [{Col1,1,1},{Col2,1,2},{Col3,1,3},{Col4,1,4},{Col5,1,5}],
	{Num,Key,PointList} = get_reward_by_line(List,0,0,[]),
	[{2,Num,Key,PointList}].

due_to_line_three(List1,List2,List3) ->
	[Col1,Col2,Col3,Col4,Col5] = List3,
	List = [{Col1,3,1},{Col2,3,2},{Col3,3,3},{Col4,3,4},{Col5,3,5}],
	{Num,Key,PointList} = get_reward_by_line(List,0,0,[]),
	[{3,Num,Key,PointList}].

due_to_line_four(List1,List2,List3) ->
	[Col1,_,_,_,Col5] = List1,
	[_,Col2,_,Col4,_] = List2,
	[_,_,Col3,_,_] = List3,
	List = [{Col1,1,1},{Col2,2,2},{Col3,3,3},{Col4,2,4},{Col5,1,5}],
	{Num,Key,PointList} = get_reward_by_line(List,0,0,[]),
	[{4,Num,Key,PointList}].

due_to_line_five(List1,List2,List3) ->
	[Col1,_,_,_,Col5] = List3,
	[_,Col2,_,Col4,_] = List2,
	[_,_,Col3,_,_] = List1,
	List = [{Col1,3,1},{Col2,2,2},{Col3,3,3},{Col4,2,4},{Col5,1,5}],
	{Num,Key,PointList} = get_reward_by_line(List,0,0,[]),
	[{5,Num,Key,PointList}].

due_to_line_six(List1,List2,List3) ->
	[Col1,Col2,_,_,_] = List1,
	[_,_,Col3,_,_] = List2,
	[_,_,_,Col4,Col5] = List3,
	List = [{Col1,1,1},{Col2,1,2},{Col3,2,3},{Col4,3,4},{Col5,3,5}],
	{Num,Key,PointList} = get_reward_by_line(List,0,0,[]),
	[{6,Num,Key,PointList}].

due_to_line_seven(List1,List2,List3) ->
	[Col1,Col2,_,_,_] = List3,
	[_,_,Col3,_,_] = List2,
	[_,_,_,Col4,Col5] = List1,
	List = [{Col1,3,1},{Col2,3,2},{Col3,2,3},{Col4,1,4},{Col5,1,5}],
	{Num,Key,PointList} = get_reward_by_line(List,0,0,[]),
	[{7,Num,Key,PointList}].

due_to_line_eight(List1,List2,List3) ->
	[Col1,_,Col3,_,Col5] = List2,
	[_,_,_,Col4,_] = List1,
	[_,Col2,_,_,_] = List3,
	List = [{Col1,2,1},{Col2,3,2},{Col3,2,3},{Col4,1,4},{Col5,2,5}],
	{Num,Key,PointList} = get_reward_by_line(List,0,0,[]),
	[{8,Num,Key,PointList}].

due_to_line_nine(List1,List2,List3) ->
	[Col1,_,Col3,_,Col5] = List2,
	[_,Col2,_,_,_] = List3,
	[_,_,_,Col4,_] = List1,
	List = [{Col1,2,1},{Col2,1,2},{Col3,2,3},{Col4,3,4},{Col5,2,5}],
	{Num,Key,PointList} = get_reward_by_line(List,0,0,[]),
	[{9,Num,Key,PointList}].

%%一条线内累计相同水果个数 Key为相同类型水果的类型ID
get_reward_by_line(List,Num,Key,PointList) ->
	Length = length(List),
	if 
		length == 0 ->
			{Num,Key,PointList};
		true ->
			ReList = lists:reverse(List),
			Point = lists:last(ReList),
			%这里Point实际为List的第一个元素
			{Type,Row,Col} = Point,
			if
				Key == 0 ->
					%%说明是首个元素
					NewList = lists:keydelete(List,1,Point),
					NewNum = Num+1,
					NewKey = Type,
					NewPointList = PointList + [{Row,Col}],
					get_reward_by_line(NewList,NewNum,NewKey,NewPointList);
				true ->
					%%说明不是首个元素 则要根据前边几类的Key判断是否继续递归
					if 
						Key == 1 ->
							%%前边的是万能水果 则继续递归
							NewList = lists:keydelete(List,1,Point),
							NewNum = Num+1,
							NewKey = Type,
							NewPointList = PointList ++ [{Row,Col}],
							get_reward_by_line(NewList,NewNum,NewKey,NewPointList);
						true ->
							%%若前边不是Wild 则比对
							if
								Type == Key ->
									%%匹配  则继续递归
									NewList = lists:keydelete(List,1,Point),
									NewNum = Num+1,
									NewKey = Type,
									NewPointList = PointList ++ [{Row,Col}],
									get_reward_by_line(NewList,NewNum,NewKey,NewPointList);
								true ->
									%%不匹配 则直接出结果
									{Num,Key,PointList}
							end
					end
					
			end
	end.