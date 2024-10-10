#!/bin/bash

set -eu


cd $HOME/website

docker compose up -d

ssl_cert_dir=$(docker compose exec webserver ls /etc/letsencrypt/live | grep -v -w README)
[[ -z "$ssl_cert_dir" ]] && echo "SSL certificate request failed. Check container logs." 1>&2 && exit 1

sed -i 's/--staging/--force-renewal/' docker-compose.yml
docker compose up --force-recreate --no-deps certbot

docker compose stop webserver
curl -sSLo nginx-conf/options-ssl-nginx.conf https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf
domain_name=$(cat nginx-conf/nginx.conf | sed -n -e 's/.*server_name //p' | cut -d' ' -f1)
mv nginx-conf/nginx.conf.2 /nginx-conf/nginx.conf
sed -i "s/DOMAIN_NAME/$domain_name/g" nginx-conf/nginx.conf
mv docker-compose.yml docker-compose.yml.bak
awk '{if ($0 ~ /80:80/) {print $0; print gensub(80, 443, "g")} else {print $0}}' docker-compose.yml.bak
mv docker-compose.yml.bak docker-compose.yml

docker compose up -d --force-recreate --no-deps webserver
