class Opportunity < ApplicationRecord
    belongs_to :sponsor
    belongs_to :user

    scope :ordered, -> { order(created_at: :asc) }

   end
