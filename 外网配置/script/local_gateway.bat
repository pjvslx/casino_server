cd ../config
erl +P 1024000 -pa ../ebin -name local_gateway@119.27.178.16 -setcookie luyang -boot start_sasl -config local_gateway  -s main local_gateway_start
pause
