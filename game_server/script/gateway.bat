cd ../config
erl +P 1024000 -pa ../ebin -name game_gateway@192.168.0.103 -setcookie luyang -boot start_sasl -config gateway  -s main gateway_start
pause