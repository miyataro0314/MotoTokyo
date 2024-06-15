require File.expand_path(File.dirname(__FILE__) + '/environment')

rails_env = ENV['RAILS_ENV'] || :development

set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"

# ログを残すようにジョブタイプrakeをオーバーライド
job_type :rake, "cd :path && :environment_variable=:environment bundle exec rake :task :output"

every 1.day, at: '3:00 am' do
  rake 'sitemap:create'
end