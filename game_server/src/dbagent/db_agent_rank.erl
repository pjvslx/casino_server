-module(db_agent_rank).

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

get_all_player()->
    ?DB_MODULE:select_all(player, "id, recharge, coin",[],[],[]).