class Reference < ApplicationRecord
    validates :group, presence: true
    validates :value, presence: true
end
