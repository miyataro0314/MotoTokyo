require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    context 'id' do
      it 'nilの時エラーとなるか' do
        user = build(:user, id: nil)
        expect(user).to be_invalid
      end
      it '重複時にエラーとなるか' do
        create(:user, id: 'duplicate_user')
        user = build(:user, email: 'duplicate_user')
        expect(user).to be_invalid
      end
    end

    context 'email' do
      it 'nilの時エラーとなるか' do
        user = build(:user, email: nil)
        expect(user).to be_invalid
      end
      it '重複時にエラーとなるか' do
        create(:user, email: 'duplicate@example.com')
        user = build(:user, email: 'duplicate@example.com')
        expect(user).to be_invalid
      end
    end

    context 'password' do
      it '6文字以下の時にエラーとなるか' do
        user = build(:user, password: 55555, password_confirmation: 55555)
        expect(user).to be_invalid
      end
    end

    context 'password_confirmation' do
      it 'パスワードと一致しない時にエラーとなるか' do
        user = build(:user, password: 666666, password_confirmation: 777777)
        expect(user).to be_invalid
      end
    end
  end

  describe 'アソシエーション' do
    let(:user) { create(:user) }
    let(:spot) { create(:spot, user_id: user.id) }

    context 'spot' do
      it '正しく作成し、参照できるか' do
        expect(user.spots).to include(spot)
      end
    end

    context 'difficulty' do
      it '正しく作成し、参照できるか' do
        difficulty = create(:difficulty, user_id: user.id, spot_id: spot.id)
        expect(spot.difficulties).to include(difficulty)
      end

      it '同じスポットに対して２つ以上作成できないようになっているか' do
        create(:difficulty, user_id: user.id, spot_id: spot.id)
        difficulty = build(:difficulty, user_id: user.id, spot_id: spot.id)

        expect(difficulty).to be_invalid
      end
    end

    context 'comment' do
      it '正しく作成し、参照できるか' do
        comment = create(:comment, user_id: user.id, spot_id: spot.id)
        expect(user.comments).to include(comment)
      end

      it '同じスポットに対して２つ以上作成できないようになっているか' do
        create(:comment, user_id: user.id, spot_id: spot.id)
        comment = build(:comment, user_id: user.id, spot_id: spot.id)

        expect(comment).to be_invalid
      end
    end

    context 'bookmark' do
      it '正しく作成し、参照できるか' do
        bookmark = user.bookmarks.create(spot_id: spot.id)
        expect(user.bookmarks).to include(bookmark)
      end

      it '同じスポットに対して２つ以上作成できないようになっているか' do
        create(:bookmark, user_id: user.id, spot_id: spot.id)
        bookmark = build(:bookmark, user_id: user.id, spot_id: spot.id)

        expect(bookmark).to be_invalid
      end
    end

    context 'edit_history' do
      it '正しく作成し、参照できるか' do
        edit_history = user.edit_histories.create(spot_id: spot.id)
        expect(user.edit_histories).to include(edit_history)
      end
    end

    context 'access_history' do
      it '正しく作成し、参照できるか' do
        access_history = user.access_histories.create(spot_id: spot.id)
        expect(user.access_histories).to include(access_history)
      end
    end

    context 'profile' do
      it '正しく作成し、参照できるか' do
        profile = user.create_profile
        expect(user.profile).to eq(profile)
      end

      it '２つ以上作成できないようになっているか' do
        user.create_profile
        profile = Profile.new(user_id: user.id)

        expect(profile).to be_invalid
      end
    end

    context 'friendships' do
      let(:friend) { create(:user, id: 'test_friend') }

      it '正しく作成し、参照できるか' do
        friendship = user.friendships.create(friend_id: friend.id)
        expect(user.friendships).to include(friendship)
      end

      it '同じフレンドに対して２つ以上作成できないようになっているか' do
        user.friendships.create(friend_id: friend.id)
        friendship = user.friendships.build(friend_id: friend.id)

        expect(friendship).to be_invalid
      end
    end
  end

  describe 'メソッド' do
    let(:user) { create(:user) }
    let(:spot) { create(:spot, user_id: user.id) }

    context 'already_commented?' do
      it '正しく動作しているか' do
        create(:comment, user_id: user.id, spot_id: spot.id)
        expect(user.already_commented?(spot)).to be_truthy
      end
    end

    context 'comment_for' do
      it '正しく動作しているか' do
        comment = create(:comment, user_id: user.id, spot_id: spot.id)
        expect(user.comment_for(spot)).to eq(comment)
      end
    end

    context 'difficulty_for' do
      it '正しく動作しているか' do
        difficulty = create(:difficulty, user_id: user.id, spot_id: spot.id)
        expect(user.difficulty_for(spot)).to eq(difficulty)
      end
    end
  end
end
