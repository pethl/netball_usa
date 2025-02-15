class Reference < ApplicationRecord
    validates :group, presence: true
    validates :value, presence: true

    
  scope :ordered, -> { order(value: :asc) }
end
