module CategoryEnum
  extend ActiveSupport::Concern

  included do
    enum category: { sightseeing: 0, scenery: 5, shopping: 10, food: 15, activity: 20, accommodations: 25 }
  end
end
