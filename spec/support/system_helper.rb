module SystemHelper
  def user_registration
    visit new_user_registration_path
    fill_in 'ユーザーID (英数字6文字以上)', with: 'test_user'
    fill_in 'メールアドレス', with: 'test@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in '確認用パスワード', with: 'password'
    check '同意する'
    click_button '新規登録'
  end

  def login_as(user)
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    sleep 0.5
  end

  def login_as_admin(user)
    visit admin_login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: '12345678'
    click_button 'ログイン'
    Capybara.assert_current_path("/admin", ignore_query: true)
  end
end

RSpec.configure do |config|
  config.include SystemHelper
end