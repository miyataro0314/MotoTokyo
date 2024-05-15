#!/bin/bash
set -e

# PIDファイルが存在する場合、削除
rm -f tmp/pids/server.pid

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
bundle exec rails assets:precompile

# サーバーを起動
rails server  # 'bundle exec puma -C config/puma.rb'だとうまく行かない"