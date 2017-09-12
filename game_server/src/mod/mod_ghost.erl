-module(mod_ghost). 
-behaviour(gen_server).

-include("debug.hrl").
-include("common.hrl"). 
-include("record.hrl").

-export([handle_call/3, handle_cast/2, handle_info/2, init/1,terminate/2]).
-compile(export_all).

-record(status,{x = 0, y = 0, ghost_id = 0,scene_id = 0}).

start(X,Y,GhostId,SceneId) ->
	gen_server:start(?MODULE,[x,y,GhostId,SceneId],[]).

init([X,Y,GhostId,SceneId]) ->
	GhostProcessName = misc:create_process_name(ghost,[GhostId]),
	io:format("----------GhostProcessName = ~p~n",[GhostProcessName]),
	misc:register(local, GhostProcessName, self()),
	Status = #status{x = X, y = Y, ghost_id = GhostId,scene_id = SceneId},
	%%告知玩家幽灵已生成
	SceneProcessName = misc:create_process_name(scene_p,[SceneId]),
	SceneProcessId = misc:whereis_name({local,SceneProcessName}),
	gen_server:cast(SceneProcessId,{scene_add_ghost,GhostId,X,Y}),

	{ok, Status}.

handle_call(_Request, _From, State) ->
    {reply, State, State}.

handle_cast({ghost_move,X,Y},State) ->
	NewState = State#status{x = X, y = Y},
	%广播
	{ok,NewState};

handle_cast({ghost_target_to_player},State) ->
	SceneId = State#status.scene_id,
	GhostId = State#status.ghost_id,
	SceneProcessName = misc:create_process_name(scene_p,[SceneId]),
	SceneProcessId = misc:whereis_name({local,SceneProcessName}),
	gen_server:cast(SceneProcessId,{scene_ghost_target_to_player,GhostId}),
	{ok, State};

handle_cast({ghost_move,X,Y},State) ->
	NewState = State#status{ x = X, y = Y},
	SceneId = State#status.scene_id,
	SceneProcessName = misc:create_process_name(scene_p,[SceneId]),
	SceneProcessId = misc:whereis_name({local, SceneProcessName}),
	gen_server:cast(SceneProcessId,{scene_ghost_move,State#status.ghost_id,X,Y}),
	{ok, NewState};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(Info, Status) ->
   	?ERROR_MSG("mod_ghost_maker: /~p/~n",[[Info]]),
   	{noreply, Status}.

terminate(_Reason, Status) ->
	ok.

