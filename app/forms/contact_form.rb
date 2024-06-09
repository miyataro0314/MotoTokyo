class ContactForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :user_id, :string
  attribute :email, :string
  attribute :content, :string

  validates :user_id, presence: true
  validates :email, presence: true
  validates :content, presence: true
end
