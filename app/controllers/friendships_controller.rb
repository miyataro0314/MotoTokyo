class FriendshipsController < ApplicationController
  def send_request
    friendship = current_user.friendships.build(friend_id: params[:id])

    if friendship.save
      redirect_to my_page_path, notice: '相手ユーザーに承認依頼を送信しました。承認され次第友だち登録されます。'
    else
      redirect_to my_page_path, alert: 'エラーが発生し、承認依頼を送信できませんでした。'
    end
  end

  def approve_request
    friendship = Friendship.find(params[:request_id])
    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback unless friendship.approved!

      current_user.friendships.create(friend_id: params[:friend_id], status: 5)
    end

    redirect_to friendships_path, notice: '友達申請を承認しました。'
  end

  def deny_request
    friendship = Friendship.find(params[:id])
    if friendship.destroy
      redirect_to friendships_path, notice: '友達申請を拒否しました'
    else
      redirect_to friendships_path, alert: 'エラーが発生し、友達申請を拒否できませんでした'
    end
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

    ActiveRecord::Base.transaction do
      if friendship.destroy && reverse_friendship.destroy
        redirect_to user_path(@user, from: params[:from]), notice: '友達を解除しました'
      else
        redirect_to user_path(@user, from: params[:from]), alert: 'エラーが発生し、友達の解除に失敗しました'
        raise ActiveRecord::Rollback
      end
    end
  end

  def add_friend; end

  def user_search
    @user = User.find_by(id: params[:id])
    @profile = @user.profile if @user
  end
end
