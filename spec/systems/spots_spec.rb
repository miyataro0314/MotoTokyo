require 'rails_helper'

RSpec.describe 'Spots', type: :system, js: true do
  context 'スポット登録' do
    before do
      @user = create(:user)
      @user.confirm
      login_as(@user)
    end

    # GoogleMapApiのAutoComplete部分がうまくいかないため一旦中止
    # it '問題なくスポット登録ができるか' do 
    #   visit new_spot_path
    #   click_link 'スポット登録'

    #   using_wait_time 10 do
    #     fill_in 'place-autocomplete-input', with: '日比谷公園大音楽堂'
    #     expect(page).to have_selector('.pac-matched', text: '日比谷公園大音楽堂')
    #   end
    #   find('.pac-matched', text: '日比谷公園大音楽堂').click
    #   sleep 0.5
    #   click_link '次へ'

    #   select 'あり（有料）', from: 'parking-select'
    #   select '全排気量', from: 'parking-limitaiton-select'
    #   click_link '次へ'

    #   select '簡単！', from: 'difficulty-select'
    #   select '観光', from: 'category-select'
    #   click_link '次へ'

    #   fill_in 'comment_content', with: '良いところです。'
    #   click_link '確認'

    #   expect(page).to have_content "日比谷公園大音楽堂"
    #   expect(page).to have_content "あり（有料）"
    #   expect(page).to have_content "全排気量"
    #   expect(page).to have_content "簡単！"
    #   expect(page).to have_content "観光"
    #   expect(page).to have_content "良いところです。"
    #   click_link '登録'

    #   Capybara.assert_current_path(success_spot_registrations_path, ignore_query: true)
    # end
  end

  context 'スポット詳細' do
    before do
      @user = create(:user)
      @profile = create(:profile, user_id: @user.id)
      @spot = create(:spot, user_id: @user.id)
      @spot_detail = create(:spot_detail, spot_id: @spot.id)
      @difficulty = create(:difficulty, user_id: @user.id, spot_id: @spot.id)
      @parking = create(:parking)
      @user.confirm
      login_as(@user)
      visit spot_path(@spot)
    end

    it 'スポット詳細が正しく表示されるか' do
      expect(page).to have_content @spot.name
      expect(page).to have_content @spot_detail.postal_code
      expect(page).to have_content @spot_detail.address
      expect(page).to have_content I18n.t("activerecord.enums.spot.category.#{@spot.category}")
      expect(page).to have_content I18n.t("activerecord.enums.spot.parking.#{@spot.parking}")
      expect(page).to have_content @parking.name
      expect(page).to have_content @parking.address
    end

    it 'ブックマークの登録・解除が正しく行えるか' do
      click_link 'ブックマークする'
      Capybara.assert_current_path(spot_path(@spot), ignore_query: true)
      expect(page).to have_content 'ブックマークしました'

      click_link 'ブックマーク解除'
      Capybara.assert_current_path(spot_path(@spot), ignore_query: true)
      expect(page).to have_content 'ブックマークを解除しました'
    end

    it '行きやすさ投票が正しく行えるか' do
      element = find('#easy-bar')
      expect(element[:style]).to include('width: 100%')

      
      find('#difficulty_vote').click

      select '交通量が多い', from: 'difficulty-select'
      sleep 0.5
      click_button '登録'

      Capybara.assert_current_path(spot_path(@spot), ignore_query: true)
      expect(page).to have_content '行きやすさ投票を完了しました'
      element = find('#traffic-bar')
      expect(element[:style]).to include('width: 100%')
    end

    it 'コメントの投稿、編集、削除ができ、問題なく表示できるか' do
      click_link 'おすすめポイントを投稿する'
      sleep 0.5

      fill_in 'comment_content', with: 'テストコメント'
      click_button '投稿する'
      sleep 0.5

      Capybara.assert_current_path(spot_path(@spot), ignore_query: true)
      expect(page).to have_content 'おすすめポイントを投稿しました'
      expect(page).to have_content 'テストコメント'

      click_link 'おすすめポイントを編集する'
      fill_in 'comment_content', with: 'テストコメント更新済み'
      click_button '更新する'
      sleep 0.5

      Capybara.assert_current_path(spot_path(@spot), ignore_query: true)
      expect(page).to have_content 'おすすめポイントを更新しました'
      expect(page).to have_content 'テストコメント更新済み'

      click_link 'おすすめポイント一覧を見る'
      expect(page).to have_content 'テストコメント更新済み'
      find('.background').click
      sleep 0.5

      Capybara.assert_current_path(spot_path(@spot), ignore_query: true)
      click_link 'おすすめポイントを編集する'
      accept_confirm do
        click_link 'おすすめポイントを削除する'
      end
      expect(page).to have_content 'おすすめポイントを削除しました'
    end

    it '駐車場詳細へ遷移できるか' do
      find("#parking-card-#{@parking.id}").click
      expect(page).to have_content(@parking.name)
    end
  end

  context '自分で登録したスポット' do
    before do
      @user = create(:user)
      @profile = create(:profile, user_id: @user.id)
      @spot = create(:spot, user_id: @user.id)
      @spot_detail = create(:spot_detail, spot_id: @spot.id)
      @difficulty = create(:difficulty, user_id: @user.id, spot_id: @spot.id)
      @parking = create(:parking)
      @user.confirm
      login_as(@user)
      visit my_spots_path
      find('label[for="tab2"]').click
    end

    it 'マイスポットで確認できるか' do
      expect(page).to have_content(@spot.name)
      expect(page).to have_content(@spot_detail.address)
    end

    it 'マイスポットから編集できるか' do
      click_link '編集'
      select 'あり(無料)', from: 'parking-select'
      select '大型不可', from: 'parking-limitaiton-select'
      select '交通量が多い', from: 'spot_form_level'
      select '景色', from: 'spot_form_category'
      fill_in 'spot_form_content', with: '良いところです。(編集済み)'
      click_button '更新'

      Capybara.assert_current_path(my_spots_path, ignore_query: true)
      expect(page).to have_content('スポット情報を更新しました')

      visit spot_path(@spot)

      expect(page).to have_content "あり(無料)"
      expect(page).to have_content "大型不可"
      expect(page).to have_content "交通量が多い"
      expect(page).to have_content "景色"
      expect(page).to have_content "良いところです。(編集済み)"
    end

    it '駐車場が無しのとき、駐車制限がdisabledとなるか' do
      click_link '編集'
      select '無し', from: 'parking-select'

      expect(page).to have_selector("select[disabled]")
    end

    it '削除ができるか' do
      click_link '編集'

      accept_confirm do
        click_link 'スポットを削除する'
      end

      Capybara.assert_current_path(my_spots_path, ignore_query: true)
      expect(page).to have_content('スポットを削除しました')
      expect(page).not_to have_content(@spot.name)
    end
  end
end
