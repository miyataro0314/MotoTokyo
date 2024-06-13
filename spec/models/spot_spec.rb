require 'rails_helper'

RSpec.describe Spot, type: :model do
  describe 'バリデーション' do
    context 'name' do
      it 'nilの時エラーとなるか' do
        spot = build(:spot, name: nil)
        expect(spot).to be_invalid
      end
      it '重複時にエラーとなるか' do
        create(:spot, name: 'duplicate_spot')
        spot = build(:spot, name: 'duplicate_spot')
        expect(spot).to be_invalid
      end
    end

    context 'parking' do
      it 'nilの時エラーとなるか' do
        spot = build(:spot, parking: nil)
        expect(spot).to be_invalid
      end
    end

    context 'category' do
      it 'nilの時エラーとなるか' do
        spot = build(:spot, category: nil)
        expect(spot).to be_invalid
      end
    end

    context 'area' do
      it 'nilの時エラーとなるか' do
        spot = build(:spot, area: nil)
        expect(spot).to be_invalid
      end
    end
  end

  describe 'アソシエーション' do
    let(:user) { create(:user) }
    let(:spot) { create(:spot) }

    context 'spot_detail' do
      it '正しく作成し、参照できるか' do
        spot_detail = create(:spot_detail, spot_id: spot.id)
        expect(spot.spot_detail).to eq(spot_detail)
      end

      it '一意性が有効か' do
        create(:spot_detail, spot_id: spot.id)
        spot_detail = build(:spot_detail, spot_id: spot.id)

        expect(spot_detail).to be_invalid
      end
    end

    context 'difficulty' do
      it '正しく作成し、参照できるか' do
        difficulty = create(:difficulty, user_id: user.id, spot_id: spot.id)
        expect(spot.difficulties).to include(difficulty)
      end

      it '同じユーザーに対して２つ以上作成できないようになっているか' do
        create(:difficulty, user_id: user.id, spot_id: spot.id)
        difficulty = build(:difficulty, user_id: user.id, spot_id: spot.id)

        expect(difficulty).to be_invalid
      end
    end

    context 'comment' do
      it '正しく作成し、参照できるか' do
        comment = create(:comment, user_id: user.id, spot_id: spot.id)
        expect(spot.comments).to include(comment)
      end

      it '同じユーザーに対して２つ以上作成できないようになっているか' do
        create(:comment, user_id: user.id, spot_id: spot.id)
        comment = build(:comment, user_id: user.id, spot_id: spot.id)

        expect(comment).to be_invalid
      end
    end

    context 'bookmark' do
      it '正しく作成し、参照できるか' do
        bookmark = spot.bookmarks.create(user_id: user.id)
        expect(spot.bookmarks).to include(bookmark)
      end

      it '同じユーザーに対して２つ以上作成できないようになっているか' do
        create(:bookmark, user_id: user.id, spot_id: spot.id)
        bookmark = build(:bookmark, user_id: user.id, spot_id: spot.id)

        expect(bookmark).to be_invalid
      end
    end

    context 'edit_history' do
      it '正しく作成し、参照できるか' do
        edit_history = spot.edit_histories.create(user_id: user.id)
        expect(spot.edit_histories).to include(edit_history)
      end
    end

    context 'access_history' do
      it '正しく作成し、参照できるか' do
        access_history = spot.access_histories.create(user_id: user.id)
        expect(spot.access_histories).to include(access_history)
      end
    end
  end

  describe 'スコープ' do
    let(:spot) { create(:spot) }

    context 'by_area' do
      it '正しく動作しているか' do
        expect(Spot.by_area('shinjuku')).to include(spot)
      end
    end

    context 'by_category' do
      it '正しく動作しているか' do
        expect(Spot.by_category('sightseeing')).to include(spot)
      end
    end

    context 'by_parking' do
      it '正しく動作しているか' do
        expect(Spot.by_parking('free')).to include(spot)
      end
    end

    context 'nearby' do
      it '正しく動作しているか' do
        parking = create(:parking)
        spot = create(:spot)
        create(:spot_detail, spot_id: spot.id)

        near_spot = Spot.nearby(parking.coordinate, 1000)

        expect(near_spot).to include(spot)
      end
    end
  end

  describe 'メソッド' do
    let(:user) { create(:user) }
    let(:spot) { create(:spot) }

    context 'bookmarked_by?' do
      it '正しく動作しているか' do
        user.bookmarks.create(spot_id: spot.id)
        expect(spot.bookmarked_by?(user)).to be_truthy
      end
    end

    context 'hashtag_for_tweet'do
      it '正しく動作しているか' do
        expect(spot.hashtag_for_tweet).to eq('#東京観光 #東京散策 #東京名所')
      end
    end
  end
end
