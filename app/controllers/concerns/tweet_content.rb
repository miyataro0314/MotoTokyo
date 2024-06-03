module TweetContent
  extend ActiveSupport::Concern

  def tweet_content_for_spot_registration(spot)
    <<~TEXT
      MotoTokyoに新しいスポット情報が登録されました！
      スポット名：#{spot.name}
      住所：#{spot.spot_detail.address}
      https://moto-tokyo.com/spots/#{spot.id}
      #{spot.hashtag_for_tweet} ##{I18n.t("activerecord.enums.spot.area.#{spot.area}")}
    TEXT
  end
end
