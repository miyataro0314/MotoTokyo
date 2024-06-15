class BookmarksController < ApplicationController
  def create
    @spot = Spot.find(params[:spot_id])
    bookmark = current_user.bookmarks.build(spot: @spot)

    if bookmark.save
      flash[:notice] = I18n.t('flash.bookmarks.create.notice')
    else
      flash[:alert] = I18n.t('flash.bookmarks.create.alert')
    end
    redirect_to spot_path(@spot, from: params[:from])
  end

  def destroy
    @spot = Spot.find(params[:spot_id])
    bookmark = current_user.bookmarks.find_by(spot_id: @spot.id)

    if bookmark.destroy
      flash[:notice] = I18n.t('flash.bookmarks.destroy.notice')
    else
      flash[:alert] = I18n.t('flash.bookmarks.destroy.notice')
    end
    redirect_to spot_path(@spot, from: params[:from]), status: :see_other
  end
end
