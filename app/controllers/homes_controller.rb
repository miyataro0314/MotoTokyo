class HomesController < ApplicationController
  before_action :require_profile, only: :my_page

  def home
    prepare_last_access_spot
    prepare_query_by_search_history
    fetch_weather_data
    @latest_spots = latest_spots(5)
    @recommended_spots = recommend_spots(5)
  end

  def weather_detail
    fetch_weather_data
  end

  def my_page
    @profile = current_user.profile
  end

  def my_spots
    @selected_tab = params[:tab] || 'bookmark'
    @registered_spots = current_user.spots.order(created_at: :desc).page(params[:page_register])
    @bookmarked_spots = current_user.bookmarked_spots.order(created_at: :desc).page(params[:page_bookmark])
  end

  def account
    utc_time = current_user.created_at
    local_time = utc_time.in_time_zone(Rails.application.config.time_zone)
    @registration_date = local_time.strftime('%Y年%m月%d日')
  end

  def cancellation; end

  private

  def require_profile
    return if current_user.profile

    redirect_to new_profile_path, alert: I18n.t('flash.homes.require_profile.alert')
  end

  def latest_spots(limit)
    Spot.includes(:spot_detail).order(created_at: :desc).limit(limit)
  end

  def fetch_weather_data
    response = HTTP.get('https://weather.tsukumijima.net/api/forecast/city/130010')
    @data = JSON.parse(response.body)
    forecasts = @data['forecasts']

    @first = forecasts[0]
    @second = forecasts[1]
    @third = forecasts[2]
  end

  def prepare_last_access_spot
    @last_access_spot = current_user.access_histories.last&.spot
    @last_access_spot_detail = @last_access_spot.spot_detail unless @last_access_spot.nil?
  end

  def prepare_query_by_search_history
    @last_search_query = current_user.search_histories.last
    return unless @last_search_query

    session[:area] = @last_search_query.area
    session[:category] = @last_search_query.category
    session[:parking] = @last_search_query.parking
  end

  def recommend_spots(limit)
    search_histories = recent_search_histories
    accessed_spots = recent_access_spots

    search_score_weights = calculate_score_weights(search_histories)
    access_score_weights = calculate_score_weights(accessed_spots)

    recommend_score_weights = merge_score_weights(search_score_weights, access_score_weights)

    spots_with_scores = Spot.includes(:spot_detail).map do |spot|
      score = calculate_score(spot, recommend_score_weights)
      score *= 0.7 if accessed_spots.include?(spot) # 閲覧済みのスポットはスコア3割減
      { spot:, score: }
    end

    spots_with_scores.sort_by { |spot_with_score| -spot_with_score[:score] }.take(limit).pluck(:spot)
  end

  def recent_search_histories(limit = 10)
    SearchHistory.where(user_id: current_user.id).order(created_at: :desc).limit(limit)
  end

  def recent_access_spots(limit = 10)
    AccessHistory.where(user_id: current_user.id).order(created_at: :desc).limit(limit).includes(:spot).map(&:spot)
  end

  def calculate_score_weights(object)
    area_score_weight = count_score(object, :area)
    parking_score_weight = count_score(object, :parking)
    category_score_weight = count_score(object, :category)

    { area: area_score_weight, parking: parking_score_weight, category: category_score_weight }
  end

  def count_score(object, key)
    object.group_by(&key).transform_values(&:count).reject { |k, _| k.nil? }
  end

  def merge_score_weights(score_weights1, score_weights2)
    merged_score_weights = {}

    score_weights1.each do |key, score_weight|
      merged_score_weights[key] = score_weight.merge(score_weights2[key]) do |_, score1, score2|
        score1 + score2
      end
    end

    merged_score_weights
  end

  def calculate_score(spot, score_weights)
    score_weights.sum do |key, score_weight|
      score_weight.fetch(spot.send(key), 0)
    end
  end
end
