class SponsoredPost < ApplicationRecord
  belongs_to :topics
  has_many :comments
end
