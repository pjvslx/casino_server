cd ../config
erl +P 1024000 -pa ../ebin -name game_server96@192.168.1.96 -env ERL_MAX_ETS_TABLES 5000 -setcookie luyang -boot start_sasl -config server  -s main server_start


pause