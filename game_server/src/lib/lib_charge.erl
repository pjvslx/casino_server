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


%---------------------------
%-	游戏服务器用
%---------------------------
start_charge(JsonObj)-> 
	CheckChargeConditionRst = check_charge_condition(JsonObj), 
	?TRACE("CheckChargeConditionRst = ~p ~n", [CheckChargeConditionRst]),
	case CheckChargeConditionRst of
		{true, _} ->
			%%?TRACE("charge condition accepted ~n"),
			[OrderId, GameId, ServerId, AccountId, PayWay, Amount, _, OrderStatus, _, _] = CheckChargeConditionRst,
			{temp_charge, _, Gold, _} = tpl_charge:get(Amount),
			Uid = db_agent_player:get_playerid_by_accountid(AccountId),
			case OrderStatus of
				?CHARGE_STATUS_SUCCESSFUL_4399PLAT -> NewOrderStatus = ?CHARGE_ORDER_STATUS_SUCCESSFUL;
				?CHARGE_STATUS_FAILED_4399PLAT -> NewOrderStatus = ?CHARGE_ORDER_STATUS_FAILED
			end,
			[DimLevel] = db_agent_player:get_player_level(Uid),
			?TRACE("level info = ~p ~n", [DimLevel]),
			db_agent_charge:insert_charge_order(OrderId, GameId, ServerId, AccountId, PayWay, Amount, Gold, NewOrderStatus, ?UNHANDLE_CHARGE_ORDER, DimLevel),
			case lib_player:get_player_pid(Uid) of
				[] ->
					skip;
		        Pid -> 
					gen_server:cast(Pid, charge)
		    end,
		    {true, success};
		{false, ErrorCode} ->
			{false, ErrorCode}
	end.

% %%将url参数中的数字全部变回数字
% convert_url_param(Param) ->
% 	[{"order_id", OrderId}, {"game_id", GameId}, {"server_id", ServerId}, {"uid", AccountId}, {"pay_way", PayWay}
% 	,{"amount", Amount}, {"callback_info", CallbackInfo}, {"order_status", OrderStatus},
% 	{"failed_desc", Desc}, {"sign", Sign}] = Param,

% 	[OrderId, GameId, list_to_integer(ServerId), list_to_integer(AccountId), 
% 	list_to_integer(PayWay), list_to_integer(Amount), CallbackInfo, OrderStatus, Desc, Sign].
		
% CREATE TABLE `charge` (
%   `id` int(10) NOT NULL AUTO_INCREMENT,
%   `order_id` varchar(30) NOT NULL COMMENT '充值订单号',
%   `game_id` varchar(20) NOT NULL COMMENT '游戏编号',
%   `server_id` int(10) NOT NULL COMMENT '服务器编号',
%   `account_id` varchar(50) NOT NULL COMMENT '4399平台用户唯一标识',
%   `pay_way` tinyint(4) NOT NULL COMMENT '1：手游币兑换2：神州行3：联通4：支付宝',
%   `amount` int(10) NOT NULL COMMENT '支付金额',
%   `gold` int(10) NOT NULL,
%   `order_status` tinyint(3) NOT NULL COMMENT 'S-成功支付F-支付失败',
%   `handle_status` tinyint(3) NOT NULL,
%   `dim_lev` int(10) NOT NULL,
%   `create_time` int(10) NOT NULL,
% ) 

