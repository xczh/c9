#!/bin/bash
cd /etc/nginx && echo -e 'Zh\nShanghai\nShanghai\nnull\nnull\nnull\nnull' |/usr/bin/openssl req -new -newkey rsa:2048 -days 2048 -nodes -x509 -keyout server.key -out server.crt
/usr/sbin/nginx
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
while [ true ] ; do echo 'app run' ;  sleep 10 ; done
