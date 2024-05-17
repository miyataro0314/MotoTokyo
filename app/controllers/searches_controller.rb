class SearchesController < ApplicationController
  def search_spot
    @spot = Spot.new
  end
end
