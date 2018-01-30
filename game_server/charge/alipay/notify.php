<?php
	require_once("aop/AopClient.php");
    require_once("AlipaySetting.php");
    require_once("Utils.php");
    foreach ($_POST as $key=>$value)  
    {
        // logger("_POST: Key: $key; Value: $value");
        file_put_contents("d:/notify.txt", "key = $key value = $value.\n", FILE_APPEND);
    }
    $Sign = $_POST["sign"];
    $OutTradeNO = $_POST["out_trade_no"];
    $Amount = $_POST["total_amount"] * 100;
    $APPID = $_POST["app_id"];
    $SellerId = $_POST["seller_id"];
    // file_put_contents("d:/notify.txt", "publicKey = $Sign\n", FILE_APPEND);
    $client = new AopClient();
    $checkRet = $client->rsaCheckV1($_POST,"");
    file_put_contents("d:/notify.txt", "checkRet = $checkRet\n", FILE_APPEND);
    if ($checkRet == 1)
    {
        echo "success";
        file_put_contents("d:/notify.txt", "success\n", FILE_APPEND);
        //通知local_server更改状态
        if ($_POST["trade_status"] == "TRADE_SUCCESS" || $_POST["trade_status"] == "TRADE_FINISHED")
        {
            $data = array(
                "order_id" => $OutTradeNO,
                "amount" => $Amount
                );
            Utils::cUrlSendRequest(AlipaySetting::$charge_gateway_host,AlipaySetting::$charge_gateway_port,$data);
        }
    }
    else
    {
        file_put_contents("d:/notify.txt", "fuckway\n", FILE_APPEND);
    }
?>