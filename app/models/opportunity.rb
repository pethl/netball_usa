class Opportunity < ApplicationRecord
    belongs_to :sponsor


    scope :ordered, -> { order(created_at: :asc) }
end
