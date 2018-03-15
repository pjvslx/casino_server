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

start_broadcast() ->
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

get_mod_broadcast_pid() ->
    case misc:whereis_name({local, ?MODULE}) of
        Pid when is_pid(Pid) ->
            case misc:is_process_alive(Pid) of
                true ->
                    Pid;                
                false -> 
                    start_mod_broadcast(?MODULE)
            end;
        _ ->
            start_mod_broadcast(?MODULE)
    end.

start_mod_broadcast(ProcessName) ->
    case misc:whereis_name({local, ProcessName}) of
        Pid when is_pid(Pid) ->
            case misc:is_process_alive(Pid) of
                true -> 
                    Pid;
                false -> 
                    start_broadcast()
            end;
        _ ->
            start_broadcast()
    end .

init([]) ->
    io:format("mod_broadcast init~n"),
    {ok, []}.

test()->
    io:format("mod_broadcast test ~n").

handle_call({apply_call, Module, Method, Args}, _From, State) -> 
    Reply  = ?APPLY(Module, Method, Args,[]),
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    {reply, State, State}.

handle_cast({apply_cast, Module, Method, Args}, State) ->
    io:format("---- mod_broadcast apply_cast : [~p/~p/~p]~n", [Module, Method, Args]),    
     ?APPLY(Module, Method, Args,[]),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({test}, Status) ->
    {noreply, Status};

handle_info(Info, Status) ->
    {noreply, Status}.

terminate(_Reason, Status) ->
    ok.

