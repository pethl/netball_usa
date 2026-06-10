class DonatedItem < ApplicationRecord

  belongs_to :club, optional: true
  belongs_to :program, optional: true
  
  has_many :donated_item_requests, dependent: :destroy
  
  validates :description, presence: true
  validates :item_type, presence: true
  validates :status, presence: true

  # app/models/donated_item.rb

def latest_request
  donated_item_requests.order(created_at: :desc).first
end

end
