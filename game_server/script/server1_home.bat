cd ../config
copy /y gateway_home.config gateway.config
copy /y server_home.config server.config
erl +P 1024000 -pa ../ebin -name game_server106@192.168.1.106 -env ERL_MAX_ETS_TABLES 5000 -setcookie luyang -boot start_sasl -config server  -s main server_start


pause