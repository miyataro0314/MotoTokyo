require 'rails_helper'

RSpec.describe 'Users', type: :system, js: true do
  context '新規登録' do
    it '問題なく新規登録できるか' do
      ActionMailer::Base.deliveries.clear

      user_registration

      Capybara.assert_current_path('/', ignore_query: true)
      expect(page).to have_content '確認リンクが記載されたメッセージをメールアドレスに送信しました。'

      expect(ActionMailer::Base.deliveries.size).to eq(1)
      
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq(['test@example.com'])
      
      confirm_url = email.body.match(/href="(?<url>.+?)">/)[:url]
      visit confirm_url
      Capybara.assert_current_path(new_user_session_path, ignore_query: true)
      expect(page).to have_content('メールアドレスの確認が完了しました。')
    end

    it 'ユーザーIDのバリデーションが機能しているか' do
      visit new_user_registration_path
      fill_in 'ユーザーID', with: 't'
      fill_in 'メールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in '確認用パスワード', with: 'password'
      check '同意する'

      expect(page).to have_selector("input[disabled]")
      expect(page).to have_content '英数字6文字以上で入力してください'
    end

    it 'パスワードのバリデーションが機能しているか' do
      visit new_user_registration_path
      fill_in 'ユーザーID', with: 'test_user'
      fill_in 'メールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'pass'
      fill_in '確認用パスワード', with: 'pass'
      check '同意する'

      expect(page).to have_selector("input[disabled]")
      expect(page).to have_content '英数字6文字以上で入力してください'
    end

    it 'パスワードが一致しない時エラーとなるか' do
      visit new_user_registration_path
      fill_in 'ユーザーID', with: 'test_user'
      fill_in 'メールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in '確認用パスワード', with: 'passwors'
      check '同意する'

      expect(page).to have_selector("input[disabled]")
      expect(page).to have_content 'パスワードが一致しません'
    end

    it '既に登録済みの値を回避できるか' do
      create(:user, id: 'test_user', email: 'test@example.com')

      visit new_user_registration_path
      fill_in 'ユーザーID', with: 'test_user'
      fill_in 'メールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in '確認用パスワード', with: 'passwors'
      check '同意する'

      expect(page).to have_selector("input[disabled]")
      expect(page).to have_content '既に使用されています'
    end
  end

  context '確認メールが届かない場合' do
    it '正しく確認メールが送られ、リンクが機能しているか' do
      ActionMailer::Base.deliveries.clear

      user_registration

      visit new_user_confirmation_path
      fill_in '登録済みのメールアドレス', with: 'test@example.com'
      click_button '確認メールを再送信する'

      sleep 1

      expect(ActionMailer::Base.deliveries.size).to eq(2)
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq(['test@example.com'])
      
      confirm_url = email.body.match(/href="(?<url>.+?)">/)[:url]
      visit confirm_url
      Capybara.assert_current_path(new_user_session_path, ignore_query: true)
      expect(page).to have_content('メールアドレスの確認が完了しました。')
    end

    it '登録されていないメールアドレスの場合、送られないか' do
      ActionMailer::Base.deliveries.clear

      visit new_user_confirmation_path

      fill_in '登録済みのメールアドレス', with: 'test@example.com'
      click_button '確認メールを再送信する'

      expect(ActionMailer::Base.deliveries.size).to eq(0)
    end
  end

  context 'ログイン' do
    let(:user) { create(:user) }

    it '問題なくログインできるか' do
      user.confirm
      login_as(user)

      Capybara.assert_current_path(home_path, ignore_query: true)
    end

    it '入力情報が正しくない時に弾かれるか' do
      visit new_user_session_path
      fill_in 'メールアドレス', with: 'invalid@mail.com'
      fill_in 'パスワード', with: 'pass'
      click_button 'ログイン'

      Capybara.assert_current_path(new_user_session_path, ignore_query: true)
      expect(page).to have_content('無効なメールアドレスまたはパスワードです。')
    end

    it '有効化されていないアカウントが弾かれるか' do
      login_as(user)
      Capybara.assert_current_path(new_user_session_path, ignore_query: true)
      expect(page).to have_content('続行する前にメールアドレスを確認し、アカウントを有効化する必要があります。')
    end

    it 'ログアウトができるか' do
      user.confirm
      login_as(user)
      visit side_menu_path
      click_link 'ログアウト'

      Capybara.assert_current_path(root_path, ignore_query: true)
      expect(page).to have_content('正常にログアウトしました。')
    end
  end

  context 'パスワードリセット' do
    let(:user) { create(:user, email: 'test@example.com') }

    it '正しく再設定用のメールが送られ、リセットが行えるか' do
      ActionMailer::Base.deliveries.clear
      user.confirm

      visit new_user_password_path
      fill_in '登録済みのメールアドレス', with: 'test@example.com'
      click_button '再設定メールを送信する'

      expect(page).to have_content('5~10分以内にパスワードをリセットするためのリンクが記載されたメールが届きます。')
      expect(ActionMailer::Base.deliveries.size).to eq(2)
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq(['test@example.com'])
      
      reset_url = email.body.match(/href="(?<url>.+?)">/)[:url]
      visit reset_url

      fill_in '新しいパスワード', with: 'newpassword'
      fill_in '確認用パスワード', with: 'newpassword'
      click_button '登録'
      
      expect(page).to have_content('パスワードが正常に変更されました。')
    end

    it '存在しないメールアドレスの場合、弾かれるか' do
      visit new_user_password_path
      fill_in '登録済みのメールアドレス', with: 'test@example.com'
      click_button '再設定メールを送信する'

      Capybara.assert_current_path(new_user_password_path, ignore_query: true)
      expect(page).to have_content('見つかりません。')
    end
  end
end
