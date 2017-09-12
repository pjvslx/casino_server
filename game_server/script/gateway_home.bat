mysql -u root -pyuanzhuti -e "delete from server" game
cd ../config
erl +P 1024000 -pa ../ebin -name game_gateway@192.168.0.103 -setcookie luyang -boot start_sasl -config gateway_home  -s main gateway_start
pause