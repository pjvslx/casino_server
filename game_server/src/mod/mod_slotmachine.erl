-module(mod_slotmachine). 
-behaviour(gen_server).

-include("debug.hrl").
-include("common.hrl"). 
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-export([handle_call/3, handle_cast/2, handle_info/2, init/1,terminate/2]).
-compile(export_all).

-record(status,{jp = 0}).

start() ->
	gen_server:start(?MODULE,[],[]).

init([]) ->
	SlotProcess = misc:create_process_name(slot_p,[]),
	io:format("----------SlotProcess = ~p~n",[SlotProcess]),
	misc:register(local, SlotProcess, self()),
	Status = #status{jp = 10000},
	{ok, Status}.

handle_call({apply_call, Module, Method, Args}, _From, State) -> 

	Reply  = ?APPLY(Module, Method, Args,[]),
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    {reply, State, State}.

handle_cast({apply_cast, Module, Method, Args}, State) ->
	io:format("---- mod_scene apply_cast : [~p/~p/~p]~n", [Module, Method, Args]),	 
	 ?APPLY(Module, Method, Args,[]),
    {noreply, State};

handle_cast({remove_player,PlayerId},State) ->
	io:format("----mod_slotmachine remove_player PlayerId = ~p~n",[PlayerId]),
	lib_slotmachine:remove_player({PlayerId},State),
	{noreply, State};

handle_cast({add_player,PlayerId},State) ->
	io:format("----mod_slotmachine add_player PlayerId = ~p~n",[PlayerId]),
	lib_slotmachine:add_player({PlayerId},State),
	{noreply, State};

handle_cast({bet,PlayerId,Line,Bet,Coin},State) ->
	io:format("----mod_slotmachine bet PlayerId = ~p Line = ~p Bet = ~p Coin = ~p~n",[PlayerId,Line,Bet,Coin]),
	lib_slotmachine:bet({PlayerId,Line,Bet,Coin}),
	{noreply, State};

handle_cast({get_scene_info,PlayerId},State) ->
	lib_scene:get_scene_info(PlayerId),
	{noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({test}, Status) ->
	{noreply, Status};

handle_info(Info, Status) ->
   	?ERROR_MSG("Mod_player_info: /~p/~n",[[Info]]),
   	{noreply, Status}.

terminate(_Reason, Status) ->
	ok.

