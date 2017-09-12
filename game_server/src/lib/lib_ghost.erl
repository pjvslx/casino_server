-module(lib_ghost).
-compile(export_all).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

%%幽灵锁定目标攻击玩家
ghost_target_to_player(GhostId) ->
	%找到Ghost进程 cast过去
	GhostProcessName = misc:create_process_name(ghost,[GhostId]),
	GhostProcessId = misc:whereis_name(GhostProcessName),
	gen_server:cast(GhostProcessId,{ghost_target_to_player}).