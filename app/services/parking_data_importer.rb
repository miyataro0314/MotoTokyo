class ParkingDataImporter
  def initialize(file_path)
    @file_path = file_path
  end

  def import
    parking_data = JSON.parse(File.read(@file_path))
    failures = []

    parking_data.each do |details|
      parking = create_parking(details)
      failures << "駐車場名: #{details['名前']}, エラー: #{parking.errors.full_messages.join(', ')}" unless parking.save
    end

    if failures.any?
      Rails.logger.warn "Import has finished. Failures: #{failures.join('、')}"
    else
      Rails.logger.info 'Parking data imported successfully.'
    end
  end

  private

  def create_parking(details)
    Parking.new(
      name: details['名前'],
      postal_code: details['郵便番号'],
      address: details['所在地'],
      coordinate: build_coordinate(details),
      closed_days: details['定休日'].presence,
      opening_hours: details['営業時間'].presence,
      fee: details['利用料金'].presence,
      capacity: details['収容台数'].presence,
      limitation: details['車両制限'].presence,
      url: details['url'].presence
    )
  end

  def build_coordinate(details)
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    factory.point(details['lng'], details['lat'])
  end
end
