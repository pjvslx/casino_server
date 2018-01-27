<?php
	require("alipay/aop/AopClient.php");
    foreach ($_POST as $key=>$value)  
    {
        // logger("_POST: Key: $key; Value: $value");
        file_put_contents("d:/notify.txt", "key = $key value = $value.\n", FILE_APPEND);
    }
    $Sign = $_POST["sign"];
    // file_put_contents("d:/notify.txt", "publicKey = $Sign\n", FILE_APPEND);
    $client = new AopClient();
    $checkRet = $client->rsaCheckV1($_POST,"");
    file_put_contents("d:/notify.txt", "checkRet = $checkRet\n", FILE_APPEND);
    if ($checkRet == true)
    {
        echo "success";
        //通知local_server更改状态
    }
?>