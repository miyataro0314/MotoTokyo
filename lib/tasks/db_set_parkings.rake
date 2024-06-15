namespace :db_set_parkings do
  desc 'Set parkings data to database'
  task set_parkings: :environment do
    files = Rails.root.glob('db/parkings_data/*.json')

    if files.empty?
      Rails.logger.error 'JSON file not found.'
      exit
    end

    file_path = files.max
    importer = ParkingDataImporter.new(file_path)
    importer.import
  end
end