%%检查充钱是否符合成功的条件
check_charge_condition(JsonObj) ->
	{ok,OrderId} = rfc4627:get_field(JsonObj,"order_id"),
	{ok,AccountTmp} = rfc4627:get_field(JsonObj,"uid"),
	AccountId = list_to_integer(AccountTmp),
	{ok,AmountTmp} = rfc4627:get_field(JsonObj,"amount"),
	Amount = list_to_integer(AccountTmp),
	{ok,OrderStatusTmp} = rfc4627:get_field(JsonObj,"order_status"),
	OrderStatus = list_to_integer(OrderStatusTmp),
	% [OrderId, _, _, AccountId, _, Amount, _, OrderStatus, _, _] = Param,
	case check_accountid_available(AccountId) of
		true ->
			case db_agent_charge:is_charge_exist(OrderId) of
				true ->
					{false, duplicate};
				false ->
					case check_amount_available(Amount) of
						true ->
							{true, success};
						false ->
							{false, system_error}
					end
			end;
		_->
			{false, uid_error}
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
	Uid = db_agent_player:get_playerid_by_accountid(AccountId),
	case Uid of
		[] ->
			false;
		_ ->
			db_agent_player:check_player_id_available(Uid)
	end.


%------------------
%-	充值网关用
%------------------
%% 处理http请求【需加入身份验证或IP验证】
% treat_http_request(Socket, PacketStr) -> 
% 	case gen_tcp:recv(Socket, 0, ?RECV_TIMEOUT) of 
% 		{ok, Packet} -> 
% 			try  
% 				io:format("Packet = ~p~n",[Packet]),
% 				io:format("PacketStr = ~p~n",[PacketStr]),
% 				P = lists:concat([PacketStr, tool:to_list(Packet)]), 
% 				io:format("P = ~p~n",[P]),
% 				KvList = http_util:get_param_lists(P),
% 				io:format("KvList = ~p~n",[KvList]),
% 				case check_request_available(KvList) of
% 					{true,_}->  
% 						call_server_for_charge(KvList);
% 					Error ->
% 						Error
% 				end
% 			catch  
% 				What:Why ->  
% 					?ERROR_MSG("What ~p, Why ~p, ~p", [What, Why, erlang:get_stacktrace()]), 
% 					{false,system_error}
% 			end;
% 		{error, Reason} ->  
% 			?ERROR_MSG("http_request error Reason:~p ~n", [Reason]),
% 			{false,system_error}
% 	end.

check_request_available(JsonObj) ->
	AvailableFieldList = ["order_id","game_id","server_id","uid","pay_way","amount","order_status"],
	IsAvailable = lists:any(
		fun(E)->
			case rfc4627:get_field(JsonObj,E) of
				not_found ->
					io:format("Key = ~p is not found ~n",[E]),
					false;
				true ->
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
							start_charge(JsonObj),
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

%%检查本次请求参数的有效性
% check_request_available(ParamList)-> 
% 	case ParamList of  
% 		[{"order_id",_},{"game_id",_},{"server_id",_},{"uid",_},{"pay_way",_}
% 		 ,{"amount",_},{"callback_info",_},{"order_status",_},
% 		 {"failed_desc",_},{"sign",SignFlag}] -> 
% 			SignKey = lists:foldl(fun({_,Val},Result)->
% 										  if Val =/= [] ->
% 												 lists:concat([Result,Val]);
% 											 true ->
% 												 Result
% 										  end
% 								  end,"", lists:keydelete("sign", 1, ParamList)),
% 			ChargeKey = get_charge_key(),
% 			NewSignKey = lists:concat([SignKey,ChargeKey]),
% 			NewSignMd5Key = tool:md5(NewSignKey),
% 			{SignFlag =:= NewSignMd5Key,check};
% 			%%{true, check};
% 		_->
% 			{false,param_error}
% 	end. 

%%获取充值密钥
get_charge_key()->
	case ets:lookup(config_info,charge_key) of
		[]->
			"";
		[{_,Key}]->
			Key
	end.

%%尝试通知服务器处理充值请求
call_server_for_charge(ParamList)->  
	case ets:lookup(config_info,game_server_node) of
		[]-> 
			{false,system_error};
		[{_,Node}] ->   
			case rpc:call(Node, lib_charge, start_charge, [ParamList],3000) of
				{badrpc,timeout}->
					{false,timeout};
				{badrpc, R} ->   
					io:format("~p ~n", [R]),
					{false,system_error};
				Res-> 
					Res
			end 
	end.