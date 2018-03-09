-module(mod_broadcast). 
-behaviour(gen_server).

-include("debug.hrl").
-include("common.hrl"). 
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-export([handle_call/3, handle_cast/2, handle_info/2, init/1,terminate/2]).
-compile(export_all).

start_link() ->
    gen_server:start_link(?MODULE, [], []).

start_rank() ->
    Pid = case supervisor:start_child(game_server_sup,
                                {mod_broadcast, 
                                 {mod_broadcast, start_link, []},
                                 permanent, 10000, supervisor, [mod_broadcast]}) of
        {ok, Pid1} ->
            Pid1;
        _ ->
            undefined
    end,
    misc:register(local, ?MODULE, Pid),
    {ok, Pid}.

get_mod_broad_pid() ->
    case misc:whereis_name({local, ?MODULE}) of
        Pid when is_pid(Pid) ->
            case misc:is_process_alive(Pid) of
                true ->
                    Pid;                
                false -> 
                    start_mod_rank(?MODULE)
            end;
        _ ->
            start_mod_rank(?MODULE)
    end.

start_mod_rank(ProcessName) ->
    case misc:whereis_name({local, ProcessName}) of
        Pid when is_pid(Pid) ->
            case misc:is_process_alive(Pid) of
                true -> 
                    Pid;
                false -> 
                    start_rank()
            end;
        _ ->
            start_rank()
    end .

init([]) ->
    io:format("mod_rank init~n"),
    List = db_agent_rank:get_all_player(),
    TupleList = lists:map(
        fun(L)->
            Tuple = list_to_tuple(L)
        end,
        List
        ),
    {ok, TupleList}.

test()->
    io:format("mod_rank test ~n").

handle_call({apply_call, Module, Method, Args}, _From, State) -> 
    Reply  = ?APPLY(Module, Method, Args,[]),
    {reply, Reply, State};

handle_call({get_rank_by_recharge}, _From, State) ->
    NewState = lists:sort(
        fun(A,B)-> 
            {_,Recharge1,_} = A,
            {_,Recharge2,_} = B,
            Recharge1 > Recharge2
        end
        ,State),
    {reply, NewState, NewState};

handle_call({get_rank_by_coin}, _From, State) ->
    NewState = lists:sort(
        fun(A,B)->
            {_,_,Coin1} = A,
            {_,_,Coin2} = B,
            A > B
        end,
        State
        ),
    {reply, NewState, NewState};

handle_call(_Request, _From, State) ->
    {reply, State, State}.

handle_cast({apply_cast, Module, Method, Args}, State) ->
    io:format("---- mod_rank apply_cast : [~p/~p/~p]~n", [Module, Method, Args]),    
     ?APPLY(Module, Method, Args,[]),
    {noreply, State};

handle_cast({set_coin,Uid,NewCoin}, State) ->
    case lists:keyfind(Uid,1,State) of
        Tuple ->
            {_,Recharge,Coin} = Tuple,
            NewState = lists:keyreplace(Uid,1,State,{Uid,Recharge,NewCoin});
        false ->
            NewState = State
    end,
    io:format("NewState = ~p~n",[NewState]),
    {noreply,NewState};

handle_cast({new_player,Uid,Recharge,Coin},State) ->
    NewState = lists:keystore(Uid,1,State,{Uid,Recharge,Coin}),
    {noreply,NewState};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({test}, Status) ->
    {noreply, Status};

handle_info(Info, Status) ->
    {noreply, Status}.

terminate(_Reason, Status) ->
    ok.

