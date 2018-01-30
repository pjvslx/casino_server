%% Author: Administrator
%% Created: 2011-10-14
%% Description: TODO: Add description to db_agent_charge
-module(db_agent_charge).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
%%
%% Exported Functions
%%
-compile(export_all).


%%根据充值订单号返回充值记录
is_charge_exist(OrderId) ->
	case ?DB_MODULE:select_all(charge, "order_id", [{order_id, OrderId}]) of
        [] -> 
            false;
        Order ->
            true
    end.

%%插入一条充值记录
insert_charge_order(OrderId, GameId, ServerId, AccountId, PayWay, Amount, Gold, OrderStatus, HandleStatus, DimLev) ->
    FieldList = [order_id, game_id, server_id, account_id, pay_way, amount, gold, order_status, handle_status, dim_lev, create_time],
 	ValueList = [OrderId, GameId, ServerId, AccountId, PayWay, Amount, Gold, OrderStatus, HandleStatus, DimLev, util:unixtime()],
 	?DB_MODULE:insert(charge, FieldList, ValueList).

get_charge_order(OrderId) ->
    ?DB_MODULE:select_row(charge, "id, order_id, game_id, server_id, account_id,pay_way, amount, gold, order_status, handle_status, create_time",[{order_id, OrderId}],[],[]).

%%根据用户Accountid返回未处理订单列表
get_all_no_handle_charge_order(AccountId) ->
    ?DB_MODULE:select_all(charge, "id, order_id, game_id, server_id, account_id,pay_way, amount, gold, order_status, handle_status, create_time",[{account_id, AccountId}, {handle_status, ?UNHANDLE_CHARGE_ORDER}, {order_status, ?CHARGE_ORDER_STATUS_SUCCESSFUL}],[],[]).

%%更改一笔订单的处理情况 当金币加上去后调用
update_charge_handle_status(OrderId, HandleStatus) ->
    ?DB_MODULE:update(charge, [handle_status], [HandleStatus], order_id, OrderId).

%%更改订单的OrderStatus 当支付异步通知时调用
update_charge_order_status(OrderId,OrderStatus) ->
    io:format("update_charge_order_status OrderId = ~p OrderStatus = ~p~n",[OrderId,OrderStatus]),
	?DB_MODULE:update(charge, [order_status], [OrderStatus] , order_id, OrderId).