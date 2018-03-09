%%%------------------------------------------------	
%%% File    : tpl_shop_config.erl	
%%% Author  : table_to_erlang	
%%% Created : 
%%% Description:从数据库表shop_config生成
%%% WARNING:程序生成，请不要增加手工代码！
%%%------------------------------------------------    	
 	
-module(tpl_shop_config). 	
-compile(export_all). 	
	
get(1)->
	{shop_config, 1, <<"1">>, 1, <<"db">>, <<"db.alipay.gold.01">>, <<"6元礼包">>, 6, 1, 6000, 0};	
get(2)->
	{shop_config, 2, <<"1">>, 1, <<"db">>, <<"db.alipay.gold.02">>, <<"12元礼包">>, 12, 1, 12000, 0};	
get(3)->
	{shop_config, 3, <<"1">>, 1, <<"db">>, <<"db.alipay.gold.03">>, <<"30元礼包">>, 30, 1, 30000, 0};	
get(4)->
	{shop_config, 4, <<"1">>, 1, <<"db">>, <<"db.alipay.gold.04">>, <<"98元礼包">>, 98, 1, 98000, 0};	
get(5)->
	{shop_config, 5, <<"1">>, 1, <<"db">>, <<"db.alipay.gold.05">>, <<"298元礼包">>, 298, 1, 298000, 0};	
get(6)->
	{shop_config, 6, <<"1">>, 1, <<"db">>, <<"db.alipay.gold06">>, <<"998元礼包">>, 998, 1, 998000, 0};	
get(_)->	
	[].	
	
get_by_provider("1")->	
	 lists:map(fun([ID])->tpl_shop_config:get(ID) end,
	[[1],[2],[3],[4],[5],[6]]);	
	
get_by_provider(_)->	
 [].	
