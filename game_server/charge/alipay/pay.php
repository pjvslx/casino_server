<?php
	require_once("aop/AopClient.php");
	require_once ("AlipaySetting.php");
	require_once("Utils.php");
	$TIMESTAMP = date("Y-m-d H:i:s",time());
	// $TIMESTAMP = "2016-07-29 16:55:53";
	$TRADE_NO = AlipaySetting::createOrder();
	$Time = time();
	$RSA_PRIVATE = AlipaySetting::$RSA_PRIVATE;
	file_put_contents("d:/charge.txt", "11111111\n", FILE_APPEND);

	//_$GET内容 
	//game_id:1 连环夺宝
	//server_id: 随便填
	//Uid: 用户ID
	//pay_way = 1:支付宝 2:微信支付
	//amount:金额
	//gold:金币数量
	
	$GameId = $_GET["game_id"];
	$ServerId = $_GET["server_id"];
	$Uid = $_GET["uid"];
	$PayWay = 1;
	$Amount = $_GET["amount"];
	$Coin = $_GET["coin"];
	file_put_contents("d:/charge.txt", "22222222\n", FILE_APPEND);

	$biz_content = array(
		"timeout_express" => AlipaySetting::$expressTime,
		"product_code" => AlipaySetting::$productCode,
		"total_amount" => "$Amount",
		"subject" => "1",
		"body" => "1",
		"out_trade_no" => $TRADE_NO
		);
	
	$db = new mysqli(AlipaySetting::$DB_HOST, AlipaySetting::$DB_USER, AlipaySetting::$DB_PWD, AlipaySetting::$DB_NAME, AlipaySetting::$DB_PORT);
	file_put_contents("d:/charge.txt", "333333333\n", FILE_APPEND);
    $db->set_charset('utf-8');

	if ($db->connect_error) {
    die('Connect Error (' . $db->connect_errno . ') '
            . $db->connect_error);
	}
	file_put_contents("d:/charge.txt", "444444444\n", FILE_APPEND);
	$sqlCheck = "SELECT id FROM charge where order_id = '$TRADE_NO'";
	file_put_contents("d:/charge.txt", "sqlCheck = $sqlCheck\n", FILE_APPEND);
	$result = mysqli_query($db,$sqlCheck);
	if ($result->num_rows > 0)
	{
		return;
	}
	file_put_contents("d:/charge.txt", "555555555\n", FILE_APPEND);
	$sql_insert = "insert into charge (order_id, game_id, server_id, account_id, pay_way, amount, gold, handle_status, order_status, create_time) ";
	$db_amount = $Amount*100;
    $sql_insert .= "values('$TRADE_NO', $GameId, $ServerId, $Uid, $PayWay, $db_amount, $Coin, 0, 0,$Time)"; //handle_status:0未处理

    file_put_contents("d:/charge.txt", "sql_insert = $sql_insert\n", FILE_APPEND);

    if(!$db->query($sql_insert))
    {
        echo "charge failed";
        return;
    }
	
	Utils::request_post(AlipaySetting::$charge_gateway_host,AlipaySetting::$charge_gateway_port,$biz_content);
	$biz_content_json = json_encode($biz_content);

	$content = array(
		"biz_content" => $biz_content_json,
		"method" =>	"alipay.trade.app.pay",
		"charset" => "utf-8",
		"notify_url" => AlipaySetting::$notifyUrl,
		"version" => AlipaySetting::$version,
		"app_id" => AlipaySetting::$APP_ID,
		"timestamp" => $TIMESTAMP,
		"sign_type" => AlipaySetting::$signType
		);

	$formatStr = 'biz_content={"timeout_express":"%s","product_code":"%s","total_amount":"%s","subject":"1","body":"1","out_trade_no":"%s"}&method=alipay.trade.app.pay&charset=utf-8&notify_url=%s&version=%s&app_id=%s&timestamp=%s&sign_type=%s';
	$contentStr = sprintf($formatStr,AlipaySetting::$expressTime,AlipaySetting::$productCode,$Amount,$TRADE_NO,AlipaySetting::$notifyUrl,AlipaySetting::$version,AlipaySetting::$APP_ID,$TIMESTAMP,AlipaySetting::$signType);
	$client = new AopClient();
	$client->rsaPrivateKey = $RSA_PRIVATE;
	$Sign = $client->rsaSign($content);
	$Sign = str_replace("=", "%3D", $Sign);
	$Sign = str_replace("+", "%2B", $Sign);
	$Sign = str_replace("/", "%2F", $Sign);
	$SignStr = "&sign=$Sign";
	$contentStr = $contentStr . $SignStr;
	$contentStr = str_replace("{", "%7B", $contentStr);
	$contentStr = str_replace("}", "%7D", $contentStr);
	$contentStr = str_replace(":", "%3A", $contentStr);
	$contentStr = str_replace("\"", "%22", $contentStr);
	$contentStr = str_replace(",", "%2C", $contentStr);
	$contentStr = str_replace("/", "%2F", $contentStr);
	$contentStr = str_replace(" ", "%20", $contentStr);
	$result = array(
		"msg" => $contentStr
		);
	echo json_encode($result);
?>