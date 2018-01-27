<?php
class Utils {
    public static function cUrlSendRequest($Host , $Port , $arr)
    {
    	$stamp = time();
        $Url = 'http://' . $Host . ':' . $Port . "?msg=";
        $JsonStr = json_encode($arr);
        $Url = $Url . $JsonStr;
    	file_put_contents("d:/cUrlSendRequest.txt", "Url = $Url\n", FILE_APPEND);
    	$ch = curl_init();
    	$timeout = 5;
    	curl_setopt ($ch, CURLOPT_URL, $Url);
    	curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
    	curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
    	$file_contents = curl_exec($ch);
    	curl_close($ch);
    }

    public static function request_post($Host, $Port, $post_data = array()) {
        $url = "http://" . $Host . ":" . $Port . "/?";
        if (empty($post_data)) {
            return false;
        }  
        $o = "";
        foreach ( $post_data as $k => $v ) 
        { 
            $o.= "$k=" . urlencode( $v ). "&" ;
        }
        $post_data = substr($o,0,-1);
        $postUrl = $url;
        $curlPost = $post_data;
        $headers = array(
            'User-Agent:lalalla',
            'TICKET:lllllllllllljjaajaj'
        );
        $ch = curl_init();//初始化curl
        curl_setopt($ch, CURLOPT_URL,$postUrl);//抓取指定网页
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_HEADER, 0);//设置header
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);//要求结果为字符串且输出到屏幕上
        curl_setopt($ch, CURLOPT_POST, 1);//post提交方式
        curl_setopt($ch, CURLOPT_POSTFIELDS, $curlPost);
        $data = curl_exec($ch);//运行curl
        curl_close($ch);  
        return $data;
    }
}
?>