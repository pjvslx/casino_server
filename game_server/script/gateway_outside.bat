cd ../config
mysql -u root -pyuanzhuti -e "delete from server" rpggame
copy /y gateway_outside.config gateway.config
copy /y server_outside.config server.config
erl +P 1024000 -pa ../ebin -name game_gateway@192.168.1.96 -setcookie luyang -boot start_sasl -config gateway  -s main gateway_start
pause