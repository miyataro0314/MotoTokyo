class Notification < ApplicationRecord
  validates :title, presence: true
  validates :message, presence: true
  validates :url, presence: true
  validates :notification_type, presence: true

  belongs_to :user

  enum notification_type: { announcement: 0, info: 5, alert: 10 }

  scope :read, -> { where(read: true) }
  scope :unread, -> { where(read: false) }
end
