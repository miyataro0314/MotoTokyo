class AccessHistory < ApplicationRecord
  belongs_to :user
  belongs_to :spot
end
