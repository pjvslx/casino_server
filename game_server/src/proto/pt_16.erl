-module(pt_16).
-export([read/2, write/2]).
-include("common.hrl").
-include("table_to_record.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%
read(16000, _) ->
    {ok,[]};

read(_Cmd, _R) ->
    {error, no_match}.


write(16000, ProviderShopConfigList) ->
    Length = length(ProviderShopConfigList),
    F = fun({ProviderId,ShopConfigList}) ->
        Len = length(ShopConfigList),

        ShopConfigListBin = list_to_binary(lists:map(
            fun(ShopConfig) ->
                PropId = ShopConfig#shop_config.prop_id,
                ShopId = ShopConfig#shop_config.shop_id,
                GameItemId = ShopConfig#shop_config.game_item_id,
                ItemName = ShopConfig#shop_config.item_name,
                PropQuantity = ShopConfig#shop_config.prop_quantity,
                PropGiftQuantity = ShopConfig#shop_config.prop_gift_quantity,
                PriceValue = ShopConfig#shop_config.price_value,
                PriceUnit = ShopConfig#shop_config.price_unit,
                ShopIdBin = pt:pack_string(ShopId),
                GameItemIdBin = pt:pack_string(GameItemId),
                ItemNameBin = pt:pack_string(ItemName),
                <<PropId:16,ShopIdBin/binary,GameItemIdBin/binary,ItemNameBin/binary,PropQuantity:32,PropGiftQuantity:32,PriceValue:32,PriceUnit:8>>
            end,
            ShopConfigList
            )),
        <<ProviderId:16,Len:16,ShopConfigListBin/binary>>
    end,
    Bin = list_to_binary(lists:map(F,ProviderShopConfigList)),
    if
        Length /= 0 ->
            {ok, pt:pack(16000,<<Length:16,Bin/binary>>)};
        true ->
            {ok, pt:pack(16000,<<Length:16>>)}
    end;

%% -----------------------------------------------------------------
%% 错误处理
%% -----------------------------------------------------------------
write(Cmd, _R) ->
?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(game_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.

%%------------------------------------
%% internal function
%%------------------------------------
pack_string(Str) ->
    BinData = tool:to_binary(Str),
    Len = byte_size(BinData),
    <<Len:16, BinData/binary>>.

any_to_binary(Any) ->
    tool:to_binary(Any).
