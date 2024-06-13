require 'rails_helper'

RSpec.describe 'Spots', type: :system, js: true do
  context 'スポット登録' do
    before do
      user = create(:user)
      user.confirm
      login_as(user)
      sleep 0.5
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

    #   select option_text:'あり（有料）', from: 'parking-select'
    #   select option_text:'全排気量', from: 'parking-limitaiton-select'
    #   click_link '次へ'

    #   select option_text:'簡単！', from: 'difficulty-select'
    #   select option_text:'観光', from: 'category-select'
    #   click_link '次へ'

    #   fill_in 'comment_content', with: '良いところです。'
    #   click_link '確認'

    #   expect(page).to have_content "スーパーレーサー"
    #   expect(page).to have_content "あり（有料）"
    #   expect(page).to have_content "全排気量"
    #   expect(page).to have_content "簡単！"
    #   expect(page).to have_content "観光"
    #   expect(page).to have_content "良いところです。"
    #   click_link '登録'

    #   Capybara.assert_current_path(success_spot_registrations_path, ignore_query: true)
    # end
  end

end
