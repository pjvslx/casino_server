-module(mod_treasure). 
-behaviour(gen_server).

-include("debug.hrl").
-include("common.hrl"). 
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-export([handle_call/3, handle_cast/2, handle_info/2, init/1,terminate/2]).
-compile(export_all).

-record(status,{jackpot = 0}).

start_link() ->
    gen_server:start_link(?MODULE, [], []).

start_treasure() ->
	Pid = case supervisor:start_child(game_server_sup,
                                {mod_treasure, 
                                 {mod_treasure, start_link, []},
                                 permanent, 10000, supervisor, [mod_treasure]}) of
        {ok, Pid1} ->
            Pid1;
        _ ->
            undefined
    end,
    misc:register(local, ?MODULE, Pid),
    {ok, Pid}.

get_mod_treasure_pid() ->
	case misc:whereis_name({local, ?MODULE}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true ->
					Pid;				
				false -> 
					start_mod_treasure(?MODULE)
			end;
		_ ->
			start_mod_treasure(?MODULE)
	end.

start_mod_treasure(ProcessName) ->
	case misc:whereis_name({local, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> 
					Pid;
				false -> 
					start_treasure()
			end;
		_ ->
			start_treasure()
	end .

init([]) ->
	io:format("mod_treasure init~n"),
	Status = #status{jackpot = 10000},
	{ok, Status}.

test()->
	io:format("mod_treasure test ~n").

handle_call({apply_call, Module, Method, Args}, _From, State) -> 
	Reply  = ?APPLY(Module, Method, Args,[]),
    {reply, Reply, State};

handle_call({test,Num1,Num2},_From,State) ->
	io:format("test Num1 = ~p Num2 = ~p ~n",[Num1,Num2]),
	{reply, Num1 + Num2, State};

handle_call(get_jackpot, _From, State) ->
	{reply, State#status.jackpot, State};

handle_call({change_jackpot, ChangeValue}, _From, State) ->
	if 
		(State#status.jackpot + ChangeValue) < 0 ->
			NewJackpot = 0;
		true ->
			NewJackpot = State#status.jackpot + ChangeValue
	end,
	{reply, NewJackpot, State#status{jackpot = NewJackpot}};

handle_call(_Request, _From, State) ->
    {reply, State, State}.

handle_cast({apply_cast, Module, Method, Args}, State) ->
	io:format("---- mod_treasure apply_cast : [~p/~p/~p]~n", [Module, Method, Args]),	 
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

