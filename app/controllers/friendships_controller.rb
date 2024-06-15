class FriendshipsController < ApplicationController
  def send_request
    friendship = current_user.friendships.build(friend_id: params[:id])

    if friendship.save
      redirect_to my_page_path, notice: I18n.t('flash.friendships.send_request.notice')
    else
      redirect_to my_page_path, alert: I18n.t('flash.friendships.send_request.alert')
    end
  end

  def approve_request
    friendship = Friendship.find(params[:request_id])
    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback unless friendship.approved!

      current_user.friendships.create(friend_id: params[:friend_id], status: 5)
    end

    redirect_to friendships_path(from: params[:from]), notice: I18n.t('flash.friendships.approve_request.notice')
  end

  def deny_request
    friendship = Friendship.find(params[:id])
    if friendship.destroy
      flash[:notice] = I18n.t('flash.friendships.deny_request.notice')
    else
      flash[:alert] = I18n.t('flash.friendships.deny_request.alert')
    end
    redirect_to friendships_path(from: params[:from])
  end

  def index
    @friends = current_user.approved_friends.page(params[:page_friends])
    @requests = current_user.friend_requests.page(params[:page_requests])
    @selected_tab = params[:tab] || 'friends'
  end

  def destroy
    @user = User.find(params[:id])
    @profile = @user.profile

    friendship = current_user.friendships.find_by(friend: @user)
    reverse_friendship = Friendship.find_by(user: @user, friend: current_user)

    friendships_destroy(friendship, reverse_friendship)
  end

  def add_friend; end

  def user_search
    @user = User.find_by(id: params[:id])
    @profile = @user.profile if @user
  end

  def friendships_destroy(friendship, reverse_friendship)
    ActiveRecord::Base.transaction do
      if friendship.destroy && reverse_friendship.destroy
        redirect_to user_path(@user, from: params[:from]), notice: I18n.t('flash.friendships.destroy.notice')
      else
        redirect_to user_path(@user, from: params[:from]), alert: I18n.t('flash.friendships.destroy.notice')
        raise ActiveRecord::Rollback
      end
    end
  end
end
