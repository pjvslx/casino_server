cd ../config
erl +P 1024000 -pa ../ebin -name game_server106@192.168.0.109 -env ERL_MAX_ETS_TABLES 5000 -setcookie luyang -boot start_sasl -config server_home  -s main server_start


pause