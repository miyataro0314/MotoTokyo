#!/bin/sh

# 初回の証明書取得が必要な場合に対応
if [ ! -f /etc/letsencrypt/live/moto-tokyo.com/fullchain.pem ]; then
    certbot --nginx -d moto-tokyo.com --email miyamoto.webdev@gmail.com --agree-tos --no-eff-email
fi

# cronサービスを開始
service cron start

# Nginxを起動
nginx -g "daemon off;" -c /etc/nginx/nginx.conf