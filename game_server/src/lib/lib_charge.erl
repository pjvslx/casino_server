%% Author: Administrator
%% Created: 2013-4-11
%% Description: TODO: Add description to lib_charge
-module(lib_charge).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
 
%%返回码
-define(CHARGE_SUCCESS_CODE, <<"HTTP/1.1 200 OK\r\nContent-Length: 7\r\n\r\nsuccess">>). %%成功
-define(CHARGE_DUPLICATE_CODE, <<"HTTP/1.1 200 OK\r\nContent-Length: 1\r\n\r\n2">>).%%订单重复不全
-define(CHARGE_PARAM_CODE, <<"HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\-1">>).	%% 提交参数不全
-define(CHARGE_SIGN_ERROR_CODE, <<"HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\n-2">>).%% 签名验证失败
-define(CHARGE_UID_ERROR_CODE, <<"HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\n-3">>).	%%用户不存在	
-define(CHARGE_TIMEOUT_CODE, <<"HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\n-4">>).		%%请求超时	
-define(CHARGE_FAIL_CODE, <<"HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\n-5">>).	%%充值失败		

-define(CHARGE_STATUS_SUCCESSFUL_4399PLAT, "S").
-define(CHARGE_STATUS_FAILED_4399PLAT, "F").
-export([do_respone/2,start_charge/1,call_server_for_charge/1]).

