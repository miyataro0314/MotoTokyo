class Notification < ApplicationRecord
  validates :title, presence: true
  validates :message, presence: true
  validates :url, presence: true
  validates :notification_type, presence: true

  belongs_to :user

  enum notification_type: { announcement: 0, info: 5, alert: 10 }
  enum priority: { normal: 0, high_importance: 5 }

  scope :read, -> { where(read: true) }
  scope :unread, -> { where(read: false) }

  def self.friend_request(friend_id, url)
    Notification.new(
      user_id: friend_id,
      title: '友達申請が届きました！',
      message: '通知をタップしてを内容を確認してください',
      url:,
      notification_type: 5
    )
  end
end
