class BookmarksController < ApplicationController
  def create
    @spot = Spot.find(params[:spot_id])
    bookmark = current_user.bookmarks.build(spot: @spot)

    if bookmark.save
      flash[:notice] = 'ブックマークしました'
    else
      flash[:alert] = 'ブックマークに失敗しました'
    end
    redirect_to spot_path(@spot, from: params[:from])
  end

  def destroy
    @spot = Spot.find(params[:spot_id])
    bookmark = current_user.bookmarks.find_by(spot_id: @spot.id)

    if bookmark.destroy
      flash[:notice] = 'ブックマークを解除しました'
    else
      flash[:alert] = 'ブックマークの解除に失敗しました'
    end
    redirect_to spot_path(@spot, from: params[:from]), status: :see_other
  end
end
