-module(db_agent_drama).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

-compile(export_all).

get_drama(PlayerId) ->
	?DB_MODULE:select_row(drama, "*", [{uid, PlayerId}], [], [1]).