require 'rails_helper'

RSpec.describe Parking, type: :model do
  describe 'バリデーション' do
    context 'name' do
      it 'nilの時エラーとなるか' do
        parking = build(:parking, name: nil)
        expect(parking).to be_invalid
      end
    end

    context 'area' do
      it '住所に応じたエリアが自動的に割り当てられているか' do
        parking = create(:parking)
        expect(parking.area).to eq('shinjuku')
      end
    end

    context 'address' do
      it 'nilの時エラーとなるか' do
        parking = build(:parking, address: nil)
        expect(parking).to be_invalid
      end
    end

    context 'coordinate' do
      it '正しく緯度が取得できるか' do
        parking = build(:parking)
        expect(parking.coordinate.latitude).to eq(35.690699)
      end

      it '正しく経度が取得できるか' do
        parking = build(:parking)
        expect(parking.coordinate.longitude).to eq(139.693724)
      end
    end
  end

  describe 'スコープ' do
    context 'nearby' do
      it '正しく動作しているか' do
        spot = create(:spot)
        create(:spot_detail, spot_id: spot.id)

        parking = create(:parking)
        near_parking = Parking.nearby(spot.spot_detail.coordinate, 1000)

        expect(near_parking).to include(parking)
      end
    end
  end

  describe 'メソッド' do
    context 'distance' do
      it '正しく動作しているか' do
        spot = create(:spot)
        create(:spot_detail, spot_id: spot.id)

        parking = create(:parking)
        distance = parking.distance(spot.spot_detail.coordinate)

        expect(distance).to eq(229)
      end
    end
  end
end
