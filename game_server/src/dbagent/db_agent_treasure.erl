-module(db_agent_treasure).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").

-compile(export_all).

get_treasure(PlayerId) ->
	?DB_MODULE:select_row(treasure, "level,left_brick,score", [{uid, PlayerId}], [], [1]).

%%保存玩家夺宝信息
save_treasure_table(PlayerId, FieldList, ValueList)->
    ?DB_MODULE:update(treasure, FieldList, ValueList, "uid", PlayerId).

create_treasure_table(FieldList,ValueList)->
	?DB_MODULE:insert_get_id(treasure, FieldList, ValueList).