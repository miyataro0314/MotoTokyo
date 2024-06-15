require 'rails_helper'

RSpec.describe "Parkings", type: :system, js: true do
  context '駐車場詳細' do
    before do
      @user = create(:user)
      @spot = create(:spot, user_id: @user.id)
      @spot_detail = create(:spot_detail, spot_id: @spot.id)
      @difficulty = create(:difficulty, user_id: @user.id, spot_id: @spot.id)
      @parking = create(:parking)
      @user.confirm
      login_as(@user)
      visit spot_path(@spot)
    end

    it '問題なく表示されるか' do
      find("#parking-card-#{@parking.id}").click
      expect(page).to have_content(@parking.name)
      expect(page).to have_content(@parking.postal_code)
      expect(page).to have_content(@parking.address)
      expect(page).to have_content(@parking.capacity)
      expect(page).to have_content(@parking.opening_hours)
      expect(page).to have_content(@parking.fee)
    end
  end
end
