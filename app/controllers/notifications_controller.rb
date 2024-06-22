class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications
  end

  def show
    notification = Notification.find(params[:id])
    notification.update(read: true)

    redirect_to notification.url
  end

  def latest_notifications
    @count = current_user.notifications.unread.count
    @notifications = current_user.notifications.unread.order(created_at: :desc).limit(3)
  end
end
