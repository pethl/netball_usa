class DonatedItem < ApplicationRecord
  validates :description, presence: true
  validates :item_type, presence: true
  validates :status, presence: true

end
