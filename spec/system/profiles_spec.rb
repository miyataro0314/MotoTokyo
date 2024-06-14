require 'rails_helper'

RSpec.describe "Profiles", type: :system, js: true do
  context 'プロフィール未登録' do
    before do
      @user = create(:user)
      @user.confirm
      login_as(@user)
    end

    it 'ホームに登録リンクが出ているか' do
      expect(page).to have_content 'プロフィールの登録をしましょう！'
      click_link 'プロフィールの登録をしましょう！'
      Capybara.assert_current_path(new_profile_path, ignore_query: true)
    end

    it 'プロフィールを登録できるか' do
      visit new_profile_path

      fill_in 'profile_user_name', with: 'テストユーザー'
      attach_file 'profile_avatar', Rails.root.join('spec/fixtures/files/test_image1.png')
      fill_in 'profile_vehicle_name', with: 'テストバイク'
      select '大型', from: 'profile_vehicle_type'
      attach_file 'profile_vehicle_photo', Rails.root.join('spec/fixtures/files/test_image2.png')
      click_button '登録'

      Capybara.assert_current_path(my_page_path, ignore_query: true)
      expect(page).to have_content 'テストユーザー'
      expect(page).to have_content 'テストバイク'
      expect(page).to have_selector("img[src*='test_image1.jpg']")
      expect(page).to have_selector("img[src*='test_image2.jpg']")

      visit current_path
      expect(page).to have_selector("img[src*='avatar.jpg']")
      expect(page).to have_selector("img[src*='vehicle_photo.jpg']")
    end

    it '入力がなかった場合、代替表示されるか' do
      visit new_profile_path
      click_button '登録'

      Capybara.assert_current_path(my_page_path, ignore_query: true)
      expect(page).to have_content 'ユーザーネーム未設定'
      expect(page).to have_selector("img[src*='preview']")
    end
  end

  context 'プロフィール登録済み' do
    before do
      @user = create(:user)
      @profile = create(:profile, user_id: @user.id)
      @user.confirm
      login_as(@user)
    end

    it 'ホームに登録リンクが出ていないか' do
      expect(page).not_to have_content 'プロフィールの登録をしましょう！'
    end

    it '更新ができるか' do
      visit my_page_path
      click_link 'プロフィール編集'

      fill_in 'profile_user_name', with: 'テストユーザー更新'
      attach_file 'profile_avatar', Rails.root.join('spec/fixtures/files/test_image2.png')
      fill_in 'profile_vehicle_name', with: 'テストバイク更新'
      select '大型', from: 'profile_vehicle_type'
      attach_file 'profile_vehicle_photo', Rails.root.join('spec/fixtures/files/test_image1.png')
      click_button '登録'

      Capybara.assert_current_path(my_page_path, ignore_query: true)
      expect(page).to have_content 'テストユーザー更新'
      expect(page).to have_content 'テストバイク更新'
      expect(page).to have_selector("img[src*='test_image2.jpg']")
      expect(page).to have_selector("img[src*='test_image1.jpg']")

      visit current_path
      expect(page).to have_selector("img[src*='avatar.jpg']")
      expect(page).to have_selector("img[src*='vehicle_photo.jpg']")
    end
  end
end
