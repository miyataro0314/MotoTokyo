class NotificationsController < ApplicationController
  def index
    @all_count = current_user.notifications.count
    @unread_count = current_user.notifications.unread.count
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page])
  end

  def show
    notification = Notification.find(params[:id])
    notification.update(read: true)

    redirect_to notification.url
  end

  def latest_notifications
    @unread_count = current_user.notifications.unread.count
    @notifications = current_user.notifications.unread.order(created_at: :desc).limit(3)
  end
end