get_player_info_local(Id) ->
	io:format("Id = ~p~n",[Id]),
	case ets:lookup(?ETS_ONLINE, Id) of
   		[] -> 
   			io:format("111111111~n"),
   			[];
   		[R] ->
       		case misc:is_process_alive(R#player.other#player_other.pid) of
           		false -> 
           			io:format("22222222~n"),
           			[];		
           		true -> 
           			io:format("33333333~n"),
           			R
       		end
	end.

%---------------------------
%-	游戏服务器用
%---------------------------
start_charge(JsonObj)-> 
	io:format("start_charge======~n"),
	CheckChargeConditionRst = check_charge_condition(JsonObj), 
	io:format("CheckChargeConditionRst = ~p ~n", [CheckChargeConditionRst]),
	case CheckChargeConditionRst of
		{true, Result} ->
			io:format("charge condition accepted ~n"),
			[Id,OrderId,GameId,ServerId,AccountId,PayWay,NewAmount,Coin,OrderStatus,HandleStatus,CreateTime] = Result,
			db_agent_charge:update_charge_order_status(OrderId,?CHARGE_ORDER_STATUS_SUCCESSFUL),
			AccountList = binary_to_list(AccountId),
			ActId = list_to_integer(AccountList),
			case get_player_info_local(ActId) of
				[] -> 
					io:format("11111111 False ~n"),
					skip;
				Player ->
					io:format("22222222 true begin to cast ~n"),
					gen_server:cast(Player#player.other#player_other.pid, charge)
			end,
		    {true, success};
		{false, ErrorCode} ->
			{false, ErrorCode}
	end.

%%检查充钱是否符合成功的条件
check_charge_condition(JsonObj) ->
	{ok,OrderId} = rfc4627:get_field(JsonObj,"order_id"),
	{ok,Amount} = rfc4627:get_field(JsonObj,"amount"),
	Ret = db_agent_charge:get_charge_order(OrderId),
	if 
		Ret == [] ->
			{false, system_error};
		true ->
			% id, game_id, server_id, account_id,pay_way, amount, gold, order_status, handle_status, create_time
			[Id,OrderId,GameId,ServerId,AccountId,PayWay,NewAmount,Coin,OrderStatus,HandleStatus,CreateTime] = Ret,
			IsAvaliable = check_accountid_available(binary_to_list(AccountId)),
			io:format("IsAvaliable = ~p~n",[IsAvaliable]),
			io:format("Amount = ~p NewAmount = ~p AccountId = ~p~n",[Amount,NewAmount,AccountId]),
			if 
				(IsAvaliable == true) and (Amount == NewAmount) ->
					{true, Ret};
				true ->
					{false, system_error}
			end
	end.

%%检查充值钱币是否符合要求
check_amount_available(Amount) ->
	TplCharge = tpl_charge:get(Amount),
	?TRACE("Amount = ~p gold = ~p ~n", [Amount, TplCharge]),
	case TplCharge of
		[] ->
			false;
		_ ->
			true
	end.

check_accountid_available(AccountId) ->
	PlayerInfo = db_agent_player:get_info_by_id(AccountId),
	case PlayerInfo of
		[] ->
			false;
		_ ->
			true
	end.

check_request_available(JsonObj) ->
	AvailableFieldList = ["order_id","amount"],
	IsAvailable = lists:any(
		fun(E)->
			io:format("JsonObj = ~p E = ~p~n",[JsonObj,E]),
			case rfc4627:get_field(JsonObj,E) of
				not_found ->
					io:format("Key = ~p is not found ~n",[E]),
					false;
				{ok,_} ->
					true
			end
		end,
		AvailableFieldList
		).

% 通过orderId去过滤出不同支付平台的订单
deal_http_request(Socket, PacketStr) ->
	io:format("====deal_http_request===~n"),
	case gen_tcp:recv(Socket, 0, ?RECV_TIMEOUT) of
		{ok, Packet} ->
			io:format("11111111~n"),
			Url = lists:concat([PacketStr, tool:to_list(Packet)]), 
			io:format("Url = ~p~n",[Url]),
			case pick_msg(Url) of
				[] ->
					pass;
				JsonObj ->
					case check_request_available(JsonObj) of
						true ->
							% start_charge(JsonObj),
							call_server_for_charge(JsonObj),
							pass;
						false ->
							io:format("yes it's param_error~n"),
							{false,param_error}
					end
			end;
		{error, Reason} ->
			io:format("2222222~n"),
			pass
	end.

pick_msg(Url) ->
	DecodeUrl = http_lib:url_decode(Url),
	io:format("DecodeUrl = ~p~n",[DecodeUrl]),
	MsgStartSymbol = "{",
	MsgStartIndex = string:str(DecodeUrl,MsgStartSymbol),
	MsgEndSymbol = "}",
	MsgEndIndex = string:str(DecodeUrl,MsgEndSymbol) + 1,
	if 
		MsgStartIndex == 0 ->
			%%没有msg字段
			{error,[]};
		true ->
			JsonContent = string:substr(DecodeUrl,MsgStartIndex,MsgEndIndex - MsgStartIndex),
			io:format("JsonContent = ~p~n",[JsonContent]),
			try 
				case rfc4627:decode(JsonContent) of
					{ok,JsonObj,_} ->
						JsonObj;
					_ ->
						[]
				end
			catch
				_:_ -> []
			end
	end.


%%响应http请求 
do_respone(Socket, PacketStr)->
	io:format("do_respone PacketStr = ~p~n",[PacketStr]),
	case deal_http_request(Socket, PacketStr) of
		{true,success}->  
			gen_tcp:send(Socket, ?CHARGE_SUCCESS_CODE);
		{false,check}->   
			gen_tcp:send(Socket, ?CHARGE_SIGN_ERROR_CODE);
		{false,param_error} ->   
			gen_tcp:send(Socket, ?CHARGE_PARAM_CODE);
		{false,duplicate} -> 
			gen_tcp:send(Socket, ?CHARGE_DUPLICATE_CODE);
		{false,uid_error} -> 
			gen_tcp:send(Socket, ?CHARGE_UID_ERROR_CODE);
		{false,timeout}-> 
			gen_tcp:send(Socket, ?CHARGE_TIMEOUT_CODE);
		{false,system_error} -> 
			gen_tcp:send(Socket, ?CHARGE_FAIL_CODE);
		_->  
			gen_tcp:send(Socket, ?CHARGE_FAIL_CODE)
	end.

%%获取充值密钥
get_charge_key()->
	case ets:lookup(config_info,charge_key) of
		[]->
			"";
		[{_,Key}]->
			Key
	end.

%%尝试通知服务器处理充值请求
call_server_for_charge(JsonObj)->  
	case ets:lookup(config_info,game_server_node) of
		[]-> 
			io:format("call_server_for_charge1111111~n"),
			{false,system_error};
		[{_,Node}] ->   
			io:format("call_server_for_charge2222222 Node = ~p~n",[Node]),
			case rpc:call(Node, lib_charge, start_charge, [JsonObj],3000) of
				{badrpc,timeout}->
					{false,timeout};
				{badrpc, R} ->   
					io:format("~p ~n", [R]),
					{false,system_error};
				Res-> 
					Res
			end 
	end.