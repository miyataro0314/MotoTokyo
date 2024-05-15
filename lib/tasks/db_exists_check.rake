namespace :db do
  desc 'Check if the database exists'
  task exists_check: :environment do
    begin # rubocop:disable Style/RedundantBegin:
      ActiveRecord::Base.connection
      puts 'Database exists'
    rescue ActiveRecord::NoDatabaseError
      exit 1
    end
  end
end
