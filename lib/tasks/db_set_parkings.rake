namespace :db_set_parkings do
  desc 'Set parkings data to database'
  task set_parkings: :environment do
    files = Dir.glob(Rails.root.join('db/parkings_data/*.json'))

    if files.empty?
      puts 'JSON file not found.'
      exit
    end

    file = File.read(files.max)
    parking_data = JSON.parse(file)

    failures = []

    parking_data.each do |details|
      begin
        ActiveRecord::Base.transaction do
          factory = RGeo::Geographic.spherical_factory(srid: 4326)
          Parking.create!(
            name: details['名前'],
            postal_code: details['郵便番号'],
            address: details['所在地'],
            coordinate: factory.point(details['lng'], details['lat']),
            closed_days: details['定休日'].presence,
            opening_hours: details['営業時間'].presence,
            fee: details['利用料金'].presence,
            capacity: details['収容台数'].presence,
            limitation: details['車両制限'].presence,
            url: details['url'].presence
          )
        end
      rescue => e
        failures << details["駐車場名:#{e}"]
        raise ActiveRecord::Rollback
        next
      end
    end

    if failures.any?
      puts "Import has finished. failures : #{failures.join('、')}"
    else
      puts 'Parking data imported successfully.'
    end
  end
end
