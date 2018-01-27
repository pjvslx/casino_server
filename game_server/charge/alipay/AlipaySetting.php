<?php
	class AlipaySetting
	{
		public static $APP_ID = "2016091300498019";
		public static $RSA_PRIVATE = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALVzlqV+TgIftfZN3CbkF4/fgL4yuaLR4ChnbfEpWUiBvjj2K5dU/ZO+pbPuf9DBFijgBbqJAe65b8eN8/Dx1t8KgFNp6jARrtkbV9etTK0+BZlbRKOl+f07TsRQec8y3l4paFL1gvgBoDIj/lfr9kgockpMDtYJL7htWtccqfFzAgMBAAECgYA9+tewe+5Fh3NuSLY0iqEJwfyF+2mxliMNahcB02/t9nN1nZDSRnO/rdWIGqWKNwpMuAj86KPCWZE3BuQWn2UXg4892nUnKe5/0GvzVrpV4n+TH5Zqgv961Qz7HggrD1czBBlJpjHRbEgtLKRdZLg1oBLy9pX8nE9r4fCy1HCNIQJBANeU77TwriJiJoSbgYjgzZ7BQFY3q8tfQubt+/MYw9j72D1f2B9OQkCLAwK8BU0Qj4mrTMldip2B9js1ooCN7SkCQQDXeIksfUBZlkcmsPMCe+Bj5h8qIWoDEGdBJTNeXuehrOKyUzQlpP2AM3jbqqOSu/oTNY/TDUrv2jfsJu9XkiE7AkEA1HC6Pu4mS0+5cVfksEQHnHgHtG6r5n97aCIA9C/lXz/eeaynR0JRW1UhpGIwPx8gs6OQyaZaYJifUv2po1E48QJAZg8f2kTRcB2wQfFaiXinhmn/pPMCxcTFQ6QdOrv1Ny0ui4zBjHsj38+BlXqz09LZ1rNuFmebcRSJnH+sqmv69QJAHehk29s1GgwSvYtjyG5M/76eslK7qSSkcK2ZitMKjMkf9XPe15iq8IgWsMjRPL6G/x/ihaa8qHx6O6hTER5Qlg==";
		public static $expressTime = "30m";
		public static $productCode = "QUICK_MSECURITY_PAY";
		public static $signType = "RSA";
		public static $version = "1.0";
		public static $notifyUrl = "http://196ns78264.iok.la:33299/notify.php";
		public static $charge_gateway_host = "192.168.0.109";
		public static $charge_gateway_port = "7799";
		public static $DB_HOST = "127.0.0.1";
		public static $DB_USER = "root";
		public static $DB_PWD = "yuanzhuti";
		public static $DB_NAME = "game";
		public static $DB_PORT = "3306";
		

		public static function createOrder()
		{
			//生成24位唯一订单号码，格式：YYYY-MMDD-HHII-SS-NNNN,NNNN-CC，其中：YYYY=年份，MM=月份，DD=日期，HH=24格式小时，II=分，SS=秒，NNNNNNNN=随机数，CC=检查码
	 		@date_default_timezone_set("PRC");
	 		//订购日期
	  		$order_date = date('Y-m-d');
	  		//订单号码主体（YYYYMMDDHHIISSNNNNNNNN）
	 		$order_id_main = date('YmdHis') . rand(10000000,99999999);
	  		//订单号码主体长度
	  		$order_id_len = strlen($order_id_main);
	  		$order_id_sum = 0;
	 		for($i=0; $i<$order_id_len; $i++)
	 		{
	 			$order_id_sum += (int)(substr($order_id_main,$i,1));
			}
	 		//唯一订单号码（YYYYMMDDHHIISSNNNNNNNNCC）
	 		$order_id = $order_id_main . str_pad((100 - $order_id_sum % 100) % 100,2,'0',STR_PAD_LEFT);
	 		return $order_id;
		}
	}