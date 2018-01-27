cd ../config
erl +P 1024000 -pa ../ebin -name game_gateway@119.27.178.16 -setcookie luyang -boot start_sasl -config gateway_home  -s main gateway_start
pause