# syntax = docker/dockerfile:1

# Rubyのバージョンは外部から指定可能
ARG RUBY_VERSION=3.3.0
FROM ruby:$RUBY_VERSION

# Railsアプリケーションの作業ディレクトリ
RUN mkdir /MotoTokyo
WORKDIR /MotoTokyo

# 必要な環境変数を設定
ENV LANG C.UTF-8 \
    TZ Asia/Tokyo \
    BUNDLE_PATH="/usr/local/bundle"

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y ca-certificates curl gnupg &&\
    apt-get install -y build-essential default-libmysqlclient-dev libvips pkg-config python3 cron vim

# Node.js 環境のセットアップ
ARG NODE_VERSION=20.13.1
RUN curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - && \
    apt-get install -y nodejs

# yarnの最新版をインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# Gemfileを基に依存パッケージをインストール
COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.5.5
RUN bundle install

# package.jsonを基に依存パッケージをインストール
COPY package.json yarn.lock ./
RUN yarn install

# entrypoint.shのコピーと実行権限の付与
COPY docker/web/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# エントリポイントを設定
ENTRYPOINT ["entrypoint.sh"]

# アプリケーションのコードをコピー
COPY . /MotoTokyo
