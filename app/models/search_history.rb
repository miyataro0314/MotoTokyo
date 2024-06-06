class SearchHistory < ApplicationRecord
  include ParkingEnum
  include CategoryEnum
  include AreaEnum

  belongs_to :user

  def self.save_search_histroy(user, params)
    user.search_histories.create(params)
  end
end
