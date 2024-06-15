#!/bin/bash
set -e

# PIDファイルが存在する場合、削除
rm -f tmp/pids/server.pid

if [ "$RAILS_ENV" = "production" ]; then
  echo "Running entrypoint script in production environment"

  # Gemをインストール
  echo "Bundle installing..."
  bundle install

  # データベースが存在しない場合createしてmigrate、存在時はmigrateのみ実行
  if ! bundle exec rake db:exists_check; then
    echo "Database does not exist. Creating and migrating..."
    rails db:create
    rails db:migrate
  else
    echo "Database exists. Running migrations..."
    rails db:migrate
  fi

  # アセットをプリコンパイル
  echo "Precompiling assets..."
  bundle exec rails assets:precompile

  # cronジョブの更新とcronの起動
  bundle exec whenever --update-crontab
  service cron start

  # サーバーを起動
  echo "Starting server..."
  rails server  # 'bundle exec puma -C config/puma.rb'だとうまく行かない"

else
  rails server -p 3000 -b '0.0.0.0'
fi