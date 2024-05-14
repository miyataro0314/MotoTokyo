# 最大スレッド数と最小スレッド数を環境変数から取得する。
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# 本番環境でのワーカー数をプロセッサーの数に等しく設定。
if ENV["RAILS_ENV"] == "production"
  require "concurrent-ruby"
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY") { Concurrent.physical_processor_count })
  workers worker_count if worker_count > 1
  # 本番環境ではnginxが受けたリクエストをUnixソケット経由で受け取る
  bind "unix://#{Rails.root}/tmp/sockets/puma.sock"
else
  # 開発環境では直接pumaがリクエストを受ける
  port ENV.fetch("PORT") { 3000 }
  # 開発環境でのワーカー終了前のタイムアウト閾値。
  worker_timeout 3600
end

# Pumaが実行する環境を指定。
environment ENV.fetch("RAILS_ENV") { "development" }

# Pumaが使用するPIDファイルを指定。
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# `bin/rails restart` コマンドによるPumaの再起動を可能にする。
plugin :tmp_restart
