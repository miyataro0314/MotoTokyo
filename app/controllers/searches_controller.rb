class SearchesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :save_search_histroy, only: :search_spots

  def new
    clear_session
    @search_spots_form = SearchSpotsForm.new
  end

  def search_spots_modal
    @search_spots_form = SearchSpotsForm.new(session_spots_params)
  end

  def search_spots
    set_page
    set_spot_search_query
    @query = build_query_string
    search_spots_form = SearchSpotsForm.new(session_spots_params)
    @spots = search_spots_form.search.order(created_at: :desc).page(session[:page])
    render 'spots/index'
  end

  private

  def search_spots_params
    params.require(:search_spots_form).permit(%i[area category parking]) if params[:search_spots_form]
  end

  def clear_session
    keys = %i[page area category parking]
    keys.each { |key| session.delete(key) }
  end

  def set_page
    session[:page] = params[:page] if params[:page]
  end

  def set_spot_search_query
    return unless params[:search_spots_form]

    session[:area] = search_spots_params[:area]
    session[:category] = search_spots_params[:category]
    session[:parking] = search_spots_params[:parking]
  end

  def session_spots_params
    {
      area: session[:area],
      category: session[:category],
      parking: session[:parking]
    }
  end

  def build_query_string
    %i[area category parking].map { |key| translated_value(key) }.compact.join(', ')
  end

  def translated_value(key)
    value = session[key]
    value.present? ? I18n.t("activerecord.enums.spot.#{key}.#{value}") : nil
  end

  def save_search_histroy
    return if search_spots_params.nil? || search_spots_params.values.all?(&:blank?)

    SearchHistory.save_search_histroy(current_user, search_spots_params)
  end
end
