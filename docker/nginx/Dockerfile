FROM nginx:latest

RUN apt-get update -qq && \
    apt-get install -y cerbot python3-cerbot-nginx cron

# デフォルトで用意されている個別設定ファイルを削除
RUN rm -f /etc/nginx/conf.d/*

# ホストマシン上の/docker/nginx/nginx.confを使用（コンテナにコピー）
COPY /docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY /docker/nginx/entrypoint.sh /entrypoint.sh
COPY /docker/nginx/certbot-renew /etc/cron.d/certbot-renew

# cronジョブファイルのパーミッションを設定
RUN chmod 644 /etc/cron.d/certbot-renew

# entrypoint.shを実行（初回証明書取得、cron起動、nginx起動）
ENTRYPOINT ["/entrypoint.sh"]

# Nginx用ポートを公開
EXPOSE 80 443