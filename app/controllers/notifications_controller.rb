class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications
  end

  def latest_notifications
    @notifications = current_user.notifications.unread.order(created_at: :desc).limit(3)
  end
end
