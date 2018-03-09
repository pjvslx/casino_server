-module(pp_shop).
-export([handle/3]).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-compile(export_all).

handle(Cmd, Player, Data) ->
	handle_cmd(Cmd, Player, Data).

% 获取配置
handle_cmd(16000, Player, _) ->
	io:format("======handle_cmd 16000 ~n"),
	ProviderList = config:get_provider_select(server),
	ProviderConfigList = lists:map(
		fun(ProviderId)-> 
			ShopConfigList = tpl_shop_config:get_by_provider(integer_to_list(ProviderId)),
			{ProviderId,ShopConfigList}
		end,
	ProviderList),
	% tpl_shop_config:get_by_provider(1)
	{ok,Data16000} = pt_16:write(16000,ProviderConfigList),
	lib_send:send_to_sid(Player#player.other#player_other.pid_send,Data16000),
	{ok,Player};

handle_cmd(_Cmd, _Socket, _Data) ->
    {error, "pp_shop handle_cmd no match"}.