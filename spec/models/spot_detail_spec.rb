require 'rails_helper'

RSpec.describe SpotDetail, type: :model do
  describe 'バリデーション' do
    let(:spot) { create(:spot) }

    context 'id' do
      it 'nilの時エラーとなるか' do
        spot_detail = build(:spot_detail, id: nil, spot_id: spot.id)
        expect(spot_detail).to be_invalid
      end
      it '重複時にエラーとなるか' do
        create(:spot_detail, id: 'duplicate_spot_detail', spot_id: spot.id)
        spot_detail = build(:spot_detail, id: 'duplicate_spot_detail', spot_id: spot.id)
        expect(spot_detail).to be_invalid
      end
    end
  end

  describe 'メソッド' do
    let(:spot) { create(:spot) }
    let(:spot_detail) { create(:spot_detail, spot_id: spot.id) }

    context 'address' do
      it '正しく動作しているか' do
        expect(spot_detail.address).to eq('東京都新宿区西新宿２丁目８−１')
      end
    end
  end
end
